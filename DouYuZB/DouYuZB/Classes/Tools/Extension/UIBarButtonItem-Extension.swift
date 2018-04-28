//
//  UIBarButtonItem-Extension.swift
//  DouYuZB
//
//  Created by 姜宁桃 on 2018/4/23.
//  Copyright © 2018年 姜宁桃. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    /*
    // 类方法
    class func createItem(imgName:String, highImgName:String, size:CGSize)-> UIBarButtonItem{
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imgName), for: .normal)
        btn.setImage(UIImage(named: highImgName), for: .highlighted)
        btn.frame = CGRect(origin: CGPoint.zero, size: size)
        let item = UIBarButtonItem(customView: btn)
        
        return item
    }
     */
    
    // 便利构造函数 1. convenience开头， 2.在构造函数中必须明确调用一个设计的构造函数（self）
    convenience init(imgName:String, highImgName:String = "", size:CGSize = CGSize.zero) {
        // 1.创建UIButton
        let btn = UIButton()
        
        // 2.设置btn的图片
        btn.setImage(UIImage(named: imgName), for: .normal)
        if highImgName != "" {
            btn.setImage(UIImage(named: highImgName), for: .highlighted)
        }
        
        // 3.设置btn的尺寸
        if size == CGSize.zero {
            btn.sizeToFit()
        }else
        {
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        self.init(customView: btn)

    }
}
