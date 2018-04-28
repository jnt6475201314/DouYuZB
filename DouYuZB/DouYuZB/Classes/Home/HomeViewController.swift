//
//  HomeViewController.swift
//  DouYuZB
//
//  Created by 姜宁桃 on 2018/4/23.
//  Copyright © 2018年 姜宁桃. All rights reserved.
//

import UIKit

private let kTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {
    
    // MARK: - 懒加载属性
    private lazy var pageTitleView:PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: KStatuBarH_And_NavBarH, width: KScreenW, height: kTitleViewH)
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.backgroundColor = UIColor.white
        titleView.delegate = self
        return titleView
    }()
    
    private lazy var pageContentView:PageContentView={[weak self] in
        // 1.确定内容的frame
        let contentH = KScreenH - KStatuBarH_And_NavBarH - kTitleViewH - KTabBarH
        let contentFrame = CGRect(x: 0, y: KStatuBarH_And_NavBarH+kTitleViewH, width: KScreenW, height: contentH)
        // 2.确定所有子控制器
        var childVcs = [UIViewController]()
        childVcs.append(RecommendViewController())
        for _ in 0..<3{
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            
            childVcs.append(vc)
        }
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        contentView.delegate = self
        return contentView
    }()

    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置UI界面
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: --- 设置UI界面
extension HomeViewController{
    private func setupUI() {
        // 0.不要调整UIScrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
        
        // 1. 设置导航栏
        setupNavigationBar()
        
        // 2. 添加titleView
        view.addSubview(pageTitleView)
        
        // 3.添加contentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.purple
    }
    
    private func setupNavigationBar(){
        // 1.设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imgName: "logo")
        
        // 2.设置右侧的item
        let size = CGSize(width: 40, height: 40)
        // 构造函数
        let historyItem = UIBarButtonItem(imgName: "image_my_history", highImgName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imgName: "btn_search", highImgName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imgName: "Image_scan", highImgName: "Image_scan_click", size: size)
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem]
        
        
    }
}

// MARK: - 遵守PageTitleViewDelegate协议
extension HomeViewController : PageTitleViewDelegate {
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        print(index)
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}

// MARK: - 遵守PageContentViewDelegate协议
extension HomeViewController : PageContentViewDelegate {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
