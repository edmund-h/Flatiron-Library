//
//  ViewFormatExtensions.swift
//  Flatiron Library
//
//  Created by Edmund Holderbaum on 3/15/17.
//  Copyright © 2017 Bozo Design Labs. All rights reserved.
//

import Foundation
import UIKit

class ViewFormatter {
    class func formatTableCell (_ cell: UITableViewCell ){
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.chocolate.cgColor
        cell.textLabel?.textColor = UIColor.chocolate
        cell.detailTextLabel?.textColor = UIColor.chocolate
    }
    
    class func formatTextField (_ field: UITextField){
        field.layer.borderWidth = 3
        field.layer.cornerRadius = 9
        field.layer.borderColor = UIColor.chocolate.cgColor
    }
    
    class func formatButton (_ button: UIButton){
        button.layer.cornerRadius = 9
        button.backgroundColor = UIColor.chocolate
        button.setTitleColor( UIColor.white, for: .normal)
    }
    
    class func formatLabel (_ label: UILabel){
        label.textColor = UIColor.chocolate
    }
}

extension UIColor{
    static let chocolate = UIColor(colorLiteralRed: 90/255.0, green: 71/255.0, blue: 56/255.0, alpha: 1)
}
