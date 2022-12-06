//
//  HomeController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 30.11.2022.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeController: UIViewController {
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Fetching User..."
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()



    override func viewDidLoad() {
        super.viewDidLoad()
        self.logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        
        AuthService.shared.fetchUser { [weak self] user, error in
            guard let self = self else {return}
            if let error = error {
                AlertManager.showFetchingUserError(on: self, with: error)
            }
            if let user = user {
                self.usernameLabel.text = "\(user.username)\n\n\(user.email)"
            }
        }
        
        self.setupUI()
        
    }
    
     @objc private func didTapLogout() {
            AuthService.shared.signOut { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    AlertManager.showLogoutErrorAlert(on: self, with: error)
                    return
                }
                
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuthentication()
                }
            }
        }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(logoutButton)
        self.view.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            self.usernameLabel.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 100),
            self.usernameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.logoutButton.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor, constant: 50),
            self.logoutButton.centerXAnchor.constraint(equalTo: self.usernameLabel.centerXAnchor),
            self.logoutButton.heightAnchor.constraint(equalToConstant: 55),
            self.logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
         
        ])
    }

    }
