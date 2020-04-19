import RxSwift

typealias ProcessSelfieViewModelBuilder = (_ goToNextStepTrigger: Observable<Void>, _ goToPreviousStepTrigger: Observable<Void>) -> ProcessSelfieViewModel

struct ProcessSelfieViewModel {
    let step: Observable<CurrentStep>
    let image: Observable<UIImage>
    
    init(goToNextStepTrigger: Observable<Void>, goToPreviousStepTrigger: Observable<Void>,
         step: Observable<CurrentStep>, image: Observable<UIImage>) {
        
        self.image = image
        
        let stepUpdate = goToNextStepTrigger
            .map {
                CurrentStep.pickColor
            }
        
        let stepUpdate2 = goToPreviousStepTrigger
            .map {
                CurrentStep.takeSelfie
            }
        
        self.step = Observable.of(step, stepUpdate, stepUpdate2).merge()
    }
}
