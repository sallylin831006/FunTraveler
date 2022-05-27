//
//  Alert+Extension.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/5/26.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, actions: [UIAlertAction], completion: (() -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alertController.addAction($0) }
        self.present(alertController, animated: true, completion: completion)
    }
}
