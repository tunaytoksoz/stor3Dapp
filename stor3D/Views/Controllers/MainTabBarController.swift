//
//  MainTabBarController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 8.12.2022.
//

import UIKit
import Firebase
import FirebaseAuth

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser?.email == "tunaytoksoz@outlook.com" {
            
            let vc1 = UINavigationController(rootViewController: AdminProductController())
            let vc2 = UINavigationController(rootViewController: UploadController())
            let vc3 = UINavigationController(rootViewController: AdminOrderController())
            let vc4 = UINavigationController(rootViewController: AdminProfileController())
            
            vc1.tabBarItem.image = UIImage(systemName: "house.fill")
            vc2.tabBarItem.image = UIImage(systemName: "u.circle.fill")
            vc3.tabBarItem.image = UIImage(systemName: "basket.fill")
            vc4.tabBarItem.image = UIImage(systemName: "person.fill")
        
            vc1.title = "Ürünler"
            vc2.title = "Ürün Ekle"
            vc3.title = "Siparişler"
            vc4.title = "Profilim"
            
            tabBar.tintColor = .label
                    
            setViewControllers([vc1,vc2,vc3,vc4], animated: true)
            
        } else {
            let vc1 = UINavigationController(rootViewController: HomeController())
            let vc2 = UINavigationController(rootViewController: CategoriesController())
            let vc3 = UINavigationController(rootViewController: BasketController())
            let vc4 = UINavigationController(rootViewController: ProfileController())
            
            vc1.tabBarItem.image = UIImage(systemName: "house.fill")
            vc2.tabBarItem.image = UIImage(systemName: "c.circle.fill")
            vc3.tabBarItem.image = UIImage(systemName: "basket.fill")
            vc4.tabBarItem.image = UIImage(systemName: "person.fill")
      
            vc1.title = "Ürünler"
            vc2.title = "Kategoriler"
            vc3.title = "Sepetim"
            vc4.title = "Profilim"
            
            tabBar.tintColor = .label
            
            setViewControllers([vc1,vc2,vc3,vc4], animated: true)
        }
        
        
    }
}
