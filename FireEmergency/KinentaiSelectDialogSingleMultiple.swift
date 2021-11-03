//
//  KinentaiSelectDialogSingleMultiple.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2021/10/10.
//  Copyright © 2021 tadakazu nakamichi. All rights reserved.
//

import UIKit

class KinentaiSelectDialogSingleMultiple: NSObject, UITableViewDelegate, UITableViewDataSource {
    //ボタン押したら出るUIWindow
    fileprivate var parent: KinentaiViewController!
    internal var win1: UIWindow!
    fileprivate var text1: UITextView!
    fileprivate var table: UITableView!
    fileprivate var items:[String] = ["",""]
    fileprivate var btnClose: UIButton!
    fileprivate var mKinentaiSelectDialog: KinentaiSelectDialog!  //南海トラフの場合の自己呼び出し用
    fileprivate var mKinentaiSelectDialog2: KinentaiSelectDialog2!
    fileprivate var mKinentaiSelectDialog2Multi: KinentaiSelectDialog2Multi! // 2021-10追加
    fileprivate var mKinentaiSelectDialog3: KinentaiSelectDialog3! // 2019-02-02 追加
    fileprivate var mKinentaiNankaitraf1: KinentaiNankaitraf1!
    fileprivate var mKinentaiNankaitraf2: KinentaiNankaitraf2!
    fileprivate var mKinentaiToukai1: KinentaiToukai1! // 2018-09-26 追加
    fileprivate var mKinentaiShutochokka1: KinentaiShutochokka1! // 2018-09-26 追加
    fileprivate var mKinentaiResultDialog: KinentaiResultDialog!
    //自分が何番目のダイアログが保存用
    fileprivate var mIndex: Int!
    
    //コンストラクタ
    init(index: Int, parentView: KinentaiViewController){
        parent = parentView
        win1 = UIWindow()
        text1 = UITextView()
        table = UITableView()
        btnClose = UIButton()
        mIndex = index
        //itemsの内容を場合分け
        switch index {
            //地震（震央「陸」）ボタン
            case 1:
                text1.text = "最大震度６弱(政令市等は震度５強)以上の地震が発生した都道府県は？"
                items = ["■震度６弱(政令市等は震度５強)以上","■複数の都道府県において震度６弱(政令市等は震度５強)以上"]
                break
            //地震（震央「海域」）ボタン
            case 2:
                text1.text = "最大震度６弱(政令市等は震度５強)以上の地震が発生した都道府県は？"
                items = ["■震度６弱(政令市等は震度５強)以上","■複数の都道府県において震度６弱(政令市等は震度５強)以上"]
                break
            //大津波警報
            case 3:
                text1.text = "大津波警報が発表された都道府県は？"
                items = ["■単一の都道府県で発表","■複数の都道府県で発表"]
                break
            default:
                text1.text = "最大震度６弱(政令市等は震度５強)以上の地震が発生した都道府県は？"
                items = ["■震度６弱(政令市等は震度５強)以上","■複数の都道府県において震度６弱(政令市等は震度５強)以上"]
                break
        }
    }
    
    //デコンストラクタ
    deinit{
        parent = nil
        win1 = nil
        text1 = nil
        table = nil
        items = ["",""]
        btnClose = nil
        mIndex = nil
    }
    
    //セットIndex
    func setIndex(_ index: Int){
        mIndex = index
    }
    
    //表示
    func showInfo (){
        //元の画面を暗く
        parent.view.alpha = 0.3
        mViewController.view.alpha = 0.3
        //初期設定
        //Win1
        win1.backgroundColor = UIColor.white
        win1.frame = CGRect(x: 80,y: 200,width: parent.view.frame.width-40,height: parent.view.frame.height)
        win1.layer.position = CGPoint(x: parent.view.frame.width/2, y: parent.view.frame.height/2+72) //+72調整
        win1.alpha = 1.0
        win1.layer.cornerRadius = 10
        //KeyWindowにする
        win1.makeKey()
        //表示
        self.win1.makeKeyAndVisible()
        
        //TextView生成
        text1.frame = CGRect(x: 10, y: 0, width: self.win1.frame.width-20, height: 60)
        text1.backgroundColor = UIColor.clear
        text1.font = UIFont.systemFont(ofSize: CGFloat(18))
        text1.textColor = UIColor.black
        text1.textAlignment = NSTextAlignment.left
        text1.isEditable = false
        self.win1.addSubview(text1)
        
        //TableView生成
        table.frame = CGRect(x: 10,y: 80, width: self.win1.frame.width-20, height: self.win1.frame.height-120)
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
        mViewController.view.alpha = 1.0
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
        //地震(震央「陸」)
        case 1:
            switch indexPath.row {
                //単一の都道府県
                case 0:
                    mKinentaiSelectDialog = KinentaiSelectDialog(index: 1, parentView: parent)
                    mKinentaiSelectDialog.showInfo()
                    break
                //複数の都道府県
                case 1:
                    mKinentaiSelectDialog2Multi = KinentaiSelectDialog2Multi(index: 1, parentView: parent)
                    mKinentaiSelectDialog2Multi.showInfo()
                    break
                default:
                    break
            }
            break
        //地震(震央「海域」)
        case 2:
            switch indexPath.row {
                //単一の都道府県
                case 0:
                    mKinentaiSelectDialog = KinentaiSelectDialog(index: 2, parentView: parent)
                    mKinentaiSelectDialog.showInfo()
                    break
                //複数の都道府県
                case 1:
                    mKinentaiSelectDialog2Multi = KinentaiSelectDialog2Multi(index: 2, parentView: parent)
                    mKinentaiSelectDialog2Multi.showInfo()
                    break
                default:
                    break
            }
            break
        //大津波警報
        case 3:
            switch indexPath.row {
                //単一の都道府県
                case 0:
                    mKinentaiSelectDialog2 = KinentaiSelectDialog2(index: 41, parentView: parent)
                    mKinentaiSelectDialog2.showInfo()
                    break
                //複数の都道府県
                case 1:
                    mKinentaiSelectDialog2Multi = KinentaiSelectDialog2Multi(index: 3, parentView: parent)
                    mKinentaiSelectDialog2Multi.showInfo()
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
        //text1.text = ""         //使い回しするのでテキスト内容クリア
        //items = ["","","",""]
    }
}
