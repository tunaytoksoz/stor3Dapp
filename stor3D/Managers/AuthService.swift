//
//  AuthService.swift
//  stor3D
//
//  Created by Tunay Toksöz on 30.11.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase


class AuthService{
    
    public static let shared = AuthService()
    private init(){}
    
    
    
   
    public func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool,Error?)-> Void){
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password
        
        Auth.auth().createUser(withEmail: email, password: password) {result, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let resultUser = result?.user else {
                completion(false, error)
                return
            }
            let db = Firestore.firestore()
            
            db.collection("users")
                .document(resultUser.uid)
                .setData([
                    "username" : username,
                    "email"    : email,
                    "order" : [],
                    "favorite" : [],
                    "adress" : ""
                ]) { error in
                    if let error = error {
                        completion(false, error)
                        return
                    }
                    
                    completion(true, nil)
                }
        }
    }
 
    public func SignIn(userRequest: LoginUserRequest, completion: @escaping (Error?)-> Void){
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { result, error in
            if let error = error {
                completion(error)
            } else{
                completion(nil)
            }
        }
    }
    
    public func signOut(completion: @escaping (Error?)-> Void){
        do{
            try Auth.auth().signOut()
            completion(nil)
        }catch{
            completion(error)
        }
    }
    
    public func passwordReset(with email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    public func fetchUser(completion: @escaping (User?, Error?) -> Void){
        guard let userUID = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        
        db.collection("users").whereField("email", isEqualTo: Auth.auth().currentUser?.email).getDocuments { data, error in
            guard let data = data, error == nil else {
                return
            }
            var userDefault : User?
            if data.isEmpty == false && data != nil {
                for document in data.documents{
                    let documentID = document.documentID
                    if let username = document.get("username") as? String{
                        if let email = document.get("email") as? String{
                            if let order = document.get("order") as? [String]{
                                if let favorite = document.get("favorite") as? [String] {
                                    if let adress = document.get("adress") as? String {
                                        let user = User(username: username, email: email, userUID: documentID, order: order, favorite: favorite, adress: adress)
                                        userDefault = user
                                    }
                                }
                            }
                        }
                        
                    }
                }
                completion(userDefault, nil)
            } else {
                print("else")
            }
        }
        
    }
    
    
    
    public func fetchUserFavorite(completion: @escaping ([String]?,String?,Error?) -> Void){
        guard let userUID = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        
        db.collection("users").whereField("email", isEqualTo: Auth.auth().currentUser?.email).getDocuments { data, error in
            guard let data = data, error == nil else {
                return
            }
            var favoriteUser : [String] = [String]()
            var documentId : String = ""
            if data.isEmpty == false && data != nil {
                for document in data.documents{
                    let documentID = document.documentID
                    if let favorite = document.get("favorite") as? [String] {
                        favoriteUser = favorite
                        documentId = documentID
                    }
                }
                completion(favoriteUser,documentId, nil)
            }
        }
    }
}
