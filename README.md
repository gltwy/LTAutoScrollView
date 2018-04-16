# LTAutoScrollView

[![CI Status](http://img.shields.io/travis/1282990794@qq.com/LTAutoScrollView.svg?style=flat)](https://travis-ci.org/1282990794@qq.com/LTAutoScrollView)
[![Version](https://img.shields.io/cocoapods/v/LTAutoScrollView.svg?style=flat)](http://cocoapods.org/pods/LTAutoScrollView)
[![License](https://img.shields.io/cocoapods/l/LTAutoScrollView.svg?style=flat)](http://cocoapods.org/pods/LTAutoScrollView)
[![Platform](https://img.shields.io/cocoapods/p/LTAutoScrollView.svg?style=flat)](http://cocoapods.org/pods/LTAutoScrollView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Swift, which automates and simplifies the process of using 3rd-party libraries like LTAutoScrollView in your projects.  You can install it with the following command:

```bash
$ gem install cocoapods
```

#### Podfile

To integrate LTAutoScrollView into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'LTAutoScrollView'
end
```

Then, run the following command:

```bash
$ pod install
```

## Usage

#### 创建LTAutoScrollView

```swift
let autoScrollView = LTAutoScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 150))

//设置滚动时间间隔 默认2.0s
autoScrollView.glt_timeInterval = 1.5
        
//设置轮播图的方向 默认水平
autoScrollView.scrollDirection = .vertical

//加载网络图片传入图片url数组， 加载本地图片传入图片名称数组
autoScrollView.images = images

//加载图片，内部不依赖任何图片加载框架
autoScrollView.imageHandle = {(imageView, imageName) in
    //加载本地图片（根据传入的images数组来决定加载方式）
    imageView.image = UIImage(named: imageName)
    //加载网络图片（根据传入的images数组来决定加载方式）
    //imageView.kf.setImage(with: URL(string: imageName))
}

// 滚动手势禁用（文字轮播较实用） 默认为false
autoScrollView.isDisableScrollGesture = false

//设置pageControl View的高度 默认为20
autoScrollView.gltPageControlHeight = 20;

// 是否自动轮播 默认true
autoScrollView.isAutoScroll = true

//dot在轮播图的位置 中心 左侧 右侧 默认居中
autoScrollView.dotDirection = .default

//点击事件
autoScrollView.didSelectItemHandle = {
    print("autoScrollView1 点击了第 \($0) 个索引")
}

//自动滚动到当前索引事件
autoScrollView.autoDidSelectItemHandle = { index in
    print("autoScrollView1 自动滚动到了第 \(index) 个索引")
}

//PageControl点击事件
autoScrollView.pageControlDidSelectIndexHandle = { index in
    print("autoScrollView1 pageControl点击了第 \(index) 个索引")
}

//设置pageControl的位置
autoScrollView.dotDirection = .right
//dot在轮播图的位置 左侧 或 右侧时，距离最屏幕最左边或最最右边的距离，默认0
autoScrollView.adjustValue = 15.0
//pageControl高度调整从而改变pageControl位置 默认20
autoScrollView.gltPageControlHeight = 25

//设置LTDotLayout，更多dot使用见LTDotLayout属性说明
let layout = LTDotLayout(dotImage: dotImage, dotSelectImage: dotSelectImage)
layout.dotMargin = 10.0
autoScrollView.dotLayout = layout
```

#### LTDotLayout属性说明

```swift
/* dot单独的一个的宽度 */
public var dotWidth: CGFloat = isPostDotSize
/* dot单独的一个的高度 */
public var dotHeight: CGFloat = isPostDotSize
/* dot之间的间距 */
public var dotMargin: CGFloat = 15.0
/* dot未选中的图片 */
public var dotImage: UIImage?
/* dot选中后的图片 */
public var dotSelectImage: UIImage?
/* dot未选中的颜色 */
public var dotColor: UIColor = UIColor.clear
/* dot选中的后颜色 */
public var dotSelectColor: UIColor = UIColor.clear
/* custom为默认是自定义 ， 想使用类似系统样式传入default */
public var dotType: LTAutoScrollViewType = .custom
/* 滚动过程是否放大当前dot */
public var isScale: Bool = true
/* 滚动过程dot放大倍率 */
public var scaleXY: CGFloat = 1.4
```

## Author

1282990794@qq.com

## License

LTAutoScrollView is available under the MIT license. See the LICENSE file for more info.
