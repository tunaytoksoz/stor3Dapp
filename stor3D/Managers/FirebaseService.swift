//
//  FirebaseService.swift
//  stor3D
//
//  Created by Tunay Toksöz on 18.12.2022.
//

import Foundation
import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore


class FirebaseService {
    public static let shared = FirebaseService()
    private init(){}
    
    public func getDataWithCategories(with category: Int, completion: @escaping (Result<[productGet],Error>, [String]) -> Void){
        let firestore = Firestore.firestore()
        
        var productsArray : [productGet] = [productGet]()
        var documentIDs : [String] = [String]()
        firestore.collection("products").whereField("category", isEqualTo: category).getDocuments(source: .default) { data, error in
            guard let data = data, error == nil else {
                return
            }
            
            if data.isEmpty == false && data != nil {
                for document in data.documents{
                    let docID = document.documentID
                    documentIDs.append(docID)
                    if let id = document.get("id") as? String{
                        if let productCategory = document.get("category") as? Int{
                            if let productName = document.get("productName") as? String{
                                if let productPrice = document.get("productPrice") as? Double{
                                    if let productStock = document.get("productStock") as? Int{
                                        if let imagesUrl = document.get("images") as? [String] {
                                            if let description = document.get("productDescription") as? String {
                                                if let modelUrl = document.get("modelUrl") as? String {
                                                    let product = productGet(id: id, productCategory: productCategory, productName: productName, productPrice: productPrice, productStock: productStock, productDescription: description, productImageUrl: imagesUrl, productModelUrl: modelUrl)
                                                    productsArray.append(product)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
                completion(.success(productsArray), documentIDs)
            }
        }
    }
    
    public func getDataWithIds(with id: String, completion: @escaping (Result<[productGet],Error>) -> Void){
        let firestore = Firestore.firestore()
        
        var productsArray : [productGet] = [productGet]()
        
        firestore.collection("products").whereField("id", isEqualTo: id).getDocuments(source: .default) { data, error in
            guard let data = data, error == nil else {
                return
            }
            
            if data.isEmpty == false && data != nil {
                for document in data.documents{
                    let documentID = document.documentID
                    if let id = document.get("id") as? String{
                        if let productCategory = document.get("category") as? Int{
                            if let productName = document.get("productName") as? String{
                                if let productPrice = document.get("productPrice") as? Double{
                                    if let productStock = document.get("productStock") as? Int{
                                        if let imagesUrl = document.get("images") as? [String] {
                                            if let description = document.get("productDescription") as? String {
                                                if let modelUrl = document.get("modelUrl") as? String{
                                                    let product = productGet(id: id, productCategory: productCategory, productName: productName, productPrice: productPrice, productStock: productStock, productDescription: description, productImageUrl: imagesUrl, productModelUrl: modelUrl)
                                                    productsArray.append(product)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
                completion(.success(productsArray))
            }
        }
    }
    
    public func getAllProducts(completion: @escaping (Result<[productGet],Error>, [String]) -> Void){
        let firestore = Firestore.firestore()
        
        var productsArray : [productGet] = [productGet]()
        var documentIDs : [String] = [String]()
        
        firestore.collection("products").getDocuments(source: .default) { data, error in
            guard let data = data, error == nil else {
                return
            }
            
            if data.isEmpty == false && data != nil {
                for document in data.documents{
                    var docID = document.documentID
                    documentIDs.append(docID)
                    if let id = document.get("id") as? String{
                        if let productCategory = document.get("category") as? Int{
                            if let productName = document.get("productName") as? String{
                                if let productPrice = document.get("productPrice") as? Double{
                                    if let productStock = document.get("productStock") as? Int{
                                        if let imagesUrl = document.get("images") as? [String] {
                                            if let description = document.get("productDescription") as? String {
                                                if let modelUrl = document.get("modelUrl") as? String {
                                                    let product = productGet(id: id, productCategory: productCategory, productName: productName, productPrice: productPrice, productStock: productStock, productDescription: description, productImageUrl: imagesUrl, productModelUrl: modelUrl)
                                                    productsArray.append(product)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
                completion(.success(productsArray), documentIDs)
            }
            
            
        }
    }

    
    
    public func addFavorite(with productID : String, vc : UIViewController, completion: @escaping (Error) -> Void) {
        AuthService.shared.fetchUserFavorite { fav, docId, error in
            if var favs = fav {
                favs.append(productID)
                favs = Array(Set(favs))
                let firestore = Firestore.firestore()
                if let docId = docId{
                    firestore.collection("users").document(docId).setData(["favorite" : favs], merge: true) { error in
                        if error != nil {
                            print(error?.localizedDescription)
                        } else {
                            AlertManager.showBasicAlert(on: vc, title: "Eklendi", message: "Ürün Favorilerinize Eklendi.")
                        }
                    }
                }
            }
        }
    }
    
    public func deleteFavorite(with id: String, docID: String){
        let favoriteRef = Firestore.firestore().collection("users").document(docID)
        
        favoriteRef.updateData(["favorite" : FieldValue.arrayRemove([id])]) { error in
            if error != nil {
                print(error?.localizedDescription)
            }
        }
    }
    
    public func deleteProduct(with id: String) {
        let firestore = Firestore.firestore()
        
        firestore.collection("products").document(id).delete()
    }
    
    
    public func uploadProduct(with selectedPhotos: [UIImage], product: Product, completion: @escaping (Bool, Error?) -> Void){
        
        let storage = Storage.storage()
        
        let storageReference = storage.reference()
        
        let uuidProduct = UUID().uuidString
        
        let mediaFolder = storageReference.child("images").child(uuidProduct)
        
        let mediaFolderModel = storageReference.child("models")
        
        var imageUrls = [String]()
        
        for (photo) in selectedPhotos {
          
            if let data = photo.jpegData(compressionQuality: 0.7) {
                let uuid = UUID().uuidString
                
                let imageReference = mediaFolder.child("\(uuid).jpg")
                
                imageReference.putData(data) { metada, error in
                    if error == nil && metada != nil {
                        
                        imageReference.downloadURL { url, error in
                            if error == nil {
                                
                                var imageUrl = url?.absoluteString
                                
                                imageUrls.append(imageUrl!)
                                
                                if imageUrls.count == selectedPhotos.count {
                                    
                                    let productDictionary = [
                                        "category" : product.productCategory.rawValue,
                                        "id" : product.id,
                                        "productName" : product.productName,
                                        "productPrice" : product.productPrice,
                                        "productStock" : product.productStock,
                                        "productDescription" : product.productDescription,
                                        "images" : imageUrls,
                                        "modelUrl" : product.productModelUrl
                                    ] as [String : Any]
                                    
                                    let firestore = Firestore.firestore()
                                    
                                    
                                    firestore.collection("products").addDocument(data: productDictionary) { error in
                                        if error == nil {
                                            completion(true, error)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    public func updateProduct(with product: Product, docID: String, completion: @escaping (Bool, Error?) -> Void){
        
        let productDictionary = [
            "category" : product.productCategory.rawValue,
            "id" : product.id,
            "productName" : product.productName,
            "productPrice" : product.productPrice,
            "productStock" : product.productStock,
            "productDescription" : product.productDescription,
            "images" : product.productImageUrl!,
            "modelUrl" : product.productModelUrl
        ] as [String : Any]
        
        let firestore = Firestore.firestore()
        
        
        firestore.collection("products").document(docID).updateData(
            productDictionary) { error in
                if error == nil {
                    completion(true,nil)
                }
            }
    }
    
    
    public func uploadOrder(with order : order, completion: @escaping (Bool, Error?) -> Void){
        
        let firestore = Firestore.firestore()
        
        let orderDictionary = [
            "id" : order.id,
            "orderList" : order.orderList,
            "customer" : order.customer,
            "customerEmail" : order.email,
            "adress" : order.adress,
            "paymentType" : order.paymentType.rawValue,
            "orderStatus" : order.orderStatus.rawValue,
            "rejectDesc" : "",
            "totalPrice" : order.totalPrice
        ] as [String : Any]
        
        firestore.collection("orders").addDocument(data: orderDictionary) { error in
            if error == nil {
                completion(true, error)
                self.addOrderUsers(with: order.id, email: order.email)
            }
        }
    }
    
    public func addOrderUsers(with orderID : String, email : String){
        let firestore = Firestore.firestore()
        
        firestore.collection("users").whereField("email", isEqualTo: email).getDocuments { data, error in
            if error == nil {
                
                guard let data = data, error == nil else {
                    return
                }
                var documentID : String = ""
                if data.isEmpty == false && data != nil {
                    for document in data.documents{
                        documentID = document.documentID
                        if var orders = document.get("order") as? [String] {
                            orders.append(orderID)
                            firestore.collection("users").document(documentID).updateData([
                                                                                        "order" : orders
                            ]) { error in
                                if error  == nil {
                                    print("ok")
                                }
                            }
                        }
                    }
                    
                    
                }
            }
        }
    }
    
    
    public func changeAdressFromFirebase(with adress : String, email : String, vc: UIViewController){
        let firestore = Firestore.firestore()
        
        firestore.collection("users").whereField("email", isEqualTo: email).getDocuments { data, error in
            if error == nil {
                
                guard let data = data, error == nil else {
                    return
                }
                var documentID : String = ""
                if data.isEmpty == false && data != nil {
                    for document in data.documents{
                        documentID = document.documentID
                    }
                    
                    firestore.collection("users").document(documentID).updateData([
                                                                                "adress" : adress
                    ]) { error in
                        if error  == nil {
                            AlertManager.showBasicAlert(on: vc, title: "Başarılı", message: "Adres Değiştirme İşlemi Başarılı.")
                        }
                    }
                }
            }
        }
    }
    
    
    public func getOrdeWithEmails(with email: String, completion: @escaping (Result<[order],Error>) -> Void){
        let firestore = Firestore.firestore()
        
        var orderArray : [order] = [order]()
        
        firestore.collection("orders").whereField("customerEmail", isEqualTo: email).getDocuments(source: .default) { data, error in
            guard let data = data, error == nil else {
                return
            }
            
            if data.isEmpty == false && data != nil {
                for document in data.documents{
                    let documentID = document.documentID
                    if let id = document.get("id") as? String{
                        if let orderList = document.get("orderList") as? [String]{
                            if let customer = document.get("customer") as? String{
                                if let customerEmail = document.get("customerEmail") as? String{
                                    if let adress = document.get("adress") as? String{
                                        if let paymentType = document.get("paymentType") as? Int{
                                            if let orderStatus = document.get("orderStatus") as? Int {
                                                if let rejectDesc = document.get("rejectDesc") as? String {
                                                    if let totalPrice = document.get("totalPrice") as? Double{
                                                        let order = order(id: id, orderList: orderList, customer: customer, email: customerEmail, adress: adress, paymentType: payment(rawValue: paymentType) ?? .kapidaOdeme, orderStatus: orderState(rawValue: orderStatus) ?? .hazırlanıyor, rejectDescription: rejectDesc, totalPrice: totalPrice)
                                                        orderArray.append(order)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
                completion(.success(orderArray))
            }
        }
    }
    
    public func getAllOrders(completion: @escaping (Result<[order],Error>, [String]) -> Void){
        let firestore = Firestore.firestore()
        
        var orderArray : [order] = [order]()
        var documentIDs : [String] = [String]()
        
        firestore.collection("orders").getDocuments(source: .default) { data, error in
            guard let data = data, error == nil else {
                return
            }
            
            if data.isEmpty == false && data != nil {
                for document in data.documents{
                    let documentID = document.documentID
                    documentIDs.append(documentID)
                    if let id = document.get("id") as? String{
                        if let orderList = document.get("orderList") as? [String]{
                            if let customer = document.get("customer") as? String{
                                if let customerEmail = document.get("customerEmail") as? String{
                                    if let adress = document.get("adress") as? String{
                                        if let paymentType = document.get("paymentType") as? Int{
                                            if let orderStatus = document.get("orderStatus") as? Int{
                                                if let rejectDesc = document.get("rejectDesc") as? String {
                                                    if let totalPrice = document.get("totalPrice") as? Double{
                                                        let order = order(id: id, orderList: orderList, customer: customer, email: customerEmail, adress: adress, paymentType: payment(rawValue: paymentType) ?? .kapidaOdeme, orderStatus: orderState(rawValue: orderStatus) ?? .hazırlanıyor, rejectDescription: rejectDesc, totalPrice: totalPrice)
                                                        orderArray.append(order)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
                completion(.success(orderArray), documentIDs)
            }
        }
    }
    
    public func updateOrderState(state: Int, orderID: String, rejectDesc: String, vc: UIViewController){
        let firestore = Firestore.firestore()
        
        firestore.collection("orders").whereField("id", isEqualTo: orderID).getDocuments { data, error in
            if error == nil {
                
                guard let data = data, error == nil else {
                    return
                }
                var documentID : String = ""
                if data.isEmpty == false && data != nil {
                    for document in data.documents{
                        documentID = document.documentID
                    }
                    
                    firestore.collection("orders").document(documentID).updateData([
                                                                                "orderStatus" : state,
                                                                                "rejectDesc" : rejectDesc
                    ]) { error in
                        if error  == nil {
                            AlertManager.showBasicAlert(on: vc, title: "Başarılı", message: "Adres Değiştirme İşlemi Başarılı.")
                        }
                    }
                }
            }
        }
    }
}







