//
//  CustomTextField.swift
//  stor3D
//
//  Created by Tunay Toksöz on 30.11.2022.
//

import UIKit

class CustomTextField: UITextField {

    enum customTextFieldType{
        case email
        case password
        case username
        case title
        case price
        case stock
        case description
        case model
    }
    
    private let authFieldType : customTextFieldType
    
    
    init(fieldType: customTextFieldType) {
        self.authFieldType = fieldType
        super.init(frame: .zero)
        
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 10
        
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
        
        switch fieldType{
        case .username:
            self.placeholder = "Username"
        case .email:
            self.placeholder = "Email Adress"
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
        case .password:
            self.placeholder = "Password"
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true
        case .title:
            self.placeholder = "Ürün Adı"
        case .price:
            self.placeholder = "Ürün Fiyatı"
            self.keyboardType = .numberPad
        case .stock:
            self.placeholder = "Stok Adeti"
            self.keyboardType = .numberPad
        case .description:
            self.placeholder = "Açıklama"
        case .model:
            self.placeholder = "Model Adresini Ekleyin"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
