//
//  AdminProductController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 29.12.2022.
//

import UIKit
import SDWebImage

class AdminProductController: UIViewController {

    private var furniture : [productGet] = [productGet]()
    var furnitureDocIds : [String] = [String]()
    private var householdAppliances : [productGet] = [productGet]()
    var householdAppliancesDocIds : [String] = [String]()
    private var fashion : [productGet] = [productGet]()
    var fashionDocIds : [String] = [String]()
    private var electronic : [productGet] = [productGet]()
    var electronicDocIds : [String] = [String]()
    
    let refreshControl = UIRefreshControl()
    
    let sectionCategory : [String] = ["Mobilya", "Beyaz Eşya", "Moda",  "Elektronik"]
    let sectionCount : [Int] = [Int]()
    
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .black
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
        
    }
    
    @objc func signOut(){
        AuthService.shared.signOut { [weak self] error in
                   guard let self = self else { return }
                   if let error = error {
                       print(error.localizedDescription)
                       return
                   }
                   
                   if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                       sceneDelegate.checkAuthentication()
                   }
               }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func configureNavbar(){
        var image = UIImage(named: "s3")
        image = image?.resizeTo(size: CGSize(width: 30, height: 30))
        image = image?.withRenderingMode(.alwaysOriginal)
        title = "Ürünler"
        var imageView = UIImageView()
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: imageView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .done, target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.33, green: 0.53, blue: 0.49, alpha: 1.00)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.furniture.removeAll()
        self.householdAppliances.removeAll()
        self.fashion.removeAll()
        self.electronic.removeAll()
        self.electronicDocIds.removeAll()
        self.fashionDocIds.removeAll()
        self.householdAppliancesDocIds.removeAll()
        self.furnitureDocIds.removeAll()
        getData()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func getData(){
        FirebaseService.shared.getDataWithCategories(with: 0) { result, docIDs  in
                switch result {
                case .success(let products):
                    self.furniture = products
                    self.tableView.reloadData()
                    self.furnitureDocIds = docIDs
                case .failure(let error):
                    print(error)
                }
            }

            FirebaseService.shared.getDataWithCategories(with: 1) { result, docIDs in
                switch result {
                case .success(let products):
                    self.householdAppliances = products
                    self.householdAppliancesDocIds = docIDs
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }

            FirebaseService.shared.getDataWithCategories(with: 2) { result, docIDs in
                switch result {
                case .success(let products):
                    self.fashion = products
                    self.fashionDocIds = docIDs
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }

            FirebaseService.shared.getDataWithCategories(with: 3) { result, docIDs in
                switch result {
                case .success(let products):
                    self.electronic = products
                    self.electronicDocIds = docIDs
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
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
    
}

extension AdminProductController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCategory.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionCategory[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0 :
            return furniture.count
        case 1 :
            return householdAppliances.count
        case 2:
            return fashion.count
        case 3 :
            return electronic.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        switch indexPath.section{
        case 0:
            if let url = URL(string: furniture[indexPath.row].productImageUrl?.first ?? ""){
                cell.imageView?.sd_setImage(with: url)
            }
            cell.textLabel?.text = furniture[indexPath.row].productName
            return cell
        case 1:
            if let url = URL(string: householdAppliances[indexPath.row].productImageUrl?.first ?? ""){
                cell.imageView?.sd_setImage(with: url)
            }
            cell.textLabel?.text = householdAppliances[indexPath.row].productName
            return cell
        case 2:
            if let url = URL(string: fashion[indexPath.row].productImageUrl?.first ?? ""){
                cell.imageView?.sd_setImage(with: url)
            }
            cell.textLabel?.text = fashion[indexPath.row].productName
            return cell
        case 3:
            if let url = URL(string: electronic[indexPath.row].productImageUrl?.first ?? ""){
                cell.imageView?.sd_setImage(with: url)
            }
            cell.textLabel?.text = electronic[indexPath.row].productName
            return cell
        default:
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            switch indexPath.section{
            case 0:
                FirebaseService.shared.deleteProduct(with: furnitureDocIds[indexPath.row])
                furnitureDocIds.remove(at: indexPath.row)
                furniture.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            case 1:
                FirebaseService.shared.deleteProduct(with: householdAppliancesDocIds[indexPath.row])
                householdAppliancesDocIds.remove(at: indexPath.row)
                householdAppliances.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            case 2:
                FirebaseService.shared.deleteProduct(with: fashionDocIds[indexPath.row])
                fashionDocIds.remove(at: indexPath.row)
                fashion.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            case 3:
                FirebaseService.shared.deleteProduct(with: electronicDocIds[indexPath.row])
                electronicDocIds.remove(at: indexPath.row)
                electronic.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            default:
                return
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section{
        case 0:
            let product = furniture[indexPath.row]
            let docId = furnitureDocIds[indexPath.row]
            let vc = UpdateUploadController()
            vc.docID = docId
            vc.product = product
            vc.modalPresentationStyle = .pageSheet
            present(vc, animated: true)
        case 1:
            let product = householdAppliances[indexPath.row]
            let docId = householdAppliancesDocIds[indexPath.row]
            let vc = UpdateUploadController()
            vc.docID = docId
            vc.product = product
            vc.modalPresentationStyle = .pageSheet
            present(vc, animated: true)
        case 2:
            let product = fashion[indexPath.row]
            let docId = fashionDocIds[indexPath.row]
            let vc = UpdateUploadController()
            vc.docID = docId
            vc.product = product
            vc.modalPresentationStyle = .pageSheet
            present(vc, animated: true)
        case 3:
            let product = electronic[indexPath.row]
            let docId = electronicDocIds[indexPath.row]
            let vc = UpdateUploadController()
            vc.docID = docId
            vc.product = product
            vc.modalPresentationStyle = .pageSheet
            present(vc, animated: true)
        default:
            return
        }
    }
}
