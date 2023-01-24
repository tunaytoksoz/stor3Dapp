//
//  AuthHeaderView.swift
//  stor3D
//
//  Created by Tunay Toksöz on 30.11.2022.
//

import UIKit

class AuthHeaderView: UIView {
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "s3")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let Titlelabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.text = "error"
        return label
    }()
    
    private let SubTitlelabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "error"
        return label
    }()
    
    init(title: String, subTitle: String){
        super.init(frame: .zero)
        self.Titlelabel.text = title
        self.SubTitlelabel.text = subTitle
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.addSubview(imageView)
        self.addSubview(Titlelabel)
        self.addSubview(SubTitlelabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        Titlelabel.translatesAutoresizingMaskIntoConstraints = false
        SubTitlelabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.imageView.widthAnchor.constraint(equalToConstant: 90),
            self.imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
                
            self.Titlelabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 19),
            self.Titlelabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.Titlelabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                      
            self.SubTitlelabel.topAnchor.constraint(equalTo: Titlelabel.bottomAnchor, constant: 12),
            self.SubTitlelabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.SubTitlelabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
        ])
    }


}
