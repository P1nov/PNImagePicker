//
//  PSCommonDefineFile.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/25.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit

//MARK:-屏幕Width
let pScreenWidth  = UIScreen.main.bounds.size.width
//MARK:-屏幕Height
let pScreenHeight = UIScreen.main.bounds.size.height
//MARK:-屏幕Size
let pScreenSize   = UIScreen.main.bounds.size
//MARK:-屏幕Scale
let pScale        = UIScreen.main.scale

private let p_scale_x = (pScreenWidth-0.000001)/375.0

func pScale(_ scale:CGFloat) -> CGFloat {
    return scale*p_scale_x
}


//MARK: -notificationName
let PSImageSelectImageNotificationName = "PSImageSelectImageNotificationName"

func pSafeBottomHeight() -> CGFloat {
    if #available(iOS 11.0, *) {
        
        if (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) > 0 {
            return 34
        } else {
            return 0
        }
    } else {
        return 0
    }
}


