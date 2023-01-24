//
//  FavoriteTableViewCell.swift
//  stor3D
//
//  Created by Tunay Toksöz on 27.12.2022.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    static let identifier = "FavoriteTableViewCell"
    
    private var favorites : [productGet] = [productGet]()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.33, green: 0.53, blue: 0.49, alpha: 1.00)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let PriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.33, green: 0.53, blue: 0.49, alpha: 1.00)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titlesPosterImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlesPosterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(PriceLabel)
        
        NSLayoutConstraint.activate([
            
            titlesPosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            titlesPosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            titlesPosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            titlesPosterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -200),
            
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: titlesPosterImageView.trailingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            
            PriceLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 10),
            PriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            PriceLabel.leadingAnchor.constraint(equalTo: titlesPosterImageView.trailingAnchor, constant: 30),
            PriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
            
            
            
            
        ])
        
    }
    
    public func configure(with favorite: productGet ){
        
        if let urlFirst = favorite.productImageUrl?.first{
            guard let url = URL(string: "\(urlFirst)") else {return}
            
            titlesPosterImageView.sd_setImage(with: url)
            titleLabel.text = favorite.productName
            PriceLabel.text = String(favorite.productPrice.formatted()) + "TL "
        }
        

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
