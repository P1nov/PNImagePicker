//
//  PSUserPhotoCollectionViewCell.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/26.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit
import Photos

typealias SelectImageCallBack = (_ selected : Bool) -> Void

class PSUserPhotoCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        
        return imageView
    }()
    
    var resource : PHAsset?
    var imageRequestID : Int32 = 0
    
    var didSelectCellImage : SelectImageCallBack?
    
    lazy var selectBtn: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(named: "photo_original_def"), for: .normal)
        button.setImage(UIImage(named: "photo_sel_previewVc"), for: .selected)
        
        button.setTitleColor(.white, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        
        button.addTarget(self, action: #selector(imageDidSelect(button:)), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(selectBtn)
        
        imageView.center = contentView.center
        imageView.frame.origin = contentView.frame.origin
        imageView.frame.size = contentView.frame.size
        
        selectBtn.frame.size = CGSize(width: pScale(20), height: pScale(20))
        selectBtn.frame.origin = CGPoint(x: contentView.bounds.width - pScale(35), y: pScale(15))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
    }
}

@objc
extension PSUserPhotoCollectionViewCell {
    
    func imageDidSelect(button : UIButton) {
        
        didSelectCellImage!(button.isSelected)
    }
}
