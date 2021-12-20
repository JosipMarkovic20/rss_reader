//
//  UITableView+Extension.swift
//  RSS Reader
//
//  Created by Josip Marković on 20.12.2021..
//

import Foundation
import UIKit

extension UITableView{
    func dequeueCell<T: UITableViewCell>(identifier: String) -> T{
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? T else{return T()}
        return cell
    }
}
