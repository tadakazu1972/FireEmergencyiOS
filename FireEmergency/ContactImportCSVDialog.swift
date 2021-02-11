//
//  ContactImportCSVDialog.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2017/02/25.
//  Copyright © 2017年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class ContactImportCSVDialog: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    //ボタン押したら出るUIWindow
    fileprivate var parent: ContactViewController!
    fileprivate var win1: UIWindow!
    fileprivate var text1: UITextView!
    fileprivate var table: UITableView!
    var result: [[String]] = []
    fileprivate var btnClose: UIButton!
    fileprivate var btnImport: UIButton!
    //CSVファイル読込成功フラグ
    fileprivate var importFlag: Bool = false
    
    //コンストラクタ
    init(parentView: ContactViewController){
        super.init()
        parent = parentView
        win1 = UIWindow()
        text1 = UITextView()
        table = UITableView()
        btnClose = UIButton()
        btnImport = UIButton()
    }
    
    //デコンストラクタ
    deinit{
        parent = nil
        win1 = nil
        text1 = nil
        table = nil
        btnClose = nil
        btnImport = nil
    }
    
    //表示
    func showResult(){
        //元の画面を暗く
        parent.view.alpha = 0.3
        //初期設定
        //Win1
        win1.backgroundColor = UIColor.white
        win1.frame = CGRect(x: 80,y: 180,width: parent.view.frame.width-20,height: parent.view.frame.height-100)
        win1.layer.position = CGPoint(x: parent.view.frame.width/2, y: parent.view.frame.height/2)
        win1.alpha = 1.0
        win1.layer.cornerRadius = 10
        //KeyWindowにする
        win1.makeKey()
        //表示
        self.win1.makeKeyAndVisible()
        
        //TextView生成
        text1.frame = CGRect(x: 10,y: 0, width: self.win1.frame.width - 20, height: self.win1.frame.height-60)
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
            
            text1.text="以下のCSVファイルを読込みます"
            
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
            //フラグ変更
            importFlag = true 
        } else {
            text1.text = "csvファイル読み込みエラー"
            let dummy: [String] = ["ダミー","ダミー","ダミー","ダミー","ダミー","ダミー","ダミー"]
            self.result.append(dummy)
        }
        self.win1.addSubview(text1)
        
        //TableView生成
        table.frame = CGRect(x: 10, y: 41, width: self.win1.frame.width-20, height: self.win1.frame.height-60)
        table.delegate = self
        table.dataSource = self
        table.estimatedRowHeight = 60 //下とあわせこの２行で複数表示されるときの間がひらくように
        table.rowHeight = UITableView.automaticDimension
        table.register(ContactCell1.self, forCellReuseIdentifier:"contactCell1")
        table.separatorColor = UIColor.clear
        self.win1.addSubview(table)
        
        func tableView(_ tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat { return UITableView.automaticDimension }
        
        
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
        
        //読込ボタン生成
        btnImport.frame = CGRect(x: 0,y: 0,width: 100,height: 30)
        btnImport.backgroundColor = UIColor.red
        btnImport.setTitle("読込", for: UIControl.State())
        btnImport.setTitleColor(UIColor.white, for: UIControl.State())
        btnImport.layer.masksToBounds = true
        btnImport.layer.cornerRadius = 10.0
        btnImport.layer.position = CGPoint(x: self.win1.frame.width/2+60, y: self.win1.frame.height-20)
        btnImport.addTarget(self, action: #selector(self.onClickImport(_:)), for: .touchUpInside)
        self.win1.addSubview(btnImport)
    }
    
    //閉じる
    @objc func onClickClose(_ sender: UIButton){
        win1.isHidden = true      //win1隠す
        text1.text = ""         //使い回しするのでテキスト内容クリア
        parent.view.alpha = 1.0 //元の画面明るく
    }
    
    //読込
    @objc func onClickImport(_ sender: UIButton){
        //アラートメッセージ
        var msg: String = ""
        //ちゃんと読込成功してるのかチェックしてからDBにinsertする
        if importFlag {
            let line = result.count //countで２次元配列の行数をカウントしてくれる！なんてこった！
            for index in 0..<line {
                //DBに書き込み
                parent.mDBHelper.insert(result[index][0], tel: result[index][1], mail: result[index][2], kubun: result[index][3], syozoku0: result[index][4], syozoku: result[index][5], kinmu: result[index][6])
            }
            msg = "CSVファイルの読込完了"
        } else {
            msg = "CSVファイル読込エラー"
        }
        
        //アラート表示
        let alert = UIAlertController(title:"", message: msg, preferredStyle: UIAlertController.Style.alert)
        let alertCancel = UIAlertAction(title:"閉じる", style: UIAlertAction.Style.cancel, handler:nil)
        alert.addAction(alertCancel)
        parent.present(alert, animated:true, completion: nil)
        
        //ダイアログ消去
        win1.isHidden = true
        text1.text = ""
        parent.view.alpha = 1.0
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
        cell.syozoku0!.text = self.result[indexPath.row][4]
        cell.syozoku!.text = self.result[indexPath.row][5]
        cell.kinmu!.text = self.result[indexPath.row][6]
        cell.mail!.text = self.result[indexPath.row][2]
        return cell
    }
    
    //セルを選択
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("セルを選択 #\(indexPath.row)")
    }
    
}
