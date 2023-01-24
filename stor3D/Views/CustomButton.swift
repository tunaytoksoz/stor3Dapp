//
//  CustomButton.swift
//  stor3D
//
//  Created by Tunay Toksöz on 30.11.2022.
//

import UIKit

class CustomButton: UIButton {
    
    enum FontSize{
        case big
        case medium
        case small
    }
    
    init(title: String, hasBackGround: Bool = false, fontSize: FontSize){
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        
        
        self.backgroundColor = hasBackGround ? UIColor(red: 0.33, green: 0.53, blue: 0.49, alpha: 1.00) : .clear
        
        let titleColor : UIColor = hasBackGround ? .white : UIColor(red: 0.33, green: 0.53, blue: 0.49, alpha: 1.00)
        self.setTitleColor(titleColor, for: .normal)
        
        switch fontSize {
        case .big:
            self.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        case .medium:
            self.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        case.small:
            self.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
