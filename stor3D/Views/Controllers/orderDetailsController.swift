//
//  orderDetailsController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 28.12.2022.
//

import UIKit
import SDWebImage


import UIKit

class orderDetailsController: UIViewController {
    
    private var productList : [productGet] = [productGet]()
    public var id : [String] = [String]()
    public var orders : order?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .black
        return tableView
    }()
    
    private let Namelabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Name"
        return label
    }()
    
    private let TotalPrice: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = "0 Tl"
        return label
    }()
    
    private let Statelabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.text = "Hazırlanıyor"
        return label
    }()
    
    private let rejectLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = ""
        return label
    }()

    
    
    private let AdresTextview: UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.textColor = .label
        textView.textAlignment = .left
        textView.isSelectable = false
        textView.isEditable = false
        return textView
    }()

    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Title"
        return label
    }()
    
    private let PaymentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Title"
        return label
    }()




    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        
        if let orders = orders {
            self.Namelabel.text = orders.customer
            self.emailLabel.text = orders.email
            self.AdresTextview.text = orders.adress
            self.TotalPrice.text = "\(orders.totalPrice.formatted()) TL"
            
            var paymentType : Int = orders.paymentType.rawValue
            var status : Int = orders.orderStatus.rawValue
            var rejectText = orders.rejectDescription ?? "iptal"
            
            switch paymentType {
            case 0:
                self.PaymentLabel.text = "Kapıda Ödeme"
            case 1:
                self.PaymentLabel.text = "Kredi Kart"
            case 2:
                self.PaymentLabel.text = "Havale / Eft"
                
            default:
                self.PaymentLabel.text = "Kapıda Ödeme"
            }
            
            
            switch status {
            case 0:
                self.Statelabel.text = "Sipariş Alındı."
            case 1:
                self.Statelabel.text = "Hazırlanıyor."
            case 2:
                self.Statelabel.text = "Kargoya Teslim Edildi."
            case 3:
                self.Statelabel.text = "Teslim Edildi."
            case 4:
                self.Statelabel.text = "İptal Edildi."
                self.rejectLabel.text = rejectText
                
            default:
                self.Statelabel.text = "Sipariş Alındı"
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.productList.removeAll()
        for id in id{
            FirebaseService.shared.getDataWithIds(with: id) { result in
                switch result  {
                case .success(let product):
                    self.productList.append(contentsOf: product)
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(Namelabel)
        view.addSubview(emailLabel)
        view.addSubview(AdresTextview)
        view.addSubview(PaymentLabel)
        view.addSubview(rejectLabel)
        view.addSubview(Statelabel)
        view.addSubview(TotalPrice)
        
        Namelabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        AdresTextview.translatesAutoresizingMaskIntoConstraints = false
        PaymentLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        Statelabel.translatesAutoresizingMaskIntoConstraints = false
        rejectLabel.translatesAutoresizingMaskIntoConstraints = false
        TotalPrice.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            Namelabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            Namelabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            emailLabel.topAnchor.constraint(equalTo: self.Namelabel.bottomAnchor, constant: 15),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            AdresTextview.topAnchor.constraint(equalTo: self.emailLabel.bottomAnchor, constant: 15),
            AdresTextview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            AdresTextview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            AdresTextview.heightAnchor.constraint(equalToConstant: 100),
            
            TotalPrice.topAnchor.constraint(equalTo: self.AdresTextview.bottomAnchor, constant: 15),
            TotalPrice.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            PaymentLabel.topAnchor.constraint(equalTo: self.TotalPrice.bottomAnchor, constant: 15),
            PaymentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
    
            tableView.topAnchor.constraint(equalTo: self.PaymentLabel.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.30),
            
            Statelabel.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 15),
            Statelabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            Statelabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            rejectLabel.topAnchor.constraint(equalTo: self.Statelabel.bottomAnchor, constant: 15),
            rejectLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            rejectLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            
        ])
    }
    
}

extension orderDetailsController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let url = URL(string: productList[indexPath.row].productImageUrl?.first ?? ""){
            cell.imageView?.sd_setImage(with: url)
        }
        cell.textLabel?.text = productList[indexPath.row].productName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = DetailController()
        vc.product = productList[indexPath.row]
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
    
}

