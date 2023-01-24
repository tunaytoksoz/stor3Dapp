//
//  profileViewModel.swift
//  stor3D
//
//  Created by Tunay Toksöz on 28.12.2022.
//

import Foundation
import UIKit

class profileViewModel {
    
    public func changeAdress(with adress : String, email : String, vc : UIViewController) {
        FirebaseService.shared.changeAdressFromFirebase(with: adress, email: email, vc: vc)
    }
}
