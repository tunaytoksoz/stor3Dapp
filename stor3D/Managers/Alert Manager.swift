//
//  Alert Manager.swift
//  stor3D
//
//  Created by Tunay Toksöz on 30.11.2022.
//

import Foundation
import UIKit

class AlertManager {
    
    private static func showBasicAlert(on vc: UIViewController,with title: String, message: String?){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam.", style: .default))
            vc.present(alert, animated: true)
        }
    }
    
}

extension AlertManager {
    
    public static func showInvalidEmailAlert(on vc: UIViewController){
        self.showBasicAlert(on: vc, with: "Geçersiz Email", message: "Lütfen Geçerli Bir Email Adresi Girin!")
    }
    public static func showInvalidPasswordAlert(on vc: UIViewController){
        self.showBasicAlert(on: vc, with: "Geçersiz Şifre", message: "Lütfen Şifrenizi Doğru Girin!")
    }
    public static func showInvalidUsernameAlert(on vc: UIViewController){
        self.showBasicAlert(on: vc, with: "Geçersiz Kullanıcı Adı", message: "Lütfen Geçerli Bir Kullanıcı Adı Girin!")
    }
}

extension AlertManager {
    public static func showRegistrationErrorAlert(on vc: UIViewController){
        self.showBasicAlert(on: vc, with: "Kayıt Ol Hata", message: nil)
    }
    public static func showRegistrationErrorAlert(on vc: UIViewController, with error: Error){
        self.showBasicAlert(on: vc, with: "Kayıt Ol Hata", message: "\(error.localizedDescription)")
    }
}

extension AlertManager {
    public static func showSignInErrorAlert(on vc: UIViewController){
        self.showBasicAlert(on: vc, with: "Giriş Bilinmeyen Hata", message: nil)
    }
    public static func showSignInErrorAlert(on vc: UIViewController, with error: Error){
        self.showBasicAlert(on: vc, with: "Giriş Hata", message: "\(error.localizedDescription)")
    }
}

extension AlertManager {
    public static func showLogoutErrorAlert(on vc: UIViewController, with error: Error){
        self.showBasicAlert(on: vc, with: "Çıkış Hata", message: "\(error.localizedDescription)")
    }
}

extension AlertManager {
    public static func showPasswordResetSend(on vc: UIViewController){
        self.showBasicAlert(on: vc, with: "Parola Sıfırlama isteğiniz Gönderildi.", message: "Lütfen spam kutusuna da bakınız.")
    }
    
    public static func showSendingPasswordResetErrorAlert(on vc: UIViewController, with error: Error){
        self.showBasicAlert(on: vc, with: "Parola Sıfırlama Hata", message: "\(error.localizedDescription)")
    }
}

extension AlertManager {
    public static func showFetchingUserError(on vc: UIViewController, with error : Error){
        self.showBasicAlert(on: vc, with: "Error Fetching User", message: "\(error.localizedDescription)")
    }
    
    public static func showUnknownFetchingUserError(on vc: UIViewController){
        self.showBasicAlert(on: vc, with: "Unknown Error Fetching User",message: nil)
    }
}

extension AlertManager {
    public static func showBasicAlert(on vc: UIViewController, title : String, message : String){
        self.showBasicAlert(on: vc, with: title, message: message)
    }
}
