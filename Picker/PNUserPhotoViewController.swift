//
//  PNUserPhotoViewController.swift
//  PNImagePicker
//
//  Created by 雷永麟 on 2019/12/30.
//

import UIKit
import Photos

typealias AfterSelectedImages = (_ images : [UIImage], _ selectedAssets : [Int : PHAsset]) -> Void

class PNUserPhotoViewController: BaseCollectionViewController {
    
    var album : PHAssetCollection?
    
    private var resource : (PHFetchResult<PHAsset>, PHFetchResult<PHAssetCollection>, PHFetchResult<PHCollection>)?
    
    private var images : [UIImage]? {
        
        didSet {
            
            collectionView.reloadData()
        }
    }
    
    private var selectImages : [Int : UIImage]? = [:]
    var selectAssets : [Int : PHAsset]? = [:] {
        
        didSet(selectAssets) {
            
            selectNum = selectAssets?.keys.count ?? 0
        }
    }
    
    private var imageRequeseOptions = PHImageRequestOptions()
    
    var maxSelect : Int = 9
    
    var selectNum : Int = 0
    
//    weak var didSelectedImagesCallBack : AfterSelectedImages?
    var didSelectedImagesCallBack : AfterSelectedImages?

    //MARK: lazyLoad
    lazy var toolBar: PSImageToolBar = {
        
        let toolBar = PSImageToolBar.init(frame: CGRect(x: 0, y: self.view.frame.height - (Scale(50) + kSafeBottomHeight()), width: self.view.frame.width, height: Scale(50) + kSafeBottomHeight()))
        
        toolBar.confirmButton.addTarget(self, action: #selector(completeImageSelect), for: .touchUpInside)
        toolBar.previewButton.isHidden = true
        
        return toolBar
    }()
    
    
    //MARK: lifeCycle
    
    convenience init(maxSelect : Int, afterSelectedImageCallBack : @escaping AfterSelectedImages) {
        
        self.init()
        
        didSelectedImagesCallBack = afterSelectedImageCallBack
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: UISet
    override func configUISet() {
        super.configUISet()
        
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

extension PNUserPhotoViewController {
    
    private func requestImage() {
        
        PNProgressHUD.loading(at: nil)
        
        DispatchQueue.global().async {
            
            PSImageHandleManager.shared.getRealImageFromAssets { (images, resource) in
                
                DispatchQueue.main.async {
                    
                    PNProgressHUD.hideLoading(from: nil)
                    
                    self.images = images
                    self.resource = resource
                    
                    self.updateToolBarState()
                }
            }
        }
    }
}

@objc
private extension PNUserPhotoViewController {
    
    func completeImageSelect() {
        
        PNProgressHUD.loading(at: nil)
        
        DispatchQueue.global().sync {
            
            let assets = selectAssets?.map { it in it.value }
            
            if let currentAssets = assets {
                
                PSImageHandleManager.shared.getImageFromAssets(options : self.imageRequeseOptions,
                                                               assets: currentAssets ) { (images) in
                    
                    DispatchQueue.main.async {
                        
                        PNProgressHUD.hideLoading(from: nil)
                        
                        if self.didSelectedImagesCallBack != nil {
                            
                            self.didSelectedImagesCallBack!(images, self.selectAssets!)
                        }else {
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: PSImageSelectImageNotificationName),
                            object: nil,
                            userInfo: ["images" : images as Any, "assets" : self.selectAssets as Any])
                        }
                    self.navigationController?.setViewControllers([self.navigationController!.viewControllers.first!], animated: true)
                    }
                    
                }
            }else {
                
                PNProgressHUD.hideLoading(from: nil)
                
                PNProgressHUD.present(with: "出现异常！请稍后重试~",
                                      presentType: .fromTop,
                                      font: .systemFont(ofSize: 14.0,
                                                        weight: .medium),
                                      backgroundColor: UIColor.init(red: 1,
                                                                    green: 75 / 255.0,
                                                                    blue: 50 / 255.0,
                                                                    alpha: 1.0),
                                      textColor: .white,
                                      in: nil)
                
                return
            }
            
        }
    }
    
    func updateToolBarState() {
        
        if selectNum == 0 {
            
            toolBar.confirmButton.isEnabled = false
        }else {
            
            toolBar.confirmButton.isEnabled = true
        }
        
        var confirmTitle = "确认" + "(\(selectNum)/\(maxSelect))"
        toolBar.confirmButton.setTitle(confirmTitle, for: .normal)
        
        guard let assets = selectAssets else {
            
            return
        }
        
        selectNum = assets.keys.count
        confirmTitle = "确认" + "(\(selectNum)/\(maxSelect))"
        toolBar.confirmButton.setTitle(confirmTitle, for: .normal)
        
        if selectNum == 0 {
            
            toolBar.confirmButton.isEnabled = false
        }else {
            
            toolBar.confirmButton.isEnabled = true
        }
    }
}
