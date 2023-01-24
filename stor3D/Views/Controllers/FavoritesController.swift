//
//  FavoritesController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 27.12.2022.
//

import UIKit

class FavoritesController: UIViewController {

    private var favorites : [productGet] = [productGet]()
    let refreshControl = UIRefreshControl()
    var userDocumentID : String = ""
        
        private let tableView: UITableView = {
            let tableView = UITableView()
            tableView.separatorColor = .black
            tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
            return tableView
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .blue
            setupUI()
            
            refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
            tableView.refreshControl = refreshControl
         
            
            
            
            title = "Favorilerim"
            
            tableView.delegate = self
            tableView.dataSource = self
            
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        self.tableView.reloadData()
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Functions
    
    @objc func refresh(_ sender: AnyObject) {
        getData()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func getData(){
        favorites.removeAll()
        AuthService.shared.fetchUserFavorite { fav, userdocID, error in
            if let userdocID = userdocID{
                self.userDocumentID = userdocID
            }
            if let fav = fav {
                for product in fav{
                    FirebaseService.shared.getDataWithIds(with: product) { result in
                        switch result {
                        case .success(let products):
                            self.favorites.append(contentsOf: products)
                            self.tableView.reloadData()
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - UI Setup
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
    
extension FavoritesController : UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return favorites.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as? FavoriteTableViewCell else {
                return UITableViewCell()
            }
            
            let favorite = favorites[indexPath.row]
            cell.configure(with: favorite)
            return cell
        }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var id = favorites[indexPath.row].id
            FirebaseService.shared.deleteFavorite(with: id, docID: userDocumentID)
            favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
    }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 250
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let vc  = DetailController()
            vc.product = self.favorites[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
  

