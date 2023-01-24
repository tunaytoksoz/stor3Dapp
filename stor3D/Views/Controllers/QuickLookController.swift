//
//  QuickLookController.swift
//  stor3D
//
//  Created by Tunay Toksöz on 28.12.2022.
//

import UIKit
import QuickLook
import SceneKit

class QuickLookController: UIViewController {

    var url: URL
    lazy var previewItem = NSURL()
     
     init(url: URL) {
         self.url = url
         super.init(nibName: nil, bundle: nil)
     }
     
     required init(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        
                self.previewItem = url as NSURL
                DispatchQueue.main.async {
                    let previewController = QLPreviewController()
                    previewController.dataSource = self
                    previewController.delegate = self
                    self.present(previewController, animated: true, completion: nil)
                }

    }
    
}

extension QuickLookController: QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.previewItem as QLPreviewItem
    }
    
    func previewControllerDidDismiss(_ controller: QLPreviewController) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}
