//
//  UIViewController.swift
//  VirtualTourist
//
//  Created by manar AL-Towaim on 16/07/2019.
//  Copyright © 2019 manar AL-Towaim. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
