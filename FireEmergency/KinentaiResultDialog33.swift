//
//  KinentaiResultDialog33.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2019/02/03.
//  Copyright © 2019年 tadakazu nakamichi. All rights reserved.
//  2019-02-03 アクションプランの追加画面

import UIKit

class KinentaiResultDialog33 {
    //ボタン押したら出るUIWindow
    fileprivate var parent: KinentaiSelectDialog3!
    fileprivate var win1: UIWindow!
    fileprivate var text0: UITextView!      //ここに出動先が表示される
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
            text0.text = "■指揮支援部隊\n　統括指揮支援隊\n　→和歌山県\n　　南別館屋上へリポート又はコスモパーク加太\n\n　指揮支援隊\n　→被害状況により消防庁長官が指示\n"
            break
        //大阪府大隊(陸上)
        case 2:
            text0.text = "■大阪府大隊(陸上)\n　出動先：被害状況により消防庁長官が指示\n\n　集結場所：高度専門教育訓練センター(統合機動部隊含む)\n\n　進出拠点：紀ノ川SA(阪和自動車道)又は橋本運動公園\n"
            break
        //航空小隊
        case 3:
            text0.text = "■航空小隊\n　出動先：長官が指定する任務による\n\n　任務：統括指揮支援隊輸送ヘリ\n　→和歌山県\n　　南別館屋上へリポート又はコスモパーク加太\n\n　任務：救助・救急・輸送ヘリ\n　→応援先は長官が指定"
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
        mViewController.view.alpha = 0.3
        //初期設定
        //Win1
        win1.backgroundColor = UIColor.white
        win1.frame = CGRect(x: 20,y: parent.win1.frame.height/2, width: parent.win1.frame.width,height: parent.win1.frame.height*0.8)
        win1.layer.position = CGPoint(x: mViewController.view.frame.width/2, y: mViewController.view.frame.height/2)
        win1.alpha = 1.0
        win1.layer.cornerRadius = 10
        //KeyWindowにする
        win1.makeKey()
        //表示
        self.win1.makeKeyAndVisible()
        
        //TextView0生成
        text0.frame = CGRect(x: 10, y: 20, width: self.win1.frame.width-20, height: 240)
        text0.backgroundColor = UIColor.clear
        text0.font = UIFont.systemFont(ofSize: CGFloat(18))
        text0.textColor = UIColor.black
        text0.textAlignment = NSTextAlignment.left
        text0.isEditable = false
        self.win1.addSubview(text0)
        
        //戻るボタン生成
        btnBack.frame = CGRect(x: 0,y: 0,width: 100,height: 30)
        btnBack.backgroundColor = UIColor.orange
        btnBack.setTitle("戻る", for: UIControl.State())
        btnBack.setTitleColor(UIColor.white, for: UIControl.State())
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
        //mViewController.view.alpha = 1.0 このダイアログは１層下に戻る仕様なので親ViewControllerは明るくしない
        parent.onButton() //前のダイアログの無効化しているボタンを有効化
    }
}

