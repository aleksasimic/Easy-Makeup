import Foundation
import UIKit

protocol FindMakeupContainerProtocol {
    var realmProvider: RealmProviderProtocol { get }
    var imagePicker: UIImagePickerController { get }
}

public final class FindMakeupContainer: FindMakeupContainerProtocol {
    var realmProvider: RealmProviderProtocol
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker.sourceType = .camera
        } else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .overFullScreen
        return imagePicker
    }()
    
    init(realmProvider: RealmProvider) {
        self.realmProvider = realmProvider
    }
}
