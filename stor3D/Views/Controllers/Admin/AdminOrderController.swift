//
//  AdminOrderController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 29.12.2022.
//

import UIKit

class AdminOrderController: UIViewController {

    private var orderList : [order] = [order]()
    var docIds : [String] = [String]()
    let refreshControl = UIRefreshControl()
    
    
    public let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .black
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        title = "Siparişler"
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.orderList.removeAll()
        getData()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.orderList.removeAll()
        getData()
        self.tableView.reloadData()
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
        FirebaseService.shared.getAllOrders(completion: { result, docIds in
            switch result{
            case .success(let order):
                self.orderList = order
                self.docIds = docIds
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
}

extension AdminOrderController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = orderList[indexPath.row].id
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            FirebaseService.shared.deleteProduct(with: docIds[indexPath.row])
            docIds.remove(at: indexPath.row)
            orderList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let id = orderList[indexPath.row].orderList
        let order = orderList[indexPath.row]
        let vc = AdminOrderDetailController()
        vc.id = id
        vc.orders = order
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
        
    }
}
