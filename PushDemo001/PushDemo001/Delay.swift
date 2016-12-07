//
//  Delay.swift
//  PushDemo001
//
//  Created by zhangyan on 16/11/28.
//  Copyright © 2016年 zhangyan. All rights reserved.
//

import UIKit

func delay(_ timeInterval: TimeInterval, _ block: @escaping ()->Void) {
    let after = DispatchTime.now() + timeInterval
    DispatchQueue.main.asyncAfter(deadline: after, execute: block)
}
