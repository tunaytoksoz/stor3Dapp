//
//  WebViewerController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 30.11.2022.
//

import UIKit
import WebKit

class WebViewerController: UIViewController {
    
    private let webView = WKWebView()
    
    private let urlString : String
    
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: urlString) else {
            self.dismiss(animated: true)
            return
        }
        
        self.webView.load(URLRequest(url: url))
        
        setupUI()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tamam", style: .done, target: self, action: #selector(didTapDone))
        self.navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
        self.view.addSubview(webView)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
                
        
        NSLayoutConstraint.activate([
            self.webView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }

    @objc func didTapDone(){
        self.dismiss(animated: true)
    }
    
    
}
