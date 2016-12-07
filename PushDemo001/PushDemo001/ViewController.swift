//
//  ViewController.swift
//  PushDemo001
//
//  Created by zhangyan on 16/12/6.
//  Copyright © 2016年 zhangyan. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        createUI()
        let cacheURL = URL(fileURLWithPath: FileManager.default.cachesDirectory)
        print("cacheURL === \(cacheURL)")
        
    }
    
    func createUI()  {
        
        let btnArray:[String] = ["iOS10以下本地推送测试","iOS10本地推送测试","iOS10自定义交互的通知","iOS10附件通知","iOS 10 Content Extension 测试本地推送"]
        let btnBackGroundColorArray:[UIColor] = [UIColor.red,UIColor.green,UIColor.cyan,UIColor.blue,UIColor.brown]
        
        for i in 0..<btnArray.count {
            // 创建测试的 button
            let testBtn = UIButton.init(type: UIButtonType.custom)
            testBtn.frame = CGRect(x: 20, y: 50+i*60, width: 300, height: 40)
            testBtn.setTitle(btnArray[i], for: UIControlState.normal)
            testBtn.backgroundColor = UIColor.cyan
            testBtn.tag = 100+i
            testBtn.addTarget(self, action: #selector(ViewController.clickBtn(sender:)), for: UIControlEvents.touchUpInside)
            testBtn.backgroundColor = btnBackGroundColorArray[i]
            self.view.addSubview(testBtn)
        }
        
    }
    
    func clickBtn(sender:UIButton) {
        
        switch sender.tag {
        case 100:
            clickBtn1(sender: sender)
        case 101:
            clickBtn2(sender: sender)
        case 102:
            clickBtn3(sender: sender)
        case 103:
            clickBtn4(sender: sender)
        case 104:
            clickBtn5(sender: sender)
        default: break
            
        }
        
    }
    
    // 测试按钮的点击事件
    func clickBtn1(sender:UIButton) {
        //发送本地推送
        let notification = UILocalNotification()
        
        var fireDate = Date()
        fireDate = fireDate.addingTimeInterval(TimeInterval.init(4.0))
        notification.fireDate = fireDate
        notification.alertBody = "body"
        notification.userInfo = ["name":"张三","age":"20"]
        notification.timeZone = NSTimeZone.default
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        //发送通知
        UIApplication.shared.scheduleLocalNotification(notification)
        UIApplication.shared.applicationIconBadgeNumber += 1;
        
    }
    
    // 测试按钮的点击事件
    func clickBtn2(sender:UIButton) {
        
        if #available(iOS 10.0, *) {
            // 1、创建推送的内容
            let content = UNMutableNotificationContent()
            content.title = "iOS 10 的推送标题"
            content.body = "iOS 10 的推送主体"
            content.subtitle = "iOS 10 的副标题"
            content.userInfo = ["name":"张三","age":"20"]
            content.categoryIdentifier = "firstLocationPush"
            
            // 2、创建发送触发
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false)
            
            // 3. 发送请求标识符
            let requestIdentifier = "firstLocationPush"
            
            // 4、创建一个发送请求
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
            
            // 5、将请求添加到发送中心
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if error == nil{
                    print("Time Interval Notification scheduled: \(requestIdentifier)")
                }
            })
            
            
            
            // 加个延时，将已经展示过的推送干掉
            
            //            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 2.5), execute: {
            //
            //                print("Notification request removed: \(requestIdentifier)")
            //                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [requestIdentifier])
            //
            //            })
            
            // 添加一个延时更新之前的通知
            //            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
            //
            //                let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            //
            //                // Add new request with the same identifier to update a notification.
            //                let newRequest = UNNotificationRequest(identifier: requestIdentifier, content:content, trigger: newTrigger)
            //                UNUserNotificationCenter.current().add(newRequest) { error in
            //                    if error != nil {
            //                        print("Notification request updated: \(requestIdentifier)")
            //                    }
            //                }
            //
            //            })
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    // 测试按钮的点击事件3
    func clickBtn3(sender:UIButton) {
        if #available(iOS 10.0, *) {
            // 1、创建推送的内容
            let content = UNMutableNotificationContent()
            content.title = "iOS 10 的推送标题"
            content.body = "iOS 10 的推送主体"
            content.subtitle = "iOS 10 的副标题"
            content.userInfo = ["name":"张三","age":"20"]
            
            content.categoryIdentifier = "saySomethingCategory"
            
            // 2、创建发送触发
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            
            // 3. 发送请求标识符
            let requestIdentifier = "saySomethingCategory"
            
            // 4、创建一个发送请求
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
            
            // 5、将请求添加到发送中心
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if error == nil{
                    print("Time Interval Notification scheduled: \(requestIdentifier)")
                }
            })
            
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    // 测试按钮的点击事件4
    func clickBtn4(sender:UIButton) {
        if #available(iOS 10.0, *) {
            // 1、创建推送的内容
            let content = UNMutableNotificationContent()
            content.title = "iOS 10 的推送标题"
            content.body = "附件"
            content.subtitle = "附件"
            content.userInfo = ["name":"张三","age":"20"]
            content.categoryIdentifier = "saySomethingCategory"
            // 2、创建发送触发
            
            /* 触发器分三种：
             UNTimeIntervalNotificationTrigger : 在一定时间后触发，如果设置重复的话，timeInterval不能小于60
             UNCalendarNotificationTrigger: 在某天某时触发，可重复
             UNLocationNotificationTrigger : 进入或离开某个地理区域时触发 */
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            // 3. 发送请求标识符
            let requestIdentifier = "music"
            // 添加图片
            //            if let imageURL = Bundle.main.url(forResource: "二哈", withExtension: "jpg"),
            //                let attachment = try? UNNotificationAttachment(identifier: "imageAttachment", url: imageURL, options: nil)
            //            {
            //                content.attachments = [attachment]
            //            }
            
            //             添加视频
            //            if let videoURL = Bundle.main.url(forResource: "IMG_2077", withExtension: "MOV"),
            //                let attachment = try? UNNotificationAttachment(identifier: "videoAttachment", url: videoURL, options: nil)
            //            {
            //                content.attachments = [attachment]
            //            }
            
            //            // 添加音频
            if let videoURL = Bundle.main.url(forResource: "聂芦苇+-+东京热", withExtension: "mp3"),
                let attachment = try? UNNotificationAttachment(identifier: "voiceAttachment", url: videoURL, options: nil)
            {
                content.attachments = [attachment]
            }
            
            // 4、创建一个发送请求
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
            
            // 5、将请求添加到发送中心
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if error == nil{
                    print("Time Interval Notification scheduled: \(requestIdentifier)")
                }
            })
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    // 测试按钮的点击事件5
    func clickBtn5(sender:UIButton) {
        if #available(iOS 10.0, *) {
            // 1、创建推送的内容
            let content = UNMutableNotificationContent()
            content.title = "iOS 10 的推送标题"
            content.body = "附件"
            content.subtitle = "附件"
            content.userInfo = ["name":"张三","age":"20"]
            content.categoryIdentifier = "myNotificationCategory1"
            // 2、创建发送触发
            
            /* 触发器分三种：
             UNTimeIntervalNotificationTrigger : 在一定时间后触发，如果设置重复的话，timeInterval不能小于60
             UNCalendarNotificationTrigger: 在某天某时触发，可重复
             UNLocationNotificationTrigger : 进入或离开某个地理区域时触发 */
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            // 3. 发送请求标识符
            let requestIdentifier = "music"
            // 添加图片
            if let imageURL = Bundle.main.url(forResource: "二哈", withExtension: "jpg"),
                let attachment = try? UNNotificationAttachment(identifier: "imageAttachment", url: imageURL, options: nil)
            {
                content.attachments = [attachment]
            }
            
            
            // 4、创建一个发送请求
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
            
            // 5、将请求添加到发送中心
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if error == nil{
                    print("Time Interval Notification scheduled: \(requestIdentifier)")
                }
            })
            
        } else {
            // Fallback on earlier versions
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

// 获取沙盒地址
extension FileManager {
    var cachesDirectory: String {
        var paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
}


