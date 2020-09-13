//
//  UIApplication+Extensions.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 13/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import Foundation

extension UIApplication {
    /**
     Returns currently presented view controller - useful for when setting up a method outside the view controller class
    */
    class func retrievePresentedViewController() -> UIViewController? {
        var presentViewController = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentViewController?.presentedViewController {
            presentViewController = pVC
        }

        return presentViewController
    }
}
