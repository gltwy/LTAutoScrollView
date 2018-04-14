//
//  ViewController.swift
//  LTAutoScrollView
//
//  Created by 1282990794@qq.com on 04/14/2018.
//  Copyright (c) 2018 1282990794@qq.com. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

    /*  用作本地图片展示 */
    private let images = ["image1", "image2" , "image1", "image2"]
    
    /*  pageControl未选中图片 */
    private let dotImage = UIImage(named: "pageControlDot")
    
    /*  pageControl选中图片 */
    private let dotSelectImage = UIImage(named: "pageControlCurrentDot")
    
    /*  用作网络图片展示 */
    private let imageUrls = [
                             "http://i2.hdslb.com/bfs/archive/41f5d8b1bb5c6a03e6740ab342c9461786d45c0a.jpg",
                             "http://scimg.jb51.net/allimg/151113/14-15111310522aG.jpg" ,
                             "http://i2.hdslb.com/bfs/archive/41f5d8b1bb5c6a03e6740ab342c9461786d45c0a.jpg",
                             "http://scimg.jb51.net/allimg/151113/14-15111310522aG.jpg"
                            ]

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.frame)
        scrollView.backgroundColor = UIColor.RGBA(0, 0, 0, 0.25)
        return scrollView
    }()
    
    /*  上下轮播利用scrollDirection控制  自定义pageControl*/
    private lazy var autoScrollView1: LTAutoScrollView = {
        let autoScrollView = LTAutoScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 150))
        view.addSubview(autoScrollView)
        autoScrollView.glt_timeInterval = 1.5
        autoScrollView.scrollDirection = .vertical
        autoScrollView.images = images
        //加载图片，内部不依赖任何图片加载框架
        autoScrollView.imageHandle = {(imageView, imageName) in
            imageView.image = UIImage(named: imageName)
        }
        let layout = LTDotLayout(dotWidth: 37/3.0, dotHeight: 19/3.0, dotMargin: 8, dotImage: dotImage, dotSelectImage: dotSelectImage)
        autoScrollView.dotLayout = layout
        return autoScrollView
    }()
    
    /*  左右轮播 加载网络图片 */
    private lazy var autoScrollView2: LTAutoScrollView = {
        let autoScrollView = LTAutoScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 150))
        view.addSubview(autoScrollView)
        autoScrollView.glt_timeInterval = 1.5
        autoScrollView.images = imageUrls
        autoScrollView.imageHandle = {(imageView, imageName) in
            imageView.kf.setImage(with: URL(string: imageName))
        }
        let layout = LTDotLayout(dotImage: dotImage, dotSelectImage: dotSelectImage)
        layout.dotMargin = 10.0
        autoScrollView.dotLayout = layout
        return autoScrollView
    }()
    
    /*  左右轮播 自定义控件 autoType = custom控制  */
    private lazy var autoScrollView3: LTAutoScrollView = {
        let autoScrollView = LTAutoScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 150))
        view.addSubview(autoScrollView)
        autoScrollView.glt_timeInterval = 1.5
        autoScrollView.autoType = .custom
        autoScrollView.autoViewHandle = {
            return self.customAutoView1()
        }
        let layout = LTDotLayout(dotImage: dotImage, dotSelectImage: dotSelectImage)
        autoScrollView.dotLayout = layout
        return autoScrollView
    }()
    
    /*  文字上下轮播两行 */
    private lazy var autoScrollView4: LTAutoScrollView = {
        let autoScrollView = LTAutoScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 60))
        view.addSubview(autoScrollView)
        autoScrollView.glt_timeInterval = 1.5
        autoScrollView.scrollDirection = .vertical
        autoScrollView.autoType = .custom
        autoScrollView.autoViewHandle = {
            return self.customAutoView2()
        }
        return autoScrollView
    }()
    
    /*  文字上下轮播一行 */
    private lazy var autoScrollView5: LTAutoScrollView = {
        let autoScrollView = LTAutoScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 30))
        view.addSubview(autoScrollView)
        autoScrollView.glt_timeInterval = 1.5
        autoScrollView.scrollDirection = .vertical
        autoScrollView.autoType = .custom
        autoScrollView.autoViewHandle = {
            return self.customAutoView3()
        }
        return autoScrollView
    }()
    
    /*  加载本地图片 */
    private lazy var autoScrollView6: LTAutoScrollView = {
        let autoScrollView = LTAutoScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 150))
        view.addSubview(autoScrollView)
        autoScrollView.glt_timeInterval = 1.5
        autoScrollView.images = images
        autoScrollView.imageHandle = {(imageView, imageName) in
            imageView.image = UIImage(named: imageName)
        }
        let layout = LTDotLayout(dotImage: dotImage, dotSelectImage: dotSelectImage)
        autoScrollView.dotLayout = layout
        return autoScrollView
    }()
    
    /*  隐藏pageControl */
    private lazy var autoScrollView7: LTAutoScrollView = {
        let autoScrollView = LTAutoScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 150))
        view.addSubview(autoScrollView)
        autoScrollView.glt_timeInterval = 1.5
        autoScrollView.images = images
        autoScrollView.imageHandle = {(imageView, imageName) in
            imageView.image = UIImage(named: imageName)
        }
        return autoScrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        
        
        let lable1 = baseLabel(Y: 34, text: "autoScrollView1")
        scrollView.addSubview(autoScrollView1)
        autoScrollView1.frame.origin.y = nextAutoViewY(lable1)
        
        let lable2 = baseLabel(Y: nextItemY(autoScrollView1), text: "autoScrollView2")
        scrollView.addSubview(autoScrollView2)
        autoScrollView2.frame.origin.y = nextAutoViewY(lable2)
        
        
        let lable3 = baseLabel(Y: nextItemY(autoScrollView2), text: "autoScrollView3")
        scrollView.addSubview(autoScrollView3)
        autoScrollView3.frame.origin.y = nextAutoViewY(lable3)
        
        let lable4 = baseLabel(Y: nextItemY(autoScrollView3), text: "autoScrollView4")
        scrollView.addSubview(autoScrollView4)
        autoScrollView4.frame.origin.y = nextAutoViewY(lable4)
        
        let lable5 = baseLabel(Y: nextItemY(autoScrollView4), text: "autoScrollView5")
        scrollView.addSubview(autoScrollView5)
        autoScrollView5.frame.origin.y = nextAutoViewY(lable5)
        
        let lable6 = baseLabel(Y: nextItemY(autoScrollView5), text: "autoScrollView6")
        scrollView.addSubview(autoScrollView6)
        autoScrollView6.frame.origin.y = nextAutoViewY(lable6)
        
        let lable7 = baseLabel(Y: nextItemY(autoScrollView6), text: "autoScrollView7")
        scrollView.addSubview(autoScrollView7)
        autoScrollView7.frame.origin.y = nextAutoViewY(lable7)
        
        scrollView.contentSize = CGSize(width: view.bounds.width, height: viewBottom(autoScrollView7) + 34);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController {
    
    private func customAutoView1() -> [UIImageView] {
        var views = [UIImageView]()
        for index in 0 ..< 3 {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 150))
            imageView.image = UIImage(named: "image\(index / 2 + 1)")
            views.append(imageView)

            let label1 = UILabel(frame: CGRect(x: 40, y: 40, width: 180, height: 25))
            label1.textColor = UIColor.white
            label1.textAlignment = .center
            label1.backgroundColor = UIColor.RGBA(0, 0, 0, 0.45)
            label1.text = "自定义内部控件"
            imageView.addSubview(label1)
            
            let label2 = UILabel(frame: CGRect(x: 0, y: 125, width: view.bounds.width, height: 25))
            label2.textColor = UIColor.white
            label2.backgroundColor = UIColor.RGBA(0, 0, 0, 0.45)
            label2.text = "自定义内部控件"
            imageView.addSubview(label2)
        }
        return views
    }
    
    private func customAutoView2() -> [UIView] {
        var views = [UIView]()
        let labelText = ["大家一起起来嗨！", "今天天气不错哦！", "厉害了我的哥！"]
        for index in 0 ..< labelText.count {
            let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 60))
            views.append(bottomView)
            
            let label1 = UILabel(frame: CGRect(x: 10, y: 10, width: 180, height: 20))
            label1.textColor = UIColor.white
            label1.backgroundColor = UIColor.RGBA(0, 0, 0, 0.45)
            label1.text = labelText[index]
            bottomView.addSubview(label1)
            
            let label2 = UILabel(frame: CGRect(x: 10, y: 30, width: view.bounds.width, height: 20))
            label2.textColor = UIColor.white
            label2.backgroundColor = UIColor.RGBA(0, 0, 0, 0.45)
            label2.text = "不错哦！哈哈哈哈"
            bottomView.addSubview(label2)
        }
        return views
    }
    
    private func customAutoView3() -> [UIView] {
        var views = [UIView]()
        let labelText = ["大家一起起来嗨！", "今天天气不错哦！", "厉害了我的哥！"]
        for index in 0 ..< labelText.count {
            let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 60))
            views.append(bottomView)
            
            let label1 = UILabel(frame: CGRect(x: 10, y: 0, width: 180, height: 30))
            label1.textColor = UIColor.white
            label1.backgroundColor = UIColor.RGBA(0, 0, 0, 0.45)
            label1.text = labelText[index]
            bottomView.addSubview(label1)
        }
        return views
    }
}

extension ViewController {
    @discardableResult
    private func baseLabel(Y: CGFloat, text: String?) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: Y, width: view.bounds.width, height: 25))
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.RGBA(0, 0, 0, 0.45)
        label.text = text
        scrollView.addSubview(label)
        return label
    }

    private func viewBottom(_ view: UIView) -> CGFloat {
        return view.frame.origin.y + view.bounds.height
    }
    
    private func nextItemY(_ view: UIView) -> CGFloat {
        return viewBottom(view) + 10
    }
    
    private func nextAutoViewY(_ lable: UILabel) -> CGFloat {
        return viewBottom(lable) + 1
    }
}

extension UIColor {
    static func RGBA(_ R:CGFloat, _ G:CGFloat, _ B:CGFloat, _ alpha:CGFloat) -> UIColor{
        let color = UIColor.init(red: (R / 255.0), green: (G / 255.0), blue: (B / 255.0), alpha: alpha);
        return color;
    }
}
