//
//  PNUserAlbumViewController.swift
//  PNImagePicker
//
//  Created by 雷永麟 on 2019/12/30.
//

import UIKit
import Photos

public typealias SelectAlbumCallBack = (_ album : PHAssetCollection) -> Void

public class PNUserAlbumViewController: BaseTableViewController {

    public var userAlbums : PHFetchResult<PHAssetCollection>?
    
    public var didSelectAlbumCallBack : SelectAlbumCallBack?

    //MARK: lazyLoad
    
    
    //MARK: lifeCycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    public convenience init(didSelectAlbumCallBack : @escaping SelectAlbumCallBack) {
        self.init()
        
        self.didSelectAlbumCallBack = didSelectAlbumCallBack
    }
    
    //MARK: UISet
    override func configUISet() {
        super.configUISet()
        
        self.setNavTitle(string: "相册选择", font: nil)
        
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

extension PNUserAlbumViewController {
 
    override public func numberOfSections(in tableView: UITableView) -> Int {
        
        1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        userAlbums?.count ?? 0
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewCellIdentifier, for: indexPath)
        
        cell.textLabel?.text = userAlbums?.object(at: indexPath.row).localizedTitle ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        pScale(50)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.didSelectAlbumCallBack!(userAlbums!.object(at: indexPath.row))
        
        self.navigationController?.popViewController(animated: true)
    }
}
