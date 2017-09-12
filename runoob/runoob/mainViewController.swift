//
//  mainViewController.swift
//  runoob
//
//  Created by zhoubaitong on 2017/8/23.
//  Copyright © 2017年 cckv. All rights reserved.
//

import UIKit

class mainViewController: UIViewController {

    let middleVc = ViewController()
    let leftVc = leftViewController()
//    let nav = JYJNavigationController()
    var navigationView = JYJNavigationController().view
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        setChildView()

    }

    
    func handleTap(sender: UIPanGestureRecognizer) {
        
        let scrollFrame = CGRect(x: 0, y: 0, width: kScreenWight, height: kScreenHeight)
        let coverView = UIView.init(frame: scrollFrame)
        leftVc.view.addSubview(coverView)
        
        
//        let _transX = sender.translation(in: UIApplication.shared.keyWindow).x
        let _transX = sender.translation(in: self.view).x

        
//        let _transY = sender.translation(in: view).y
        let leftX = _transX - kScreenWight
        
        print(_transX)
        print(leftX)
        
        if _transX <= 0 {
            return
        }
        
        navigationView?.transform = CGAffineTransform(translationX: _transX, y: 0)
        leftVc.view.transform = CGAffineTransform(translationX: leftX, y: 0)
        
        if sender.state == .ended {
            
            if _transX >= kScreenWight/3 {
                let scrollFrame = CGRect(x: kScreenWight/3 * 2, y: 0, width: kScreenWight, height: kScreenHeight)
                navigationView?.frame = scrollFrame
                let leftFrame = CGRect(x: -kScreenWight/3, y: 0, width: kScreenWight, height: kScreenHeight)
                leftVc.view.frame = leftFrame
            }
            if _transX < kScreenWight/3 {
                let scrollFrame = CGRect(x: 0, y: 0, width: kScreenWight, height: kScreenHeight)
                navigationView?.frame = scrollFrame
                let leftFrame = CGRect(x: -kScreenWight, y: 0, width: kScreenWight, height: kScreenHeight)
                leftVc.view.frame = leftFrame
            
            }
            
        }
    }
    
    func setChildView() {
        
        let scrollFrame = CGRect(x: 0, y: 0, width: kScreenWight, height: kScreenHeight)
        
        let scrollVoew = UIScrollView.init(frame: scrollFrame)
        
        self.view.addSubview(scrollVoew)
        
        let nav = JYJNavigationController.init(rootViewController: middleVc)
        navigationView = nav.view

        nav.view.backgroundColor = UIColor.red
        
        self.addChildViewController(nav)
        self.addChildViewController(leftVc)
        
        scrollVoew.addSubview(nav.view)
        scrollVoew.addSubview(leftVc.view)
        
        let leftViewFrame = CGRect(x: -kScreenWight, y: 0, width: kScreenWight, height: kScreenHeight)
        leftVc.view.frame = leftViewFrame
        
        let naviFrame = CGRect(x: 0, y: 0, width: kScreenWight, height: kScreenHeight)
        nav.view.frame = naviFrame
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(self.handleTap))
        nav.view.addGestureRecognizer(pan)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    


}
