//
//  Product.swift
//  stor3D
//
//  Created by Tunay Toksöz on 18.12.2022.
//

import Foundation

enum category: Int{
    case mobilya = 0
    case beyazEsya = 1
    case moda = 2
    case elektronik = 3
}

struct Product{
    let productCategory: category
    let id : String
    let productName : String
    let productPrice : Double
    let productStock : Int
    let productDescription : String
    let productImageUrl : [String]?
    let productModelUrl : String
}
