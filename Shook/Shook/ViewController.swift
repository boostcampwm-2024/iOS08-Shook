//
//  ViewController.swift
//  Shook
//
//  Created by hyunjun on 11/4/24.
//

import UIKit

class ViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let broadcastViewController = BroadcastViewController()
        broadcastViewController.tabBarItem = UITabBarItem(title: "Broadcast", image: UIImage(systemName: "antenna.radiowaves.left.and.right"), tag: 0)
        
        let responseViewController = ResponseViewController()
        responseViewController.tabBarItem = UITabBarItem(title: "Response", image: UIImage(systemName: "bubble.left.and.bubble.right"), tag: 1)
        
        viewControllers = [broadcastViewController, responseViewController]
    }
}
