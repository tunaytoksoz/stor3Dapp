//
//  ForgotPasswordController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 30.11.2022.
//

import UIKit

class ForgotPasswordController: UIViewController {
    
    private let headerView = AuthHeaderView(title: "Şifremi unuttum", subTitle: "Email adresinizi Giriniz.")
    
    private let emailField = CustomTextField(fieldType: .email)
    
    private let resetPasswordButton = CustomButton(title: "Şifremi Sıfırla", fontSize: .big)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.resetPasswordButton.addTarget(self, action: #selector(didTapResetPassword), for: .touchUpInside)
        
        self.setupUI()
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.addSubview(headerView)
        self.view.addSubview(emailField)
        self.view.addSubview(resetPasswordButton)
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.emailField.translatesAutoresizingMaskIntoConstraints = false
        self.resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 220),
            
            self.emailField.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 12),
            self.emailField.centerXAnchor.constraint(equalTo: self.headerView.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 55),
            self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.resetPasswordButton.topAnchor.constraint(equalTo: self.emailField.bottomAnchor, constant: 22),
            self.resetPasswordButton.centerXAnchor.constraint(equalTo: self.headerView.centerXAnchor),
            self.resetPasswordButton.heightAnchor.constraint(equalToConstant: 55),
            self.resetPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
          
        ])
    }

    
    
    // MARK: - Selectors
    
    @objc func didTapResetPassword(){
        let email = self.emailField.text ?? ""
        
        if !Validator.isValidEmail(for: email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        AuthService.shared.passwordReset(with: email) { [weak self] error in
            guard let self = self else {return}
            if let error = error {
                AlertManager.showSendingPasswordResetErrorAlert(on: self, with: error)
                return
            }
            AlertManager.showPasswordResetSend(on: self)
        }
    }

}
