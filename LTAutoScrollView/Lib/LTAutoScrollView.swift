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

    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        imageView.isUserInteractionEnabled = true
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
    public typealias SetImageHandle = (UIImageView, String) -> Void
    
    var imageHandle: SetImageHandle?
    
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
    public var autoType: LTAutoScrollViewType = .default {
        didSet {
            
        }
    }
    
    /* 设置轮播图的方向 */
    public var scrollDirection: UICollectionViewScrollDirection = .horizontal {
        didSet {
            layout.scrollDirection = scrollDirection
        }
    }
    
    /* 设置pageControl的属性 */
    public var dotLayout: LTDotLayout = LTDotLayout() {
        didSet {
            gltPageControl.dotLayout = dotLayout
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
    
    private lazy var gltPageControl: LTPageControlView = {
        let gltPageControl = LTPageControlView(frame: CGRect(x: 0, y: bounds.size.height - 20, width: bounds.size.width, height: 20))
        return gltPageControl
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
        if autoType == .custom { return }
        images.count == 1 ? destroyTimrer() : setupTimer()
        totalsCount = images.count * 1024
        collectionView.reloadData()
        if scrollDirection == .vertical {
            collectionView.scrollToItem(item: totalsCount / 2, section: 0, at: .top)
        }else {
            collectionView.scrollToItem(item: totalsCount / 2, section: 0, at: .left)
        }
        pageControl.numberOfPages = images.count
        gltPageControl.numberOfPages = images.count
        gltPageControl.currentDot = 0
    }
    
    private func setupAutoViewHandle(autoViewHandle: AutoViewHandle?) {
        guard let autoViewHandle = autoViewHandle else { return }
        if autoType == .default { return }
        contentViews.removeAll()
        contentViews = autoViewHandle()
        contentViews.count == 1 ? destroyTimrer() : setupTimer()
        totalsCount = contentViews.count * 1024
        collectionView.reloadData()
        if scrollDirection == .vertical {
            collectionView.scrollToItem(item: totalsCount / 2, section: 0, at: .top)
        }else {
            collectionView.scrollToItem(item: totalsCount / 2, section: 0, at: .left)
        }
        pageControl.numberOfPages = contentViews.count
        gltPageControl.numberOfPages = contentViews.count
    }
}

extension LTAutoScrollView {
    private func setupSubViews() {
        LTCollectionViewCell.registerCellWithCollectionView(collectionView)
        addSubview(collectionView)
//        addSubview(pageControl)
        addSubview(gltPageControl)
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
        destroyTimrer()
        timer = Timer(timeInterval: glt_timeInterval, target: self, selector: #selector(timerUpdate(_:)), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .defaultRunLoopMode)
    }
    
    private func destroyTimrer() {
        timer?.invalidate()
        timer = nil
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
        return totalsCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = LTCollectionViewCell.itemViewWithCollectionView(collectionView, indexPath)
        if autoType == .default {
            guard let images = images else { return cell }
            imageHandle?(cell.imageView, images[indexPath.item % (images.count)])
        }else {
            cell.subView = contentViews[indexPath.item % contentViews.count]
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(realItemIndex(currentIndex()))
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = currentIndex()
        if currentPageIndex != index {
            let realIndex = realItemIndex(index)
            pageControl.currentPage = realIndex
            gltPageControl.currentDot = realIndex
            print(realIndex)
        }
        currentPageIndex = index
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation -> ", realItemIndex(currentIndex()))
    }
    
    private func realItemIndex(_ targetIndex: Int) -> Int {
        let contentCount = (autoType == .default ? (images?.count ?? 1) : contentViews.count)
        return targetIndex % contentCount
    }
    
    private func currentIndex() -> Int {
        if collectionView.frame.width == 0 || collectionView.frame.height == 0 {
            return 0
        }
        var index = 0
        if scrollDirection == .horizontal {
            index = Int((collectionView.contentOffset.x + layout.itemSize.width * 0.5) / layout.itemSize.width)
        } else {
            index = Int((collectionView.contentOffset.y + layout.itemSize.height * 0.5) / layout.itemSize.height)
        }
        return max(0, index)
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

public class LTDotLayout {
    public var dotWidth: CGFloat = 10
    public var dotHeight: CGFloat = 10
    public var dotMargin: CGFloat = 15.0
    public var dotImage: UIImage?
    public var dotSelectImage: UIImage?
    public var dotColor: UIColor = UIColor.clear
    public var dotSelectColor: UIColor = UIColor.clear
    public init() { }
    public convenience init(dotWidth: CGFloat = 15.0, dotHeight: CGFloat = 10, dotMargin: CGFloat = 15.0, dotImage: UIImage? = nil, dotSelectImage: UIImage? = nil, dotColor: UIColor = UIColor.clear, dotSelectColor: UIColor = UIColor.clear) {
        self.init()
        self.dotWidth = dotWidth
        self.dotHeight = dotHeight
        self.dotMargin = dotMargin
        self.dotImage = dotImage
        self.dotSelectImage = dotSelectImage
        self.dotColor = dotColor
        self.dotSelectColor = dotSelectColor
    }
}

public class LTPageControlView: UIView {
    
    fileprivate var numberOfPages: Int = 0 {
        didSet {
            setupSubViews()
        }
    }
    
    fileprivate var currentDot: Int = 0 {
        willSet {
            guard newValue != currentDot else { return }
            glt_dissmissAnimation(currentIndex: currentDot)
            glt_showAnimation(willIndex: newValue)
        }
    }
    
    fileprivate var dotLayout: LTDotLayout = LTDotLayout() {
        didSet {
            setupSubViews()
        }
    }
    
    fileprivate convenience init(frame: CGRect, layout: LTDotLayout) {
        self.init(frame: frame)
        setupSubViews()
    }

    private var dotViews: [UIImageView] = []

    private func setupSubViews() {
        glt_resetAllSubViews()
        glt_layoutSubViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LTPageControlView {
    
    private func glt_layoutSubViews() {
        var totalWidth: CGFloat = 0.0
        for index in 0 ..< numberOfPages {
            let dotView = UIImageView()
            glt_autoSizeImage(dotView: dotView, index: index)
            if index == numberOfPages - 1 {
                totalWidth = dotView.frame.origin.x + dotView.bounds.width
            }
            dotView.tag = index + 200
            glt_createGesture(dotView: dotView)
            addSubview(dotView)
            dotViews.append(dotView)
        }
        bounds.size.width = totalWidth
    }
    
    private func glt_resetAllSubViews() {
        for view in subviews { view.removeFromSuperview() }
        dotViews.removeAll()
    }
    
}

extension LTPageControlView {
    
    private func glt_autoSizeImage(dotView: UIImageView, index: Int) {
        if index == 0 {
            dotView.backgroundColor = dotLayout.dotSelectColor
            dotView.image = dotLayout.dotSelectImage
            glt_dotImage(dotLayout.dotSelectImage, dotView: dotView, index: index)
        }else {
            dotView.backgroundColor = dotLayout.dotColor
            dotView.image = dotLayout.dotImage
            glt_dotImage(dotLayout.dotImage, dotView: dotView, index: index)
        }
    }
    
    private func glt_dotImage(_ dotImage: UIImage?, dotView: UIImageView, index: Int) {
        let imageW = dotImage?.size.width ?? dotLayout.dotWidth
        let imageH = dotImage?.size.height ?? dotLayout.dotHeight
        dotView.frame = CGRect(x: (imageW + dotLayout.dotMargin) * CGFloat(index), y: (bounds.height - imageH) / 2.0, width: imageW, height: imageH)
    }
    
    private func glt_createGesture(dotView: UIImageView) {
        dotView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(glt_tapGesture(_:)))
        dotView.addGestureRecognizer(tap)
    }
    
    @objc private func glt_tapGesture(_ tap: UITapGestureRecognizer) {
        guard let dotView = tap.view else { return }
        let index = dotView.tag - 200
        print("click --> \(index)")
    }
    
    private func glt_showAnimation(willIndex: Int) {
        UIView.animate(withDuration: 0.34 * 3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: -24, options: [.curveEaseInOut, .curveLinear], animations: {
            let dotView = self.dotViews[willIndex]
            dotView.backgroundColor = self.dotLayout.dotSelectColor
            dotView.image = self.dotLayout.dotSelectImage
            dotView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }) { (_) in }
    }
    
    private func glt_dissmissAnimation(currentIndex: Int) {
        UIView.animate(withDuration: 0.5, animations: {
            let dotView = self.dotViews[currentIndex]
            dotView.backgroundColor = self.dotLayout.dotColor
            dotView.image = self.dotLayout.dotImage
            dotView.transform = CGAffineTransform.identity
        })
    }
}
