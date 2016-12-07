//
//  NotificationViewController.swift
//  MyContentExtension
//
//  Created by zhangyan on 16/12/7.
//  Copyright © 2016年 zhangyan. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var subImageView: UIImageView!
    // 只要是 category 的标识和  NotificationContent 中的Info.plist 中的 UNNotificationExtensionCategory 的选项中的某一项一致的话就会走这个方法，不管是本地推送还是远程推送
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func didReceive(_ notification: UNNotification) {
        // 1、获取需要显示的内容
        let content = notification.request.content
        let titleStr = content.title
        let subTitleStr = content.subtitle
        // 附件的本地url
        let finalUrl:URL? = content.attachments[0].url
        
        // 2、通过 category 标识来判断应该采取哪一种布局
        let category = notification.request.content.categoryIdentifier
        if category == "myNotificationCategory1" {
            // 布局，图片在左边，标题和子标题在右边
            contentImageView.frame = CGRect(x: 10, y: 10, width:self.view.frame.width*(1/3.0), height: self.view.frame.width*(1/3.0))
            contentImageView.backgroundColor = UIColor.cyan
            contentImageView.contentMode = UIViewContentMode.scaleAspectFit
            let  titleLabelX = self.contentImageView.frame.maxX+10
            self.titleLabel.frame = CGRect(x: titleLabelX, y: 10, width: self.view.frame.width-titleLabelX-10, height: 0)
            
        }
        
        // 3、加载存储在沙盒中的附件
        if (finalUrl?.startAccessingSecurityScopedResource())!{
            print("finalUrl = \(finalUrl)     finalUrl.path = \(finalUrl?.path)")
            
            let tempImage = UIImage(contentsOfFile: finalUrl!.path)
            let imageDate = UIImageJPEGRepresentation(tempImage!, 1.0)
            let operateImage = UIImage.init(data: imageDate!)
            
            contentImageView.image = operateImage
            subImageView.image = operateImage //UIImage(contentsOfFile: finalUrl!.path)
            subImageView.contentMode = UIViewContentMode.scaleAspectFit
            finalUrl?.stopAccessingSecurityScopedResource()
        }
        
        
        self.titleLabel.text = titleStr
        self.titleLabel.sizeToFit()
        
        
        // 重新布局 subTitleLabel
        self.subTitleLabel.frame = CGRect(x: self.titleLabel.frame.minX, y: self.titleLabel.frame.maxY+5, width:self.view.frame.width*(1/3.0), height: 0)
        self.subTitleLabel.text = subTitleStr
        self.subTitleLabel.sizeToFit()
        
        // 修改整体的高度
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 150)
    }
}



// 获取沙盒地址
extension FileManager {
    var cachesDirectory: String {
        var paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
}

