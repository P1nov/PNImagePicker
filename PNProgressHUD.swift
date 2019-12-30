//
//  PNProgressHUD.swift
//  UITestDemo
//
//  Created by ma c on 2019/12/22.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

class PNProgressHUDView : UIView {
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel(frame: CGRect(x: 0, y: self.frame.origin.y - pScale(20), width: self.frame.width - pScale(50), height: 0.0))
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = pScale(8)
        
        return label
    }()
    
    init() {
        super.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        self.addSubview(titleLabel)
        
        titleLabel.center = self.center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PNProgressHUD: NSObject {
    
    var loadingView : LSDMidIndicatorView?
    
    enum PresentType {
        case popup
        case fromTop
        case fromBottom
    }
    
    enum WarningType {
        
        case error
        case warning
        case success
        case `default`
    }
    
    /**
     - Parameters:
     - title: 提示内容（不能为空）
     - presentType: 弹窗方式
     - font: 字体（可为空，为空使用默认字体）
     - backgroundColor: 弹窗提示的背景色（可为空，默认为白色）
     - textColor: 字色（可为空，默认为黑色）
     - superView: 父视图（为空则是window上显示）
     */
    class func present(with title : NSString, presentType : PresentType, font : UIFont?, backgroundColor : UIColor?, textColor : UIColor?, in superView : UIView?) {
        
        let hudView : PNProgressHUDView = PNProgressHUDView()
        if backgroundColor != nil {
            
            hudView.titleLabel.backgroundColor = backgroundColor!
        }
        
        if textColor != nil {
            
            hudView.titleLabel.textColor = textColor
        }
        
        if font != nil {
            
            hudView.titleLabel.font = font!
        }
        
        let height = title.boundingRect(with: .init(width: hudView.bounds.width, height: 0.0), options: NSStringDrawingOptions.Element(rawValue: NSStringDrawingOptions.usesFontLeading.rawValue | NSStringDrawingOptions.usesLineFragmentOrigin.rawValue), attributes: [NSAttributedString.Key.font : font != nil ? font as Any : UIFont.systemFont(ofSize: 14.0)], context: nil).size.height
        
        hudView.titleLabel.text = String(title)
        hudView.titleLabel.frame.size.height = height + 40
        
        presentAnimation(view: hudView, presentType: presentType, superView: superView)
        
    }
    
    class func presentAnimation(view : PNProgressHUDView, presentType : PresentType, superView : UIView?) {
        
        var newSuperView : UIView?
        
        if superView == nil {
            
            guard let currentWindow = UIApplication.shared.keyWindow else {
                
                return
            }
            
            currentWindow.addSubview(view)
            
            newSuperView = currentWindow
            
        }else {
            
            superView?.addSubview(view)
            newSuperView = superView
        }
        
        
        switch presentType {
        case .popup:
            
            view.titleLabel.center = view.center
            
            view.titleLabel.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            
            UIView.animate(withDuration: 0.1, animations: {
                
                view.titleLabel.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            }) { (completed) in
                
                UIView.animate(withDuration: 0.1, delay: 1, options: .curveEaseInOut, animations: {
                    
                    view.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                }) { (completed) in
                    
                    view.removeFromSuperview()
                }
            }
            break
        case .fromTop:
            
            view.titleLabel.center = CGPoint(x: newSuperView!.bounds.width / 2.0, y: newSuperView!.bounds.origin.y - view.titleLabel.bounds.height / 2.0)
            
            UIView.animate(withDuration: 0.1, animations: {
                
                view.titleLabel.center = CGPoint(x: newSuperView!.bounds.width / 2.0, y: newSuperView!.bounds.origin.y + pScale(10) + view.titleLabel.frame.height)
            }) { (completed) in
                
                UIView.animate(withDuration: 0.1, delay: 1, options: .curveEaseInOut, animations: {
                    
                    view.titleLabel.center = CGPoint(x: newSuperView!.bounds.width / 2.0, y: newSuperView!.bounds.origin.y - view.titleLabel.bounds.height / 2.0)
                }) { (completed) in
                    
                    view.removeFromSuperview()
                }
            }
            break
        default:
            break
        }
        
        
    }
    
    class func loading(at superView : UIView?) {
        
        var newSuperView : UIView?
        
        var loadingView : LSDMidIndicatorView?
        
        if superView == nil {
            
            guard let currentWindow = UIApplication.shared.keyWindow else {
                
                return
            }
            
            loadingView = LSDMidIndicatorView()
            loadingView!.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            
            currentWindow.addSubview(loadingView!)
            
            newSuperView = currentWindow
            
        }else {
            
            loadingView = LSDMidIndicatorView()
            loadingView!.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            
            superView?.addSubview(loadingView!)
            
            newSuperView = superView
        }
        
        loadingView?.showMe(newSuperView!)
        
    }
    
    class func hideLoading(from superView : UIView?) {
        
        if superView == nil {
            
            var keyWindow : UIWindow?
            
            for window in UIApplication.shared.windows {
                if (window.isKeyWindow) {
                    // you have the key window
                    
                    keyWindow = window
                    
                    break;
                }
            }
            
            guard let currentWindow = keyWindow else {
                
                return
            }
            
            var isHided : Bool = false
            
            for subView in currentWindow.subviews {
                
                if isHided {
                    
                    break
                }
                
                if subView.isKind(of: LSDMidIndicatorView.self) {
                    
                    (subView as! LSDMidIndicatorView).dismiss()
                    
                    isHided = true
                }
            }
            
        }else {
            
            var isHided : Bool = false
            
            for subView in superView!.subviews {
                
                if isHided {
                    
                    break
                }
                
                if subView.isKind(of: LSDMidIndicatorView.self) {
                    
                    (subView as! LSDMidIndicatorView).dismiss()
                    
                    isHided = true
                }
            }
        }
    }

}
