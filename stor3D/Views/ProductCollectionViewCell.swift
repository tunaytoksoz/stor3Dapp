//
//  ProductCollectionViewCell.swift
//  stor3D
//
//  Created by Tunay Toksöz on 19.12.2022.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProductCollectionViewCell"
    
    private let posterImageView : UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titlelabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "Title"
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemOrange
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = " TL"
        return label
    }()


    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
     
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func configure(with model: String, title: String, price: String){
        DispatchQueue.main.async {
            guard let url = URL(string: "\(model)") else {return}
            self.posterImageView.sd_setImage(with: url,completed: nil)
            self.titlelabel.text = title
            self.priceLabel.text = price
        }
        
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titlelabel)
        contentView.addSubview(priceLabel)
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        titlelabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: self.titlelabel.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            titlelabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            titlelabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor),
            titlelabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: titlelabel.bottomAnchor, constant: 10),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

}
