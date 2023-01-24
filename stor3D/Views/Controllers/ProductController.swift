//
//  ProductController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 22.12.2022.
//

import UIKit

class ProductController: UIViewController {
    
    var product : [productGet] = [productGet]()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ProductPageCollectionViewCell.self, forCellWithReuseIdentifier: ProductPageCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
         let productcategory : Int = product[0].productCategory
        
            switch productcategory{
            case 0:
                self.title = "Mobilya"
            case 1:
                self.title = "Beyaz Eşya"
            case 2:
                self.title = "Moda"
            case 3:
                self.title = "Elektronik"
            default:
                self.title = "Ürünler"
            }

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

}

extension ProductController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductPageCollectionViewCell.identifier, for: indexPath) as? ProductPageCollectionViewCell else { return UICollectionViewCell()
        }
        
        DispatchQueue.main.async {
            cell.configure(with: self.product[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let vc = DetailController()
        vc.product = product[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension ProductController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let columns: CGFloat = 2
        let spacing: CGFloat = 4
        let totalHorizontalSpacing = (columns + 1) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth * 1.7)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

