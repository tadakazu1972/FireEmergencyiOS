//
//  KinentaiSelectDialog2Multi.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2021/10/10.
//  Copyright © 2021 tadakazu nakamichi. All rights reserved.
//

import UIKit

class KinentaiSelectDialog2Multi: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    //ボタン押したら出るUIWindow
    fileprivate var parent: KinentaiViewController!
    fileprivate var win1: UIWindow!
    fileprivate var text1: UITextView!
    fileprivate var collection: UICollectionView!
    fileprivate var items:[String] = ["","","",""]
    fileprivate var btnFinishSelect: UIButton!
    fileprivate var btnClose: UIButton!
    fileprivate var mKinentaiResultDialogMulti: KinentaiResultDialogMulti!
    //陸、海域、大津波警報どれから遷移してきたのか判別用　それによって格納する読み込み先のcsvファイル名を変更する
    fileprivate var mIndex: Int!
    //複数都道府県選択保存配列
    fileprivate var mSelectedPrefectureIndexList:[Int] = [];
    fileprivate var mSelectedPrefectureScaleList:[String] = [];
    fileprivate var mSelectedPrefectureCSVList:[String] = [];
    
    //コンストラクタ
    init(index: Int, parentView: KinentaiViewController){
        parent = parentView
        win1 = UIWindow()
        text1 = UITextView()
        let layout = UICollectionViewFlowLayout() //これがないとエラーになる
        layout.itemSize = CGSize(width: 70,height: 30) // Cellの大きさ
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) //Cellのマージン
        layout.headerReferenceSize = CGSize(width: 1,height: 1) //セクション毎のヘッダーサイズ
        collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        btnFinishSelect = UIButton()
        btnClose = UIButton()
        mIndex = index
        
        //itemsに47都道府県を設定
        items = ["北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県","茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県","新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"]
        
        //タイトル
        text1.text = "■都道府県選択(複数選択可)"
    }
    
    //デコンストラクタ
    deinit{
        parent = nil
        win1 = nil
        text1 = nil
        collection = nil
        items = ["","","",""]
        btnFinishSelect = nil
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
        
        //UICollectionView生成
        collection.frame = CGRect(x: 10,y: 60, width: self.win1.frame.width-20, height: self.win1.frame.height-100)
        collection.backgroundColor = UIColor.white
        collection.delegate = self
        collection.dataSource = self
        collection.register(CustomUICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        self.win1.addSubview(collection)
        
        //選択終了ボタン生成
        btnFinishSelect.frame = CGRect(x: 0,y: 0,width: 100,height: 30)
        btnFinishSelect.backgroundColor = UIColor.blue
        btnFinishSelect.setTitle("選択終了", for: UIControl.State())
        btnFinishSelect.setTitleColor(UIColor.white, for: UIControl.State())
        btnFinishSelect.layer.masksToBounds = true
        btnFinishSelect.layer.cornerRadius = 10.0
        btnFinishSelect.layer.position = CGPoint(x: self.win1.frame.width/2+100, y: self.win1.frame.height-20)
        btnFinishSelect.addTarget(self, action: #selector(self.onClickFinishSelect(_:)), for: .touchUpInside)
        self.win1.addSubview(btnFinishSelect)
        
        //閉じるボタン生成
        btnClose.frame = CGRect(x: 0,y: 0,width: 100,height: 30)
        btnClose.backgroundColor = UIColor.orange
        btnClose.setTitle("閉じる", for: UIControl.State())
        btnClose.setTitleColor(UIColor.white, for: UIControl.State())
        btnClose.layer.masksToBounds = true
        btnClose.layer.cornerRadius = 10.0
        btnClose.layer.position = CGPoint(x: self.win1.frame.width/2-100, y: self.win1.frame.height-20)
        btnClose.addTarget(self, action: #selector(self.onClickClose(_:)), for: .touchUpInside)
        self.win1.addSubview(btnClose)
    }
    
    //選択終了→結果表示へ
    @objc func onClickFinishSelect(_ sender: UIButton){
        print("選択終了")
        //csvファイルの結果呼び出し
        //let itemNo: Int = indexPath.row + 1 //csvファイルのヘッダの分+1するのを忘れないように
        mKinentaiResultDialogMulti = KinentaiResultDialogMulti(parentView: parent)
        //複数県選択の結果の３つの配列を次の結果表示クラスに引数として渡す
        mKinentaiResultDialogMulti.showResult(mSelectedPrefectureIndexList, scaleList: mSelectedPrefectureScaleList, csvList: mSelectedPrefectureCSVList)
        //消去処理
        win1.isHidden = true      //win1隠す
        text1.text = ""         //使い回しするのでテキスト内容クリア
        //parent.view.alpha = 1.0 //元の画面明るく
        //mViewController.view.alpha = 1.0
    }
    
    //閉じる
    @objc func onClickClose(_ sender: UIButton){
        win1.isHidden = true      //win1隠す
        text1.text = ""         //使い回しするのでテキスト内容クリア
        parent.view.alpha = 1.0 //元の画面明るく
        mViewController.view.alpha = 1.0
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
        print("セルを選択 #\(indexPath.row + 1)")
        mSelectedPrefectureIndexList.append(indexPath.row + 1) //csvファイルのヘッダの分+1するのを忘れないように
        //陸、海域ならば震度選択　大津波警報なら起動しない
        if mIndex != 3 {
            selectScale(items[indexPath.row])
        }
        print("mSelectedPrefectureIndexList= \(mSelectedPrefectureIndexList)")
    }
    
    func selectScale(_ prefecture: String){
        print("selectScale()")
        //アラート生成
        //UIAlertControllerのスタイルがactionSheet
        let actionSheet = UIAlertController(title: "\(prefecture)の最大震度は？", message: "", preferredStyle: UIAlertController.Style.actionSheet)

        // 表示させたいタイトル1ボタンが押された時の処理をクロージャ実装する
        let action1 = UIAlertAction(title: "震度７", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            //実際の処理
            self.mSelectedPrefectureScaleList.append("震度７")
            //陸か海域か
            if self.mIndex == 1 {
                self.mSelectedPrefectureCSVList.append("riku7_multi")
            } else if self.mIndex == 2 {
                self.mSelectedPrefectureCSVList.append("kaiiki7_multi")
            }
            print("mSelectedPrefectureScaleList= \(self.mSelectedPrefectureScaleList)")
            print("mSelectedPrefectureCSVList= \(self.mSelectedPrefectureCSVList)")
            self.win1.isHidden = false
        })
        // 表示させたいタイトル2ボタンが押された時の処理をクロージャ実装する
        let action2 = UIAlertAction(title: "震度６強(特別区６弱)", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            //実際の処理
            if prefecture == "東京都" {
                self.mSelectedPrefectureScaleList.append("震度６強(特別区６弱)")
            } else {
                self.mSelectedPrefectureScaleList.append("震度６強")
            }
            //陸か海域か
            if self.mIndex == 1 {
                self.mSelectedPrefectureCSVList.append("riku6strong_multi")
            } else if self.mIndex == 2 {
                self.mSelectedPrefectureCSVList.append("kaiiki6strong_multi")
            }
            print("mSelectedPrefectureScaleList= \(self.mSelectedPrefectureScaleList)")
            print("mSelectedPrefectureCSVList= \(self.mSelectedPrefectureCSVList)")
            self.win1.isHidden = false
        })
        // 表示させたいタイトル2ボタンが押された時の処理をクロージャ実装する
        let action3 = UIAlertAction(title: "震度６弱(特別区は５強、政令市は５強又は６弱)", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            let specialSet = Set(arrayLiteral: "北海道", "宮城県", "埼玉県", "千葉県", "東京都", "神奈川県", "新潟県", "静岡県", "愛知県", "京都府", "大阪府", "兵庫県", "岡山県", "広島県", "福岡県", "熊本県")
            //実際の処理
            if specialSet.contains(prefecture) {
                self.mSelectedPrefectureScaleList.append("震度６弱(特別区は５強、政令市は５強又は６弱)")
            } else {
                self.mSelectedPrefectureScaleList.append("震度６弱")
            }
            //陸か海域か
            if self.mIndex == 1 {
                self.mSelectedPrefectureCSVList.append("riku6weak_multi")
            } else if self.mIndex == 2 {
                self.mSelectedPrefectureCSVList.append("kaiiki6weak_multi")
            }
            print("mSelectedPrefectureScaleList= \(self.mSelectedPrefectureScaleList)")
            print("mSelectedPrefectureCSVList= \(self.mSelectedPrefectureCSVList)")
            self.win1.isHidden = false
        })
        /*// 閉じるボタンが押された時の処理をクロージャ実装する
        //UIAlertActionのスタイルがCancelなので赤く表示される
        let close = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.destructive, handler: {
            (action: UIAlertAction!) in
            //実際の処理
            print("閉じる")
            self.win1.isHidden = false
        })*/

        //UIAlertControllerにタイトル1ボタンとタイトル2ボタンと閉じるボタンをActionを追加
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        //actionSheet.addAction(close)

        //実際にAlertを表示する
        win1.isHidden = true
        parent.present(actionSheet, animated: true, completion: nil)
    }
}
