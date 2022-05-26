//
//  AlertManager.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/5/26.
//

import UIKit

protocol AlertManagerDelegate: AnyObject {
    
    func okAction()
}

class AlertManager {
    
    weak var delegate: AlertManagerDelegate?
    
    static let shared = AlertManager()

    private init() { }
        
    func showPublishStatus(at viewController: UIViewController, title: String, message: String = "", publicAction: UIAlertAction, privateAction: UIAlertAction) {
               
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let publicAction = UIAlertAction(title: "公開", style: .default) { (_) in
            publicAction
        }
        
        let privateAction = UIAlertAction(title: "私密", style: .default) { (_) in
            privateAction
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addAction(publicAction)
        alert.addAction(privateAction)
        alert.addAction(cancelAction)

        viewController.present(alert, animated: true)
        
        specificForIpad(at: viewController, show: alert)
        
    }
    
    func okAction() {
        print("okAction")
        delegate?.okAction()
    }
    
    func specificForIpad(at viewController: UIViewController, show alertViewController: UIViewController) {

        alertViewController.popoverPresentationController?.sourceView = viewController.view

        let xOrigin = viewController.view.bounds.width / 2

        let popoverRect = CGRect(x: xOrigin, y: 0, width: 1, height: 1)

        alertViewController.popoverPresentationController?.sourceRect = popoverRect

        alertViewController.popoverPresentationController?.permittedArrowDirections = .up
    }

}
