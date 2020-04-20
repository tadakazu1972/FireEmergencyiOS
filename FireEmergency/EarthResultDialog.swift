//
//  EarthResultDialog.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2016/11/05.
//  Copyright © 2016年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class EarthResultDialog {
    //ボタン押したら出るUIWindow
    fileprivate var parent: ViewController!
    fileprivate var win1: UIWindow!
    fileprivate var text1: UITextView!
    fileprivate var btnClose: UIButton!
    //データ保存用
    let userDefaults = UserDefaults.standard
    var mainStation: String = ""
    var tsunamiStation: String = ""
    var kubun: String = ""
    
    //コンストラクタ
    init(parentView: ViewController){
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
            if _mainStation == "消防局" || _mainStation == "教育訓練センター" {
                mainStation = _mainStation
            } else {
                mainStation = _mainStation + "消防署"
            }
        }
        //大津波・津波警報時参集指定署が保存されている場合は呼び出して格納
        if let _tsunamiStation = userDefaults.string(forKey: "tsunamiStation"){
            if _tsunamiStation == "消防局" || _tsunamiStation == "教育訓練センター" {
                tsunamiStation = _tsunamiStation
            } else {
                tsunamiStation = _tsunamiStation + "消防署"
            }
        }
        //非常招集区分を呼び出して格納
        if let _kubun = userDefaults.string(forKey: "kubun"){
            kubun = _kubun
        }
        //元の画面を暗く
        parent.view.alpha = 0.3
        //初期設定
        //Win1
        win1.backgroundColor = UIColor.white
        win1.frame = CGRect(x: 80,y: 180,width: parent.view.frame.width-40,height: parent.view.frame.height-280)
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
        
        //テキストの内容を場合分け
        switch data {
        //震度５強以上
        case 11:
            text1.text="■大津波警報\n\n１号非常招集\n\n\(tsunamiStation)へ参集"
            break
        case 12:
            text1.text="■津波警報\n\n１号非常招集\n\n\(tsunamiStation)へ参集"
            break
        case 13:
            text1.text="■警報なし\n\n１号非常招集\n\n\(mainStation)へ参集"
            break
        //震度５弱
        case 21:
            text1.text="■大津波警報\n\n１号非常招集\n\n\(tsunamiStation)へ参集"
            break
        case 22:
            //２号招集なので、１号は参集なしの判定する
            if kubun != "１号招集" {
                text1.text="■津波警報\n\n２号非常招集\n\n\(tsunamiStation)へ参集"
            } else {
                text1.text="■津波警報\n\n２号非常招集\n\n招集なし"
            }
            break
        case 23:
            //２号招集なので、１号は参集なしの判定する
            if kubun != "１号招集" {
                text1.text="■警報なし\n\n２号非常招集\n\n\(mainStation)へ参集"
            } else {
                text1.text="■警報なし\n\n２号非常招集\n\n招集なし"
            }
            break
        //震度４
        case 31:
            text1.text="■大津波警報\n\n１号招集\n\n\(tsunamiStation)へ参集"
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
        //震度３以下
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
                text1.text="■津波注意報\n\n第５非常警備(此花,港,大正,西淀川,住之江,西成,水上,消防局)\n\n\(mainStation)\n\n招集なし"
            } else {
                text1.text="■津波注意報\n\n第５非常警備(此花,港,大正,西淀川,住之江,西成,水上,消防局)\n\n招集なし"
            }
            break
        case 44:
            text1.text="■警報なし\n\n招集なし"
            break
        //東海地震に伴う非常招集
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
                text1.text="■東海地震注意報が発表されたとき\n\n４号非常招集(非番・日勤)\n\n\(mainStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            } else {
                text1.text="■東海地震注意報が発表されたとき\n\n４号非常招集(非番・日勤)\n\n招集なし"
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
        parent.view.alpha = 1.0 //元の画面明るく
    }
}
