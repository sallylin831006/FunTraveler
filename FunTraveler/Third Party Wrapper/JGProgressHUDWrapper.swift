//
//  JGProgressHUDWrapper.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/22.
//

import Foundation
import JGProgressHUD
import UIKit

enum HUDType {

    case success(String)

    case failure(String)
}

class ProgressHUD {

    static let shared = ProgressHUD()

    private init() { }

    let hud = JGProgressHUD(style: .light)

    var view: UIView {
        
//        guard let view = AppDelegate.shared.window?.rootViewController?.view else { return UIView() }

        return AppDelegate.shared.window!.rootViewController!.view
    }

    static func show(type: HUDType) {

        switch type {

        case .success(let text):

            showSuccess(text: text)

        case .failure(let text):

            showFailure(text: text)
        }
    }

    static func showSuccess(text: String = "success") {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                showSuccess(text: text)
            }

            return
        }

        shared.hud.textLabel.text = text

        shared.hud.indicatorView = JGProgressHUDSuccessIndicatorView()

        shared.hud.show(in: shared.view)

        shared.hud.dismiss(afterDelay: 1.5)
    }

    static func showFailure(text: String = "Failure") {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                showFailure(text: text)
            }

            return
        }

        shared.hud.textLabel.text = text

        shared.hud.indicatorView = JGProgressHUDErrorIndicatorView()

        shared.hud.show(in: shared.view)

        shared.hud.dismiss(afterDelay: 1.5)
    }

    static func show() {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                show()
            }

            return
        }

        shared.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()

        shared.hud.textLabel.text = "Loading"

        shared.hud.show(in: shared.view)
    }

    static func dismiss() {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                dismiss()
            }

            return
        }

        shared.hud.dismiss()
    }
}
