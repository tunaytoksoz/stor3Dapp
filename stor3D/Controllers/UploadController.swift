//
//  UploadController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 8.12.2022.
//

import UIKit
import DKImagePickerController
import Photos
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

class UploadController: UIViewController {
    
    private var selectedPhotos : [UIImage] = []
    private var path = [URL]()
    
    
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
    
    private let photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 60)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let modelLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.text = ""
        return label
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
        
        imagesButton.addTarget(self, action: #selector(didTapImagesButton) , for: .touchUpInside)
        Model3DButton.addTarget(self, action: #selector(didTap3DButton), for: .touchUpInside)
        uploadButton.addTarget(self, action: #selector(didTapUploadButton), for: .touchUpInside)
    }
    
    // MARK: - OBJC FUNCTİONS
    
    @objc func didTapUploadButton(){
        self.uploadButton.setTitle("Uploading", for: .disabled)
        self.uploadButton.isEnabled = false
        self.imagesButton.isEnabled = false
        self.Model3DButton.isEnabled = false
       
        
        let storage = Storage.storage()
        
        let storageReference = storage.reference()
        
        let uuidProduct = UUID().uuidString
        
        let mediaFolder = storageReference.child("images").child(uuidProduct)
        
        var imageUrls = [String]()
        
        for photo in selectedPhotos {
            if let data = photo.jpegData(compressionQuality: 0.7) {
                let uuid = UUID().uuidString
                
                let imageReference = mediaFolder.child("\(uuid).jpg")
                
                imageReference.putData(data) { metada, error in
                    if error == nil && metada != nil {
                        
                        imageReference.downloadURL { url, error in
                            if error == nil {
                                
                                var imageUrl = url?.absoluteString
                                
                                imageUrls.append(imageUrl!)
                                
                                if imageUrls.count == self.selectedPhotos.count {
                                    
                                    let productDictionary = [
                                        "productName" : self.titleField.text,
                                        "productPrice" : self.priceField.text,
                                        "productStock" : self.stockField.text,
                                        "productDescription" : self.descriptionTextView.text,
                                        "images" : imageUrls
                                    ] as [String : Any]
                                    
                                    let firestore = Firestore.firestore()
                                    
                                    
                                    firestore.collection("products").addDocument(data: productDictionary) { error in
                                        if error == nil {
                                            self.uploadButton.isEnabled = true
                                            self.imagesButton.isEnabled = true
                                            self.Model3DButton.isEnabled = true
                                            AlertManager.showBasicAlert(on: self, title: "Done", message: "Photos uploading is done")
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func didTapImagesButton(){
        
        let pickerController = DKImagePickerController()

        pickerController.didSelectAssets = { [weak self] (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
            
            guard let self = self else { return }
            self.selectedPhotos.removeAll()
            for asset in assets {
                let image = self.getUIImage(asset: asset.originalAsset!)
                if image == nil {
                    print("image nil")
                    
                    continue
                }
                self.selectedPhotos.append(image!)
                self.photosCollectionView.reloadData()
            }
        }

        self.present(pickerController, animated: true) {}
       
    }
    
  
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        self.view.addSubview(photosCollectionView)
        
    }
    
    

    // MARK: - UI Setup
    private func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
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
        self.view.addSubview(modelLabel)
        self.view.addSubview(photosCollectionView)
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
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
        photosCollectionView.translatesAutoresizingMaskIntoConstraints = false
        modelLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
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
            
            photosCollectionView.topAnchor.constraint(equalTo: self.imagesButton.bottomAnchor, constant: 10),
            photosCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            photosCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            photosCollectionView.heightAnchor.constraint(equalToConstant: 70),
            
            Model3DButton.topAnchor.constraint(equalTo: self.photosCollectionView.bottomAnchor, constant: 15),
            Model3DButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            Model3DButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
            modelLabel.topAnchor.constraint(equalTo: self.Model3DButton.bottomAnchor, constant: 5),
            modelLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            modelLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
            uploadButton.topAnchor.constraint(equalTo: self.Model3DButton.bottomAnchor, constant: 20),
            uploadButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            uploadButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),


        ])
    }
    
    private func getUIImage(asset: PHAsset) -> UIImage? {
        
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageDataAndOrientation(for: asset, options: options) { data, _, _, _ in
            
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }

}


extension UploadController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifier, for: indexPath) as? PhotosCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: selectedPhotos[indexPath.row])
        return cell
        
    }
}

extension UploadController : UIDocumentPickerDelegate{
    @objc func didTap3DButton(){
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.usdz,.image])
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        path = urls as [URL]
        let sec_path = path[0].startAccessingSecurityScopedResource()
        modelLabel.text = path[0].absoluteString
    }
}
