//
//  AuthTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/25.
//

import UIKit
import AuthenticationServices

class AuthTableViewCell: UITableViewCell {
    private var appleToken: String = ""
    var loginClosure: ((_ cell: AuthTableViewCell) -> Void)?
    
    var siginInwithAppleClosure: (( _ appleToken: String) -> Void)?
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var moveToRegisterButton: UIButton!
    
    @IBOutlet weak var siginView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loginButton.addTarget(self, action: #selector(tapLoginButton), for: .touchUpInside)
        setupSignInwithApple()
        self.backgroundColor = .themeApricot
        passwordTextField.isSecureTextEntry = true

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loginButton.layer.cornerRadius = CornerRadius.buttonCorner
        emailTextField.addBottomBorder(textField: emailTextField)
        passwordTextField.addBottomBorder(textField: passwordTextField)
        
    }

    @objc func tapLoginButton() {
        loginClosure?(self)
    }
    
    private let authorizationAppleIDButton: ASAuthorizationAppleIDButton =
    ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
    
    func setupSignInwithApple() {
        authorizationAppleIDButton.addTarget(
            self, action: #selector(pressSignInWithAppleButton), for: UIControl.Event.touchUpInside)
        layoutOfSignInWithApple()
    }
    
    @objc func pressSignInWithAppleButton() {
        
        let authorizationAppleIDRequest: ASAuthorizationAppleIDRequest =
        ASAuthorizationAppleIDProvider().createRequest()
        authorizationAppleIDRequest.requestedScopes = [.fullName, .email]
        
        let controller: ASAuthorizationController = ASAuthorizationController(
            authorizationRequests: [authorizationAppleIDRequest])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func layoutCell() {
        
    }
    
}

extension AuthTableViewCell: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            self.appleToken = idTokenString
            siginInwithAppleClosure?(appleToken)
//                        print("appleIDToken", idTokenString)
//                        print("user: \(appleIDCredential.user)")
//                        print("fullName: \(String(describing: appleIDCredential.fullName))")
//                        print("Email: \(String(describing: appleIDCredential.email))")
//                        print("realUserStatus: \(String(describing: appleIDCredential.realUserStatus))")
        }
        
    }
    
}

extension AuthTableViewCell: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window!
    }
    
}

extension AuthTableViewCell {
    func layoutOfSignInWithApple() {
        siginView.addSubview(authorizationAppleIDButton)
        authorizationAppleIDButton.translatesAutoresizingMaskIntoConstraints = false
        authorizationAppleIDButton.centerXAnchor.constraint(equalTo: siginView.centerXAnchor).isActive = true
        authorizationAppleIDButton.centerYAnchor.constraint(equalTo: siginView.centerYAnchor).isActive = true
        authorizationAppleIDButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        authorizationAppleIDButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
}
