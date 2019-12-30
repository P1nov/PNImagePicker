//
//  PNUserAlbumViewController.swift
//  PNImagePicker
//
//  Created by 雷永麟 on 2019/12/30.
//

import UIKit
import Photos

typealias SelectAlbumCallBack = (_ album : PHAssetCollection) -> Void

class PNUserAlbumViewController: BaseTableViewController {

    var userAlbums : PHFetchResult<PHAssetCollection>?
    
    var didSelectAlbumCallBack : SelectAlbumCallBack?

    //MARK: lazyLoad
    
    
    //MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    convenience init(didSelectAlbumCallBack : @escaping SelectAlbumCallBack) {
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
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        userAlbums?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
