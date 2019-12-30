//
//  BaseCollectionViewController.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/25.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit

let BaseCellIdentifier = "BaseCellIdentifier"
let BaseHeaderViewIdentifier = "BaseHeaderViewIdentifier"
let BaseFooterViewIdentifier = "BaseFooterViewIdentifier"

class BaseCollectionViewController: BaseViewController {
    
    //MARK: lazyLoad
    lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: BaseCellIdentifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BaseHeaderViewIdentifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: BaseFooterViewIdentifier)
        
        return collectionView
    }()
    

    //MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: UISet
    override func configUISet() {
        super.configUISet()
        
        self.view.addSubview(collectionView)
        
    }
    
    //MARK: delegate & dataSource
    
    //MARK: notification & observer
    override func addNotificationObserver() {
        super.addNotificationObserver()
        
    }
    
    //MARK: action
    
    //MARK: dealloc
    deinit {
        removeNotificationObserver()
    }

}

extension BaseCollectionViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: BaseCellIdentifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind.elementsEqual(UICollectionView.elementKindSectionHeader) {
            
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BaseHeaderViewIdentifier, for: indexPath)
        }else {
            
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BaseFooterViewIdentifier, for: indexPath)
        }
    }
}

extension UICollectionView {
    
    var currentOperateCell : UICollectionViewCell? {
        
        get {
            
            let key = UnsafeRawPointer.init(bitPattern: "currentCell".hashValue)
            
            return (objc_getAssociatedObject(self, key!) as! UICollectionViewCell)
        }
        set(newCell) {
            
            let Key = UnsafeRawPointer.init(bitPattern: "currentCell".hashValue)
            
            objc_setAssociatedObject(self, Key!, newCell, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
