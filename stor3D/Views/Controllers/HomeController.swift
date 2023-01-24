//
//  HomeController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 30.11.2022.
//

import UIKit
import Firebase
import FirebaseAuth


class HomeController: UIViewController, UITabBarControllerDelegate {

    let sectionCategory : [String] = ["Mobilyalar", "Beyaz Eşyalar", "Moda", "Elektronik"]
    let refreshControl = UIRefreshControl()
    
    private let tableView : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
       
        configureNavbar()
        configureHeader()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
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
    
    func configureNavbar(){
        var image = UIImage(named: "s3")
        image = image?.resizeTo(size: CGSize(width: 30, height: 30))
        image = image?.withRenderingMode(.alwaysOriginal)
        title = "Stor 3D"
        var imageView = UIImageView()
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: imageView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .done, target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.33, green: 0.53, blue: 0.49, alpha: 1.00)
    }
    
    func configureHeader(){
        let headerview = PhotoSliderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200))
       
        headerview.configure(with: ["https://firebasestorage.googleapis.com/v0/b/stor3d.appspot.com/o/header%2FScreenshot%202022-12-22%20at%2000.41.30.png?alt=media&token=200cbab9-5c90-4c7d-9894-529a464ae363","https://firebasestorage.googleapis.com/v0/b/stor3d.appspot.com/o/header%2FSTor%203d.png?alt=media&token=9d9e5d6d-b456-4f3b-8129-5e1723b82d17","https://firebasestorage.googleapis.com/v0/b/stor3d.appspot.com/o/header%2FSTor%203d%20(1).png?alt=media&token=675e4b26-393a-4766-a2fd-1924fcbd8e3b"])
        tableView.tableHeaderView = headerview
        tableView.sectionHeaderHeight = 30
    }
    
}



extension HomeController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCategory.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionCategory[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case 0 :
            FirebaseService.shared.getDataWithCategories(with: 0) { result, docIDs in
                switch result {
                case .success(let products):
                    cell.configure(with: products)
                case .failure(let error):
                    print(error)
                }
            }
        case 1:
            FirebaseService.shared.getDataWithCategories(with: 1) { result, docIDs in
                switch result {
                case .success(let products):
                    cell.configure(with: products)
                case .failure(let error):
                    print(error)
                }
            }
        case 2:
            FirebaseService.shared.getDataWithCategories(with: 2) { result, docIDs in
                switch result {
                case .success(let products):
                    cell.configure(with: products)
                case .failure(let error):
                    print(error)
                }
            }
        case 3:
            FirebaseService.shared.getDataWithCategories(with: 3) { result, docIDs in
                switch result {
                case .success(let products):
                    cell.configure(with: products)
                case .failure(let error):
                    print(error)
                }
            }
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
   /* func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }*/
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
}


extension HomeController: CollectionViewTableViewCellDelegate{
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: productGet) {
        DispatchQueue.main.async { [weak self] in
            let vc = DetailController()
            vc.product = viewModel
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

extension UIImage {
    func resizeTo(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: size))
        }
        return image.withRenderingMode(self.renderingMode)
    }
}
