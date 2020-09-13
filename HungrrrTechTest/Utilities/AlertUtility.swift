//
//  AlertUtility.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 13/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import Foundation
import UIKit

class AlertUtility {
    
    func getTopViewController() -> UIViewController {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return UIViewController()
    }
    
    func presentOKAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        DispatchQueue.main.async {
            self.getTopViewController().present(alert, animated: true, completion: nil)
        }
    }
    
}
