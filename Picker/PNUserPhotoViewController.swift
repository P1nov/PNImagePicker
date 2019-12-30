//
//  PNUserPhotoViewController.swift
//  PNImagePicker
//
//  Created by 雷永麟 on 2019/12/30.
//

import UIKit
import Photos

private let PSUserPhotoCollectionViewCellIdentifier = "PSUserPhotoCollectionViewCellIdentifier"

typealias AfterSelectedImages = ((_ images : [UIImage], _ selectedAssets : [Int : PHAsset]) -> Void)

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
    
    var didSelectedImagesCallBack : AfterSelectedImages?
    
    private var imageRequeseOptions = PHImageRequestOptions()
    
    var maxSelect : Int = 9
    
    var selectNum : Int = 0

    //MARK: lazyLoad
    lazy var toolBar: PSImageToolBar = {
        let toolBar = PSImageToolBar.init(frame: CGRect(x: 0, y: self.view.frame.height - (pScale(50) + pSafeBottomHeight()), width: self.view.frame.width, height: pScale(50) + pSafeBottomHeight()))
        
        toolBar.confirmButton.addTarget(self, action: #selector(completeImageSelect), for: .touchUpInside)
        toolBar.previewButton.isHidden = true
        
        return toolBar
    }()
    
    //MARK: lifeCycle
    
    convenience init(maxSelect : Int, afterSelectImagesCallBack : @escaping AfterSelectedImages) {
        
        self.init()
        
        self.maxSelect = maxSelect
        
        didSelectedImagesCallBack = afterSelectImagesCallBack
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - toolBar.frame.height - pSafeBottomHeight())
        toolBar.frame = CGRect(x: 0, y: collectionView.frame.height, width: self.view.frame.width, height: pScale(50) + pSafeBottomHeight())
    }
    
    //MARK: UISet
    override func configUISet() {
        super.configUISet()
        
        self.view.addSubview(toolBar)
        
        config()
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "前往相册", style: .plain, target: self, action: #selector(gotoAlbum))
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(closeCurrent))
        
        collectionView.register(PSUserPhotoCollectionViewCell.self, forCellWithReuseIdentifier: PSUserPhotoCollectionViewCellIdentifier)
        
        requestImage()
        
    }
    
    func config() {
        
        imageRequeseOptions.isSynchronous = true
        imageRequeseOptions.resizeMode = .fast
        imageRequeseOptions.isNetworkAccessAllowed = false;
        imageRequeseOptions.isSynchronous = true
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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        images?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PSUserPhotoCollectionViewCellIdentifier, for: indexPath) as! PSUserPhotoCollectionViewCell
        
        cell.resource = resource?.0[indexPath.row]
        
        if selectImages![indexPath.row] != nil {
            
            cell.selectBtn.isSelected = true
        }else {
            
            cell.selectBtn.isSelected = false
        }
        
        if selectAssets![indexPath.row] != nil {
            
            cell.selectBtn.isSelected = true
        }else {
            
            cell.selectBtn.isSelected = false
        }
        
        //加载cell上的图片（缩略图）
        cell.imageView.image = images![indexPath.row]
        
        //cell上的button点击交互
        cell.didSelectCellImage = { (selected) in
            
            //超出最大选择数
            if !selected && self.selectNum >= self.maxSelect {
                
                PNProgressHUD.present(with: "已超出最大选择数量，不能再选择",
                                      presentType: .fromTop,
                                      font: .systemFont(ofSize: 14.0, weight: .medium),
                                      backgroundColor: UIColor.init(red: 1, green: 75 / 255.0, blue: 50 / 255.0, alpha: 1.0),
                                      textColor: .white,
                                      in: nil)
                
                return
            }
            
            //小于最大选择数且选择
            if self.selectNum < self.maxSelect && !selected {
                
                self.selectNum += 1
                
                self.selectAssets![indexPath.row] = cell.resource
            }
            
            //取消选择图片
            if selected {
                self.selectAssets?.removeValue(forKey: indexPath.row)
                
                self.selectNum -= 1
            }
            
            cell.selectBtn.isSelected = !selected
            
            self.updateToolBarState()
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        .init(width: (pScreenWidth - pScale(5)) / 4, height: (pScreenWidth - pScale(5)) / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        pScale(1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        pScale(1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        .init(top: pScale(1), left: pScale(1), bottom: pScale(1), right: pScale(1))
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
