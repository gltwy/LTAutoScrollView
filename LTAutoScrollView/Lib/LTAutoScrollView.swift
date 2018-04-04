//
//  LTAutoScrollView.swift
//  LTAutoScrollView
//
//  Created by 高刘通 on 2018/4/3.
//  Copyright © 2018年 LT. All rights reserved.
//

import UIKit

fileprivate class LTFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
    }
    convenience init(itemSize: CGSize) {
        self.init()
        minimumLineSpacing = 0.0
        minimumInteritemSpacing = 0.0
        self.itemSize = itemSize
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class LTCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    convenience init(frame: CGRect, collectionViewLayout layout: LTFlowLayout, delegate: UICollectionViewDelegate?, dataSource: UICollectionViewDataSource?) {
        self.init(frame: frame, collectionViewLayout: layout)
        bounces = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        isPagingEnabled = true
        self.delegate = delegate
        self.dataSource = dataSource
    }
    
    fileprivate func scrollToItem(item: Int, section: Int, at: UICollectionViewScrollPosition) {
        scrollToItem(at: IndexPath(item: item, section: section), at: at, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Notification.Name {
    public struct LTTask {
        static let BecomeActive = Notification.Name("UIApplicationDidBecomeActiveNotification")
        static let Background = Notification.Name("UIApplicationDidEnterBackgroundNotification")
    }
}

fileprivate class LTCollectionViewCell: UICollectionViewCell {
    
    var subView: UIView? {
        didSet {
            guard let subView = subView else { return }
            imageView.isHidden = true
            contentView.addSubview(subView)
        }
    }
    
    var image: String? {
        didSet {
            guard let image = image else { return }
            imageView.image = UIImage(named: image)
        }
    }

    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        return imageView
    }()
    
    private static let reusedCellId = "LTCollectionViewCellID"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    static func itemViewWithCollectionView(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> LTCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusedCellId, for: indexPath) as! LTCollectionViewCell
        return cell
    }
    
    static func registerCellWithCollectionView(_ collectionView: UICollectionView) {
        collectionView.register(LTCollectionViewCell.self, forCellWithReuseIdentifier: reusedCellId)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: 轮播类型视图是自定义 或者 默认
public enum LTAutoScrollViewType {
    case `default`//默认
    case  custom //自定义
}

public class LTAutoScrollView: UIView {
    
    /* -------------  共有方法  ---------------- */
    public typealias AutoViewHandle = () -> [UIView]
    
    /*如果是默认模式`default`  直接传入images数组即可*/
    public var images: [String]? {
        didSet {
            setupImages(images)
        }
    }
    
    /* 设置滚动时间间隔 */
    public var glt_timeInterval: TimeInterval = 2.0 {
        didSet {
            setupTimer()
        }
    }
    
    /* 判断轮播类型是自定义视图custom 还是默认模式`default` */
    public var autoType: LTAutoScrollViewType = .default
    
    /* 设置轮播图的方向 */
    public var scrollDirection: UICollectionViewScrollDirection = .horizontal {
        didSet {
            layout.scrollDirection = scrollDirection
        }
    }
    
    /* 设置系统pageContoal的熟悉 */
    public lazy var pageControl: UIPageControl = {
        let pageControl: UIPageControl = UIPageControl(frame: CGRect(x: 0, y: bounds.height - 20, width: bounds.width, height: 20))
        pageControl.currentPageIndicatorTintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.blue
        return pageControl
    }()
    
    /* 设置自定义视图 */
    public var autoViewHandle: AutoViewHandle? {
        didSet {
            setupAutoViewHandle(autoViewHandle: autoViewHandle)
        }
    }
    
    /* -------------  以下私有方法  ---------------- */
    private var contentViews: [UIView] = []
    private var currentPageIndex: Int = 0
    private var timer: Timer?
    private var totalsCount: Int = 0
    
    private lazy var layout: LTFlowLayout = {
        let layout = LTFlowLayout(itemSize: CGSize(width: bounds.width, height: bounds.height))
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var collectionView: LTCollectionView = {
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
    
    private func setupImages(_ images: [String]?)  {
        guard let images = images else { return }
        totalsCount = images.count * 1024
        if scrollDirection == .vertical {
            collectionView.scrollToItem(item: totalsCount / 2, section: 0, at: .top)
        }else {
            collectionView.scrollToItem(item: totalsCount / 2, section: 0, at: .left)
        }
        pageControl.numberOfPages = images.count
        collectionView.reloadData()
    }
    
    private func setupAutoViewHandle(autoViewHandle: AutoViewHandle?) {
        guard let autoViewHandle = autoViewHandle else { return }
        contentViews.removeAll()
        contentViews = autoViewHandle()
        totalsCount = contentViews.count * 1024
        if scrollDirection == .vertical {
            collectionView.scrollToItem(item: totalsCount / 2, section: 0, at: .top)
        }else {
            collectionView.scrollToItem(item: totalsCount / 2, section: 0, at: .left)
        }
        pageControl.numberOfPages = contentViews.count
        collectionView.reloadData()
    }
}

extension LTAutoScrollView {
    private func setupSubViews() {
        LTCollectionViewCell.registerCellWithCollectionView(collectionView)
        addSubview(collectionView)
        addSubview(pageControl)
        registerNotification()
        setupTimer()
    }
    
    private func registerNotification() {
        let noticenter = NotificationCenter.default
        noticenter.addObserver(self, selector: #selector(registerNoti(_:)), name: Notification.Name.LTTask.BecomeActive, object: nil)
        noticenter.addObserver(self, selector: #selector(registerNoti(_:)), name: Notification.Name.LTTask.Background, object: nil)
    }
    
    @objc private func registerNoti(_ notification: Notification) {
        if notification.name == Notification.Name.LTTask.BecomeActive {
            timer?.restart(glt_timeInterval)
        }else {
            timer?.pause()
        }
    }
}

extension LTAutoScrollView {
    private func setupTimer() {
        timer?.invalidate()
        timer = nil
        timer = Timer(timeInterval: glt_timeInterval, target: self, selector: #selector(timerUpdate(_:)), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .defaultRunLoopMode)
    }
    
    @objc func timerUpdate(_ timer: Timer)  {
        if scrollDirection == .horizontal {
            let point = CGPoint(x: CGFloat(currentPageIndex + 1) * bounds.width, y: 0)
            collectionView.setContentOffset(point, animated: true)
        }else {
            let point = CGPoint(x: 0, y: CGFloat(currentPageIndex + 1) * bounds.height)
            collectionView.setContentOffset(point, animated: true)
        }
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
            return totalsCount
        }else {
            return totalsCount
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
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var scrllW = bounds.size.width
        var offsetX = scrollView.contentOffset.x
        if scrollDirection == .vertical {
            scrllW = bounds.size.height
            offsetX = scrollView.contentOffset.y
        }
        let abs = offsetX.truncatingRemainder(dividingBy: scrllW)
        if abs == 0 {
            let totalCurrentIndex = Int(offsetX) / Int(scrllW)
            currentPageIndex = totalCurrentIndex
            let contentCount = (autoType == .default ? (images?.count ?? 1) : contentViews.count)
            let index = totalCurrentIndex % contentCount
            pageControl.currentPage = index
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.pause()
    }
   
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        timer?.restart(glt_timeInterval)
    }
    
    private func item(_ scrollView: UIScrollView) -> IndexPath? {
        return collectionView.indexPathForItem(at: scrollView.contentOffset)
    }
    
}



