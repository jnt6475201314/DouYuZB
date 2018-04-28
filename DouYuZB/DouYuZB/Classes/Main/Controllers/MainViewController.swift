//
//  MainViewController.swift
//  DouYuZB
//
//  Created by 姜宁桃 on 2018/4/23.
//  Copyright © 2018年 姜宁桃. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildVC(storyName: "Home")
        addChildVC(storyName: "Live")
        addChildVC(storyName: "Follow")
        addChildVC(storyName: "Profile")
        
    }
    
    // 往TabBarController添加自控制器
    private func addChildVC(storyName:String){
        // 1. 通过Storyboard获取控制器
        let ChildVC = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        
        // 2. 将ChildVC作为子控制器
        addChildViewController(ChildVC)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
