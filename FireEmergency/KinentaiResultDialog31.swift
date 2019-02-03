//
//  KinentaiResultDialog31.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2019/02/02.
//  Copyright © 2019年 tadakazu nakamichi. All rights reserved.
//
//  2019.2.2追加　アクションプランの追加画面

import UIKit

class KinentaiResultDialog31 {
    //ボタン押したら出るUIWindow
    fileprivate var parent: KinentaiSelectDialog3!
    fileprivate var win1: UIWindow!
    fileprivate var text0: UITextView!      //被害状況により、消防庁が決定
    fileprivate var btnBack: UIButton!
    fileprivate var mKinentaiResultDialog: KinentaiResultDialog!
    //一つ前のだ画面から送られてくるインデックス保存用 1:指揮支援部隊 2:大阪府大隊　3:航空小隊
    fileprivate var mIndex: Int!
    
    //コンストラクタ
    init(index: Int, parentView: KinentaiSelectDialog3){
        parent = parentView
        win1 = UIWindow()
        text0 = UITextView()
        btnBack = UIButton()
        mIndex = index
        
        //タイトルとなるtextの内容を場合分け
        switch index {
        //指揮支援部隊
        case 1:
            text0.text = "被害状況により、消防庁が決定"
            break
        //大阪府大隊
        case 2:
            text0.text = "被害状況により、消防庁が決定"
            break
        //航空小隊
        case 3:
            text0.text = "被害状況により、消防庁が決定"
            break
        default:
            break
        }
    }
    
    //デコンストラクタ
    deinit{
        parent = nil
        win1 = nil
        text0 = nil
        btnBack = nil
        mIndex = nil
    }
    
    //セットIndex
    func setIndex(_ index: Int){
        mIndex = index
    }
    
    //表示
    func showInfo (){
        //元の画面を暗く
        parent.win1.alpha = 0.1
        //初期設定
        //Win1
        win1.backgroundColor = UIColor.white
        win1.frame = CGRect(x: 20,y: 200,width: parent.win1.frame.width, height: parent.win1.frame.height/3)
        win1.alpha = 1.0
        win1.layer.cornerRadius = 10
        //KeyWindowにする
        win1.makeKey()
        //表示
        self.win1.makeKeyAndVisible()
        
        //TextView0生成
        text0.frame = CGRect(x: 10, y: 20, width: self.win1.frame.width-20, height: 60)
        text0.backgroundColor = UIColor.clear
        text0.font = UIFont.systemFont(ofSize: CGFloat(18))
        text0.textColor = UIColor.black
        text0.textAlignment = NSTextAlignment.left
        text0.isEditable = false
        self.win1.addSubview(text0)
        
        //戻るボタン生成
        btnBack.frame = CGRect(x: 0,y: 0,width: 100,height: 30)
        btnBack.backgroundColor = UIColor.orange
        btnBack.setTitle("戻る", for: UIControlState())
        btnBack.setTitleColor(UIColor.white, for: UIControlState())
        btnBack.layer.masksToBounds = true
        btnBack.layer.cornerRadius = 10.0
        btnBack.layer.position = CGPoint(x: self.win1.frame.width/2, y: self.win1.frame.height-20)
        btnBack.addTarget(self, action: #selector(self.onClickClose(_:)), for: .touchUpInside)
        self.win1.addSubview(btnBack)
    }
    
    //閉じる
    @objc func onClickClose(_ sender: UIButton){
        win1.isHidden = true      //win1隠す
        text0.text = ""         //使い回しするのでテキスト内容クリア
        parent.win1.alpha = 1.0 //下の画面をもとどおり明るくする
        parent.onButton() //前のダイアログの無効化しているボタンを有効化
    }
}

