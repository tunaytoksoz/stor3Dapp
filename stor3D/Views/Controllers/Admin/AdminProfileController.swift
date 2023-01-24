//
//  AdminProfileController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 29.12.2022.
//

import UIKit

class AdminProfileController: UIViewController, UITabBarControllerDelegate {
    
    private var user : User?
    
    private let Namelabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = "admin"
        return label
    }()
    
    private let Emaillabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = "tunaytoksoz@outlook.com"
        return label
    }()
    
    private let Logoutbutton: UIButton = {
        let button = UIButton()
        button.setTitle("Çıkış", for: .normal)
        button.backgroundColor = UIColor(red: 0.33, green: 0.53, blue: 0.49, alpha: 1.00)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupUI()
       
        self.Logoutbutton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        title = "Profilim"
        
        

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self
    }
    
    // MARK: - Functions
    @objc func didTapLogout(){
        AuthService.shared.signOut { [weak self] error in
                   guard let self = self else { return }
                   if let error = error {
                       print(error.localizedDescription)
                       return
                   }
                   
                   if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                       sceneDelegate.checkAuthentication()
                   }
               }
    }
    
    

    // MARK: - UI Setup
    private func setupUI() {
        self.view.addSubview(Namelabel)
        self.view.addSubview(Emaillabel)
        self.view.addSubview(Logoutbutton)
        
        Namelabel.translatesAutoresizingMaskIntoConstraints = false
        Emaillabel.translatesAutoresizingMaskIntoConstraints = false
        Logoutbutton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
        
            Namelabel.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 30),
            Namelabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            
            Emaillabel.topAnchor.constraint(equalTo: self.Namelabel.bottomAnchor, constant: 20),
            Emaillabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            
            Logoutbutton.topAnchor.constraint(equalTo: self.Emaillabel.bottomAnchor, constant: 25),
            Logoutbutton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            Logoutbutton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
        
        ])
        

    }
    
    
   
    


}
