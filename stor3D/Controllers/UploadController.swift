//
//  UploadController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 8.12.2022.
//

import UIKit

class UploadController: UIViewController {
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.text = "Ürün Adı"
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.text = "Ürün Fiyatı"
        return label
    }()
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.text = "Toplam Stok Adeti"
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.text = "Ürün Açıklaması"
        return label
    }()
    
    private let descriptionTextView: UITextView = {
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
    
    private let titleField = CustomTextField(fieldType: .title)
    private let priceField = CustomTextField(fieldType: .price)
    private let stockField = CustomTextField(fieldType: .stock)
    private let imagesButton = CustomButton(title: "Resim Seç", fontSize: .medium)
    private let Model3DButton = CustomButton(title: "3D Modelini Seç", fontSize: .medium)
    private let uploadButton = CustomButton(title: "Ürünü Yükle", fontSize: .big)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(titleLabel)
        self.view.addSubview(priceLabel)
        self.view.addSubview(stockLabel)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(descriptionTextView)
        self.view.addSubview(titleField)
        self.view.addSubview(priceField)
        self.view.addSubview(stockField)
        self.view.addSubview(imagesButton)
        self.view.addSubview(Model3DButton)
        self.view.addSubview(uploadButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        titleField.translatesAutoresizingMaskIntoConstraints = false
        priceField.translatesAutoresizingMaskIntoConstraints = false
        stockField.translatesAutoresizingMaskIntoConstraints = false
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        imagesButton.translatesAutoresizingMaskIntoConstraints = false
        Model3DButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
            titleField.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 15),
            titleField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            titleField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            titleField.heightAnchor.constraint(equalToConstant: 45),
            
            priceLabel.topAnchor.constraint(equalTo: self.titleField.bottomAnchor, constant: 15),
            priceLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            priceLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
            priceField.topAnchor.constraint(equalTo: self.priceLabel.bottomAnchor, constant: 15),
            priceField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            priceField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            priceField.heightAnchor.constraint(equalToConstant: 45),
            
            stockLabel.topAnchor.constraint(equalTo: self.priceField.bottomAnchor, constant: 15),
            stockLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            stockLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
            stockField.topAnchor.constraint(equalTo: self.stockLabel.bottomAnchor, constant: 15),
            stockField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            stockField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            stockField.heightAnchor.constraint(equalToConstant: 45),
            
            descriptionLabel.topAnchor.constraint(equalTo: self.stockField.bottomAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
            descriptionTextView.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 15),
            descriptionTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            descriptionTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 140),
            
            imagesButton.topAnchor.constraint(equalTo: self.descriptionTextView.bottomAnchor, constant: 25),
            imagesButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            imagesButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
            Model3DButton.topAnchor.constraint(equalTo: self.imagesButton.bottomAnchor, constant: 25),
            Model3DButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            Model3DButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
            uploadButton.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -130),
            uploadButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            uploadButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),


        ])
    }

}
