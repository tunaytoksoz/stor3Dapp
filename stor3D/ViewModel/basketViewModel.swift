//
//  basketViewModel.swift
//  stor3D
//
//  Created by Tunay Toksöz on 28.12.2022.
//

import Foundation
import UIKit

class basketViewModel {
    
    var user : User?
    
    
    public func removeObject(with product : [productGet]){
        UserDefaults.standard.removeObject(forKey: "basket")
        UserDefaults.standard.synchronize()
        
        
        do {
            let encoder = JSONEncoder()
            
            let data = try encoder.encode(product)

            UserDefaults.standard.set(data, forKey: "basket")
            print("saved")

        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    public func getOrder(with productList : [String], paymnetType: Int, totalPrice : Double, vc : UIViewController, completion: @escaping (Bool) -> Void){
        AuthService.shared.fetchUser { user, error in
            if error == nil {
                self.user = user
                if let userAdress = user?.adress{
                    if userAdress == "" {
                        AlertManager.showBasicAlert(on: vc.self, title: "Adres Bilgisi Eksik", message: "Lütfen adresinizi ekleyin")
                    } else {
                        let uuid = UUID().uuidString
                        var order = order(id: uuid, orderList: productList, customer: user?.username ?? "Unknown", email: user?.email ?? "Unknown", adress: userAdress, paymentType: payment(rawValue: paymnetType) ?? .kapidaOdeme, orderStatus: orderState.siparisAlindi, rejectDescription: "", totalPrice: totalPrice)
                        
                        FirebaseService.shared.uploadOrder(with: order) { wasUpload, error in
                            if error == nil && wasUpload == true {
                                AlertManager.showBasicAlert(on: vc.self, title: "Başarılı", message: "Siparişiniz Alındı.")
                                UserDefaults.standard.removeObject(forKey: "basket")
                                completion(true)
                            } else {
                                AlertManager.showBasicAlert(on: BasketController().self, title: "Bir Sorun Var", message: "Lütfen yeniden deneyin.")
                                completion(false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
}
