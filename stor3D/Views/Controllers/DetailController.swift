//
//  DetailController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 22.12.2022.
//

import UIKit
import ImageSlideshow
import Kingfisher
import Firebase


class DetailController: UIViewController {
    
    
    var imageUrls = [KingfisherSource]()
    var product : productGet?
    var basket : [productGet] = [productGet]()
    var productUrl : [String] = [String]()
    var imageSlider : ImageSlideshow!
    var urlString : String = ""
    private var activityIndicator : UIActivityIndicatorView!
    
    
    private let Titlelabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "Title"
        label.text?.capitalized
        return label
    }()
    
    private let Pricelabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "Title"
        return label
    }()
    
    
    private let DescriptiontextView: UITextView = {
        let textView = UITextView()
        
        textView.font = .systemFont(ofSize: 18, weight: .regular)
        textView.text = "Enter your email below to recieve a password reset link."
        textView.textAlignment = .left
        textView.textColor = .label
        textView.isSelectable = true
        textView.isEditable = false
        textView.delaysContentTouches = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let Basketbutton: UIButton = {
        let button = UIButton()
        button.setTitle("Sepete Ekle", for: .normal)
        button.backgroundColor = UIColor(red: 0.33, green: 0.53, blue: 0.49, alpha: 1.00)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let Show3Dbutton: UIButton = {
        let button = UIButton()
        button.setTitle("3D Göster", for: .normal)
        button.backgroundColor = UIColor(red: 0.33, green: 0.53, blue: 0.49, alpha: 1.00)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()
    
    public let Favoributton: UIButton = {
        let button = UIButton()
        button.setTitle("Favorilere Ekle", for: .normal)
        button.backgroundColor = UIColor(red: 0.33, green: 0.53, blue: 0.49, alpha: 1.00)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()






    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = .systemBackground
        
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .blue
        
        productUrl = product?.productImageUrl ?? []
        
        for string in productUrl {
            imageUrls.append(KingfisherSource(urlString: string)!)
        }
        
        imageSlider = ImageSlideshow(frame: CGRect(x: 0, y: 40, width: self.view.frame.width, height: 300))
        imageSlider.backgroundColor = UIColor.white
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.gray
        pageIndicator.pageIndicatorTintColor = UIColor.black
        imageSlider.pageIndicator = pageIndicator
        imageSlider.contentScaleMode = UIViewContentMode.scaleAspectFit
        imageSlider.setImageInputs(imageUrls)
        
        
        if let price = product?.productPrice{
            Pricelabel.text = "\(price) TL"
        }
        
        Titlelabel.text = product?.productName
        DescriptiontextView.text = product?.productDescription
        urlString = product?.productModelUrl ?? ""
        
        Favoributton.addTarget(self, action: #selector(didTapAddFavorite), for: .touchUpInside)
        Basketbutton.addTarget(self, action: #selector(didTapAddBasket), for: .touchUpInside)
        Show3Dbutton.addTarget(self, action: #selector(didTapShowModel), for: .touchUpInside)
    
        setupUI()
    }
    
    
    // MARK: - Functions
    
    @objc func didTapAddFavorite(){
        
        if let productID = product?.id {
            FirebaseService.shared.addFavorite(with: productID, vc: self) { error in
                if error != nil {
                    print(error.localizedDescription)
                    AlertManager.showBasicAlert(on: self, title: "Error.", message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc func didTapShowModel(){
        self.activityIndicator.startAnimating()
        ModelViewModel().downloadUsdzModel(url: urlString) { succes, url in
            if succes {
                guard let url = url else {return}
                DispatchQueue.main.async {
                    
                     let vc = QuickLookController(url: url)
                     self.navigationController?.pushViewController(vc, animated: false)
              
                    self.activityIndicator.stopAnimating()
                }
            } else {
                
            }
        }
        
    }
    
    @objc func didTapAddBasket(){
        
        var data  = UserDefaults.standard.data(forKey: "basket") ?? nil
        
        if data != nil {
            do {
                let decoder = JSONDecoder()
                
                basket = try decoder.decode([productGet].self, from: data!)
                
                if let product = product {
                    basket.append(product)
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(basket)
                        UserDefaults.standard.set(data, forKey: "basket")
                        AlertManager.showBasicAlert(on: self, title: "Eklendi.", message: "Ürün Sepetinize Eklendi.")
                    } catch {
                        print("Unable to Encode Note (\(error))")
                        AlertManager.showBasicAlert(on: self, title: "Error.", message: error.localizedDescription)
                    }
                }
            } catch {
                AlertManager.showBasicAlert(on: self, title: "Error.", message: error.localizedDescription)
            }
        } else {
            if let product = product{
                do {
                    basket.append(product)
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(basket)
                    UserDefaults.standard.set(data, forKey: "basket")
                    AlertManager.showBasicAlert(on: self, title: "Eklendi.", message: "Ürün Sepetinize Eklendi.")
                } catch {
                    print("Unable to Encode Note (\(error))")
                    AlertManager.showBasicAlert(on: self, title: "Error.", message: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        
        
        self.view.addSubview(imageSlider)
        self.view.addSubview(Titlelabel)
        self.view.addSubview(Pricelabel)
        self.view.addSubview(DescriptiontextView)
        self.view.addSubview(Show3Dbutton)
        self.view.addSubview(Favoributton)
        self.view.addSubview(Basketbutton)
        self.view.addSubview(activityIndicator)
        
        
        activityIndicator?.center = self.view.center
        
        Titlelabel.translatesAutoresizingMaskIntoConstraints = false
        Pricelabel.translatesAutoresizingMaskIntoConstraints = false
        DescriptiontextView.translatesAutoresizingMaskIntoConstraints = false
        Show3Dbutton.translatesAutoresizingMaskIntoConstraints = false
        Favoributton.translatesAutoresizingMaskIntoConstraints = false
        Basketbutton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            Titlelabel.topAnchor.constraint(equalTo: self.imageSlider.bottomAnchor, constant: 50),
            Titlelabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            
            Pricelabel.topAnchor.constraint(equalTo: self.imageSlider.bottomAnchor, constant: 50),
            Pricelabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
            
            DescriptiontextView.topAnchor.constraint(equalTo: self.Titlelabel.bottomAnchor, constant: 50),
            DescriptiontextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            DescriptiontextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            
            
            Show3Dbutton.topAnchor.constraint(equalTo: self.DescriptiontextView.bottomAnchor, constant: 50),
            Show3Dbutton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            Show3Dbutton.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 80) / 2),
            
            Favoributton.topAnchor.constraint(equalTo: self.DescriptiontextView.bottomAnchor, constant: 50),
            Favoributton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            Favoributton.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 80) / 2),
            
            Basketbutton.topAnchor.constraint(equalTo: self.Show3Dbutton.bottomAnchor, constant: 50),
            Basketbutton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            Basketbutton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            Basketbutton.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 80) / 2),
            
        ])
    }
}
