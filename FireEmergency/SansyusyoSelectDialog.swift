//
//  SansyusyoSelectDialog.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2021/02/14.
//  Copyright © 2021 tadakazu nakamichi. All rights reserved.
//

import UIKit

class SansyusyoSelectDialog: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    //ボタン押したら出るUIWindow
    fileprivate var parent: PersonalViewController1!
    public var win1: UIWindow!
    fileprivate var text1: UITextView!
    fileprivate var collection: UICollectionView!
    fileprivate var items:[String] = ["","","",""]
    fileprivate var address:[String] = []
    fileprivate var mailAddress: String! //メール送信先アドレス格納用
    fileprivate var subject: String! //参集署ごとのメール件名「＠参集署」格納用
    fileprivate var btnClose: UIButton!
    fileprivate var btnMail: UIButton!
    //消防局か消防署か　どちらが押されたのか判定用（KyokusyoSelectDialogから引き継ぐ 0:消防局 1:消防署）
    fileprivate var mIndex: Int!
    //基礎データ登録で保存された勤務消防署と津波警報時参集指定署を呼び出す用
    let userDefaults = UserDefaults.standard
    fileprivate var mAlertDialog: AlertDialog!
    //iPhoneSE(2016)=iPhone5画面判定用
    let iPhone5 : CGRect = CGRect(x: 0.0, y: 0.0, width: 320.0, height: 568.0)
    
    //コンストラクタ
    init(index: Int, parentView: PersonalViewController1){
        parent = parentView
        win1 = UIWindow()
        text1 = UITextView()
        let layout = UICollectionViewFlowLayout() //これがないとエラーになる
        //iPhoneSEのときボタンの幅を小さくしないと１列表示になるのを防ぐ
        if Int(UIScreen.main.bounds.size.height)==Int(iPhone5.height){
            layout.itemSize = CGSize(width: 80,height: 40) // Cellの大きさ
        } else {
            layout.itemSize = CGSize(width: 100,height: 40) // Cellの大きさ
        }
        layout.sectionInset = UIEdgeInsets(top: 8, left: 32, bottom: 8, right: 32) //Cellのマージン
        layout.minimumInteritemSpacing = 30 //セル同士の間隔
        layout.headerReferenceSize = CGSize(width: 1,height: 1) //セクション毎のヘッダーサイズ
        collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        btnClose = UIButton()
        btnMail  = UIButton()
        mIndex = index
        
        //mIndexの値を判定してitemsに参集署を設定
        //消防局の場合
        if mIndex == 0 {
            items = ["総務","施設","企画","人事","訓練センター","予防","規制","警防","司令","救急"]
            //総務:pa0002　企画:pa0110　警防:pa0035　予防:pa0003　救急:pa0034　施設:pa0031
            //人事：pa0030　訓練センター:pa0029　規制:pa0032　司令:pa0108
        
            address =
                ["pa0002","pa0031","pa0110","pa0030","pa0029","pa0003","pa0032","pa0035","pa0108","pa0034"]
        } else {
            //消防署の場合
            items = ["北","都島","福島","此花","中央","西","港","大正","天王寺","浪速","西淀川","淀川","東淀川","東成","生野","旭","城東","鶴見","住之江","阿倍野","住吉","東住吉","平野","西成","水上"]
            
            address =
                ["pa0005","pa0006","pa0007","pa0008","pa0009","pa0036","pa0010","pa0011","pa0013","pa0012","pa0014","pa0015","pa0016","pa0017","pa0018","pa0019","pa0020","pa0021","pa0023","pa0022","pa0024","pa0025","pa0026","pa0027","pa0028"]
            
        }

        text1.text = "■参集先　メール送信\n　必ず参集先に到着してから送信"
    }
    
    //デコンストラクタ
    deinit{
        parent = nil
        win1 = nil
        text1 = nil
        collection = nil
        items = ["","","",""]
        btnClose = nil
        mIndex = nil
    }
        
    //表示
    func showInfo (){
        //元の画面を暗く、タップを無効化
        mViewController2.view.alpha = 0.1 //親２画面も明るく
        parent.view.alpha = 0.1
        parent.view.isUserInteractionEnabled = false
        //初期設定
        //Win1
        win1.backgroundColor = UIColor.white
        win1.frame = CGRect(x: 80,y: 200,width: parent.view.frame.width-40,height: parent.view.frame.height-100)
        win1.layer.position = CGPoint(x: parent.view.frame.width/2, y: parent.view.frame.height/2)
        win1.alpha = 1.0
        win1.layer.cornerRadius = 10
        //KeyWindowにする
        win1.makeKey()
        //表示
        self.win1.makeKeyAndVisible()
        
        //TextView生成
        text1.frame = CGRect(x: 10, y: 0, width: self.win1.frame.width-20, height: 60)
        text1.backgroundColor = UIColor.clear
        text1.font = UIFont.systemFont(ofSize: CGFloat(16))
        text1.textColor = UIColor.black
        text1.textAlignment = NSTextAlignment.left
        text1.isEditable = false
        self.win1.addSubview(text1)
        
        //UICollectionView生成
        collection.frame = CGRect(x: 10,y: 60, width: self.win1.frame.width-20, height: self.win1.frame.height-100)
        collection.backgroundColor = UIColor.white
        collection.delegate = self
        collection.dataSource = self
        collection.register(CustomUICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        self.win1.addSubview(collection)
        
        //閉じるボタン生成
        btnClose.frame = CGRect(x: 0,y: 0,width: 125,height: 30)
        btnClose.backgroundColor = UIColor.blue
        btnClose.setTitle("閉じる", for: UIControl.State())
        btnClose.setTitleColor(UIColor.white, for: UIControl.State())
        btnClose.layer.masksToBounds = true
        btnClose.layer.cornerRadius = 10.0
        btnClose.layer.position = CGPoint(x: self.win1.frame.width/2-75, y: self.win1.frame.height-20)
        btnClose.addTarget(self, action: #selector(self.onClickClose(_:)), for: .touchUpInside)
        self.win1.addSubview(btnClose)
        
        //メール送信ボタン生成
        btnMail.frame = CGRect(x: 0,y: 0,width: 125,height: 30)
        btnMail.backgroundColor = UIColor.red
        btnMail.setTitle("メール送信", for: UIControl.State())
        btnMail.setTitleColor(UIColor.white, for: UIControl.State())
        btnMail.layer.masksToBounds = true
        btnMail.layer.cornerRadius = 10.0
        btnMail.layer.position = CGPoint(x: self.win1.frame.width/2+75, y: self.win1.frame.height-20)
        btnMail.addTarget(self, action: #selector(self.onClickMail(_:)), for: .touchUpInside)
        self.win1.addSubview(btnMail)
    }
    
    //閉じる
    @objc func onClickClose(_ sender: UIButton){
        dismissDialog()
     }
    
    //消去処理
    func dismissDialog(){
        win1.isHidden = true      //win1隠す
        text1.text = ""         //使い回しするのでテキスト内容クリア
        parent.view.alpha = 1.0 //元の画面明るく
        mViewController2.view.alpha = 1.0 //親２画面も明るく
        parent.view.isUserInteractionEnabled = true //タップ有効化
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CustomUICollectionViewCell = collection.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! CustomUICollectionViewCell
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //タップした参集署のメールアドレスを格納
        mailAddress = address[indexPath.row] + "@city.osaka.lg.jp"
        subject = "@" + items[indexPath.row]
        //確認用
        print("セルを選択 #\(indexPath.row)!")
        print(mailAddress!)
        print(subject!)
        //基礎データで登録されている「勤務消防署」「津波警報時(震度5弱以上)の参集指定署」のどちらにも該当しない場合、アラート表示
        //まずは基礎データの登録を呼び出し
        let mainStation = userDefaults.string(forKey: "mainStation")
        let tsunamiStation = userDefaults.string(forKey: "tsunamiStation")
        //判定
        //参集先が消防局の場合
        if mIndex == 0 {
            if mainStation != "消防局" && tsunamiStation != "消防局" {
                if mainStation != "訓練センター" && tsunamiStation != "訓練センター" {
                    print("どっちも消防局ではないが参集先は消防局で大丈夫か？")
                    mAlertDialog = AlertDialog(parentView: self)
                    mAlertDialog.showInfo()
                }
            }
        }
        //参集先が消防署の場合
        if mIndex == 1 {
            if items[indexPath.row] != mainStation && items[indexPath.row] != tsunamiStation {
                print("どっちもちゃうけど大丈夫か？")
                //アラート表示
                mAlertDialog = AlertDialog(parentView: self)
                mAlertDialog.showInfo()
            }
        }
    }
    
    //メール送信
    @objc func onClickMail(_ sender: UIButton){
        //ダイアログ消去
        dismissDialog()
        
        //選択された参集署のメールアドレスと件名
        var addressArray: [String] = []
        // addressArray = ["pa0009@city.osaka.lg.jp", "@中央"] の形で格納される。
        // 後にMailViewControllerで送信先アドレス：addressAttary[0],件名：addressArray[1]で呼び出して使用する
        addressArray.append(mailAddress)
        addressArray.append(subject)
        //print(addressArray) //デバッグ用
        
        //次の関数でMailViewControllerを生成して画面遷移する
        sendMail(addressArray)
    }
    
    //参集署宛メール送信 MailViewController2遷移
    func sendMail(_ addressArray: [String]){
        //MailViewController2のインスタンス生成
        let data:MailViewController2 = MailViewController2(addressArray: addressArray)
        
        //navigationControllerのrootViewControllerにKokuminhogoViewControllerをセット
        let nav = UINavigationController(rootViewController: data)
        nav.setNavigationBarHidden(true, animated: false) //これをいれないとNavigationBarが表示されてうざい
        
        //画面遷移
        parent.present(nav, animated: true, completion: nil)
    }
}

