//
//  ViewController.swift
//  LTAutoScrollView
//
//  Created by 高刘通 on 2018/4/3.
//  Copyright © 2018年 LT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var autoScrollView: LTAutoScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        self.automaticallyAdjustsScrollViewInsets = false
//        demo1()
//        demo2()
        demo3()
//        Deom3()
//        Deom4()
//        Deom5()
//        Deom6()
    }
    
    
    
    
    
    func Deom3() {
        let autoScrollView = LTAutoScrollView(frame: CGRect(x: 0, y: 360, width: view.bounds.width, height: 80))
        view.addSubview(autoScrollView)
        autoScrollView.autoType = .custom
        autoScrollView.scrollDirection = .vertical
        autoScrollView.pageControl.isHidden = true
        autoScrollView.autoViewHandle = {
            var views = [UIView]()
            for index in 1..<4 {
                
                let myV = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 80))
                myV.backgroundColor = UIColor.black

                let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40))
                label.text = "测试--\(index)"
                label.backgroundColor = UIColor.black
                label.textColor = UIColor.white
                label.textAlignment = .center
                myV.addSubview(label)
                views.append(myV)
                
                let label1 = UILabel(frame: CGRect(x: 0, y: 40, width: self.view.bounds.width, height: 40))
                label1.text = "测试--\(index)"
                label1.backgroundColor = UIColor.black
                label1.textColor = UIColor.white
                label1.textAlignment = .center
                myV.addSubview(label1)
                views.append(myV)
            }
            return views
        }
    }
    
    func Deom4() {
        let autoScrollView = LTAutoScrollView(frame: CGRect(x: 0, y: 460, width: view.bounds.width, height: 40))
        view.addSubview(autoScrollView)
        autoScrollView.autoType = .custom
        autoScrollView.scrollDirection = .vertical
        autoScrollView.pageControl.isHidden = true
        autoScrollView.autoViewHandle = {
            var views = [UILabel]()
            for index in 1..<4 {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40))
                label.text = "测试--\(index)"
                label.backgroundColor = UIColor.black
                label.textColor = UIColor.white
                label.textAlignment = .center
                views.append(label)
            }
            return views
        }
    }
    
    func Deom5() {
        let autoScrollView = LTAutoScrollView(frame: CGRect(x: 0, y: 520, width: view.bounds.width, height: 120))
        view.addSubview(autoScrollView)
        autoScrollView.autoType = .custom
        autoScrollView.scrollDirection = .horizontal
        autoScrollView.autoViewHandle = {
            var views = [UIImageView]()
            for index in 1..<4 {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200))
                imageView.image = UIImage(named: "cycle_image\(index)")
                views.append(imageView)
                
                let label = UILabel(frame: CGRect(x: 15, y: 15, width: 80, height: 40))
                label.text = "测试--\(index)"
                label.textColor = UIColor.white
                label.backgroundColor = UIColor.black
                label.textAlignment = .center
                imageView.addSubview(label)
            }
            return views
        }
    }
    
    func Deom6() {
        let autoScrollView = LTAutoScrollView(frame: CGRect(x: 30, y: 20, width: view.bounds.width - 60, height: 50))
        view.addSubview(autoScrollView)
        autoScrollView.glt_timeInterval = 0.5
        autoScrollView.scrollDirection = .horizontal
        autoScrollView.images = ["cycle_image1","cycle_image2"]
    }
}


extension ViewController {
    func demo1() {
        let autoScrollView = LTAutoScrollView(frame: CGRect(x: 30, y: 20, width: view.width - 60, height: 50))
        view.addSubview(autoScrollView)
        autoScrollView.glt_timeInterval = 0.5
        autoScrollView.scrollDirection = .horizontal
        autoScrollView.images = ["cycle_image1"]
        self.autoScrollView = autoScrollView
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        autoScrollView.images = ["cycle_image1","cycle_image2"]
//    }
}

extension ViewController {
    func demo2() {
        let autoScrollView = LTAutoScrollView(frame: CGRect(x: 0, y: 80, width: view.bounds.width, height: 120))
        view.addSubview(autoScrollView)
        autoScrollView.glt_timeInterval = 3
        autoScrollView.scrollDirection = .vertical
        autoScrollView.images = ["cycle_image1","cycle_image2"]
    }
}

extension ViewController {
    func demo3() {
        let autoScrollView = LTAutoScrollView(frame: CGRect(x: 0, y: 220, width: view.bounds.width, height: 120))
        view.addSubview(autoScrollView)
        autoScrollView.autoType = .default
        autoScrollView.scrollDirection = .horizontal
        autoScrollView.autoViewHandle = {
            var views = [UIImageView]()
            for index in 1..<4 {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200))
                imageView.image = UIImage(named: "cycle_image\(index)")
                views.append(imageView)
            }
            return views
        }
        let layout = LTDotLayout(dotImage: UIImage(named: "pageControlDot"), dotSelectImage: UIImage(named: "pageControlCurrentDot"))
        autoScrollView.dotLayout = layout
        autoScrollView.images = ["cycle_image1","cycle_image2","cycle_image3"]
        autoScrollView.imageHandle = {(imageView, imageName) in
            imageView.image = UIImage(named: imageName)
        }
        self.autoScrollView = autoScrollView
    }
}


extension UIView {

    public var x: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var r = self.frame
            r.origin.x = newValue
            self.frame = r
        }
    }
    
    public var y: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    }

    public var right: CGFloat{
        get{
            return self.x + self.width
        }
        set{
            var r = self.frame
            r.origin.x = newValue - frame.size.width
            self.frame = r
        }
    }
 
    public var bottom: CGFloat{
        get{
            return self.y + self.height
        }
        set{
            var r = self.frame
            r.origin.y = newValue - frame.size.height
            self.frame = r
        }
    }
    
    public var width: CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            var r = self.frame
            r.size.width = newValue
            self.frame = r
        }
    }
    public var height: CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var r = self.frame
            r.size.height = newValue
            self.frame = r
        }
    }

    
    public var size: CGSize{
        get{
            return self.frame.size
        }
        set{
            self.width = newValue.width
            self.height = newValue.height
        }
    }
    
}

