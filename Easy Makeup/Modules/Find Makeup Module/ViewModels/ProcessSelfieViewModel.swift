import RxSwift

typealias ProcessSelfieViewModelBuilder = () -> ProcessSelfieViewModel

struct ProcessSelfieViewModel {
    let currentImage: Observable<UIImage>
    let step: Observable<CurrentStep>
    
    init(currentImage: Observable<UIImage>, step: Observable<CurrentStep>) {
        self.currentImage = currentImage
        self.step = step
    }
}
