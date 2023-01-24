//
//  CategoriesTableViewCell.swift
//  stor3D
//
//  Created by Tunay Toksöz on 22.12.2022.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {
    
    static let identifier = "CategoriesTableViewCell"
    
    private var kategoriler : [categoriess] = [categoriess]()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.33, green: 0.53, blue: 0.49, alpha: 1.00)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titlesPosterImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlesPosterImageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            
            titlesPosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            titlesPosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            titlesPosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            titlesPosterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -200),
            
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: titlesPosterImageView.trailingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
            
            
            
            
        ])
        
    }
    
    public func configure(with kategori: categoriess){
        guard let url = URL(string: "\(kategori.imageUrl)") else {return}

        titlesPosterImageView.sd_setImage(with: url)
        titleLabel.text = kategori.name
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
