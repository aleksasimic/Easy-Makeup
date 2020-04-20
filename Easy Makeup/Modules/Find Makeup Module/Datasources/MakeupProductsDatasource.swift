import RxSwift

class MakeupProductsDatasource: NSObject, UITableViewDataSource {
    private var data: [Product] = []
    private let tableView: UITableView
    private let bag = DisposeBag()
    var selectedProducts: [Product] = []
    
    init(withTableView tableView: UITableView,
         products: Observable<[Product]>) {
        self.tableView = tableView
        super.init()
        setupTableView()
        setupUpdate(withData: products)
        bindActions()
    }
    
    private func setupUpdate(withData data: Observable<[Product]>) {
        data
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                self.reload(withData: $0)
            })
            .disposed(by: bag)
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self
    }
    
    private func bindActions() {
        tableView.rx.itemSelected.asObservable()
            .map { [weak self] in
                (self?.getItem(atIndexPath: $0))!
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.selectedProducts.append($0)
            })
            .disposed(by: bag)
        
        tableView.rx.itemDeselected.asObservable()
            .map { [weak self] in
                (self?.getItem(atIndexPath: $0))!
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] productToRemove in
                self?.selectedProducts.removeAll(where: { $0.name == productToRemove.name })
            })
            .disposed(by: bag)
    }
    
    private func reload(withData data: [Product]) {
        self.data = data
        self.reload()
    }
    
    private func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension MakeupProductsDatasource {
    func getItem(atIndexPath indexPath: IndexPath) -> Product? {
        guard data.count > indexPath.row else { return nil }
        return data[indexPath.row]
    }
}

extension MakeupProductsDatasource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let product = getItem(atIndexPath: indexPath) else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.identifier, for: indexPath) as! ProductsTableViewCell
        cell.setup(withProduct: product)
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
}

extension MakeupProductsDatasource {
    public func emptySelected() {
        selectedProducts = []
    }
}
