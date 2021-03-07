//
//  AlertDialogMail.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2021/03/07.
//  Copyright © 2021 tadakazu nakamichi. All rights reserved.
//

import UIKit

class AlertDialogMail: NSObject {
    //ボタン押したら出るUIWindow
    fileprivate var parent: KinmusyoSelectDialog!
    fileprivate var win1: UIWindow!
    fileprivate var text1: UITextView!
    fileprivate var btnClose: UIButton!
    fileprivate var mKinmusyoSelectDialog: KinmusyoSelectDialog!
    
    //コンストラクタ
    init(parentView: KinmusyoSelectDialog){
        parent = parentView
        win1 = UIWindow()
        text1 = UITextView()
        btnClose = UIButton()
        
        text1.text = "ボタンをタップして参集先を選択してください"
    }
    
    //デコンストラクタ
    deinit{
        parent = nil
        win1 = nil
        text1 = nil
        btnClose = nil
    }
        
    //表示
    func showInfo (){
        //元の画面を暗く、タップ無効化
        parent.win1.alpha = 0.1
        parent.win1.isUserInteractionEnabled = false
        //初期設定
        //Win1
        win1.backgroundColor = UIColor.white
        win1.frame = CGRect(x: 0, y: parent.win1.frame.height/2, width: parent.win1.frame.width-40, height: 180)
        win1.layer.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
        win1.alpha = 1.0
        win1.layer.cornerRadius = 10
        //KeyWindowにする
        win1.makeKey()
        //表示
        self.win1.makeKeyAndVisible()
        
        //TextView生成
        text1.frame = CGRect(x: 10, y: 10, width: self.win1.frame.width-20, height: 100)
        text1.backgroundColor = UIColor.clear
        text1.font = UIFont.systemFont(ofSize: CGFloat(18))
        text1.textColor = UIColor.black
        text1.textAlignment = NSTextAlignment.left
        text1.isEditable = false
        self.win1.addSubview(text1)
                
        //閉じるボタン生成
        btnClose.frame = CGRect(x: 0,y: 0,width: 125,height: 30)
        btnClose.backgroundColor = UIColor.red
        btnClose.setTitle("はい", for: UIControl.State())
        btnClose.setTitleColor(UIColor.white, for: UIControl.State())
        btnClose.layer.masksToBounds = true
        btnClose.layer.cornerRadius = 10.0
        btnClose.layer.position = CGPoint(x: self.win1.frame.width/2, y: self.win1.frame.height-40)
        btnClose.addTarget(self, action: #selector(self.onClickClose(_:)), for: .touchUpInside)
        self.win1.addSubview(btnClose)
    }
    
    //閉じる
    @objc func onClickClose(_ sender: UIButton){
        win1.isHidden = true      //win1隠す
        text1.text = ""         //使い回しするのでテキスト内容クリア
        parent.win1.alpha = 1.0 //下のダイアログを明るく戻す
        parent.win1.isUserInteractionEnabled = true //タップ有効化
    }
}

