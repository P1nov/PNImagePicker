//
//  PSImageToolBar.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/28.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit

let themeColor: UIColor = UIColor(red: 252 / 255.0, green: 105 / 255.0, blue: 118 / 255.0, alpha: 1.0)

var previewTitle: String = "预览"

class GradientButton: UIButton {
    
    private let gradientView = UIView()
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        gradientView.isUserInteractionEnabled = false
        gradientView.frame = CGRect(x: 259, y: 627, width: 100, height: 32)

        gradientLayer.colors = [
            UIColor(red: 1, green: 0.64, blue: 0.68, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.49, blue: 0.53, alpha: 1).cgColor
        ]
        
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientView.layer.addSublayer(gradientLayer)
        
        titleLabel?.font = .systemFont(ofSize: 14.0)
        setTitleColor(.white, for: .normal)
        
        addSubview(gradientView)
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        sendSubview(toBack: gradientView)
        sendSubviewToBack(gradientView)
        gradientView.frame = bounds
        gradientLayer.frame = gradientView.bounds
        gradientLayer.cornerRadius = bounds.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isEnabled: Bool {
        didSet {
            
            let normalColors = [
                UIColor(red: 1, green: 0.64, blue: 0.68, alpha: 1).cgColor,
                UIColor(red: 1, green: 0.49, blue: 0.53, alpha: 1).cgColor
            ]
            
            let disabledColors = [
                UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor,
                UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
            ]
            gradientLayer.colors = isEnabled ? normalColors : disabledColors
            
        }
    }
    
}

class PSImageToolBar: UIView {

    private let contentView = UIView()
    private let shadowView = UIView()
    
    let previewButton = UIButton()
    
    let confirmButton = GradientButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let rgb: CGFloat = 229 / 255.0
        shadowView.backgroundColor = UIColor(red: rgb, green: rgb, blue: rgb, alpha: 1.0)
        addSubview(shadowView)
        insertSubview(contentView, belowSubview: shadowView)
        
        let disabledRgb: CGFloat = 102 / 255.0
        let disabledColor = UIColor(red: disabledRgb, green: disabledRgb, blue: disabledRgb, alpha: 1.0)
        previewButton.titleLabel?.font = .systemFont(ofSize: 14)
        previewButton.setTitleColor(themeColor, for: .normal)
        previewButton.setTitleColor(disabledColor, for: .disabled)
        previewButton.contentHorizontalAlignment = .left
        previewButton.setTitle(previewTitle, for: .normal)
        contentView.addSubview(previewButton)
        addSubview(confirmButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.frame = .init(x: 0, y: 0, width: bounds.width, height: 1.0 / UIScreen.main.scale)
        contentView.frame = bounds
        previewButton.frame = .init(x: 16.0, y: 0, width: 40.0, height: contentView.bounds.height)
        confirmButton.frame = .init(
            x: contentView.bounds.width - 16.0 - 100.0,
            y: contentView.bounds.height / 2 - 16.0,
            width: 100.0,
            height: 32.0
        )
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
