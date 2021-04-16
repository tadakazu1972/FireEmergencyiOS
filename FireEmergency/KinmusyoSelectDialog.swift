//
//  KinmusyoSelectDialog.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2021/03/07.
//  Copyright © 2021 tadakazu nakamichi. All rights reserved.
//

import UIKit

class KinmusyoSelectDialog: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    //ボタン押したら出るUIWindow
    fileprivate var parent: PersonalViewController1!
    public var win1: UIWindow!
    fileprivate var text1: UITextView!
    fileprivate var text2: UITextView!
    fileprivate var text3: UITextView!
    fileprivate var text4: UITextView!
    fileprivate var collection: UICollectionView!
    fileprivate var items:[String] = []
    fileprivate var syoMailAddress: [String: String] = [:]
    fileprivate var sansyusyo:[String] = []
    fileprivate var address:[String] = []
    fileprivate var mailAddress: String! //メール送信先アドレス格納用
    fileprivate var subject: String! //参集署ごとのメール件名「＠参集署」格納用
    /*
    fileprivate var btnKinmu: UIButton!
    fileprivate var btnShitei: UIButton!
    fileprivate var btnSonota: UIButton!
    */
    fileprivate var btnClose: UIButton!
    fileprivate var btnMail: UIButton!
    //上記以外参集署選択ダイアログ
    fileprivate var mSansyusyoSelectDialog: SansyusyoSelectDialog!    
    fileprivate var mKyokusyoSelectDialog: KyokusyoSelectDialog!
    //非常参集　職員情報　保存用
    let userDefaults = UserDefaults.standard
    var mainStation: String?
    var tsunamiStation: String?
    //警告用
    fileprivate var mAlertDialog: AlertDialog!
    fileprivate var mAlertDialogMail: AlertDialogMail!
    
    //コンストラクタ
    init(parentView: PersonalViewController1){
        parent = parentView
        win1 = UIWindow()
        text1 = UITextView()
        text2 = UITextView()
        text3 = UITextView()
        text4 = UITextView()
        
        let layout = UICollectionViewFlowLayout() //これがないとエラーになる
        layout.itemSize = CGSize(width: 100,height: 50) // Cellの大きさ
        layout.sectionInset = UIEdgeInsets(top: 40, left: 32, bottom: 40, right: 20) //Cellのマージン
        layout.minimumInteritemSpacing = 40 //セル同士の間隔
        layout.headerReferenceSize = CGSize(width: 1,height: 1) //セクション毎のヘッダーサイズ
        collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        /*
        btnKinmu = UIButton()
        btnShitei = UIButton()
        btnSonota = UIButton()
        */
        btnClose = UIButton()
        btnMail  = UIButton()
                
        text1.text = "■参集先　メール送信\n　必ず参集先に到着してから送信"
        text2.text = "勤務消防署"
        text3.text = "指定参集署"
        text4.text = "上記以外"
        
        //基礎データから勤務消防署、指定参集署を呼び出し
        mainStation = userDefaults.string(forKey: "mainStation")
        tsunamiStation = userDefaults.string(forKey: "tsunamiStation")
        //collectionViewのアイテムとして配列に格納
        items = [mainStation!, tsunamiStation!, "その他"]
        
        //メール送信に使う基礎設定 辞書型
        syoMailAddress = ["北":"pa0005","都島":"pa0006","福島":"pa0007","此花":"pa0008","中央":"pa0009","西":"pa0036","港":"pa0010","大正":"pa0011","天王寺":"pa0013","浪速":"pa0012","西淀川":"pa0014","淀川":"pa0015","東淀川":"pa0016","東成":"pa0017","生野":"pa0018","旭":"pa0019","城東":"pa0020","鶴見":"pa0021","住之江":"pa0023","阿倍野":"pa0022","住吉":"pa0024","東住吉":"pa0025","平野":"pa0026","西成":"pa0027","水上":"pa0028"]
    }
    
    //デコンストラクタ
    deinit{
        parent = nil
        win1 = nil
        text1 = nil
        text2 = nil
        text3 = nil
        text4 = nil
        collection = nil
        /*
        btnKinmu = nil
        btnShitei = nil
        btnSonota = nil
        */
        items = ["","","",""]
        btnClose = nil
        btnMail = nil
    }
    
    private func createImageFromUIColor(color: UIColor) -> UIImage {
      // 1x1のbitmapを作成
      let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
      UIGraphicsBeginImageContext(rect.size)
      let context = UIGraphicsGetCurrentContext()
      // bitmapを塗りつぶし
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
      // UIImageに変換
      let image = UIGraphicsGetImageFromCurrentImageContext()!
      UIGraphicsEndImageContext()
      return image
    }
    
    //表示
    func showInfo (){
        //元の画面を暗く、画面タップ無効化
        mViewController2.view.alpha = 0.1 //親２画面も明るく
        parent.view.alpha = 0.1
        parent.view.isUserInteractionEnabled = false
        //初期設定
        //Win1
        win1.backgroundColor = UIColor.white
        win1.frame = CGRect(x: 80, y: parent.view.frame.height/2, width: parent.view.frame.width-40, height: 300)
        win1.layer.position = CGPoint(x: parent.view.frame.width/2, y: parent.view.frame.height/2)
        win1.alpha = 1.0
        win1.layer.cornerRadius = 10
        //KeyWindowにする
        win1.makeKey()
        //表示
        self.win1.makeKeyAndVisible()
        
        //UICollectionView生成
        collection.frame = CGRect(x: 0 ,y: 0, width: win1.frame.width/2, height: 280)
        collection.layer.position = CGPoint(x: win1.frame.width/2+65, y: win1.frame.height/2+10)
        collection.backgroundColor = UIColor.white
        collection.delegate = self
        collection.dataSource = self
        collection.register(CustomUICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        self.win1.addSubview(collection)
        
        //TextView生成 UICollectionの後に描画しないとかぶって見えない
        text1.frame = CGRect(x: 10, y: 0, width: self.win1.frame.width-20, height: 60)
        text1.backgroundColor = UIColor.clear
        text1.font = UIFont.systemFont(ofSize: CGFloat(16))
        text1.textColor = UIColor.black
        text1.textAlignment = NSTextAlignment.left
        text1.isEditable = false
        self.win1.addSubview(text1)
        
        //勤務消防署、指定参集署、上記以外　TextView生成
        text2.frame = CGRect(x: 0, y: 0, width: self.win1.frame.width/2, height: 60)
        text2.layer.position = CGPoint(x: self.win1.frame.width/2-50, y: win1.frame.height/2-60)
        text2.backgroundColor = UIColor.clear
        text2.font = UIFont.systemFont(ofSize: CGFloat(18))
        text2.textColor = UIColor.black
        text2.textAlignment = NSTextAlignment.left
        text2.isEditable = false
        self.win1.addSubview(text2)
        
        text3.frame = CGRect(x: 0, y: 0, width: self.win1.frame.width/2, height: 60)
        text3.layer.position = CGPoint(x: self.win1.frame.width/2-50, y: win1.frame.height/2)
        text3.backgroundColor = UIColor.clear
        text3.font = UIFont.systemFont(ofSize: CGFloat(18))
        text3.textColor = UIColor.black
        text3.textAlignment = NSTextAlignment.left
        text3.isEditable = false
        self.win1.addSubview(text3)
        
        text4.frame = CGRect(x: 0, y: 0, width: self.win1.frame.width/2, height: 60)
        text4.layer.position = CGPoint(x: self.win1.frame.width/2-50, y: win1.frame.height/2+60)
        text4.backgroundColor = UIColor.clear
        text4.font = UIFont.systemFont(ofSize: CGFloat(18))
        text4.textColor = UIColor.black
        text4.textAlignment = NSTextAlignment.left
        text4.isEditable = false
        self.win1.addSubview(text4)
        
        /*
        //勤務署ボタン生成
        btnKinmu.frame = CGRect(x: 0, y:0, width: 120, height: 48)
        btnKinmu.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKinmu.layer.masksToBounds = true
        btnKinmu.layer.position = CGPoint(x: self.win1.frame.width/2+75, y: win1.frame.height/2-60)
        btnKinmu.setTitle(userDefaults.string(forKey: "mainStation"), for: UIControl.State())
        btnKinmu.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btnKinmu.setTitleColor(UIColor.white, for: UIControl.State.highlighted)
        btnKinmu.setBackgroundImage(self.createImageFromUIColor(color: UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)), for: .normal)
        btnKinmu.setBackgroundImage(self.createImageFromUIColor(color: UIColor.red), for: .highlighted)
        btnKinmu.translatesAutoresizingMaskIntoConstraints = false
        self.win1.addSubview(btnKinmu)
        
        //指定参集署ボタン生成
        btnShitei.frame = CGRect(x: 0, y:0, width: 120, height: 48)
        btnShitei.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnShitei.layer.masksToBounds = true
        btnShitei.layer.position = CGPoint(x: self.win1.frame.width/2+75, y: win1.frame.height/2)
        btnShitei.setTitle(userDefaults.string(forKey: "tsunamiStation"), for: UIControl.State())
        btnShitei.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btnShitei.setTitleColor(UIColor.white, for: UIControl.State.highlighted)
        btnShitei.setBackgroundImage(self.createImageFromUIColor(color: UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)), for: .normal)
        btnShitei.setBackgroundImage(self.createImageFromUIColor(color: UIColor.red), for: .highlighted)
        btnShitei.translatesAutoresizingMaskIntoConstraints = false
        self.win1.addSubview(btnShitei)
        
        //上記以外ボタン生成
        btnSonota.frame = CGRect(x: 0, y:0, width: 120, height: 48)
        btnSonota.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnSonota.layer.masksToBounds = true
        btnSonota.layer.position = CGPoint(x: self.win1.frame.width/2+75, y: win1.frame.height/2+60)
        btnSonota.setTitle("その他", for: UIControl.State())
        btnSonota.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btnSonota.setTitleColor(UIColor.white, for: UIControl.State.highlighted)
        btnSonota.setBackgroundImage(self.createImageFromUIColor(color: UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)), for: .normal)
        btnSonota.setBackgroundImage(self.createImageFromUIColor(color: UIColor.red), for: .highlighted)
        btnSonota.translatesAutoresizingMaskIntoConstraints = false
        btnSonota.addTarget(self, action: #selector(self.onClickSonota(_:)), for: .touchUpInside)
        self.win1.addSubview(btnSonota)
        */
        
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
    
    //閉じるボタン押された
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
    
    //collectionView処理
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CustomUICollectionViewCell = collection.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! CustomUICollectionViewCell
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //タップしたボタンによる動作
        switch indexPath.row {
        //勤務消防署
        case 0:
            //消防局なら本局の課を選択させるため、index:0でSansyusyoSelectDialogへ遷移
            if mainStation == "消防局" {
                //自分を消去
                dismissDialog()
                //基礎データ画面を暗く
                mViewController2.view.alpha = 0.1
                mSansyusyoSelectDialog = SansyusyoSelectDialog(index: 0, parentView: parent)
                mSansyusyoSelectDialog.showInfo()
            } else {
                //消防署の該当署のメールアドレスを抽出
                pickupSyoMailAddress(syo: mainStation)
            }
            break
        //指定参集署
        case 1:
            //消防局なら本局の課を選択させるため、index:0でSansyusyoSelectDialogへ遷移
            if tsunamiStation == "消防局" {
                //自分を消去
                dismissDialog()
                //基礎データ画面を暗く
                mViewController2.view.alpha = 0.1
                mSansyusyoSelectDialog = SansyusyoSelectDialog(index: 0, parentView: parent)
                mSansyusyoSelectDialog.showInfo()
            } else {
                //消防署の該当署のメールアドレスを抽出
                pickupSyoMailAddress(syo: tsunamiStation)
            }
            break
        //その他　消防局　消防署　選択ダイアログへ遷移
        case 2:
            //自分を消去
            dismissDialog()
            //基礎データ画面を暗く
            mViewController2.view.alpha = 0.1
            //ダイアログ表示
            mKyokusyoSelectDialog = KyokusyoSelectDialog(parentView: parent)
            mKyokusyoSelectDialog.showInfo()
            break
        default:
            break
        }
    }
    
    func pickupSyoMailAddress(syo: String?){
        //タップした参集署のメールアドレスを格納
        let syo: String = syo!
        mailAddress = syoMailAddress[syo]! + "@city.osaka.lg.jp"
        subject = "@" + syo
        //確認用
        print(mailAddress!)
        print(subject!)
    }
    
    //上記以外参集先到着ボタンクリック
    @objc func onClickSonota(_ sender: UIButton){
        //自分を消去
        dismissDialog()
        
        //基礎データ画面を暗く
        mViewController2.view.alpha = 0.1
        //ダイアログ表示
        mKyokusyoSelectDialog = KyokusyoSelectDialog(parentView: parent)
        mKyokusyoSelectDialog.showInfo()
    }
    
    //メール送信
    @objc func onClickMail(_ sender: UIButton){
        //参集先をタップしていない場合は警告出してメール送信に進ませない
        if mailAddress == nil {
            mAlertDialogMail = AlertDialogMail(parentView: self)
            mAlertDialogMail.showInfo()
        } else {
            //メール送信へ進む
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
