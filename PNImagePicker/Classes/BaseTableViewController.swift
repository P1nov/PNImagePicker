//
//  BaseTableViewController.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/25.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit

let BaseTableViewCellIdentifier = "BaseTableViewCellIdentifier"

public class BaseTableViewController: BaseViewController {

    //MARK: lazyLoad
    lazy var tableView: UITableView = {
        
        let tableView = UITableView.init(frame: self.view.bounds, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView.init(frame: .zero)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: BaseTableViewCellIdentifier)
        
        return tableView
    }()
    
    //MARK: lifeCycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: UISet
    override func configUISet() {
        super.configUISet()
        
        self.view.addSubview(tableView)
        
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    //MARK: delegate & dataSource
    
    //MARK: notification & observer
    override func addNotificationObserver() {
        
        
    }
    
    //MARK: action
    
    //MARK: dealloc
    deinit {
        removeNotificationObserver()
    }

}

extension BaseTableViewController : UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return tableView.dequeueReusableCell(withIdentifier: BaseTableViewCellIdentifier, for: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        0.0001
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        0.0001
    }
}
