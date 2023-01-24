//
//  ProfileController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 8.12.2022.
//

import UIKit

class ProfileController: UIViewController, UITabBarControllerDelegate {
    
    private var user : User?
    
    private let Namelabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = ""
        return label
    }()
    
    private let Emaillabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = ""
        return label
    }()

    
    private let AdressTextView: UITextView = {
        let textView = UITextView()
        
        textView.font = .systemFont(ofSize: 18, weight: .regular)
        textView.text = ""
        textView.backgroundColor = .secondarySystemBackground
        textView.textAlignment = .left
        textView.textColor = .label
        textView.isEditable = true
        textView.isScrollEnabled = true
        return textView
    }()
    
    private let changeAdressButton: UIButton = {
        let button = UIButton()
        button.setTitle("Adresimi Değiştir", for: .normal)
        button.backgroundColor = UIColor(red: 0.33, green: 0.53, blue: 0.49, alpha: 1.00)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 5
        return button
    }()

   private let FavoriteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Favorilerim", for: .normal)
        button.backgroundColor = UIColor(red: 0.33, green: 0.53, blue: 0.49, alpha: 1.00)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let BasketButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sepetim", for: .normal)
        button.backgroundColor = UIColor(red: 0.33, green: 0.53, blue: 0.49, alpha: 1.00)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let OrderButton: UIButton = {
        let button = UIButton()
        button.setTitle("Siparişlerim", for: .normal)
        button.backgroundColor = UIColor(red: 0.33, green: 0.53, blue: 0.49, alpha: 1.00)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        return button
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
        
        title = "Profilim"
        self.changeAdressButton.addTarget(self, action: #selector(didTapChangeAdress), for: .touchUpInside)
        self.FavoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
        self.BasketButton.addTarget(self, action: #selector(didTapBasket), for: .touchUpInside)
        self.OrderButton.addTarget(self, action: #selector(didTapOrder), for: .touchUpInside)
        self.Logoutbutton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        AuthService.shared.fetchUser { user, error in
            if error == nil{
                self.user = user
                if let username = user?.username{
                    self.Namelabel.text = "@\(username)"
                }
                self.Emaillabel.text = user?.email
                self.AdressTextView.text = user?.adress
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self
    }
    
    // MARK: - Functions
    
    @objc func didTapChangeAdress(){
        profileViewModel().changeAdress(with: AdressTextView.text ?? "", email: Emaillabel.text ?? "", vc : self)
    }
    @objc func didTapFavorite(){
        let vc = FavoritesController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapBasket(){
        let vc = BasketController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapOrder(){
        let vc = OrdersConroller()
        navigationController?.pushViewController(vc, animated: true)
    }
    
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
        self.view.addSubview(AdressTextView)
        self.view.addSubview(changeAdressButton)
        self.view.addSubview(FavoriteButton)
        self.view.addSubview(OrderButton)
        self.view.addSubview(BasketButton)
        self.view.addSubview(Logoutbutton)
        
        Namelabel.translatesAutoresizingMaskIntoConstraints = false
        Emaillabel.translatesAutoresizingMaskIntoConstraints = false
        AdressTextView.translatesAutoresizingMaskIntoConstraints = false
        changeAdressButton.translatesAutoresizingMaskIntoConstraints = false
        FavoriteButton.translatesAutoresizingMaskIntoConstraints = false
        OrderButton.translatesAutoresizingMaskIntoConstraints = false
        BasketButton.translatesAutoresizingMaskIntoConstraints = false
        Logoutbutton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
        
            Namelabel.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 15),
            Namelabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            
            Emaillabel.topAnchor.constraint(equalTo: self.Namelabel.bottomAnchor, constant: 20),
            Emaillabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            
            AdressTextView.topAnchor.constraint(equalTo: self.Emaillabel.bottomAnchor, constant: 20),
            AdressTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            AdressTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            AdressTextView.heightAnchor.constraint(equalToConstant: 100),
            
            changeAdressButton.topAnchor.constraint(equalTo: self.AdressTextView.bottomAnchor, constant: 15),
            changeAdressButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
            FavoriteButton.topAnchor.constraint(equalTo: self.changeAdressButton.bottomAnchor, constant: 40),
            FavoriteButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            FavoriteButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
            OrderButton.topAnchor.constraint(equalTo: self.FavoriteButton.bottomAnchor, constant: 25),
            OrderButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            OrderButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
            BasketButton.topAnchor.constraint(equalTo: self.OrderButton.bottomAnchor, constant: 25),
            BasketButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            BasketButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
            Logoutbutton.topAnchor.constraint(equalTo: self.BasketButton.bottomAnchor, constant: 25),
            Logoutbutton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            Logoutbutton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
        
        ])
        

    }
    
    
   
    


}
