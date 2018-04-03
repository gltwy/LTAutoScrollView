//
//  LTAutoScrollView.swift
//  LTAutoScrollView
//
//  Created by 高刘通 on 2018/4/3.
//  Copyright © 2018年 LT. All rights reserved.
//

import UIKit

public class LTFlowLayout: UICollectionViewFlowLayout {
    public override init() {
        super.init()
    }
    public convenience init(itemSize: CGSize) {
        self.init()
        minimumLineSpacing = 0.0
        minimumInteritemSpacing = 0.0
        scrollDirection = .horizontal
        self.itemSize = itemSize
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class LTCollectionView: UICollectionView {
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    public convenience init(frame: CGRect, collectionViewLayout layout: LTFlowLayout, delegate: UICollectionViewDelegate?, dataSource: UICollectionViewDataSource?) {
        self.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = UIColor.white
        bounces = false
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        self.delegate = delegate
        self.dataSource = dataSource
    }
    
    public func scrollToItem(item: Int, section: Int) {
        scrollToItem(at: IndexPath(item: item, section: section), at: .left, animated: false)
    }
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class LTCollectionViewCell: UICollectionViewCell {
    
    public var subView: UIView? {
        didSet {
            guard let subView = subView else { return }
            imageView.isHidden = true
            contentView.addSubview(subView)
        }
    }
    
    public var image: String? {
        didSet {
            guard let image = image else { return }
            imageView.image = UIImage(named: image)
        }
    }
    
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        return imageView
    }()
    
    private static let reusedCellId = "LTCollectionViewCellID"
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    public static func itemViewWithCollectionView(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> LTCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusedCellId, for: indexPath) as! LTCollectionViewCell
        return cell
    }
    
    public static func registerCellWithCollectionView(_ collectionView: UICollectionView) {
        collectionView.register(LTCollectionViewCell.self, forCellWithReuseIdentifier: reusedCellId)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public enum LTAutoScrollViewType {
    case `default`
    case  custom
}

public class LTAutoScrollView: UIView {
    
    public typealias AutoViewHandle = () -> [UIView]
    public var images: [String]? {
        didSet {
            collectionView.reloadData()
        }
    }
    public var glt_timeInterval: TimeInterval = 2.0
    public var autoType: LTAutoScrollViewType = .default
    public var autoViewHandle: AutoViewHandle? {
        didSet {
            guard let autoViewHandle = autoViewHandle else { return }
            contentViews.removeAll()
            contentViews = autoViewHandle()
            collectionView.reloadData()
        }
    }
    
    private var contentViews: [UIView] = []
    
    private var currentPageIndex: Int = 0
    private var timer: Timer?
    private var glt_isAdjust: Bool = false

    public lazy var layout: LTFlowLayout = {
        let layout = LTFlowLayout(itemSize: CGSize(width: bounds.width, height: bounds.height))
        return layout
    }()
    
    public lazy var collectionView: LTCollectionView = {
        let collectionView = LTCollectionView(frame: bounds, collectionViewLayout: layout, delegate: self, dataSource: self)
        return collectionView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LTAutoScrollView {
    private func setupSubViews() {
        LTCollectionViewCell.registerCellWithCollectionView(collectionView)
        addSubview(collectionView)
        setupTimer()
    }
}

extension LTAutoScrollView {
    private func setupTimer() {
        timer = Timer(timeInterval: glt_timeInterval, target: self, selector: #selector(timerUpdate(_:)), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .defaultRunLoopMode)
    }
    
    @objc func timerUpdate(_ timer: Timer)  {
        print("timerUpdate")
        if currentPageIndex == 0 && glt_isAdjust{
            let X = bounds.width * CGFloat((autoType == .default ? (images?.count ?? 0) + 1 : contentViews.count + 1))
            collectionView.setContentOffset(CGPoint(x: X, y: 0), animated: true)
        }else {
            collectionView.setContentOffset(CGPoint(x: (bounds.width * CGFloat(currentPageIndex + 1)), y: 0), animated: true)
        }
        glt_isAdjust = true
    }
}

extension Timer {
    func pause() {
        fireDate = Date.distantFuture
    }
    func restart(_ timeInterval: TimeInterval) {
        fireDate = Date() + timeInterval
    }
}

extension LTAutoScrollView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if autoType == .default {
            return (images?.count ?? 0) + 2
        }else {
            return contentViews.count + 2
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = LTCollectionViewCell.itemViewWithCollectionView(collectionView, indexPath)
        if autoType == .default {
            guard let images = images else { return cell }
            cell.image = images[indexPath.item % (images.count)]
        }else {
            cell.subView = contentViews[indexPath.item % contentViews.count]
        }
        return cell
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.pause()
        if item(scrollView)?.item == 0 {
            collectionView.scrollToItem(item: autoType == .default ? images?.count ?? 0 : contentViews.count, section: 0)
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        timer?.restart(glt_timeInterval)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(collectionView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard let item = item(scrollView)?.item else { return }
        if item == 0 {
            collectionView.scrollToItem(item: autoType == .default ? images?.count ?? 0 : contentViews.count, section: 0)
        }else if item == (autoType == .default ? images?.count ?? 0 : contentViews.count) + 1 {
            collectionView.scrollToItem(item: 1, section: 0)
        }
        currentPageIndex = item % (autoType == .default ? images?.count ?? 0 : contentViews.count)
        print("当前的位置 ---> \(currentPageIndex)")
    }
    
    private func item(_ scrollView: UIScrollView) -> IndexPath? {
        return collectionView.indexPathForItem(at: scrollView.contentOffset)
    }
    
}



