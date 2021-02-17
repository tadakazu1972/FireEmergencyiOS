//
//  EarthSelectDialog.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2016/10/02.
//  Copyright © 2016年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class EarthSelectDialog: NSObject, UITableViewDelegate, UITableViewDataSource {
    //ボタン押したら出るUIWindow
    fileprivate var parent: EarthquakeViewController!
    fileprivate var win1: UIWindow!
    fileprivate var text1: UITextView!
    fileprivate var table: UITableView!
    fileprivate var items:[String] = ["","","",""]
    fileprivate var btnClose: UIButton!
    //自分が何番目のダイアログが保存用
    fileprivate var mIndex: Int!
    
    //コンストラクタ
    init(index: Int, parentView: EarthquakeViewController){
        parent = parentView
        win1 = UIWindow()
        text1 = UITextView()
        table = UITableView()
        btnClose = UIButton()
        mIndex = index
        //itemsの内容を場合分け
        switch index {
        case 1:
            items = ["■大津波警報","■津波警報","■警報なし"]
            break
        case 2:
            items = ["■大津波警報","■津波警報","■警報なし"]
            break
        case 3:
            items = ["■大津波警報","■津波警報","■警報なし"]
            break
        case 4:
            items = ["■大津波警報","■津波警報","■津波注意報","■警報なし"]
            break
        case 5:
            items = ["■警戒宣言が発令されたとき（東海地震予知情報）","■東海地震注意報が発表されたとき","■東海地震に関連する調査情報（臨時）が発表されたとき"]
            break
        case 6:
            items = ["■調査中","■巨大地震注意","■巨大地震警戒"]
            break
        default:
            items = ["■大津波警報","■津波警報","■警報なし"]
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
        //元の画面を暗く、タップ無効化
        parent.view.alpha = 0.3
        parent.view.isUserInteractionEnabled = false
        mViewController.view.alpha = 0.3
        mViewController.view.isUserInteractionEnabled = false
        //初期設定
        //Win1
        win1.backgroundColor = UIColor.white
        win1.frame = CGRect(x: 80,y: 200,width: parent.view.frame.width-40,height: parent.view.frame.height*0.8)
        win1.layer.position = CGPoint(x: parent.view.frame.width/2, y: parent.view.frame.height/2+72) //+72子ViewController調整
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
        text1.text="発令されている警報は？"
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
        parent.view.isUserInteractionEnabled = true //タップ有効化
        mViewController.view.alpha = 1.0 //明るく
        mViewController.view.isUserInteractionEnabled = true
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
                parent.mEarthResultDialog.showResult(11)
                break
            case 1:
                parent.mEarthResultDialog.showResult(12)
                break
            case 2:
                parent.mEarthResultDialog.showResult(13)
                break
            default:
                break
            }
            break
        case 2:
            switch indexPath.row {
            case 0:
                parent.mEarthResultDialog.showResult(21)
                break
            case 1:
                parent.mEarthResultDialog.showResult(22)
                break
            case 2:
                parent.mEarthResultDialog.showResult(23)
                break
            default:
                break
            }
            break
        case 3:
            switch indexPath.row {
            case 0:
                parent.mEarthResultDialog.showResult(31)
                break
            case 1:
                parent.mEarthResultDialog.showResult(32)
                break
            case 2:
                parent.mEarthResultDialog.showResult(33)
                break
            default:
                break
            }
            break
        case 4:
            switch indexPath.row {
            case 0:
                parent.mEarthResultDialog.showResult(41)
                break
            case 1:
                parent.mEarthResultDialog.showResult(42)
                break
            case 2:
                parent.mEarthResultDialog.showResult(43)
                break
            case 3:
                parent.mEarthResultDialog.showResult(44)
                break
            default:
                break
            }
            break
        case 5:
            switch indexPath.row {
            case 0:
                parent.mEarthResultDialog.showResult(51)
                break
            case 1:
                parent.mEarthResultDialog.showResult(52)
                break
            case 2:
                parent.mEarthResultDialog.showResult(53)
                break
            default:
                break
            }
            break
        case 6:
            switch indexPath.row {
            case 0:
                parent.mEarthResultDialog.showResult(61)
                break
            case 1:
                parent.mEarthResultDialog.showResult(62)
                break
            case 2:
                parent.mEarthResultDialog.showResult(63)
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

