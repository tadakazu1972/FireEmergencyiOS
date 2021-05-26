//
//  TyphoonSelectDialog.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2016/12/01.
//  Copyright © 2016年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class TyphoonSelectDialog: NSObject, UITableViewDelegate, UITableViewDataSource {
    //ボタン押したら出るUIWindow
    fileprivate var parent: TyphoonViewController!
    fileprivate var win1: UIWindow!
    fileprivate var text1: UITextView!
    fileprivate var table: UITableView!
    fileprivate var items:[String] = ["","","",""]
    fileprivate var btnClose: UIButton!
    fileprivate var mTyphoonSelectDialog2: TyphoonSelectDialog2!
    fileprivate var mTyphoonResultDialog2: TyphoonResultDialog2!
    //自分が何番目のダイアログが保存用
    fileprivate var mIndex: Int!
    
    //コンストラクタ
    init(index: Int, parentView: TyphoonViewController){
        parent = parentView
        win1 = UIWindow()
        text1 = UITextView()
        table = UITableView()
        btnClose = UIButton()
        mIndex = index
        //itemsの内容を場合分け
        switch index {
        case 2:
            items = ["■特別警報", "■暴風（雪）警報", "■大雨警報", "■大雪警報", "■洪水警報", "■波浪警報", "■高潮警報", "■高潮注意報"]
            break
        case 3:
            //2020.06 天竺川、高川、西除川　追加
            //2021.05 石川　追加
            items = ["■淀川（枚方）", "■大和川（柏原）", "■神崎川（三国）", "■天竺川（天竺川橋）", "■高川（水路橋）", "■安威川（千歳橋）", "■寝屋川（京橋）", "■第二寝屋川（昭明橋）", "■平野川（剣橋）", "■平野川分水路（今里大橋）", "■古川（桑才）", "■東除川（大堀上小橋）", "■石川（玉手橋）", "■西除川（布忍橋）", "■高潮"]
            break
        default:
            items = ["■特別警報", "■暴風（雪）警報", "■大雨警報", "■大雪警報", "■洪水警報", "■波浪警報", "■高潮警報", "■高潮注意報"]
            break
        }
    }
    
    //デコンストラクタ
    deinit{
        parent = nil
        win1 = nil
        text1 = nil
        table = nil
        items = ["","","",""]
        btnClose = nil
        mIndex = nil
    }
    
    //セットIndex
    func setIndex(_ index: Int){
        mIndex = index
    }
    
    //表示
    func showInfo (){
        //下層の画面を暗く
        parent.view.alpha = 0.3
        mViewController.view.alpha = 0.3
        //初期設定
        //Win1
        win1.backgroundColor = UIColor.white
        if mViewController.view.frame.height < 570 {
            //iPhone SE
            win1.frame = CGRect(x: 0,y: 0,width: mViewController.view.frame.width-5,height: mViewController.view.frame.height*0.9)
        } else {
            win1.frame = CGRect(x: 0,y: 0,width: mViewController.view.frame.width-5,height: mViewController.view.frame.height*0.8)
        }
        win1.layer.position = CGPoint(x: parent.view.frame.width/2, y: parent.view.frame.height/2+72) //+72:子ViewController調整
        win1.alpha = 1.0
        win1.layer.cornerRadius = 10
        //KeyWindowにする
        win1.makeKey()
        //表示
        self.win1.makeKeyAndVisible()
        
        //TextView生成
        text1.frame = CGRect(x: 10, y: 0, width: self.win1.frame.width-20, height: 40)
        text1.backgroundColor = UIColor.clear
        text1.font = UIFont.systemFont(ofSize: CGFloat(18))
        text1.textColor = UIColor.black
        text1.textAlignment = NSTextAlignment.left
        text1.isEditable = false
        if (mIndex==3){
            text1.text="河川等を選択してください"
        } else {
            text1.text="発令されている警報は？"
        }
        self.win1.addSubview(text1)
        
        //TableView生成
        table.frame = CGRect(x: 10,y: 41, width: self.win1.frame.width-20, height: self.win1.frame.height-60)
        table.delegate = self
        table.dataSource = self
        table.estimatedRowHeight = 10 //下とあわせこの２行で複数行表示されるときの間がひらくようになる
        table.rowHeight = UITableView.automaticDimension //同上
        table.register(UITableViewCell.self, forCellReuseIdentifier:"cell")
        table.separatorColor = UIColor.clear
        self.win1.addSubview(table)
        
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
    
    //閉じる
    @objc func onClickClose(_ sender: UIButton){
        win1.isHidden = true      //win1隠す
        text1.text = ""         //使い回しするのでテキスト内容クリア
        parent.view.alpha = 1.0 //元の画面明るく
        mViewController.view.alpha = 1.0 //明るく
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection sction: Int)-> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = table.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.numberOfLines = 0 //これをしないと複数行表示されない
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("セルを選択 #\(indexPath.row)!")
        switch mIndex{
        case 1:
            switch indexPath.row {
            case 0:
                parent.mTyphoonResultDialog.showResult(11)
                break
            default:
                break
            }
            break
        case 2:
            switch indexPath.row {
            case 0:
                parent.mTyphoonResultDialog.showResult(21)
                break
            case 1:
                parent.mTyphoonResultDialog.showResult(22)
                break
            case 2:
                parent.mTyphoonResultDialog.showResult(23)
                break
            case 3:
                parent.mTyphoonResultDialog.showResult(24)
                break
            case 4:
                parent.mTyphoonResultDialog.showResult(25)
                break
            case 5:
                parent.mTyphoonResultDialog.showResult(26)
                break
            case 6:
                parent.mTyphoonResultDialog.showResult(27)
                break
            case 7:
                parent.mTyphoonResultDialog.showResult(28)
                break
            default:
                break
            }
            break
        case 3:
            switch indexPath.row {
            //淀川
            case 0:
                mTyphoonSelectDialog2 = TyphoonSelectDialog2(index: 1, parentView: parent)
                mTyphoonSelectDialog2.showInfo()
                break
            //大和川
            case 1:
                mTyphoonSelectDialog2 = TyphoonSelectDialog2(index: 2, parentView: parent)
                mTyphoonSelectDialog2.showInfo()
                break
            //神崎川
            case 2:
                mTyphoonSelectDialog2 = TyphoonSelectDialog2(index: 3, parentView: parent)
                mTyphoonSelectDialog2.showInfo()
                break
            //天竺川 2020.06　追加 index:12(既存分を変更しないため)
            case 3:
                mTyphoonSelectDialog2 = TyphoonSelectDialog2(index: 12, parentView: parent)
                mTyphoonSelectDialog2.showInfo()
                break
            //高川 2020.06　追加 index:13(既存分を変更しないため)
            case 4:
                mTyphoonSelectDialog2 = TyphoonSelectDialog2(index: 13, parentView: parent)
                mTyphoonSelectDialog2.showInfo()
                break
            //安威川
            case 5:
                mTyphoonSelectDialog2 = TyphoonSelectDialog2(index: 4, parentView: parent)
                mTyphoonSelectDialog2.showInfo()
                break
            //寝屋川
            case 6:
                mTyphoonSelectDialog2 = TyphoonSelectDialog2(index: 5, parentView: parent)
                mTyphoonSelectDialog2.showInfo()
                break
            //第二寝屋川
            case 7:
                mTyphoonSelectDialog2 = TyphoonSelectDialog2(index: 6, parentView: parent)
                mTyphoonSelectDialog2.showInfo()
                break
            //平野川
            case 8:
                mTyphoonSelectDialog2 = TyphoonSelectDialog2(index: 7, parentView: parent)
                mTyphoonSelectDialog2.showInfo()
                break
            //平野川分水路
            case 9:
                mTyphoonSelectDialog2 = TyphoonSelectDialog2(index: 8, parentView: parent)
                mTyphoonSelectDialog2.showInfo()
                break
            //古川
            case 10:
                mTyphoonSelectDialog2 = TyphoonSelectDialog2(index: 9, parentView: parent)
                mTyphoonSelectDialog2.showInfo()
                break
            //東除川
            case 11:
                mTyphoonSelectDialog2 = TyphoonSelectDialog2(index: 10, parentView: parent)
                mTyphoonSelectDialog2.showInfo()
                break
            //石川（玉手橋） 2021.05 追加 index:15
            case 12:
                mTyphoonSelectDialog2 = TyphoonSelectDialog2(index: 15, parentView: parent)
                mTyphoonSelectDialog2.showInfo()
                break
            //西除川 2020.06　追加 index:14(既存分を変更しないため)
            case 13:
                mTyphoonSelectDialog2 = TyphoonSelectDialog2(index: 14, parentView: parent)
                mTyphoonSelectDialog2.showInfo()
                break
            //高潮区域
            case 14:
                mTyphoonSelectDialog2 = TyphoonSelectDialog2(index: 11, parentView: parent)
                mTyphoonSelectDialog2.showInfo()
                break
            default:
                break
            }
            break
        default:
            break
        }
        //自らのダイアログを消去しておく
        win1.isHidden = true      //win1隠す
        text1.text = ""         //使い回しするのでテキスト内容クリア
        items = ["","","",""]
    }
}
