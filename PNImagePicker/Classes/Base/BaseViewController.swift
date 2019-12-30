//
//  BaseViewController.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/25.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        label.textAlignment = .center
        label.textColor = .black
        
        return label
    }()
    
    //MARK: lifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configUISet()
    }
    
    //MARK: UISet
    func configUISet() {
        
        self.view.backgroundColor = .white
//        self.navigationController?.navigationBar.set(backgroundColor: .white, tintColor: .black, isShowShadow: false)
        self.navigationItem.titleView = titleLabel
        
        addNotificationObserver()
    }
    
    //MARK: delegate & dataSource
    
    //MARK: notification & observer
    func addNotificationObserver() {
        
        
    }
    
    func removeNotificationObserver() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: action
    
    //MARK: dealloc
    deinit {
        removeNotificationObserver()
    }
}

extension BaseViewController {
    
    func setNavTitle(string : String, font : UIFont?) {
        
        titleLabel.text = string
        
        if font != nil {
            
            titleLabel.font = font
        }
    }
}
