//
//  UIView+Extension.swift
//  RSS Reader
//
//  Created by Josip Marković on 20.12.2021..
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(views: [UIView]){
        for view in views{
            self.addSubview(view)
        }
    }
}
