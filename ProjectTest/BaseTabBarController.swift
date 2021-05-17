//
//  BaseTabBarController.swift
//  ProjectTest
//
//  Created by Mariam Khan on 5/4/21.
//

// CITATIONS:
// 1. https://www.youtube.com/watch?v=GL8-eM93EvQ&t=1057s - Implementing Tabbar Controller Class

import UIKit

// Tabbar Controller for easy variable and informationa acess across tabs
class BaseTabBarController: UITabBarController {
    
    var artistMBID: String = ""
    var artistName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    


}
