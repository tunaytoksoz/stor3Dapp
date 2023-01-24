//
//  BasketController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 8.12.2022.
//

import UIKit

class BasketController: UIViewController, UITabBarControllerDelegate {

    private var basket : [productGet] = [productGet]()
    private var basketID : [String] = [String]()
    private var elementFrequency : [productGet : Int] = [:]
    private var totalPrice : Int = 0
    let refreshControl = UIRefreshControl()
        
    private let tableView: UITableView = {
            let tableView = UITableView()
            tableView.separatorColor = .black
            tableView.register(BasketTableViewCell.self, forCellReuseIdentifier: BasketTableViewCell.identifier)
            return tableView
    }()
    private let orderButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sipariş Ver", for: .normal)
        button.backgroundColor = UIColor(red: 0.33, green: 0.53, blue: 0.49, alpha: 1.00)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.33, green: 0.53, blue: 0.49, alpha: 1.00)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "TL"
        return label
    }()
    private let TotalTextlabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.33, green: 0.53, blue: 0.49, alpha: 1.00)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "Toplam Ücret:"
        return label
    }()



        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .systemBackground
            setupUI()
            
            
            
            refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
            tableView.refreshControl = refreshControl
            
            orderButton.addTarget(self, action: #selector(didTapOrderButton), for: .touchUpInside)
            title = "Sepetim"
            
            tableView.delegate = self
            tableView.dataSource = self
            
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        self.tableView.reloadData()
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Functions
    
    @objc func didTapOrderButton(){
        if basketID.isEmpty == false {
            basketViewModel().getOrder(with: basketID, paymnetType: 0, totalPrice: Double(totalPrice), vc: self) { isOrderOk in
                if isOrderOk == true {
                    self.basket = []
                    self.elementFrequency = [:]
                    self.basketID = []
                    self.totalPrice = 0
                    self.tableView.reloadData()
                    self.refresh(self)
                    self.totalLabel.text = String(0) + " TL"
                }
            }
        } else {
            AlertManager.showBasicAlert(on: self, title: "Sepetiniz Boş", message: "Lütfen sepete ürün ekleyin")
        }
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.basket = []
        self.elementFrequency = [:]
        self.basketID = []
        self.totalPrice = 0
        getData()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func getData(){
        
        if let data = UserDefaults.standard.data(forKey: "basket") {
            do {
                let decoder = JSONDecoder()

                let basket = try decoder.decode([productGet].self, from: data)
                
                for product in basket{
                    self.basketID.append(product.id)
                }
                
                let tupleArray = basket.map { ($0, 1) }
                self.elementFrequency = Dictionary(tupleArray, uniquingKeysWith: +)
                self.basket = [productGet](elementFrequency.keys)
                totalPrice = 0
                for key in elementFrequency.keys {
                   totalPrice += Int(key.productPrice) * (elementFrequency[key] ?? 0)
                }
                self.totalLabel.text = "\(totalPrice) TL"
                
            } catch {
                print("Unable to Decode Notes (\(error))")
            }
        }

    }
    
    
        // MARK: - UI Setup
        private func setupUI() {
            view.addSubview(tableView)
            view.addSubview(orderButton)
            view.addSubview(totalLabel)
            view.addSubview(TotalTextlabel)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            totalLabel.translatesAutoresizingMaskIntoConstraints = false
            TotalTextlabel.translatesAutoresizingMaskIntoConstraints = false
            orderButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.75),
                
                TotalTextlabel.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 10),
                TotalTextlabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
                
                totalLabel.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 10),
                totalLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
                
                orderButton.topAnchor.constraint(equalTo: self.totalLabel.bottomAnchor, constant: 20),
                orderButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
                orderButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
            ])
        }
        
    }
    
extension BasketController : UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return basket.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BasketTableViewCell.identifier, for: indexPath) as? BasketTableViewCell else {
                return UITableViewCell()
            }
            
            
            let totalNumber : Int = elementFrequency[basket[indexPath.row]] ?? 0
            cell.configure(with: basket[indexPath.row], total: totalNumber)
            return cell
        }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            basket.remove(at: indexPath.row)
            basketViewModel().removeObject(with: basket)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
    }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 150
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let vc  = DetailController()
            vc.product = self.basket[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
  
