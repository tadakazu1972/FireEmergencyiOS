//
//  TyphoonResultDialog.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2016/12/01.
//  Copyright © 2016年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class TyphoonResultDialog {
    //ボタン押したら出るUIWindow
    fileprivate var parent: TyphoonViewController!
    fileprivate var win1: UIWindow!
    fileprivate var text1: UITextView!
    fileprivate var btnClose: UIButton!
    //データ保存用
    let userDefaults = UserDefaults.standard
    var mainStation: String = ""
    var tsunamiStation: String = ""
    var kubun: String = ""
    
    //コンストラクタ
    init(parentView: TyphoonViewController){
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
    func showResult(_ data :Int){
        //勤務消防署が保存されている場合は呼び出して格納
        if let _mainStation = userDefaults.string(forKey: "mainStation"){
            if _mainStation == "消防局" || _mainStation == "訓練センター" {
                mainStation = _mainStation
            } else {
                mainStation = _mainStation + "消防署"
            }
        }
        //大津波・津波警報時参集指定署が保存されている場合は呼び出して格納
        if let _tsunamiStation = userDefaults.string(forKey: "tsunamiStation"){
            if _tsunamiStation == "消防局" || _tsunamiStation == "訓練センター" {
                tsunamiStation = _tsunamiStation
            } else {
                tsunamiStation = _tsunamiStation + "消防署"
            }
        }
        //非常招集区分を呼び出して格納
        if let _kubun = userDefaults.string(forKey: "kubun"){
            kubun = _kubun
        }
        //下層の画面を暗く
        parent.view.alpha = 0.3 //TyphoonViewController
        mViewController.view.alpha = 0.3 //ViewController
        //初期設定
        //Win1
        win1.backgroundColor = UIColor.white
        if mViewController.view.frame.height < 570 {
            //iPhone SE
            win1.frame = CGRect(x: 0,y: 0,width: mViewController.view.frame.width-5,height: mViewController.view.frame.height*0.9)
        } else {
            win1.frame = CGRect(x: 0,y: 0,width: mViewController.view.frame.width-20,height: mViewController.view.frame.height*0.6)
        }
        win1.layer.position = CGPoint(x: parent.view.frame.width/2, y: parent.view.frame.height/2+72) //+72:子ViewController調整
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
        //非常警備の基準（全て）
        case 11:
            //テキストファイル読込
            let path = Bundle.main.path(forResource: "typhoon1", ofType: "txt")!
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)){
                if text1.text=="" { //これしないと毎回ファイルを読み込んでスクロールすると下とカブる
                    text1.text = String(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
                }
            } else {
                text1.text = "ファイル読込エラー"
            }
            break
        //特別警報
        case 21:
            text1.text="■特別警報\n\n１号非常招集\n\n\(mainStation)へ参集"
            break
        //暴風（雪）警報
        case 22:
            //４号招集なので、１号、２号、３号は参集なしの判定する
            if kubun == "４号招集" {
                text1.text="■暴風(雪)警報\n\n４号非常招集\n\n\(mainStation)へ参集　所属担当者に確認すること\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            } else {
                text1.text="■暴風(雪)警報\n\n４号非常招集\n\n招集なし"
            }
            break
        //大雨警報
        case 23:
            if mainStation == "訓練センター" {
                text1.text="■大雨警報\n\n第５非常警備(全署、消防局)\n\nー\n\n招集なし"
            } else {
                text1.text="■大雨警報\n\n第５非常警備(全署、消防局)\n\n\(mainStation)\n\n招集なし"
            }
            break
        //大雪警報
        case 24:
            if mainStation == "訓練センター" {
                text1.text="■大雪警報\n\n第５非常警備(全署、消防局)\n\nー\n\n招集なし"
            } else {
                text1.text="■大雪警報\n\n第５非常警備(全署、消防局)\n\n\(mainStation)\n\n招集なし"
            }
            break
        //洪水警報
        case 25:
            if mainStation == "訓練センター" {
                text1.text="■洪水警報\n\n第５非常警備(全署、消防局)\n\nー\n\n招集なし"
            } else {
                text1.text="■洪水警報\n\n第５非常警備(全署、消防局)\n\n\(mainStation)\n\n招集なし"
            }
            break
        //波浪警報
        case 26:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let gaitousyo = Set(arrayLiteral: "此花", "港", "大正", "西淀川", "住之江", "水上", "消防局")
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo.contains(userDefaults.string(forKey: "mainStation")!){
                text1.text="■波浪警報\n\n第５非常警備(此花、港、大正、西淀川、住之江、水上、消防局)\n\n\(mainStation)\n\n招集なし"
            } else {
                text1.text="■洪水警報\n\n第５非常警備(此花、港、大正、西淀川、住之江、水上、消防局)\n\nー\n\n招集なし"
            }
            break
        //高潮警報
        case 27:
            if mainStation == "訓練センター" {
                text1.text="■高潮警報\n\n第５非常警備(全署、消防局)\n\nー\n\n招集なし"
            } else {
                text1.text="■高潮警報\n\n第５非常警備(全署、消防局)\n\n\(mainStation)\n\n招集なし"
            }
            break
        //高潮注意報
        case 28:
            if mainStation == "訓練センター" {
                text1.text="■高潮注意報\n\n第５非常警備(全署、消防局)\n\nー\n\n招集なし"
            } else {
                text1.text="■高潮注意報\n\n第５非常警備(全署、消防局)\n\n\(mainStation)\n\n招集なし"
            }
            break
        //
        case 31:
            text1.text="■大津波警報\n\n１号非常招集\n\n\(tsunamiStation)へ参集"
            break
        case 32:
            //３号招集なので、１号、２号は参集なしの判定する
            if kubun == "１号招集" || kubun == "２号招集" {
                text1.text="■津波警報\n\n３号非常招集(非番・日勤)\n\n招集なし"
            } else {
                text1.text="■津波警報\n\n３号非常招集(非番・日勤)\n\n\(tsunamiStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            }
            break
        case 33:
            //３号招集なので、１号、２号は参集なしの判定する
            if kubun == "１号招集" || kubun == "２号招集" {
                text1.text="■警報なし\n\n３号非常招集(非番・日勤)\n\n招集なし"
            } else {
                text1.text="■警報なし\n\n３号非常招集(非番・日勤)\n\n\(mainStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            }
            break
        //
        case 41:
            text1.text="■大津波警報\n\n１号非常招集\n\n\(tsunamiStation)へ参集"
            break
        case 42:
            //３号招集なので、１号、２号は参集なしの判定する
            if kubun == "１号招集" || kubun == "２号招集" {
                text1.text="■津波警報\n\n３号非常招集(非番・日勤)\n\n招集なし"
            } else {
                text1.text="■津波警報\n\n３号非常招集(非番・日勤)\n\n\(tsunamiStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            }
            break
        case 43:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let gaitousyo = Set(arrayLiteral: "此花消防署","港消防署","大正消防署","西淀川消防署","住之江消防署","西成消防署","水上消防署","消防局")
            if gaitousyo.contains(mainStation){
                text1.text="■津波注意報\n\n第５非常警備(此花,港,大正,西淀川,住之江,西成,水上,消防局)\n\n\(mainStation)"
            } else {
                text1.text="■津波注意報\n\n第５非常警備(此花,港,大正,西淀川,住之江,西成,水上,消防局)\n\n招集なし"
            }
            break
        case 44:
            text1.text="■警報なし\n\n招集なし"
            break
        //
        case 51:
            //３号招集なので、１号、２号は参集なしの判定する
            if kubun == "１号招集" || kubun == "２号招集" {
                text1.text="■警戒宣言が発令されたとき（東海地震予知情報）\n\n３号非常招集(非番・日勤)\n\n招集なし"
            } else {
                text1.text="■警戒宣言が発令されたとき（東海地震予知情報）\n\n３号非常招集(非番・日勤)\n\n\(mainStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            }
            break
        case 52:
            //４号招集なので、１号、２号、３号は参集なしの判定する
            if kubun == "４号招集" {
                text1.text="■東海地震注意報が発表されたとき\n\n４号非常招集\n\n\(mainStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            } else {
                text1.text="■東海地震注意報が発表されたとき\n\n４号非常招集\n\n招集なし"
            }
            break
        case 53:
            text1.text="■東海地震に関連する調査情報（臨時）が発表されたとき\n\n第５非常警備(全署、消防局)\n\n\(mainStation)\n\n招集なし"
            break
            
        default:
            text1.text=""
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
        parent.view.alpha = 1.0 //TyphoonViewController 明るく
        mViewController.view.alpha = 1.0 //ViewController 明るく
    }
}
