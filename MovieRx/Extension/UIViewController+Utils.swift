//
//  UIViewController+Utils.swift
//  MovieRx
//
//  Created by Gustavo Henrique on 17/04/19.
//  Copyright © 2019 Gustavo Henrique. All rights reserved.
//

import UIKit

extension UIViewController {

    func simpleAlert(title: String,message: String) -> UIAlertController {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let simpleAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(simpleAction)

        return alertController
    }
}
