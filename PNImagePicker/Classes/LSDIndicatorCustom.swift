//
//  LSDIndicatorCustom.swift
//  jianbianse
//
//  Created by 罗达达 on 2018/9/29.
//  Copyright © 2018 罗达达. All rights reserved.
//

import UIKit

//MARK:-颜色初始化方法
/// - Parameters:
///   - R: RED
///   - G: GREEN
///   - B: BLUE
/// - Returns: UIColor
func RGB(R:CGFloat,G:CGFloat,B:CGFloat) -> UIColor? {
    return RGBA(R: R, G: G, B: B, A: 1.0)
}

/// - Parameters:
///   - R: RED
///   - G: GREEN
///   - B: BLUE
///   - A: Alpha 透明度
/// - Returns: UIColor
func RGBA(R:CGFloat,G:CGFloat,B:CGFloat,A:CGFloat) -> UIColor? {
    if R>255.0||G>255.0||B>255.0||A>1.0 {
        return nil
    }
    return UIColor.init(red: CGFloat(R/255.0), green: G/255.0, blue: B/255.0, alpha: A)
}

class LSDIndicatorCustom: UIView {
    
    private lazy var mainView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.layer.cornerRadius = 20
        view.backgroundColor = .clear
        view.layer.borderColor = RGB(R: 180, G: 180, B: 180)?.cgColor
        view.layer.borderWidth = 5
        return view
    }()
    
    private var count: Int = 1

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.mainView)
        
        let bezie:UIBezierPath = UIBezierPath(arcCenter: CGPoint(x: 20, y: 20), radius: 17.5, startAngle: .pi, endAngle: -.pi/2, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 5
        shapeLayer.strokeColor = UIColor.black.cgColor
//        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.path = bezie.cgPath
        setGradualChangingColor(targetLayer: shapeLayer, color: RGB(R: 255, G: 0, B: 42)!, toColor: UIColor.white)
        self.layer.addSublayer(shapeLayer)
        
        self.start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func start() {
        let rotation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.repeatCount = MAXFLOAT
        rotation.duration = 1
        rotation.isRemovedOnCompletion = false
        self.layer.add(rotation, forKey: nil)
    }
    
    func setGradualChangingColor(targetLayer:CAShapeLayer, color:UIColor, toColor:UIColor){
        let gradLayer:CAGradientLayer = CAGradientLayer()
        gradLayer.frame = targetLayer.bounds
        gradLayer.colors = [color.cgColor,toColor.cgColor]
        gradLayer.startPoint = CGPoint(x: 0, y: 0)
        gradLayer.endPoint = CGPoint(x: 1, y: 1)
        gradLayer.locations = [0,1]
        self.layer.addSublayer(gradLayer)
    }
    
}
