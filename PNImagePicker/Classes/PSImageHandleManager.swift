//
//  PSImageHandleManager.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/26.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit
import Photos

public class PSImageHandleManager: NSObject {
    
    private var groups : [Any] = []
    private var photos : [Any] = []

    static let shared : PSImageHandleManager = {
       
        let shared = PSImageHandleManager()
        
        return shared
    }()
    
    //判断是否授权
    class func isAuthorized() -> Bool {
        
        return PHPhotoLibrary.authorizationStatus() == .authorized ||
            PHPhotoLibrary.authorizationStatus() == .notDetermined
    }
    
    func getAllUserAlbum() -> (PHFetchResult<PHAsset>, PHFetchResult<PHAssetCollection>, PHFetchResult<PHCollection>) {
        
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // 获取所有照片
        let allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        
        // 获取智能相册
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                  subtype: .albumRegular,
                                                                  options: nil)
        
        // 获取用户创建的所有相册
        let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        return (allPhotos, smartAlbums, userCollections)
    }
    
    func getUserAlbums(completion : (PHFetchResult<PHAssetCollection>) -> Void) {
        
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                  subtype: .albumRegular,
                                                                  options: nil)
        
        completion(smartAlbums)
    }
    
    func getImageFromAssets(options : PHImageRequestOptions, assets : [PHAsset], completion : (_ images : [UIImage]) -> Void) {
        
        var images = [UIImage]()
        
        for index in 0 ..< assets.count {
            
            PHImageManager.default().requestImage(for: assets[index], targetSize: .zero, contentMode: .aspectFill, options: options) { (image, info) in
                
                guard let originalImage = image else {
                    
                    return
                }
                
                images.append(originalImage)
            }
            
            if index == assets.count - 1 {
                
                completion(images)
            }
        }
        
        
    }
    
    func directGetPhotos(album : PHAssetCollection) -> PHFetchResult<PHAsset> {
        
        let photosOption = PHFetchOptions()
        photosOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let photos = PHAsset.fetchAssets(in: album,
                                         options: photosOption)
        
        return photos
    }
    
    func getPhotosFromAlbum(album : PHAssetCollection, completion : (_ photos : PHFetchResult<PHAsset>) -> Void) {
        
        let photosOption = PHFetchOptions()
        photosOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let photos = PHAsset.fetchAssets(in: album,
                                         options: photosOption)
        
        completion(photos)
    }
    
    func exchangePhotos(with album : PHAssetCollection, completion : (_ images : [UIImage]) -> Void) {
        
        let photosOption = PHFetchOptions()
        photosOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let photos = PHAsset.fetchAssets(in: album,
                                         options: photosOption)
        
        var images = [UIImage]()
        
        let options = PHImageRequestOptions()
        
        options.isSynchronous = true
        options.resizeMode = .exact
        options.isNetworkAccessAllowed = false
        
        if photos.count == 0 {
            
            completion([])
        }else {
            
            for index in 0 ..< photos.count {
                
                PHImageManager.default().requestImage(for: photos[index],
                                                      targetSize: CGSize(width: (UIScreen.main.scale * pScreenWidth - pScale(5)) / 5.0, height: (UIScreen.main.scale * pScreenWidth - pScale(5)) / 5.0),
                                                      contentMode: .aspectFill,
                                                      options: options) { (image, info) in
                    
                    guard let originalImage = image else {
                        
                        return
                    }
                    
                    images.append(originalImage)
                }
                
                if index == photos.count - 1 {
                    
                    completion(images)
                }
            }
        }
        
        
    }
    
    func getAspectFillWidthImage(image1 : UIImage, width : CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: image1.size.height * (width / image1.size.width)),
                                               false,
                                               UIScreen.main.scale)
                
        image1.draw(in: CGRect(x: 0, y: 0, width: width, height: image1.size.height * (width / image1.size.width)))
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return finalImage!
    }
    
    func getRealImageFromAssets(completion : @escaping (_ images : [UIImage], _ assets : (PHFetchResult<PHAsset>, PHFetchResult<PHAssetCollection>, PHFetchResult<PHCollection>)) -> Void) {
        
        let resource = self.getAllUserAlbum()
        
        var images = [UIImage]()
        
        let options = PHImageRequestOptions()
        
        options.isSynchronous = true
        options.resizeMode = .exact
        options.isNetworkAccessAllowed = false
        
        let assets = resource.0
        
        for index in 0 ..< assets.count {
            
            PHImageManager.default().requestImage(for: assets[index],
                                                  targetSize: CGSize(width: (UIScreen.main.scale * pScreenWidth - pScale(5)) / 5.0, height: (UIScreen.main.scale * pScreenWidth - pScale(5)) / 5.0),
                                                  contentMode: .aspectFill,
                                                  options: options) { (image, info) in
                
                images.append(image!)
            }
            
            if index == assets.count - 1 {
                
                completion(images, resource)
            }
            
        }
        
    }
    
    func sliceImage(with images : [UIImage], completion : (_ finalImage : UIImage) -> Void) {
        
        var height : CGFloat = 0.0
        var totalHeight : CGFloat = 0.0
        
        images.enumerated().forEach { (index, image) in
            
            totalHeight += image.size.height
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: pScale(360),height: totalHeight * (pScale(360) / images[0].size.width)),
                                               false,
                                               UIScreen.main.scale)
        
        images.enumerated().forEach { (index, image) in
            
            let finalImage = self.getAspectFillWidthImage(image1: image,
                                                          width: pScale(360))
            
            image.draw(in: CGRect(x: 0, y: height, width: pScale(360), height: finalImage.size.height))
            
            height += finalImage.size.height
        }
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        completion(finalImage!)
        
    }
}
