//
//  ContactLoadDialog.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2017/01/21.
//  Copyright © 2017年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class ContactLoadDialog: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    //ボタン押したら出るUIWindow
    fileprivate var parent: UIViewController!
    fileprivate var win1: UIWindow!
    fileprivate var text1: UITextView!
    fileprivate var table: UITableView!
    var result: [[String]] = []
    fileprivate var btnClose: UIButton!
    fileprivate var btnMail: UIButton!
    //データ保存用
    let userDefaults = UserDefaults.standard
    var mainStation: String!
    var tsunamiStation: String!
    var kubun: String!
    
    //コンストラクタ
    init(parentView: UIViewController){
        super.init()
        parent = parentView
        win1 = UIWindow()
        text1 = UITextView()
        table = UITableView()
        btnClose = UIButton()
        btnMail = UIButton()
    }
    
    //デコンストラクタ
    deinit{
        parent = nil
        win1 = nil
        text1 = nil
        table = nil
        btnClose = nil
        btnMail = nil
    }
    
    //表示
    func showResult(){
        //元の画面を暗く
        parent.view.alpha = 0.3
        //初期設定
        //Win1
        win1.backgroundColor = UIColor.white
        win1.frame = CGRect(x: 80,y: 180,width: parent.view.frame.width-40,height: parent.view.frame.height-100)
        win1.layer.position = CGPoint(x: parent.view.frame.width/2, y: parent.view.frame.height/2)
        win1.alpha = 1.0
        win1.layer.cornerRadius = 10
        //KeyWindowにする
        win1.makeKey()
        //表示
        self.win1.makeKeyAndVisible()
        
        //TextView生成
        text1.frame = CGRect(x: 10,y: 10, width: self.win1.frame.width - 20, height: self.win1.frame.height-60)
        text1.backgroundColor = UIColor.clear
        text1.font = UIFont.systemFont(ofSize: CGFloat(18))
        text1.textColor = UIColor.black
        text1.textAlignment = NSTextAlignment.left
        text1.isEditable = false
        text1.isScrollEnabled = true
        text1.dataDetectorTypes = .link
        
        text1.text=""
        
        //csvファイル読込
        let file_name = "fire.csv"
        var csvString = ""
        if let dir : NSString = NSSearchPathForDirectoriesInDomains( FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true ).first! as NSString? {
            
            let path_file_name = dir.appendingPathComponent( file_name )
            
            do {
                csvString = try String( contentsOfFile: path_file_name, encoding: String.Encoding.utf8 )
            } catch let error as NSError {
                //エラー処理
                print(error.localizedDescription)
            }
            csvString.enumerateLines { (line, stop) -> () in
                self.result.append(line.components(separatedBy: ","))
            }
        } else {
            text1.text = "csvファイル読み込みエラー"
        }

        //TableView生成
        table.frame = CGRect(x: 10, y: 41, width: self.win1.frame.width-20, height: self.win1.frame.height-60)
        table.delegate = self
        table.dataSource = self
        table.estimatedRowHeight = 10 //下とあわせこの２行で複数表示されるときの間がひらくように
        table.rowHeight = UITableView.automaticDimension
        table.register(ContactCell1.self, forCellReuseIdentifier:"contactCell1")
        table.separatorColor = UIColor.clear
        self.win1.addSubview(table)
        
        //閉じるボタン生成
        btnClose.frame = CGRect(x: 0,y: 0,width: 100,height: 30)
        btnClose.backgroundColor = UIColor.orange
        btnClose.setTitle("閉じる", for: UIControl.State())
        btnClose.setTitleColor(UIColor.white, for: UIControl.State())
        btnClose.layer.masksToBounds = true
        btnClose.layer.cornerRadius = 10.0
        btnClose.layer.position = CGPoint(x: self.win1.frame.width/2-60, y: self.win1.frame.height-20)
        btnClose.addTarget(self, action: #selector(self.onClickClose(_:)), for: .touchUpInside)
        self.win1.addSubview(btnClose)
        
        //メール送信ボタン生成
        btnMail.frame = CGRect(x: 0,y: 0,width: 100,height: 30)
        btnMail.backgroundColor = UIColor.red
        btnMail.setTitle("メール送信", for: UIControl.State())
        btnMail.setTitleColor(UIColor.white, for: UIControl.State())
        btnMail.layer.masksToBounds = true
        btnMail.layer.cornerRadius = 10.0
        btnMail.layer.position = CGPoint(x: self.win1.frame.width/2+60, y: self.win1.frame.height-20)
        btnMail.addTarget(self, action: #selector(self.onClickMail(_:)), for: .touchUpInside)
        self.win1.addSubview(btnMail)
    }
    
    //閉じる
    @objc func onClickClose(_ sender: UIButton){
        win1.isHidden = true      //win1隠す
        text1.text = ""         //使い回しするのでテキスト内容クリア
        parent.view.alpha = 1.0 //元の画面明るく
    }
    
    //メール送信
    @objc func onClickMail(_ sender: UIButton){
        //ダイアログ消去
        win1.isHidden = true
        text1.text = ""
        parent.view.alpha = 1.0
        
        //メールアドレス集約
        var addressArray: [String] = []
        let line = result.count //countで２次元配列の行数をカウントしてくれる！なんてこった！
        for index in 0..<line {
            addressArray.append(result[index][2])
        }
        
        print(addressArray)
        
        //次の関数でMailViewControllerを生成して画面遷移する
        sendMail(addressArray)
    }
    
    //メール送信 MailViewController遷移
    func sendMail(_ addressArray: [String]){
        //MailViewControllerのインスタンス生成
        let data:MailViewController = MailViewController(addressArray: addressArray)
        
        //navigationControllerのrootViewControllerにKokuminhogoViewControllerをセット
        let nav = UINavigationController(rootViewController: data)
        nav.setNavigationBarHidden(true, animated: false) //これをいれないとNavigationBarが表示されてうざい
        
        //画面遷移
        parent.present(nav, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection sction:Int)-> Int {
        return self.result.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 // セルの高さ
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let cell:ContactCell1 = table.dequeueReusableCell(withIdentifier: "contactCell1")! as! ContactCell1
        cell.textLabel?.numberOfLines = 0 //これをしないと複数表示されない
        cell.name!.text = self.result[indexPath.row][0]
        cell.tel!.text  = self.result[indexPath.row][1]
        cell.kubun!.text = self.result[indexPath.row][3]
        cell.syozoku!.text = self.result[indexPath.row][4]
        cell.kinmu!.text = self.result[indexPath.row][5]
        cell.mail!.text = self.result[indexPath.row][2]        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("セルを選択 #\(indexPath.row)")
        //自らのダイアログを消去しておく
        win1.isHidden = true      //win1隠す
        text1.text = ""
    }
}
