//
//  ViewController.swift
//  LTAutoScrollView
//
//  Created by 高刘通 on 2018/4/3.
//  Copyright © 2018年 LT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        self.automaticallyAdjustsScrollViewInsets = false
        Deom1()
        Deom2()
    }
    
    func Deom1() {
        let autoScrollView = LTAutoScrollView(frame: CGRect(x: 0, y: 80, width: view.bounds.width, height: 200))
        view.addSubview(autoScrollView)
        autoScrollView.images = ["cycle_image1","cycle_image2"]
    }
    
    func Deom2() {
        let autoScrollView = LTAutoScrollView(frame: CGRect(x: 0, y: 300, width: view.bounds.width, height: 200))
        view.addSubview(autoScrollView)
        autoScrollView.autoType = .custom
        autoScrollView.autoViewHandle = {
            var views = [UIImageView]()
            for index in 1..<4 {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200))
                imageView.image = UIImage(named: "cycle_image\(index)")
                views.append(imageView)
            }
            return views
        }
    }
    

}

