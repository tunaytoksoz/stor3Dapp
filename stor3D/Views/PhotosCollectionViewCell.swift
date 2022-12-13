//
//  PhotosCollectionViewCell.swift
//  stor3D
//
//  Created by Tunay Toksöz on 9.12.2022.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotosCollectionViewCell"
    
    private let imageView: UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.image = UIImage(systemName: "rays")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        imageView.frame = CGRect(x: 0,
                                 y: 0,
                             width : contentView.frame.size.width,
                             height: contentView.frame.size.height
                            )
    }
    
    public func configure(with image: UIImage){
        self.imageView.image = image
    }
}
