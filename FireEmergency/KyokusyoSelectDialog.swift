//
//  KyokusyoSelectDialog.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2021/02/16.
//  Copyright © 2021 tadakazu nakamichi. All rights reserved.
//

import UIKit

class KyokusyoSelectDialog: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    //ボタン押したら出るUIWindow
    fileprivate var parent: PersonalViewController1!
    fileprivate var win1: UIWindow!
    fileprivate var text1: UITextView!
    fileprivate var collection: UICollectionView!
    fileprivate var items:[String] = []
    fileprivate var address:[String] = []
    fileprivate var mailAddress: String! //メール送信先アドレス格納用
    fileprivate var subject: String! //参集署ごとのメール件名「＠参集署」格納用
    fileprivate var btnClose: UIButton!
    fileprivate var mSansyusyoSelectDialog: SansyusyoSelectDialog!
    
    //コンストラクタ
    init(parentView: PersonalViewController1){
        parent = parentView
        win1 = UIWindow()
        text1 = UITextView()
        let layout = UICollectionViewFlowLayout() //これがないとエラーになる
        layout.itemSize = CGSize(width: 100,height: 50) // Cellの大きさ
        layout.sectionInset = UIEdgeInsets(top: 8, left: 32, bottom: 8, right: 32) //Cellのマージン
        layout.minimumInteritemSpacing = 40 //セル同士の間隔
        layout.headerReferenceSize = CGSize(width: 1,height: 1) //セクション毎のヘッダーサイズ
        collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        btnClose = UIButton()
        
        //itemsに参集署を設定
        items = ["消防局","消防署"]

        text1.text = "■参集先"
    }
    
    //デコンストラクタ
    deinit{
        parent = nil
        win1 = nil
        text1 = nil
        collection = nil
        items = ["","","",""]
        btnClose = nil
    }
        
    //表示
    func showInfo (){
        //元の画面を暗く
        parent.view.alpha = 0.3
        //初期設定
        //Win1
        win1.backgroundColor = UIColor.white
        win1.frame = CGRect(x: 80, y: parent.view.frame.height/2, width: parent.view.frame.width-40, height: 240)
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
        text1.font = UIFont.systemFont(ofSize: CGFloat(18))
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
        btnClose.layer.position = CGPoint(x: self.win1.frame.width/2, y: self.win1.frame.height-20)
        btnClose.addTarget(self, action: #selector(self.onClickClose(_:)), for: .touchUpInside)
        self.win1.addSubview(btnClose)
        
    }
    
    //閉じる
    @objc func onClickClose(_ sender: UIButton){
        win1.isHidden = true      //win1隠す
        text1.text = ""         //使い回しするのでテキスト内容クリア
        parent.view.alpha = 1.0 //元の画面明るく
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
        //確認用
        print("セルを選択 #\(indexPath.row)!")

        //自らを消去
        win1.isHidden = true      //win1隠す
        text1.text = ""         //使い回しするのでテキスト内容クリア
        parent.view.alpha = 1.0 //元の画面明るく

        //消防局か消防署かどちらの選択がされたのかを第１引数にして次の選択ダイアログへ遷移
        mSansyusyoSelectDialog = SansyusyoSelectDialog(index: indexPath.row, parentView: parent)
        mSansyusyoSelectDialog.showInfo()
    }
}


