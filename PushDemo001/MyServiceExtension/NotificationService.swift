//
//  NotificationService.swift
//  MyServiceExtension
//
//  Created by zhangyan on 16/12/6.
//  Copyright © 2016年 zhangyan. All rights reserved.
//

import UserNotifications

@available(iOSApplicationExtension 10.0, *)
class NotificationService: UNNotificationServiceExtension {
    
    typealias CompletionHandlerBlock = (UNNotificationAttachment?) -> Void
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            bestAttemptContent.body = "我是新修改的body"
            bestAttemptContent.title = "我是新修改的title"
            bestAttemptContent.subtitle = "我是subTitle"
            
            // 获取相关的附件，看是不是有相关的附件
            let userInfoDic = bestAttemptContent.userInfo
            let apsDic:[AnyHashable : Any] = userInfoDic["aps"] as! [AnyHashable : Any]
            if apsDic["my-attachment"] != nil{
                // 如果说存在附件的话
                loadAttachmentForUrlString(urlStr: apsDic["my-attachment"] as! String, completionHandler: { (attachment) in
                    
                    if attachment != nil{
                        // 如果说 attachment 不为空的话
                        bestAttemptContent.attachments = [attachment!,attachment!]
                    }
                    contentHandler(bestAttemptContent)
                })
                
            }else{
                // 如果说不存在附件的话
                contentHandler(bestAttemptContent)
            }
        }
    }
    
    // MARK:- 下载相关的附件信息
    func loadAttachmentForUrlString(urlStr:String,completionHandler:@escaping CompletionHandlerBlock) -> Void {
        
        let attachmentURL:URL = URL(string: urlStr)!
        
        // 开启线程去下载
        DispatchQueue.global().async {
            
            let urlSession = URLSession.shared.dataTask(with: attachmentURL, completionHandler: { (data, response, error) in
                
                // 下载完毕，或者报错，转到主线程中
                DispatchQueue.main.async {
                    var attachment : UNNotificationAttachment? = nil
                    if let data = data{
                        
                        // 加工目的 url，将下载好的推送附件添加到沙盒中
                        let ext = (urlStr as NSString).pathExtension
                        let cacheURL = URL(fileURLWithPath: FileManager.default.cachesDirectory)
                        let finalUrl = cacheURL.appendingPathComponent(urlStr.md5).appendingPathExtension(ext)
                        
                        print("finalUrl ************* \(finalUrl)")
                        // 将下载好的附件写入沙盒
                        
                        if let _ = try? data.write(to: finalUrl) {
                            // 写入
                            attachment = try? UNNotificationAttachment(identifier: "pushAttachment", url: finalUrl, options: nil)
                            completionHandler(attachment)
                        }else{
                            completionHandler(attachment)
                        }
                        
                    }else{
                        completionHandler(attachment)
                    }
                }
            })
            
            
            urlSession.resume()
            
        }
    }
    
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}

// 获取沙盒地址
extension FileManager {
    var cachesDirectory: String {
        var paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
}

extension String {
    var md5: String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        if let data = data(using: .utf8) {
            data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
                CC_MD5(bytes, CC_LONG(data.count), &digest)
            }
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
        
    }
}
