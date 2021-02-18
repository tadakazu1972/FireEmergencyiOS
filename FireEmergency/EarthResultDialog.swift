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
    fileprivate var parent: EarthquakeViewController!
    fileprivate var win1: UIWindow!
    fileprivate var text1: UITextView!
    fileprivate var btnClose: UIButton!
    //データ保存用
    let userDefaults = UserDefaults.standard
    var mainStation: String = ""
    var tsunamiStation: String = ""
    var kubun: String = ""
    
    //コンストラクタ
    init(parentView: EarthquakeViewController){
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
        //元の画面を暗く、タップ無効化
        parent.view.alpha = 0.3
        parent.view.isUserInteractionEnabled = false
        mViewController.view.alpha = 0.3
        mViewController.view.isUserInteractionEnabled = false
        //初期設定
        //Win1
        win1.backgroundColor = UIColor.white
        win1.frame = CGRect(x: 80,y: 180,width: parent.view.frame.width-40,height: parent.view.frame.height*0.8)
        win1.layer.position = CGPoint(x: parent.view.frame.width/2, y: parent.view.frame.height/2+72) //+72子ViewController調整
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
            //以下の勤務消防署に該当する場合は第４非常警備（大津波・津波警報時参集指定署ではないことに注意！）、それ以外は３号招集
            let gaitousyo = Set(arrayLiteral:"天王寺消防署","東淀川消防署","東成消防署","生野消防署","阿倍野消防署","東住吉消防署","平野消防署")
            if gaitousyo.contains(mainStation){
                //４号召集なので、１号、２号、３号は招集なしの判定する
                if kubun != "４号招集" {
                    text1.text="■津波警報\n\n４号非常招集\n(天王寺,東淀川,東成,生野,阿倍野,東住吉,平野)\n\n招集なし"
                } else {
                    text1.text="■津波警報\n\n４非常招集(非番・日勤)\n(天王寺,東淀川,東成,生野,阿倍野,東住吉,平野)\n\n\(mainStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
                }
            } else {
                //３号招集なので、１号、２号は参集なしの判定する
                if kubun == "１号招集" || kubun == "２号招集" {
                    text1.text="■津波警報\n\n３号非常招集(非番・日勤)\n(北,都島,福島,此花,中央,西,港,大正,浪速,西淀川,淀川,旭,城東,鶴見,住之江,住吉,西成,水上,消防局)\n\n招集なし"
                } else {
                    text1.text="■津波警報\n\n３号非常招集(非番・日勤)\n(北,都島,福島,此花,中央,西,港,大正,浪速,西淀川,淀川,旭,城東,鶴見,住之江,住吉,西成,水上,消防局)\n\n\(mainStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
                }
            }
            break
        case 33:
            //４号招集なので、１号、２号、３号は参集なしの判定する
            if kubun != "４号招集" {
                text1.text="■警報なし\n\n４号非常招集\n\n招集なし"
            } else {
                text1.text="■警報なし\n\n４号非常招集\n\n\(mainStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            }
            break
        //震度３以下
        case 41:
            text1.text="■大津波警報\n\n１号非常招集\n\n\(tsunamiStation)へ参集"
            break
        case 42:
            //以下の勤務消防署に該当する場合は第５非常警備（大津波・津波警報時参集指定署ではないことに注意！）、それ以外は３号招集
            let gaitousyo = Set(arrayLiteral:"天王寺消防署","東淀川消防署","東成消防署","生野消防署","阿倍野消防署","東住吉消防署","平野消防署")
            if gaitousyo.contains(mainStation){
                text1.text="■津波警報\n\n第５非常警備\n(天王寺,東淀川,東成,生野,阿倍野,東住吉,平野)\n\n\(mainStation)\n\n招集なし"
            } else {
                //３号招集なので、１号、２号は参集なしの判定する
                if kubun == "１号招集" || kubun == "２号招集" {
                    text1.text="■津波警報\n\n３号非常招集(非番・日勤)\n\n招集なし"
                } else {
                    text1.text="■津波警報\n\n３号非常招集(非番・日勤)\n(北,都島,福島,此花,中央,西,港,大正,浪速,西淀川,淀川,旭,城東,鶴見,住之江,住吉,西成,水上,消防局)\n\n\(mainStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
                }
            }
            break
        case 43:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let gaitousyo = Set(arrayLiteral: "北消防署","都島消防署","福島消防署","此花消防署","中央消防署","西消防署","港消防署","大正消防署","浪速消防署","西淀川消防署","淀川消防署","旭消防署","城東消防署","鶴見消防署","住之江消防署","住吉消防署","西成消防署","水上消防署","消防局")
            if gaitousyo.contains(mainStation){
                text1.text="■津波注意報\n\n第５非常警備\n(北,都島,福島,此花,中央,西,港,大正,浪速,西淀川,淀川,旭,城東,鶴見,住之江,住吉,西成,水上,消防局)\n\n\(mainStation)\n\n招集なし"
            } else {
                text1.text="■津波注意報\n\n第５非常警備\n(北,都島,福島,此花,中央,西,港,大正,浪速,西淀川,淀川,旭,城東,鶴見,住之江,住吉,西成,水上,消防局)\n\n招集なし"
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
                text1.text="■東海地震注意報が発表されたとき\n\n４号非常招集\n\n\(mainStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            } else {
                text1.text="■東海地震注意報が発表されたとき\n\n４号非常招集\n\n招集なし"
            }
            break
        case 53:
            text1.text="■東海地震に関連する調査情報（臨時）が発表されたとき\n\n第５非常警備(全署、消防局)\n\n\(mainStation)\n\n招集なし"
            break
        //南海トラフ地震臨時情報
        case 61:
            text1.text="■調査中\n\n第５非常警備(全署、消防局)\n\n\(mainStation)\n\n招集なし"
            break
        case 62:
            //４号招集なので、１号、２号、３号は参集なしの判定する
            if kubun == "４号招集" {
                text1.text="■巨大地震注意\n\n４号非常招集\n\n\(mainStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            } else {
                text1.text="■巨大地震注意\n\n４号非常招集\n\n招集なし"
            }
            break
        case 63:
            //４号招集なので、１号、２号、３号は参集なしの判定する
            if kubun == "４号招集" {
                text1.text="■巨大地震警戒\n\n４号非常招集\n\n\(mainStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            } else {
                text1.text="■巨大地震警戒\n\n４号非常招集\n\n招集なし"
            }
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
        parent.view.isUserInteractionEnabled = true //タップ有効化
        mViewController.view.alpha = 1.0 //明るく
        mViewController.view.isUserInteractionEnabled = true
    }
}
