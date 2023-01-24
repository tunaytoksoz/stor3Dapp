//
//  productGet.swift
//  stor3D
//
//  Created by Tunay Toksöz on 19.12.2022.
//

import Foundation


struct productGet : Codable, Hashable{
    let id : String
    let productCategory: Int
    let productName : String
    let productPrice : Double
    let productStock : Int
    let productDescription : String
    let productImageUrl : [String]?
    let productModelUrl : String
}


