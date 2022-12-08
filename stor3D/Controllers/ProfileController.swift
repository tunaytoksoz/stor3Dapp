//
//  ProfileController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 8.12.2022.
//

import UIKit

class ProfileController: UIViewController {
    
    private let uploadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Upload", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupUI()
       
        uploadButton.addTarget(self, action: #selector(didTapUploadButton), for: .touchUpInside)
    }
    

    // MARK: - UI Setup
    private func setupUI() {
        self.view.addSubview(uploadButton)
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            uploadButton.topAnchor.constraint(equalTo: self.view.topAnchor),
            uploadButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            uploadButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            uploadButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            uploadButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            uploadButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    @objc func didTapUploadButton(){
        let vc = UploadController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    


}
