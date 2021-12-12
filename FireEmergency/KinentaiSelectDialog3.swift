//
//  KinentaiSelectDialog3.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2019/02/02.
//  Copyright © 2019年 tadakazu nakamichi. All rights reserved.
//
//  2019.2.2追加　アクションプランの追加画面

import UIKit

class KinentaiSelectDialog3 {
    //ボタン押したら出るUIWindow
    fileprivate var parent: KinentaiViewController! //2019-02-02 クラス変更
    internal var win1: UIWindow!
    fileprivate var text0: UITextView!      //見出し
    fileprivate var text1: UITextView!      //■指揮支援部隊
    fileprivate var button1: UIButton!      //出動先ボタン1
    fileprivate var text2: UITextView!      //■大阪府大隊（陸上）
    fileprivate var button2: UIButton!      //出動先ボタン2
    fileprivate var text3: UITextView!      //■航空小隊
    fileprivate var button3: UIButton!      //出動先ボタン3
    fileprivate var btnClose: UIButton!
    fileprivate var mKinentaiResultDialog31: KinentaiResultDialog31!
    fileprivate var mKinentaiResultDialog32: KinentaiResultDialog32!
    fileprivate var mKinentaiResultDialog33: KinentaiResultDialog33!
    //一つ前のだ画面から送られてくるインデックス保存用 1:東海地震 2:首都直下地震　3:南海トラフ地震
    fileprivate var mIndex: Int!
    
    //コンストラクタ
    init(index: Int, parentView: KinentaiViewController){
        parent = parentView
        win1 = UIWindow()
        text0 = UITextView()
        text1 = UITextView()
        button1 = UIButton()
        text2 = UITextView()
        button2 = UIButton()
        text3 = UITextView()
        button3 = UIButton()
        btnClose = UIButton()
        mIndex = index
        
        //タイトルとなるtextの内容を場合分け
        switch index {
        //東海地震
        case 1:
            text0.text = "東海地震アクションプラン適用"
            text1.text = "■指揮支援部隊\n　→第二次応援\n　→"
            text2.text = "■大阪府大隊\n　→第二次応援\n　→"
            text3.text = "■航空小隊\n　→第一次応援(全隊出動)\n　→"
            break
        //首都直下地震
        case 2:
            text0.text = "首都直下地震アクションプラン適用\n\n即時応援都道府県に該当する\n"
            text1.text = "■指揮支援部隊\n　→統括指揮支援隊として出動\n　→"
            text2.text = "■大阪府大隊(陸上)\n　→全隊出動(エネ産編成)\n　→"
            text3.text = "■航空小隊\n　→統括指揮支援部隊輸送航空小隊\n　→"
            break
        //南海トラフ地震
        case 3:
            text0.text = "南海トラフ地震アクションプラン適用\n\n被害確認後応援都道府県に該当\n"
            text1.text = "■指揮支援部隊\n　→被害確認後、出動可能な全隊出動\n　→"
            text2.text = "■大阪府大隊(陸上)\n　→被害確認後、出動可能な全隊出動\n　→"
            text3.text = "■航空小隊\n　→被害確認後、出動可能な全隊出動\n　→"
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
        text1 = nil
        button1 = nil
        text2 = nil
        button2 = nil
        text3 = nil
        button3 = nil
        btnClose = nil
        mIndex = nil
    }
    
    //セットIndex
    func setIndex(_ index: Int){
        mIndex = index
    }
    
    //表示
    func showInfo (){
        //KinentaiViewControllerの画面を暗く
        parent.view.alpha = 0.1
        mViewController.view.alpha = 0.1
        //初期設定
        //Win1
        win1.backgroundColor = UIColor.white
        win1.frame = CGRect(x: 20,y: 80, width: parent.view.frame.width-40, height: parent.view.frame.height)
        win1.layer.position = CGPoint(x: parent.view.frame.width/2, y: parent.view.frame.height/2+72) //+72調整
        win1.alpha = 1.0
        win1.layer.cornerRadius = 10
        //KeyWindowにする
        win1.makeKey()
        //表示
        self.win1.makeKeyAndVisible()
        
        //TextView0生成
        text0.frame = CGRect(x: 10, y: 0, width: self.win1.frame.width-20, height: 80)
        text0.backgroundColor = UIColor.clear
        text0.font = UIFont.systemFont(ofSize: CGFloat(18))
        text0.textColor = UIColor.black
        text0.textAlignment = NSTextAlignment.left
        text0.isEditable = false
        self.win1.addSubview(text0)
        
        //TextView1生成
        text1.frame = CGRect(x: 10, y: 100, width: self.win1.frame.width-20, height: 90)
        text1.backgroundColor = UIColor.clear
        text1.font = UIFont.systemFont(ofSize: CGFloat(18))
        text1.textColor = UIColor.black
        text1.textAlignment = NSTextAlignment.left
        text1.isEditable = false
        self.win1.addSubview(text1)
        
        //出動先ボタン1生成
        button1.frame = CGRect(x: 0,y: 0,width: 100,height: 30)
        button1.backgroundColor = UIColor.red
        button1.setTitle("出動先", for: UIControl.State())
        button1.setTitleColor(UIColor.white, for: UIControl.State())
        button1.layer.masksToBounds = true
        button1.layer.cornerRadius = 10.0
        button1.layer.position = CGPoint(x: self.win1.frame.width/2, y: 170)
        button1.addTarget(self, action: #selector(self.onClickButton1(_:)), for: .touchUpInside)
        self.win1.addSubview(button1)
        
        //TextView2生成
        text2.frame = CGRect(x: 10, y: 200, width: self.win1.frame.width-20, height: 90)
        text2.backgroundColor = UIColor.clear
        text2.font = UIFont.systemFont(ofSize: CGFloat(18))
        text2.textColor = UIColor.black
        text2.textAlignment = NSTextAlignment.left
        text2.isEditable = false
        self.win1.addSubview(text2)
        
        //出動先ボタン2生成
        button2.frame = CGRect(x: 0,y: 0,width: 100,height: 30)
        button2.backgroundColor = UIColor.red
        button2.setTitle("出動先", for: UIControl.State())
        button2.setTitleColor(UIColor.white, for: UIControl.State())
        button2.layer.masksToBounds = true
        button2.layer.cornerRadius = 10.0
        button2.layer.position = CGPoint(x: self.win1.frame.width/2, y: 270)
        button2.addTarget(self, action: #selector(self.onClickButton2(_:)), for: .touchUpInside)
        self.win1.addSubview(button2)
        
        //TextView3生成
        text3.frame = CGRect(x: 10, y: 320, width: self.win1.frame.width-20, height: 90)
        text3.backgroundColor = UIColor.clear
        text3.font = UIFont.systemFont(ofSize: CGFloat(18))
        text3.textColor = UIColor.black
        text3.textAlignment = NSTextAlignment.left
        text3.isEditable = false
        self.win1.addSubview(text3)
        
        //出動先ボタン3生成
        button3.frame = CGRect(x: 0,y: 0,width: 100,height: 30)
        button3.backgroundColor = UIColor.red
        button3.setTitle("出動先", for: UIControl.State())
        button3.setTitleColor(UIColor.white, for: UIControl.State())
        button3.layer.masksToBounds = true
        button3.layer.cornerRadius = 10.0
        button3.layer.position = CGPoint(x: self.win1.frame.width/2, y: 400)
        button3.addTarget(self, action: #selector(self.onClickButton3(_:)), for: .touchUpInside)
        self.win1.addSubview(button3)
        
        //閉じるボタン生成
        btnClose.frame = CGRect(x: 0,y: 0,width: 100,height: 30)
        btnClose.backgroundColor = UIColor.orange
        btnClose.setTitle("閉じる", for: UIControl.State())
        btnClose.setTitleColor(UIColor.white, for: UIControl.State())
        btnClose.layer.masksToBounds = true
        btnClose.layer.cornerRadius = 10.0
        btnClose.layer.position = CGPoint(x: self.win1.frame.width/2, y: self.win1.frame.height-20)
        btnClose.addTarget(self, action: #selector(self.onClickClose(_:)), for: .touchUpInside)
        self.win1.addSubview(btnClose)
    }
    
    //指揮支援部隊　出動先ボタン1
    @objc func onClickButton1(_ sender: UIButton){
        //まずボタン無効化
        offButton()
        
        switch mIndex{
        //東海地震　ボタン1
        case 1:
            mKinentaiResultDialog31 = KinentaiResultDialog31(index: 1, parentView: self)
            mKinentaiResultDialog31.showInfo()
            break
        //首都直下地震　ボタン1
        case 2:
            mKinentaiResultDialog32 = KinentaiResultDialog32(index: 1, parentView: self)
            mKinentaiResultDialog32.showInfo()
            break
        //南海トラフ地震　ボタン1
        case 3:
            mKinentaiResultDialog33 = KinentaiResultDialog33(index: 1, parentView: self)
            mKinentaiResultDialog33.showInfo()
            break
        default:
            break
        }
    }
    
    //大阪府大隊　出動先ボタン2
    @objc func onClickButton2(_ sender: UIButton){
        //まずボタン無効化
        offButton()
        
        switch mIndex{
        //東海地震　ボタン2
        case 1:
            mKinentaiResultDialog31 = KinentaiResultDialog31(index: 2, parentView: self)
            mKinentaiResultDialog31.showInfo()
            break
        //首都直下地震　ボタン2
        case 2:
            mKinentaiResultDialog32 = KinentaiResultDialog32(index: 2, parentView: self)
            mKinentaiResultDialog32.showInfo()
            break
        //南海トラフ地震　ボタン2
        case 3:
            mKinentaiResultDialog33 = KinentaiResultDialog33(index: 2, parentView: self)
            mKinentaiResultDialog33.showInfo()
            break
        default:
            break
        }
    }
    
    //航空小隊　出動先ボタン3
    @objc func onClickButton3(_ sender: UIButton){
        //まずボタン無効化
        offButton()
        
        switch mIndex{
        //東海地震　ボタン3
        case 1:
            mKinentaiResultDialog31 = KinentaiResultDialog31(index: 3, parentView: self)
            mKinentaiResultDialog31.showInfo()
            break
        //首都直下地震　ボタン3
        case 2:
            mKinentaiResultDialog32 = KinentaiResultDialog32(index: 3, parentView: self)
            mKinentaiResultDialog32.showInfo()
            break
        //南海トラフ地震　ボタン3
        case 3:
            mKinentaiResultDialog33 = KinentaiResultDialog33(index: 3, parentView: self)
            mKinentaiResultDialog33.showInfo()
            break
        default:
            break
        }
    }
    
    //次の画面に遷移する前に、全てのボタン無効化
    func offButton() {
        button1.isEnabled = false
        button2.isEnabled = false
        button3.isEnabled = false
        btnClose.isEnabled = false
    }
    
    //帰ってきた時に無効化されていたボタンを有効化
    func onButton(){
        button1.isEnabled = true
        button2.isEnabled = true
        button3.isEnabled = true
        btnClose.isEnabled = true
    }
    
    //閉じる
    @objc func onClickClose(_ sender: UIButton){
        win1.isHidden = true      //win1隠す
        text1.text = ""         //使い回しするのでテキスト内容クリア
        parent.view.alpha = 1.0 //元の画面明るく
        mViewController.view.alpha = 1.0
    }
}

