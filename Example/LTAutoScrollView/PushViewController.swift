//
//  PushViewController.swift
//  LTAutoScrollView_Example
//
//  Created by 高刘通 on 2018/4/16.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import LTAutoScrollView

class PushViewController: UIViewController {

    private let images = ["image1", "image2" , "image1", "image2"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        view.addSubview(autoScrollView)
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*  设置为系统的pageControl样式利用dotType */
    private lazy var autoScrollView: LTAutoScrollView = {
        let autoScrollView = LTAutoScrollView(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 150))
        autoScrollView.glt_timeInterval = 1.5
        autoScrollView.images = images
        autoScrollView.imageHandle = {(imageView, imageName) in
            imageView.image = UIImage(named: imageName)
        }
        autoScrollView.didSelectItemHandle = {
            print("autoScrollView8 点击了第 \($0) 个索引")
        }
        
        let layout = LTDotLayout(dotColor: UIColor.white, dotSelectColor: UIColor.red, dotType: .default)
        /*设置dot的间距*/
        layout.dotMargin = 8
        /* 如果需要改变dot的大小，设置dotWidth的宽度即可 */
        layout.dotWidth = 10
        /*如需和系统一致，dot放大效果需手动关闭 */
        layout.isScale = false
        
        autoScrollView.dotLayout = layout
        return autoScrollView
    }()

}


