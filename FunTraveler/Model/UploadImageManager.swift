//
//  UploadImageManager.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/5/23.
//

import UIKit

protocol UploadImageManagerDelegate: AnyObject {
    
    func uploadAction(index: Int, strBase64: String)
}

class UploadImageManager: NSObject {
    
    weak var delegate: UploadImageManagerDelegate?
    
    var tripImageView: UIImageView?
    var imageIndex: Int = 0
    var viewController: UIViewController?
//    var schedules: [Schedule] = []
    
    func selectImageAction(sender: UITapGestureRecognizer, viewController: UIViewController) {

        let photoSourceRequestController = UIAlertController(title: "", message: "選擇照片", preferredStyle: .alert)
        
        let photoLibraryAction = UIAlertAction(title: "相簿", style: .default, handler: { (_) in
//            self.showLoadingView()
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                
                viewController.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        let cameraAction = UIAlertAction(title: "相機", style: .default, handler: { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .camera
                imagePicker.delegate = self
                
                viewController.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
        })
        
        photoSourceRequestController.addAction(photoLibraryAction)
        photoSourceRequestController.addAction(cameraAction)
        photoSourceRequestController.addAction(cancelAction)
        
        // iPad specific code
        photoSourceRequestController.popoverPresentationController?.sourceView = viewController.view
        
        let xOrigin = viewController.view.bounds.width / 2
        
        let popoverRect = CGRect(x: xOrigin, y: 0, width: 1, height: 1)
        
        photoSourceRequestController.popoverPresentationController?.sourceRect = popoverRect
        
        photoSourceRequestController.popoverPresentationController?.permittedArrowDirections = .up
        
        viewController.present(photoSourceRequestController, animated: true, completion: nil)
        
    }
    
}

extension UploadImageManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                               info: [UIImagePickerController.InfoKey: Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

            tripImageView?.image = selectedImage
//            schedules[imageIndex].images.append(convertImageString())
            delegate?.uploadAction(index: imageIndex, strBase64: convertImageString())
            
        }
        
    }
    
    func convertImageString() -> String {
        guard let image = tripImageView?.image else { return "" }
        let newImage = image.scale(newWidth: 100.0)
        guard let imageData: NSData = newImage.jpegData(compressionQuality: 1) as NSData? else { return "" }
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        return strBase64
    }
}
