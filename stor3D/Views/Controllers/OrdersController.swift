//
//  OrdersController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 28.12.2022.
//


import UIKit
import FirebaseAuth

class OrdersConroller: UIViewController {
    
    private var orderList : [order] = [order]()
    let refreshControl = UIRefreshControl()
    
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .black
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        setupUI()
        
        title = "Siparişlerim"
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        getData()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        getData()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func getData(){
        if let email = Auth.auth().currentUser?.email{
            FirebaseService.shared.getOrdeWithEmails(with: email) { result in
                switch result {
                case .success(let order):
                    self.orderList = order
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

extension OrdersConroller : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = orderList[indexPath.row].id
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let id = orderList[indexPath.row].orderList
        let order = orderList[indexPath.row]
        let vc = orderDetailsController()
        vc.id = id
        vc.orders = order
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
}

