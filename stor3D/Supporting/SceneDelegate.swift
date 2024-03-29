//
//  SceneDelegate.swift
//  stor3D
//
//  Created by Tunay Toksöz on 30.11.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.setupWindow(with: scene)
        self.checkAuthentication()
    }

    private func setupWindow(with scene: UIScene){
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        self.window = window
        self.window?.makeKeyAndVisible()
        
    }
    
    public func checkAuthentication(){
        if Auth.auth().currentUser == nil {
            self.goToController(with: LoginController())
        } else {
            self.goToController(with: MainTabBarController())
        }
    }

    
    private func goToController(with viewController: UIViewController) {
           DispatchQueue.main.async { [weak self] in
               UIView.animate(withDuration: 0.25) {
                   self?.window?.layer.opacity = 0
                   
               } completion: { [weak self] _ in
                   
                   self?.window?.rootViewController = viewController
                   
                   UIView.animate(withDuration: 0.25) { [weak self] in
                       self?.window?.layer.opacity = 1
                   }
               }
           }
       }
}

