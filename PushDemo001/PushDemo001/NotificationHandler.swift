//
//  NotificationHandler.swift
//  PushDemo001
//
//  Created by zhangyan on 16/12/1.
//  Copyright © 2016年 zhangyan. All rights reserved.
//

import UIKit
import UserNotifications
class NotificationHandler: NSObject,UNUserNotificationCenterDelegate {

    @available(iOS 10.0, *)
    // 点击推送框的时候，就会走这个方法。不管是本地推送还是远程推送，相比之前更加方便了
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        let title = response.notification.request.content.title
        let subTitle = response.notification.request.content.subtitle
        let categoryIdentifier = response.notification.request.content.categoryIdentifier
        let body = response.notification.request.content.body
        let content = response.notification.request.content
        let identifier = response.notification.request.identifier
        
        print("  userInfo = \(userInfo)\n  title = \(title)\n  subTitle = \(subTitle)\n  categoryIdentifier = \(categoryIdentifier)\n  body = \(body)\n  identifier = \(identifier)  \n  content = \(content)\n  ")
        
        // 获取特殊的 categoryIdentifier 的操作信息
        if categoryIdentifier == "saySomethingCategory" {
            let text: String
            if let actionType = SaySomethingCategoryAction(rawValue: response.actionIdentifier) {
                
                switch actionType {
                case .input:
                    text = (response as! UNTextInputNotificationResponse).userText
                case .goodbye:
                    text = "Goodbye"
                case .none:
                    text = ""
                }
            }else{
                text = ""
            }
            
            print("text ===== \(text)")
        }
    }
    
    enum SaySomethingCategoryAction: String {
        case input
        case goodbye
        case none
    }
    
    @available(iOS 10.0, *)
    // 展示之前进行的设置
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
        completionHandler([.alert, .sound])
        
        // 演示使用
//        let identifier = notification.request.identifier
//        if identifier == "firstLocationPush"{
//            
//            completionHandler([.alert, .sound])
//            
//        }else{
//            // 如果不想显示某个通知，可以直接用空 options 调用 completionHandler:
//            completionHandler([])
//            
//        }
    }
}
