//
//  AppDelegate.swift
//  PushDemo001
//
//  Created by zhangyan on 16/12/6.
//  Copyright © 2016年 zhangyan. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let notificationHandler = NotificationHandler()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // 注册推送
        registerPush(application: application)
        
        registerNotificationCategory()
        
        // 添加iOS10 推送的相关的代理
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = notificationHandler
        } else {
            // Fallback on earlier versions
        }
        
        return true
    }
    
    
    // 注册推送
    func registerPush(application:UIApplication) {
        
        // 首先通过系统版本进行判断，进行不同的注册
        let version:NSString = UIDevice.current.systemVersion as NSString;
        let versionFloat = version.floatValue
        if versionFloat < 10{
            
            let settings = UIUserNotificationSettings.init(types: [.alert, .sound, .badge], categories: nil)
            application.registerUserNotificationSettings(settings)
            
        }else{
            
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                    granted, error in
                    if granted {
                        // 用户允许进行通知
                        
                        print("用户允许进行通知了")
                        
                    }else{
                        print("用户不允许进行通知了")
                    }
                }
                
                // 向 APNs 请求 token：
                UIApplication.shared.registerForRemoteNotifications()
                
            } else {
                // Fallback on earlier versions
            }
            
            
            /******************************************************************************************/
            // 用户可以在系统设置中修改你的应用的通知权限，除了打开和关闭全部通知权限外，用户也可以限制你的应用只能进行某种形式的通知显示，比如只允许横幅而不允许弹窗及通知中心显示等。一般来说你不应该对用户的选择进行干涉，但是如果你的应用确实需要某种特定场景的推送的话，你可以对当前用户进行的设置进行检查：
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().getNotificationSettings {
                    settings in
                    print(settings.authorizationStatus) // .authorized | .denied | .notDetermined
                    print(settings.badgeSetting) // .enabled | .disabled | .notSupported
                    // etc...
                }
            } else {
                // Fallback on earlier versions
            }
            
            /******************************************************************************************/
        }
    }
    
    // 获取token，有需要的话上传到服务器
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenString = deviceToken.hexString
        print("Get Push token: \(tokenString)")
        
    }
    
    
    // 设置特殊标识的通知条的交互
    private func registerNotificationCategory() {
        if #available(iOS 10.0, *) {
            let saySomethingCategory: UNNotificationCategory = {
                // 1
                let inputAction = UNTextInputNotificationAction(
                    identifier: "input",
                    title: "Input",
                    options: [.foreground],
                    textInputButtonTitle: "Send",
                    textInputPlaceholder: "What do you want to say...")
                
                // 2
                let goodbyeAction = UNNotificationAction(
                    identifier: "goodbye",
                    title: "Goodbye",
                    options: [.foreground])
                
                let cancelAction = UNNotificationAction(
                    identifier: "cancel",
                    title: "Cancel",
                    options: [.foreground])
                
                // 3
                return UNNotificationCategory(identifier:"saySomethingCategory", actions: [inputAction, goodbyeAction, cancelAction], intentIdentifiers: [], options: [.customDismissAction])
            }()
            
            UNUserNotificationCenter.current().setNotificationCategories([saySomethingCategory])
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    // 接收到本地推送
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        print("notification.userInfo = \(notification)  notification.alertBody = \(notification.alertBody)  notification.userInfo = \(notification.userInfo)");
        
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

