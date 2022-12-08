//
//  LoginController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 30.11.2022.
//

import UIKit

class LoginController: UIViewController {
    
    private let headerView = AuthHeaderView(title: "Giriş Yap", subTitle: "Hesap Bigilerini Gir")
    
    private let emailField = CustomTextField(fieldType: .email)
    
    private let passwordField = CustomTextField(fieldType: .password)
    
    private let signInButton = CustomButton(title: "Giriş",hasBackGround: true ,fontSize: .big)
    private let newUserButton = CustomButton(title: "Yeni Hesap Oluştur", fontSize: .medium)
    private let forgotPasswordButton = CustomButton(title: "Şifremi Unuttum.", fontSize: .small)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupUI()
        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        self.newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
        self.forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
        // Do any additional setup after loading the view
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.addSubview(headerView)
        self.view.addSubview(emailField)
        self.view.addSubview(passwordField)
        self.view.addSubview(signInButton)
        self.view.addSubview(newUserButton)
        self.view.addSubview(forgotPasswordButton)
        
        
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        newUserButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 220),
            
            
            self.emailField.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 12),
            self.emailField.centerXAnchor.constraint(equalTo: self.headerView.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 55),
            self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.passwordField.topAnchor.constraint(equalTo: self.emailField.bottomAnchor, constant: 22),
            self.passwordField.centerXAnchor.constraint(equalTo: self.headerView.centerXAnchor),
            self.passwordField.heightAnchor.constraint(equalToConstant: 55),
            self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.signInButton.topAnchor.constraint(equalTo: self.passwordField.bottomAnchor, constant: 22),
            self.signInButton.centerXAnchor.constraint(equalTo: self.headerView.centerXAnchor),
            self.signInButton.heightAnchor.constraint(equalToConstant: 55),
            self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.newUserButton.topAnchor.constraint(equalTo: self.signInButton.bottomAnchor, constant: 11),
            self.newUserButton.centerXAnchor.constraint(equalTo: self.headerView.centerXAnchor),
            self.newUserButton.heightAnchor.constraint(equalToConstant: 25),
            self.newUserButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.forgotPasswordButton.topAnchor.constraint(equalTo: self.newUserButton.bottomAnchor, constant: 11),
            self.forgotPasswordButton.centerXAnchor.constraint(equalTo: self.headerView.centerXAnchor),
            self.forgotPasswordButton.heightAnchor.constraint(equalToConstant: 15),
            self.forgotPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85)
            
            
        ])
    }

    
    // MARK: Selectors
    
    
    @objc func didTapSignIn(){
        
        let loginUserRequest = LoginUserRequest(email: emailField.text ?? "",
                                                password: passwordField.text ?? "")
        
        // email check
        if !Validator.isValidEmail(for: loginUserRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
        }
        // Password check
        if !Validator.isPasswordValid(for: loginUserRequest.password) {
            AlertManager.showInvalidPasswordAlert(on: self)
        }
        
        
        AuthService.shared.SignIn(userRequest: loginUserRequest) { [weak self] error in
            guard let self = self else {return}
            print(loginUserRequest)
            if let error = error {
                AlertManager.showSignInErrorAlert(on: self, with: error)
                return
            }
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
                sceneDelegate.checkAuthentication()
            }
        }
      
        
    }
    @objc func didTapNewUser(){
        let vc = RegisterController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @objc func didTapForgotPassword(){
        let vc = ForgotPasswordController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
