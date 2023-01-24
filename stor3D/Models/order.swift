//
//  order.swift
//  stor3D
//
//  Created by Tunay Toksöz on 28.12.2022.
//

import Foundation

enum payment : Int{
    case kapidaOdeme = 0
    case krediKart = 1
    case havaleEft = 2
}

enum orderState : Int {
    case siparisAlindi = 0
    case hazırlanıyor = 1
    case kargoda = 2
    case teslimEdildi = 3
    case red = 4
}

struct order {
    let id : String
    let orderList : [String]
    let customer : String
    let email : String
    let adress : String
    let paymentType : payment
    let orderStatus : orderState
    let rejectDescription : String?
    let totalPrice : Double
}
