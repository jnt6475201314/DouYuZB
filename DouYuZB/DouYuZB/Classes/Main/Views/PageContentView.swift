//
//  PageContentView.swift
//  DouYuZB
//
//  Created by 姜宁桃 on 2018/4/24.
//  Copyright © 2018年 姜宁桃. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : class {
    func pageContentView(contentView : PageContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
}

private let collectionViewCellIde = "CellIde"

class PageContentView: UIView {

    // MARK: - 定义属性
    private var childVCs : [UIViewController]
    private weak var parentViewController : UIViewController?
    private var startOffsetX : CGFloat = 0
    private var isForbidScrollDelegate : Bool = false
    weak var delegate : PageContentViewDelegate?
    
    // MARK: - 懒加载属性
    lazy var collectionView : UICollectionView = {[weak self] in
        // 1. 创建Layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        // 2. 创建CollectionView
        let collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellIde)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    init(frame: CGRect, childVcs : [UIViewController], parentViewController : UIViewController?) {
        self.childVCs = childVcs
        self.parentViewController = parentViewController
        super.init(frame: frame)
        
        // 设置UI界面
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: 设置UI界面
extension PageContentView{
    private func setupUI(){
        // 1.将所有的子控制器添加到父控制器
        for childVC in childVCs{
            parentViewController?.addChildViewController(childVC)
        }
        // 2.添加UICollectionView
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

// MARK: 遵守UICollectionView DataSource 协议
extension PageContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 创建Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIde, for: indexPath)
        
        // 设置内容
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        let childVC = childVCs[indexPath.item]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        
        return cell
    }
}

// MARK: - 遵循UICollectionViewDelegate
extension PageContentView : UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 0.判断是否是点击事件
        if isForbidScrollDelegate {
            return
        }
        
        // 1.获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        // 2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.frame.width
        
        if currentOffsetX > startOffsetX {
            // 左滑
            // 1. 计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            // 2. 计算souceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            // 3. 计算currentIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVCs.count {
                targetIndex = childVCs.count - 1
            }
            // 4. 完全滑过去
            if currentOffsetX - startOffsetX == scrollViewW{
                progress = 1
                targetIndex = sourceIndex
            }
        }else{
            // 右滑
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            targetIndex = Int(currentOffsetX / scrollViewW)
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVCs.count {
                sourceIndex = childVCs.count - 1
            }
        }
        
        // 3. 将progress、sourceIndex、targetIndex 传递给titleView
            delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
}

// MARK: - 对外暴露的方法
extension PageContentView {
    func setCurrentIndex(currentIndex : Int) {
        
        // 1. 记录需要禁止执行代理方法
        isForbidScrollDelegate = true
        
        // 2. 滚动到正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
