//
//  KinentaiResultRialogMulti.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2021/10/31.
//  Copyright © 2021 tadakazu nakamichi. All rights reserved.
//

import UIKit

class KinentaiResultDialogMulti {
    //ボタン押したら出るUIWindow
    fileprivate var parent: KinentaiViewController!
    fileprivate var win1: UIWindow!
    fileprivate var text1: UITextView!
    fileprivate var btnClose: UIButton!
    //データ保存用
    let userDefaults = UserDefaults.standard
    var mainStation: String = ""
    var tsunamiStation: String = ""
    var kubun: String = ""
    //複数都道府県選択保存配列
    fileprivate var mSelectedPrefectureIndexList:[Int] = [];
    fileprivate var mSelectedPrefectureScaleList:[String] = [];
    fileprivate var mSelectedPrefectureCSVList:[String] = [];
    
    //コンストラクタ
    init(parentView: KinentaiViewController){
        parent = parentView
        win1 = UIWindow()
        text1 = UITextView()
        btnClose = UIButton()
    }
    
    //デコンストラクタ
    deinit{
        parent = nil
        win1 = nil
        text1 = nil
        btnClose = nil
    }
    
    //表示
    func showResult(_ indexList:[Int], scaleList:[String], csvList:[String]){
        //引数が渡されたかtest
        print("\(indexList)")
        print("\(scaleList)")
        print("\(csvList)")
        //元の画面を暗く
        parent.view.alpha = 0.3
        mViewController.view.alpha = 0.3
        //初期設定
        //Win1
        win1.backgroundColor = UIColor.white
        win1.frame = CGRect(x: 80,y: 180,width: parent.view.frame.width-40,height: parent.view.frame.height)
        win1.layer.position = CGPoint(x: parent.view.frame.width/2, y: parent.view.frame.height/2+72) //+72調整
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
        
        //テキストの内容を場合分け
        switch data {
        //地震(震央「陸」)>震度７(特別区６強)
        case 11:
            //csvファイル読込
            var result: [[String]] = []
            if let path = Bundle.main.path(forResource: "riku7", ofType: "csv") {
                var csvString = ""
                do {
                    csvString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                csvString.enumerateLines { (line, stop) -> () in
                    result.append(line.components(separatedBy: ","))
                }
                
                if text1.text=="" { //これしないと毎回ファイルを読み込んでスクロールすると下とカブる
                    text1.text = "■最大震度７(特別区６強)\n　\(result[item][0])\n\n・指揮支援隊\n　\(result[item][1])\n\n・大阪府大隊(陸上)\n　\(result[item][2])\n\n・大阪府大隊(航空)\n　\(result[item][3])"
                }
            } else {
                text1.text = "csvファイル読み込みエラー"
            }
            break
        case 12:
            //csvファイル読込
            var result: [[String]] = []
            if let path = Bundle.main.path(forResource: "riku6strong", ofType: "csv") {
                var csvString = ""
                do {
                    csvString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                csvString.enumerateLines { (line, stop) -> () in
                    result.append(line.components(separatedBy: ","))
                }
                
                if text1.text=="" { //これしないと毎回ファイルを読み込んでスクロールすると下とカブる
                    text1.text = "■最大震度６強(特別区６弱)\n　\(result[item][0])\n\n・指揮支援隊\n　\(result[item][1])\n\n・大阪府大隊(陸上)\n　\(result[item][2])\n\n・大阪府大隊(航空)\n　\(result[item][3])"
                }
            } else {
                text1.text = "csvファイル読み込みエラー"
            }
            break
        case 13:
            //csvファイル読込
            var result: [[String]] = []
            if let path = Bundle.main.path(forResource: "riku6weak", ofType: "csv") {
                var csvString = ""
                do {
                    csvString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                csvString.enumerateLines { (line, stop) -> () in
                    result.append(line.components(separatedBy: ","))
                }
                
                if text1.text=="" { //これしないと毎回ファイルを読み込んでスクロールすると下とカブる
                    text1.text = "■最大震度6弱(特別区5強,政令市5強)\n　\(result[item][0])\n\n・指揮支援隊\n　\(result[item][1])\n\n・大阪府大隊(陸上)\n　\(result[item][2])\n\n・大阪府大隊(航空)\n　\(result[item][3])"
                }
            } else {
                text1.text = "csvファイル読み込みエラー"
            }
            break
        //地震(震央「海域」)
        case 21:
            //csvファイル読込
            var result: [[String]] = []
            if let path = Bundle.main.path(forResource: "kaiiki7", ofType: "csv") {
                var csvString = ""
                do {
                    csvString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                csvString.enumerateLines { (line, stop) -> () in
                    result.append(line.components(separatedBy: ","))
                }
                
                if text1.text=="" { //これしないと毎回ファイルを読み込んでスクロールすると下とカブる
                    text1.text = "■最大震度７(特別区６強)\n　\(result[item][0])\n\n・指揮支援隊\n　\(result[item][1])\n\n・大阪府大隊(陸上)\n　\(result[item][2])\n\n・大阪府大隊(航空)\n　\(result[item][3])"
                }
            } else {
                text1.text = "csvファイル読み込みエラー"
            }
            break
        case 22:
            //csvファイル読込
            var result: [[String]] = []
            if let path = Bundle.main.path(forResource: "kaiiki6strong", ofType: "csv") {
                var csvString = ""
                do {
                    csvString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                csvString.enumerateLines { (line, stop) -> () in
                    result.append(line.components(separatedBy: ","))
                }
                
                if text1.text=="" { //これしないと毎回ファイルを読み込んでスクロールすると下とカブる
                    text1.text = "■最大震度６強(特別区６弱)\n　\(result[item][0])\n\n・指揮支援隊\n　\(result[item][1])\n\n・大阪府大隊(陸上)\n　\(result[item][2])\n\n・大阪府大隊(航空)\n　\(result[item][3])"
                }
            } else {
                text1.text = "csvファイル読み込みエラー"
            }
            break
        case 23:
            //csvファイル読込
            var result: [[String]] = []
            if let path = Bundle.main.path(forResource: "kaiiki6weak", ofType: "csv") {
                var csvString = ""
                do {
                    csvString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                csvString.enumerateLines { (line, stop) -> () in
                    result.append(line.components(separatedBy: ","))
                }
                
                if text1.text=="" { //これしないと毎回ファイルを読み込んでスクロールすると下とカブる
                    text1.text = "■最大震度6弱(特別区5強,政令市5強)\n　\(result[item][0])\n\n・指揮支援隊\n　\(result[item][1])\n\n・大阪府大隊(陸上)\n　\(result[item][2])\n\n・大阪府大隊(航空)\n　\(result[item][3])"
                }
            } else {
                text1.text = "csvファイル読み込みエラー"
            }
            break
        
        default:
            text1.text=""
            break
        }
        
        self.win1.addSubview(text1)
        
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
}
