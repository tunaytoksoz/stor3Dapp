//
//  CategoriesController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 8.12.2022.
//

import UIKit

class CategoriesController: UIViewController, UITabBarControllerDelegate {
    
    private var kategori : [categoriess] = [
                            categoriess(name: "Mobilya", imageUrl: "https://firebasestorage.googleapis.com/v0/b/stor3d.appspot.com/o/categories%2Fpuma-koltuk-takimi-mobilya-diyari-634-19-B.jpg?alt=media&token=6d9a895b-4113-4d04-bde6-f325595ecfb6", categoryCode: 0),
                            categoriess(name: "Beyaz Eşya", imageUrl: "https://firebasestorage.googleapis.com/v0/b/stor3d.appspot.com/o/categories%2F0000494.jpeg?alt=media&token=4bd28c68-bda0-4a50-b43f-7d7322252ecc", categoryCode: 1),
                            categoriess(name: "Moda", imageUrl:"https://firebasestorage.googleapis.com/v0/b/stor3d.appspot.com/o/categories%2FScreenshot%202022-12-22%20at%2015.35.42.png?alt=media&token=31e409e9-bbba-4b4f-b0d6-b2b67e6952a4", categoryCode: 2),
                            categoriess(name: "Elektronik", imageUrl: "https://firebasestorage.googleapis.com/v0/b/stor3d.appspot.com/o/categories%2FScreenshot%202022-12-22%20at%2015.37.29.png?alt=media&token=caa09ea6-0ab2-4a65-9deb-a5e661be4977", categoryCode: 3)
    ]
        
        private let tableView: UITableView = {
            let tableView = UITableView()
            tableView.separatorColor = .black
            tableView.register(CategoriesTableViewCell.self, forCellReuseIdentifier: CategoriesTableViewCell.identifier)
            return tableView
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            
            title = "Kategoriler"
            
            tableView.delegate = self
            tableView.dataSource = self
            
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
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
    
    extension CategoriesController : UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 4
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCell.identifier, for: indexPath) as? CategoriesTableViewCell else {
                return UITableViewCell()
            }
            
            let categories = kategori[indexPath.row]
            cell.configure(with: categories)
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 200
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            FirebaseService.shared.getDataWithCategories(with: indexPath.row) { result, docIDs in
                switch result {
                case .success(let products):
                    let vc = ProductController()
                    vc.product = products
                    self.navigationController?.pushViewController(vc, animated: true)
                case .failure(let error):
                    print(error)
                }
            }
            
            
        }
    }

    
  
