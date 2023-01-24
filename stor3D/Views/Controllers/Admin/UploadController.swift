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
    
    private let photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 60)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier)
        return collectionView
    }()
    

    
    private let titleField = CustomTextField(fieldType: .title)
    private let priceField = CustomTextField(fieldType: .price)
    private let stockField = CustomTextField(fieldType: .stock)
    private let modelField = CustomTextField(fieldType: .model)
    private let imagesButton = CustomButton(title: "Resim Seç", fontSize: .medium)
    private let uploadButton = CustomButton(title: "Ürünü Yükle", fontSize: .big)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .blue
        
        self.setupUI()
        
        title = "Ürün Ekle"
        
        imagesButton.addTarget(self, action: #selector(didTapImagesButton) , for: .touchUpInside)
        uploadButton.addTarget(self, action: #selector(didTapUploadButton), for: .touchUpInside)
    }
    
    // MARK: - OBJC FUNCTİONS
    
    @objc func didTapUploadButton(){
        self.activityIndicator.startAnimating()
        self.uploadButton.setTitle("Uploading", for: .disabled)
        self.uploadButton.isEnabled = false
        self.imagesButton.isEnabled = false
        let uuid = UUID().uuidString
        FirebaseService.shared.uploadProduct(with: selectedPhotos, product: Product(productCategory: category(rawValue: sectionSegment.selectedSegmentIndex) ?? .mobilya, id: uuid, productName: self.titleField.text!, productPrice: Double(self.priceField.text!) ?? 0, productStock: Int(self.stockField.text!) ?? 0, productDescription: self.descriptionTextView.text, productImageUrl: [], productModelUrl: self.modelField.text!)) { wasUploaded, error in
            if wasUploaded == true && error == nil {
                self.uploadButton.isEnabled = true
                self.imagesButton.isEnabled = true
                self.titleField.text = ""
                self.priceField.text = ""
                self.modelField.text = ""
                self.descriptionTextView.text = ""
                self.stockField.text = ""
                self.activityIndicator.stopAnimating()
                AlertManager.showBasicAlert(on: self, title: "Done", message: "Photos uploading is done")
            } else {
                self.uploadButton.isEnabled = true
                self.imagesButton.isEnabled = true
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
        self.view.addSubview(sectionSegment)
        self.view.addSubview(descriptionTextView)
        self.view.addSubview(titleField)
        self.view.addSubview(priceField)
        self.view.addSubview(stockField)
        self.view.addSubview(imagesButton)
        self.view.addSubview(uploadButton)
        self.view.addSubview(modelField)
        self.view.addSubview(photosCollectionView)
        self.view.addSubview(activityIndicator)
        
        
        activityIndicator?.center = self.view.center
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        sectionSegment.translatesAutoresizingMaskIntoConstraints = false
        titleField.translatesAutoresizingMaskIntoConstraints = false
        priceField.translatesAutoresizingMaskIntoConstraints = false
        stockField.translatesAutoresizingMaskIntoConstraints = false
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        imagesButton.translatesAutoresizingMaskIntoConstraints = false
        modelField.translatesAutoresizingMaskIntoConstraints = false
        photosCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
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
            
            imagesButton.topAnchor.constraint(equalTo: self.descriptionTextView.bottomAnchor, constant: 10),
            imagesButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            imagesButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
            photosCollectionView.topAnchor.constraint(equalTo: self.imagesButton.bottomAnchor, constant: 10),
            photosCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            photosCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            photosCollectionView.heightAnchor.constraint(equalToConstant: 70),
            
            
            uploadButton.topAnchor.constraint(equalTo: self.photosCollectionView.bottomAnchor, constant: 10),
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
