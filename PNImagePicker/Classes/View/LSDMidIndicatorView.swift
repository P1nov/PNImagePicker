//
//  LSDMidIndicatorView.swift
//  jianbianse
//
//  Created by 罗达达 on 2018/9/29.
//  Copyright © 2018 罗达达. All rights reserved.
//

import UIKit

class LSDMidIndicatorView: UIView {
    
    /// 背景view
    private lazy var bacView: UIView = {
        let view = UIView(frame: CGRect(x: pScreenWidth/3, y: (pScreenHeight - 60)/2, width: pScreenWidth/3, height: 60))
        view.backgroundColor = .clear
        view.layer.cornerRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        return view
    }()
    
    /// 透明效果
    private lazy var visual: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let vis = UIVisualEffectView(effect: blur)
        vis.frame = CGRect(x: 0, y: 0, width: pScreenWidth/3, height: 60)
        vis.backgroundColor = .white
        vis.alpha = 0.8
        vis.layer.cornerRadius = 5
        vis.layer.masksToBounds = true
        return vis
    }()
    
    /// 自定义菊花
    private lazy var custom: LSDIndicatorCustom = {
        let view = LSDIndicatorCustom(frame: CGRect(x: (pScreenWidth/3 - 40)/2, y: 10, width: 40, height: 40))
        return view
    }()
    
    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: pScreenWidth, height: pScreenHeight))
        self.backgroundColor = .clear
        self.addSubview(self.bacView)
        self.bacView.addSubview(self.visual)
        self.bacView.addSubview(self.custom)
    }
    
    /// 把我show出来
    public func showMe(_ view: UIView) {
        self.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        view.addSubview(self)
        self.presentAnimation()
    }
    
    /// window上弹出来
    public func showMeInWindow() {
        self.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIApplication.shared.keyWindow?.addSubview(self)
        self.presentAnimation()
    }
    
    /// 变消失
    public func dismiss() {
        self.dissAnimation()
    }
    
    /// 弹出视图
    private func presentAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
    
    /// 消失了
    private func dissAnimation() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            self.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        }) { _ in
            self.removeFromSuperview()
        }
    }

    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("LSDMidIndicatorView deinit")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss()
    }
}
