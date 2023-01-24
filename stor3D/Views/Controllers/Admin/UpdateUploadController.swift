//
//  UpdateUploadController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 29.12.2022.
//

import UIKit
import DKImagePickerController
import Photos
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

class UpdateUploadController: UIViewController {
    
    public var product : productGet?
    public var docID : String?
    private var selectedPhotos : [UIImage] = []
    private var path = [URL]()
    private var activityIndicator : UIActivityIndicatorView!
    
    
    private let sectionSegment : UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Mobilya", "Beyaz Eşya", "Moda", "Elektronik"])
        segment.selectedSegmentTintColor = .systemBlue
        segment.selectedSegmentIndex = 0
        return segment
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
    private let modelField = CustomTextField(fieldType: .model)
    private let uploadButton = CustomButton(title: "Ürünü Güncelle", fontSize: .big)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .blue
        
        self.setupUI()
        
        if let product = product{
            self.sectionSegment.selectedSegmentIndex = product.productCategory
            self.titleField.text = product.productName
            self.priceField.text = String(product.productPrice.formatted())
            self.stockField.text = String(product.productStock)
            self.modelField.text = product.productModelUrl
            self.descriptionTextView.text = product.productDescription
        }
        
        uploadButton.addTarget(self, action: #selector(didTapUploadButton), for: .touchUpInside)
    }
    
    // MARK: - OBJC FUNCTİONS
    
    @objc func didTapUploadButton(){
        self.activityIndicator.startAnimating()
        self.uploadButton.setTitle("Uploading", for: .disabled)
        self.uploadButton.isEnabled = false
        
        if let product = product{
            let product = Product(productCategory: category(rawValue: sectionSegment.selectedSegmentIndex) ?? .beyazEsya, id: product.id, productName: titleField.text ?? product.productName, productPrice: Double(self.priceField.text!) ?? product.productPrice, productStock: Int(self.stockField.text!) ?? product.productStock, productDescription: descriptionTextView.text, productImageUrl: product.productImageUrl, productModelUrl: modelField.text ?? product.productModelUrl)
            if let docID = docID{
                FirebaseService.shared.updateProduct(with: product, docID: docID) { wasUploaded , error in
                    if wasUploaded == true && error == nil {
                        self.uploadButton.isEnabled = true
                        
                        self.titleField.text = ""
                        self.priceField.text = ""
                        self.modelField.text = ""
                        self.descriptionTextView.text = ""
                        self.stockField.text = ""
                        self.activityIndicator.stopAnimating()
                        AlertManager.showBasicAlert(on: self, title: "Done", message: "Photos uploading is done")
                    } else {
                        self.uploadButton.isEnabled = true
                        self.titleField.text = ""
                        self.modelField.text = ""
                        self.priceField.text = ""
                        self.selectedPhotos = []
                        self.descriptionTextView.text = ""
                        self.stockField.text = ""
                        self.activityIndicator.stopAnimating()
                        AlertManager.showBasicAlert(on: self, title: "Bir Sorun Var", message: "\(error?.localizedDescription)")
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    // MARK: - UI Setup
    private func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(sectionSegment)
        self.view.addSubview(descriptionTextView)
        self.view.addSubview(titleField)
        self.view.addSubview(priceField)
        self.view.addSubview(stockField)
        self.view.addSubview(uploadButton)
        self.view.addSubview(modelField)
        self.view.addSubview(activityIndicator)
        
        
        activityIndicator?.center = self.view.center
      
        sectionSegment.translatesAutoresizingMaskIntoConstraints = false
        titleField.translatesAutoresizingMaskIntoConstraints = false
        priceField.translatesAutoresizingMaskIntoConstraints = false
        stockField.translatesAutoresizingMaskIntoConstraints = false
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        modelField.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
        NSLayoutConstraint.activate([
            sectionSegment.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 15),
            sectionSegment.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            sectionSegment.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
            titleField.topAnchor.constraint(equalTo: self.sectionSegment.bottomAnchor, constant: 15),
            titleField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            titleField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            titleField.heightAnchor.constraint(equalToConstant: 45),
            
            priceField.topAnchor.constraint(equalTo: self.titleField.bottomAnchor, constant: 15),
            priceField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            priceField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            priceField.heightAnchor.constraint(equalToConstant: 45),
            
            stockField.topAnchor.constraint(equalTo: self.priceField.bottomAnchor, constant: 15),
            stockField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            stockField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            stockField.heightAnchor.constraint(equalToConstant: 45),
            
            modelField.topAnchor.constraint(equalTo: self.stockField.bottomAnchor, constant: 15),
            modelField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            modelField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            modelField.heightAnchor.constraint(equalToConstant: 45),
            
            descriptionTextView.topAnchor.constraint(equalTo: self.modelField.bottomAnchor, constant: 15),
            descriptionTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            descriptionTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            
            
            uploadButton.topAnchor.constraint(equalTo: self.descriptionTextView.bottomAnchor, constant: 50),
            uploadButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            uploadButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),


        ])
    }

}
