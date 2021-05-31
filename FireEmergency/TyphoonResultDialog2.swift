//
//  TyphoonResultDialog2.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2016/12/14.
//  Copyright © 2016年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class TyphoonResultDialog2 {
    //ボタン押したら出るUIWindow
    fileprivate var parent: TyphoonViewController!
    fileprivate var win1: UIWindow!
    fileprivate var text1: UITextView!
    fileprivate var text2: UITextView!
    fileprivate var btnClose: UIButton!
    fileprivate var btnBack: UIButton!
    fileprivate var btnGaitousyo: UIButton!
    //データ保存用
    let userDefaults = UserDefaults.standard
    var mainStation: String = ""
    var tsunamiStation: String = ""
    var kubun: String = ""
    //戻るTyphoonSelectDialog2用
    var backIndex: Int!
    fileprivate var mTyphoonSelectDialog2: TyphoonSelectDialog2!
    
    //コンストラクタ
    init(index: Int, parentView: TyphoonViewController){
        parent = parentView
        win1 = UIWindow()
        text1 = UITextView()
        text2 = UITextView()
        btnClose = UIButton()
        btnBack  = UIButton()
        btnGaitousyo = UIButton()
        backIndex = index
    }
    
    //デコンストラクタ
    deinit{
        parent = nil
        win1 = nil
        text1 = nil
        text2 = nil
        btnClose = nil
        btnBack  = nil
        btnGaitousyo = nil
        backIndex = nil
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
        //元の画面を暗く
        parent.view.alpha = 0.3
        //初期設定
        //Win1
        win1.backgroundColor = UIColor.white
        if mViewController.view.frame.height < 570 {
            //iPhone SE
            win1.frame = CGRect(x: 0,y: 0,width: mViewController.view.frame.width-5,height: mViewController.view.frame.height*0.9)
        } else {
            win1.frame = CGRect(x: 0,y: 0,width: mViewController.view.frame.width-20,height: mViewController.view.frame.height*0.7)
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
        
        //該当署を表示するTextView生成
        text2.frame = CGRect(x: 100,y: self.win1.frame.height-170, width: self.win1.frame.width/1.7, height: self.win1.frame.height/3)
        text2.backgroundColor = UIColor.clear
        text2.font = UIFont.systemFont(ofSize: CGFloat(12))
        text2.textColor = UIColor.black
        text2.textAlignment = NSTextAlignment.left
        text2.isEditable = false
        text2.isScrollEnabled = true
        text2.dataDetectorTypes = .link
        text2.isHidden = true //該当署ボタンを押すまで隠しておく
        
        //テキストの内容を場合分け
        switch data {
        //淀川（枚方）
        //氾濫注意水位、水防警報(出動)
        case 11:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let title:String! = "■淀川（枚方）\n氾濫注意水位(水位4.5m)、水防警報(出動)\n\n"
            let gaitousyo = Set(arrayLiteral: "北", "都島", "福島", "此花", "西淀川", "淀川", "東淀川", "旭", "消防局")
            text2.text = "北,都島,福島,此花,西淀川,淀川,東淀川,旭,消防局"
            var message:String! = ""
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo.contains(userDefaults.string(forKey: "mainStation")!){
                message = "\(mainStation)\n\n招集なし"
            } else {
                message = "ー\n\n招集なし"
            }
            text1.text = title + "第５非常警備\n\n" + message
            break
        //高齢者等避難発令の見込み
        case 12:
            let title:String! = "■淀川（枚方）\n高齢者等避難が発令される見込みとなったとき\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "北", "都島", "福島", "此花", "西淀川", "淀川", "東淀川", "旭", "消防局")
            text2.text = "4号:北,都島,福島,此花,西淀川,淀川,東淀川,旭,消防局\n5号:その他の署"
            setLevel2(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //高齢者等避難
        case 13:
            let title:String! = "■淀川（枚方）\n 【警戒レベル３】\n高齢者等避難(水位5.4m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "北", "都島", "福島", "此花", "西淀川", "淀川", "東淀川", "旭", "消防局")
            text2.text = "3号:北,都島,福島,此花,西淀川,淀川,東淀川,旭,消防局\n4号:その他の署"
            setLevel3(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //避難指示
        case 14:
            let title:String! = "■淀川（枚方）\n【警戒レベル４】\n避難指示(水位5.5m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "北", "都島", "福島", "此花", "西淀川", "淀川", "東淀川", "旭", "消防局")
            text2.text = "2号:北,都島,福島,此花,西淀川,淀川,東淀川,旭,消防局\n3号:その他の署"
            setLevel4(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //緊急安全確保
        case 15:
            let title:String! = "■淀川（枚方）\n【警戒レベル５】\n緊急安全確保(水位8.3m)\n\n"
            let hosoku:String! = ""
            let gaitousyo = Set(arrayLiteral: "北", "都島", "福島", "此花", "西淀川", "淀川", "東淀川", "旭", "消防局")
            text2.text = "1号:北,都島,福島,此花,西淀川,淀川,東淀川,旭,消防局\n2号:その他の署"
            setLevel5(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //大和川(柏原)
        //氾濫注意水位、水防警報(出動)
        case 21:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let title:String! = "■大和川(柏原)\n氾濫注意水位(水位3.2m)、水防警報(出動)\n\n"
            let gaitousyo = Set(arrayLiteral: "住之江", "住吉", "東住吉", "平野", "消防局")
            text2.text = "住之江,住吉,東住吉,平野,消防局"
            var message:String! = ""
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo.contains(userDefaults.string(forKey: "mainStation")!){
                message = "\(mainStation)\n\n招集なし"
            } else {
                message = "ー\n\n招集なし"
            }
            text1.text = title + "第５非常警備\n\n" + message
            break
        //高齢者等避難発令の見込み
        case 22:
            let title:String! = "■大和川(柏原)\n高齢者等避難が発令される見込みとなったとき\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "住之江", "住吉", "東住吉", "平野", "消防局")
            text2.text = "4号:住之江,住吉,東住吉,平野,消防局\n5号:その他の署"
            setLevel2(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //高齢者等避難
        case 23:
            let title:String! = "■大和川(柏原)\n 【警戒レベル３】\n高齢者等避難(水位4.7m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "住之江", "住吉", "東住吉", "平野", "消防局")
            text2.text = "3号:住之江,住吉,東住吉,平野,消防局\n4号:その他の署"
            setLevel3(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //避難指示
        case 24:
            let title:String! = "■大和川(柏原)\n【警戒レベル４】\n避難指示(水位5.3m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "住之江", "住吉", "東住吉", "平野", "消防局")
            text2.text = "2号:住之江,住吉,東住吉,平野,消防局\n3号:その他の署"
            setLevel4(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //緊急安全確保
        case 25:
            let title:String! = "■大和川(柏原)\n【警戒レベル５】\n緊急安全確保(水位6.8m)\n\n"
            let hosoku:String! = ""
            let gaitousyo = Set(arrayLiteral: "住之江", "住吉", "東住吉", "平野", "消防局")
            text2.text = "1号:住之江,住吉,東住吉,平野,消防局\n2号:その他の署"
            setLevel5(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //神崎川(三国)
        //氾濫注意水位、水防警報(出動)
        case 31:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let title:String! = "■神崎川(三国)\n氾濫注意水位(水位3.8m)、水防警報(出動)\n\n"
            let gaitousyo = Set(arrayLiteral: "淀川", "東淀川", "消防局")
            text2.text = "淀川,東淀川,消防局"
            var message:String! = ""
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo.contains(userDefaults.string(forKey: "mainStation")!){
                message = "\(mainStation)\n\n招集なし"
            } else {
                message = "ー\n\n招集なし"
            }
            text1.text = title + "第５非常警備\n\n" + message
            break
        //高齢者等避難発令の見込み
        case 32:
            let title:String! = "■神崎川(三国)\n高齢者等避難が発令される見込みとなったとき\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "西淀川", "淀川", "東淀川", "消防局")
            text2.text = "4号:西淀川,淀川,東淀川,消防局\n5号:その他の署"
            setLevel2(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //高齢者等避難
        case 33:
            let title:String! = "■神崎川(三国)\n 【警戒レベル３】\n高齢者等避難(水位4.8m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "西淀川", "淀川", "東淀川", "消防局")
            text2.text = "3号:西淀川,淀川,東淀川,消防局\n4号:その他の署"
            setLevel3(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //避難指示
        case 34:
            let title:String! = "■神崎川(三国)\n【警戒レベル４】\n避難指示(水位5m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "西淀川", "淀川", "東淀川", "消防局")
            text2.text = "2号:西淀川,淀川,東淀川,消防局\n3号:その他の署"
            setLevel4(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //緊急安全確保
        case 35:
            let title:String! = "■神崎川(三国)\n【警戒レベル５】\n緊急安全確保(水位5.8m)\n\n"
            let hosoku:String! = ""
            let gaitousyo = Set(arrayLiteral: "西淀川", "淀川", "東淀川", "消防局")
            text2.text = "1号:西淀川,淀川,東淀川,消防局\n2号:その他の署"
            setLevel5(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //天竺川 2020.06　追加(既存分を修正しないためcase 121-125)
        //氾濫注意水位、水防警報(出動)
        case 121:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let title:String! = "■天竺川(天竺川橋)\n氾濫注意水位(水位2m)、水防警報(出動)\n\n"
            let gaitousyo = Set(arrayLiteral: "淀川", "消防局")
            text2.text = "淀川,消防局"
            var message:String! = ""
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo.contains(userDefaults.string(forKey: "mainStation")!){
                message = "\(mainStation)\n\n招集なし"
            } else {
                message = "ー\n\n招集なし"
            }
            text1.text = title + "第５非常警備\n\n" + message
            break
        //高齢者等避難発令の見込み
        case 122:
            let title:String! = "■天竺川(天竺川橋)\n高齢者等避難が発令される見込みとなったとき\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "淀川", "消防局")
            text2.text = "4号:淀川,消防局\n5号:その他の署"
            setLevel2(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //高齢者等避難
        case 123:
            let title:String! = "■天竺川(天竺川橋)\n 【警戒レベル３】\n高齢者等避難(水位2.2m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "淀川", "消防局")
            text2.text = "3号:淀川,消防局\n4号:その他の署"
            setLevel3(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //避難指示
        case 124:
            let title:String! = "■天竺川(天竺川橋)\n【警戒レベル４】\n避難指示(水位2.3m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "淀川", "消防局")
            text2.text = "2号:淀川,消防局\n3号:その他の署"
            setLevel4(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //緊急安全確保
        case 125:
            let title:String! = "■天竺川(天竺川橋)\n【警戒レベル５】\n緊急安全確保(水位2.86m)\n\n"
            let hosoku:String! = ""
            let gaitousyo = Set(arrayLiteral: "淀川", "消防局")
            text2.text = "1号:淀川,消防局\n2号:その他の署"
            setLevel5(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //高川 2020.06　追加(既存分を修正しないためcase 131-135)、2021.05改正
        //氾濫注意水位、水防警報(出動)
        case 131:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let title:String! = "■高川(水路橋)\n氾濫注意水位(水位1.5m)、水防警報(出動)\n\n"
            let gaitousyo = Set(arrayLiteral: "淀川", "消防局")
            text2.text = "淀川,消防局"
            var message:String! = ""
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo.contains(userDefaults.string(forKey: "mainStation")!){
                message = "\(mainStation)\n\n招集なし"
            } else {
                message = "ー\n\n招集なし"
            }
            text1.text = title + "第５非常警備\n\n" + message
            break
        //高齢者等避難発令の見込み
        case 132:
            let title:String! = "■高川(水路橋)\n高齢者等避難が発令される見込みとなったとき\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "淀川", "消防局")
            text2.text = "4号:淀川,消防局\n5号:その他の署"
            setLevel2(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //高齢者等避難
        case 133:
            let title:String! = "■高川(水路橋)\n 【警戒レベル３】\n高齢者等避難(水位1.62m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "淀川", "消防局")
            text2.text = "3号:淀川,消防局\n4号:その他の署"
            setLevel3(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //避難指示
        case 134:
            let title:String! = "■高川(水路橋)\n【警戒レベル４】\n避難指示(水位1.7m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "淀川", "消防局")
            text2.text = "2号:淀川,消防局\n3号:その他の署"
            setLevel4(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //緊急安全確保
        case 135:
            let title:String! = "■高川(水路橋)\n【警戒レベル５】\n緊急安全確保(水位3.6m)\n\n"
            let hosoku:String! = ""
            let gaitousyo = Set(arrayLiteral: "淀川", "消防局")
            text2.text = "1号:淀川,消防局\n2号:その他の署"
            setLevel5(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //安威川(千歳橋)
        //氾濫注意水位、水防警報(出動)
        case 41:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let title:String! = "■安威川(千歳橋)\n氾濫注意水位(水位3.25m)、水防警報(出動)\n\n"
            let gaitousyo = Set(arrayLiteral: "東淀川", "消防局")
            text2.text = "東淀川,消防局"
            var message:String! = ""
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo.contains(userDefaults.string(forKey: "mainStation")!){
                message = "\(mainStation)\n\n招集なし"
            } else {
                message = "ー\n\n招集なし"
            }
            text1.text = title + "第５非常警備\n\n" + message
            break
        //高齢者等避難発令の見込み
        case 42:
            let title:String! = "■安威川(千歳橋)\n高齢者等避難が発令される見込みとなったとき\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "東淀川", "消防局")
            text2.text = "4号:東淀川,消防局\n5号:その他の署"
            setLevel2(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //高齢者等避難
        case 43:
            let title:String! = "■安威川(千歳橋)\n 【警戒レベル３】\n高齢者等避難(水位3.5m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "東淀川", "消防局")
            text2.text = "3号:東淀川,消防局\n4号:その他の署"
            setLevel3(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //避難指示
        case 44:
            let title:String! = "■安威川(千歳橋)\n【警戒レベル４】\n避難指示(水位4.25m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "東淀川", "消防局")
            text2.text = "2号:東淀川,消防局\n3号:その他の署"
            setLevel4(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //緊急安全確保
        case 45:
            let title:String! = "■安威川(千歳橋)\n【警戒レベル５】\n緊急安全確保(水位5.1m)\n\n"
            let hosoku:String! = ""
            let gaitousyo = Set(arrayLiteral: "東淀川", "消防局")
            text2.text = "1号:東淀川,消防局\n2号:その他の署"
            setLevel5(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //寝屋川(京橋)
        //氾濫注意水位、水防警報(出動)
        case 51:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let title:String! = "■寝屋川(京橋)\n氾濫注意水位(水位3m)、水防警報(出動)\n\n"
            let gaitousyo = Set(arrayLiteral: "都島", "中央", "東成", "生野", "旭", "城東", "鶴見", "東住吉", "平野", "消防局")
            // 2020.09.07以前 let gaitousyo = Set(arrayLiteral: "都島", "中央", "城東", "鶴見", "消防局")
            text2.text = "都島,中央,城東,鶴見,消防局"
            var message:String! = ""
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo.contains(userDefaults.string(forKey: "mainStation")!){
                message = "\(mainStation)\n\n招集なし"
            } else {
                message = "ー\n\n招集なし"
            }
            text1.text = title + "第５非常警備\n\n" + message
            break
        //高齢者等避難発令の見込み
        case 52:
            let title:String! = "■寝屋川(京橋)\n高齢者等避難が発令される見込みとなったとき\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "都島", "中央", "東成", "生野", "旭", "城東", "鶴見", "東住吉", "平野", "消防局")
            text2.text = "4号:都島,中央,東成,生野,旭,城東,鶴見,東住吉,平野,消防局\n5号:その他の署"
            setLevel2(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //高齢者等避難
        case 53:
            let title:String! = "■寝屋川(京橋)\n 【警戒レベル３】\n高齢者等避難(水位3.1m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "都島", "中央", "東成", "生野", "旭", "城東", "鶴見", "東住吉", "平野", "消防局")
            text2.text = "3号:都島,中央,東成,生野,旭,城東,鶴見,東住吉,平野,消防局\n4号:その他の署"
            setLevel3(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //避難指示
        case 54:
            let title:String! = "■寝屋川(京橋)\n【警戒レベル４】\n避難指示(水位3.3m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "都島", "中央", "東成", "生野", "旭", "城東", "鶴見", "東住吉", "平野", "消防局")
            text2.text = "2号:都島,中央,東成,生野,旭,城東,鶴見,東住吉,平野,消防局\n3号:その他の署"
            setLevel4(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //緊急安全確保
        case 55:
            let title:String! = "■寝屋川(京橋)\n【警戒レベル５】\n緊急安全確保(水位3.5m)\n\n"
            let hosoku:String! = ""
            let gaitousyo = Set(arrayLiteral: "都島", "中央", "東成", "生野", "旭", "城東", "鶴見", "東住吉", "平野", "消防局")
            text2.text = "1号:都島,中央,東成,生野,旭,城東,鶴見,東住吉,平野,消防局\n2号:その他の署"
            setLevel5(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //第二寝屋川(昭明橋)
        //氾濫注意水位、水防警報(出動)
        case 61:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let title:String! = "■第二寝屋川(昭明橋)\n氾濫注意水位(水位3.4m)、水防警報(出動)\n\n"
            let gaitousyo = Set(arrayLiteral: "中央", "城東", "鶴見", "消防局")
            text2.text = "中央,城東,鶴見,消防局"
            var message:String! = ""
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo.contains(userDefaults.string(forKey: "mainStation")!){
                message = "\(mainStation)\n\n招集なし"
            } else {
                message = "ー\n\n招集なし"
            }
            text1.text = title + "第５非常警備\n\n" + message
            break
        //高齢者等避難発令の見込み
        case 62:
            let title:String! = "■第二寝屋川(昭明橋)\n高齢者等避難が発令される見込みとなったとき\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "中央", "東成", "城東", "鶴見", "消防局")
            text2.text = "4号:中央,東成,城東,鶴見,消防局\n5号:その他の署"
            setLevel2(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //高齢者等避難
        case 63:
            let title:String! = "■第二寝屋川(昭明橋)\n 【警戒レベル３】\n高齢者等避難(水位4.2m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "中央", "東成", "城東", "鶴見", "消防局")
            text2.text = "3号:中央,東成,城東,鶴見,消防局\n4号:その他の署"
            setLevel3(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //避難指示
        case 64:
            let title:String! = "■第二寝屋川(昭明橋)\n【警戒レベル４】\n避難指示(水位4.55m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "中央", "東成", "城東", "鶴見", "消防局")
            text2.text = "2号:中央,東成,城東,鶴見,消防局\n3号:その他の署"
            setLevel4(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //緊急安全確保
        case 65:
            let title:String! = "■第二寝屋川(昭明橋)\n【警戒レベル５】\n緊急安全確保(水位4.85m)\n\n"
            let hosoku:String! = ""
            let gaitousyo = Set(arrayLiteral: "中央", "東成", "城東", "鶴見", "消防局")
            text2.text = "1号:中央,東成,城東,鶴見,消防局\n2号:その他の署"
            setLevel5(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //平野川(剣橋)
        //氾濫注意水位、水防警報(出動)
        case 71:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let title:String! = "■平野川(剣橋)\n氾濫注意水位(水位3.3m)、水防警報(出動)\n\n"
            let gaitousyo = Set(arrayLiteral: "東成", "生野", "城東", "東住吉", "平野", "消防局")
            text2.text = "東成,生野,城東,東住吉,平野,消防局"
            var message:String! = ""
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo.contains(userDefaults.string(forKey: "mainStation")!){
                message = "\(mainStation)\n\n招集なし"
            } else {
                message = "ー\n\n招集なし"
            }
            text1.text = title + "第５非常警備\n\n" + message
            break
        //高齢者等避難発令の見込み
        case 72:
            let title:String! = "■平野川(剣橋)\n高齢者等避難が発令される見込みとなったとき\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "中央", "東成", "生野", "城東", "東住吉", "平野", "消防局")
            text2.text = "4号:中央,東成,生野,城東,東住吉,平野,消防局\n5号:その他の署"
            setLevel2(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //高齢者等避難
        case 73:
            let title:String! = "■平野川(剣橋)\n 【警戒レベル３】\n高齢者等避難(水位3.9m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "中央", "東成", "生野", "城東", "東住吉", "平野", "消防局")
            text2.text = "3号:中央,東成,生野,城東,東住吉,平野,消防局\n4号:その他の署"
            setLevel3(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //避難指示
        case 74:
            let title:String! = "■平野川(剣橋)\n【警戒レベル４】\n避難指示(水位4.15m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "中央", "東成", "生野", "城東", "東住吉", "平野", "消防局")
            text2.text = "2号:中央,東成,生野,城東,東住吉,平野,消防局\n3号:その他の署"
            setLevel4(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //緊急安全確保
        case 75:
            let title:String! = "■平野川(剣橋)\n【警戒レベル５】\n緊急安全確保(水位4.4m)\n\n"
            let hosoku:String! = ""
            let gaitousyo = Set(arrayLiteral: "中央", "東成", "生野", "城東", "東住吉", "平野", "消防局")
            text2.text = "1号:中央,東成,生野,城東,東住吉,平野,消防局\n2号:その他の署"
            setLevel5(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //平野川分水路(今里大橋)
        //氾濫注意水位、水防警報(出動)
        case 81:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let title:String! = "■平野川分水路(今里大橋)\n氾濫注意水位(水位3.3m)、水防警報(出動)\n\n"
            let gaitousyo = Set(arrayLiteral: "東成", "生野", "城東", "消防局")
            text2.text = "東成,生野,城東,消防局"
            var message:String! = ""
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo.contains(userDefaults.string(forKey: "mainStation")!){
                message = "\(mainStation)\n\n招集なし"
            } else {
                message = "ー\n\n招集なし"
            }
            text1.text = title + "第５非常警備\n\n" + message
            break
        //高齢者等避難発令の見込み
        case 82:
            let title:String! = "■平野川分水路(今里大橋)\n高齢者等避難が発令される見込みとなったとき\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "中央", "東成", "生野", "城東", "東住吉", "平野", "消防局")
            text2.text = "4号:中央,東成,生野,城東,東住吉,平野,消防局\n5号:その他の署"
            setLevel2(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //高齢者等避難
        case 83:
            let title:String! = "■平野川分水路(今里大橋)\n 【警戒レベル３】\n高齢者等避難(水位3.4m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "中央", "東成", "生野", "城東", "東住吉", "平野", "消防局")
            text2.text = "3号:中央,東成,生野,城東,東住吉,平野,消防局\n4号:その他の署"
            setLevel3(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //避難指示
        case 84:
            let title:String! = "■平野川分水路(今里大橋)\n【警戒レベル４】\n避難指示(水位3.85m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "中央", "東成", "生野", "城東", "東住吉", "平野", "消防局")
            text2.text = "2号:中央,東成,生野,城東,東住吉,平野,消防局\n3号:その他の署"
            setLevel4(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //緊急安全確保
        case 85:
            let title:String! = "■平野川分水路(今里大橋)\n【警戒レベル５】\n緊急安全確保(水位4.63m)\n\n"
            let hosoku:String! = ""
            let gaitousyo = Set(arrayLiteral: "中央", "東成", "生野", "城東", "東住吉", "平野", "消防局")
            text2.text = "1号:中央,東成,生野,城東,東住吉,平野,消防局\n2号:その他の署"
            setLevel5(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //古川(桑才) 2020.06 修正
        //氾濫注意水位、水防警報(出動)
        case 91:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let title:String! = "■古川(桑才)\n氾濫注意水位(水位3.2m)、水防警報(出動)\n\n"
            let gaitousyo = Set(arrayLiteral: "鶴見", "消防局")
            text2.text = "鶴見,消防局"
            var message:String! = ""
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo.contains(userDefaults.string(forKey: "mainStation")!){
                message = "\(mainStation)\n\n招集なし"
            } else {
                message = "ー\n\n招集なし"
            }
            text1.text = title + "第５非常警備\n\n" + message
            break
        //高齢者等避難発令の見込み
        case 92:
            let title:String! = "■古川(桑才)\n高齢者等避難が発令される見込みとなったとき\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "旭", "城東", "鶴見", "消防局")
            text2.text = "4号:旭,城東,鶴見,消防局\n5号:その他の署"
            setLevel2(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //高齢者等避難
        case 93:
            let title:String! = "■古川(桑才)\n 【警戒レベル３】\n高齢者等避難(水位3.3m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "旭", "城東", "鶴見", "消防局")
            text2.text = "3号:旭,城東,鶴見,消防局\n4号:その他の署"
            setLevel3(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //避難指示　２号、３号、４号判定
        case 94:
            let title:String! = "■古川(桑才)\n【警戒レベル４】\n避難指示(水位3.4m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "旭", "城東", "鶴見", "消防局")
            text2.text = "2号:旭,城東,鶴見,消防局\n3号:その他の署"
            setLevel4(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //緊急安全確保
        case 95:
            let title:String! = "■古川(桑才)\n【警戒レベル５】\n緊急安全確保(水位3.67m)\n\n"
            let hosoku:String! = ""
            let gaitousyo = Set(arrayLiteral: "旭", "城東", "鶴見", "消防局")
            text2.text = "1号:旭,城東,鶴見,消防局\n2号:その他の署"
            setLevel5(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //東除川(大堀上小橋)
        //氾濫注意水位、水防警報(出動)
        case 101:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let title:String! = "■東除川(大堀上小橋)\n氾濫注意水位(水位2.9m)、水防警報(出動)\n\n"
            let gaitousyo = Set(arrayLiteral: "平野", "消防局")
            text2.text = "平野,消防局"
            var message:String! = ""
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo.contains(userDefaults.string(forKey: "mainStation")!){
                message = "\(mainStation)\n\n招集なし"
            } else {
                message = "ー\n\n招集なし"
            }
            text1.text = title + "第５非常警備\n\n" + message
            break
        //高齢者等避難発令の見込み
        case 102:
            let title:String! = "■東除川(大堀上小橋)\n高齢者等避難が発令される見込みとなったとき\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "平野", "消防局")
            text2.text = "4号:平野,消防局\n5号:その他の署"
            setLevel2(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //高齢者等避難
        case 103:
            let title:String! = "■東除川(大堀上小橋)\n 【警戒レベル３】\n高齢者等避難(水位3.2m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "平野", "消防局")
            text2.text = "3号:平野,消防局\n4号:その他の署"
            setLevel3(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //避難指示　２号、４号判定　神崎川、東除川
        case 104:
            let title:String! = "■東除川(大堀上小橋)\n【警戒レベル４】\n避難指示(水位3.9m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "平野", "消防局")
            text2.text = "2号:平野,消防局\n3号:その他の署"
            setLevel4(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //緊急安全確保
        case 105:
            let title:String! = "■東除川(大堀上小橋)\n【警戒レベル５】\n緊急安全確保(水位5.3m)\n\n"
            let hosoku:String! = ""
            let gaitousyo = Set(arrayLiteral: "平野", "消防局")
            text2.text = "1号:平野,消防局\n2号:その他の署"
            setLevel5(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //石川(玉手橋) 2021.05　追加(既存分を修正しないためcase 151のみ)
        case 151:
            let title:String! = "■石川(玉手橋)\n【警戒レベル５】\n緊急安全確保(参考水位5.88m)\n\n"
            let hosoku:String! = ""
            let gaitousyo = Set(arrayLiteral: "平野", "消防局")
            text2.text = "1号:平野,消防局\n2号:その他の署"
            setLevel5(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //氾濫注意水位、水防警報(出動)        //西除川(布忍橋) 2020.06　追加(既存分を修正しないためcase 131-135)
        //氾濫注意水位、水防警報(出動)
        case 141:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let title:String! = "■西除川(布忍橋)\n氾濫注意水位(水位2.5m)、水防警報(出動)\n\n"
            let gaitousyo = Set(arrayLiteral: "東住吉", "平野", "消防局")
            text2.text = "東住吉,平野,消防局"
            var message:String! = ""
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo.contains(userDefaults.string(forKey: "mainStation")!){
                message = "\(mainStation)\n\n招集なし"
            } else {
                message = "ー\n\n招集なし"
            }
            text1.text = title + "第５非常警備\n\n" + message
            break
        //高齢者等避難発令の見込み
        case 142:
            let title:String! = "■西除川(布忍橋)\n高齢者等避難が発令される見込みとなったとき\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "東住吉", "平野", "消防局")
            text2.text = "4号:東住吉,平野,消防局\n5号:その他の署"
            setLevel2(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //高齢者等避難
        case 143:
            let title:String! = "■西除川(布忍橋)\n 【警戒レベル３】\n高齢者等避難(水位3.7m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "東住吉", "平野", "消防局")
            text2.text = "3号:東住吉,平野,消防局\n4号:その他の署"
            setLevel3(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //避難指示　２号、４号判定　神崎川、天竺川、高川、古川、東除川、西除川
        case 144:
            let title:String! = "■西除川(布忍橋)\n【警戒レベル４】\n避難指示(水位4m)\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "東住吉", "平野", "消防局")
            text2.text = "2号:東住吉,平野,消防局\n3号:その他の署"
            setLevel4(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //緊急安全確保
        case 145:
            let title:String! = "■西除川(布忍橋)\n【警戒レベル５】\n緊急安全確保(水位5.06m)\n\n"
            let hosoku:String! = ""
            let gaitousyo = Set(arrayLiteral: "東住吉", "平野", "消防局")
            text2.text = "1号:東住吉,平野,消防局\n2号:その他の署"
            setLevel5(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //高潮
        //氾濫注意水位、水防警報(出動)
        case 111:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let title:String! = "■高潮区域(水防警報(出動))\n\n"
            let gaitousyo = Set(arrayLiteral: "北", "都島", "福島", "此花", "中央","西","港","大正","浪速","西淀川", "淀川","住之江","西成","水上","消防局")
            text2.text = "北,都島,福島,此花,中央,西,港,大正,浪速,西淀川,淀川,住之江,西成,水上,消防局"
            var message:String! = ""
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo.contains(userDefaults.string(forKey: "mainStation")!){
                message = "\(mainStation)\n\n招集なし"
            } else {
                message = "ー\n\n招集なし"
            }
            text1.text = title + "第５非常警備\n\n" + message
            break
        //高齢者等避難発令の見込み
        case 112:
            let title:String! = "■高潮\n高齢者等避難が発令される見込みとなったとき\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "北", "都島", "福島", "此花", "中央","西","港","大正","天王寺","浪速","西淀川", "淀川", "東淀川", "旭", "城東","阿倍野","住之江","住吉","西成","水上","消防局")
            text2.text = "4号:北,都島,福島,此花,中央,西,港,大正,天王寺,浪速,西淀川,淀川,東淀川,旭,城東,阿倍野,住之江,住吉,西成,水上,消防局\n5号:その他の署"
            setLevel2(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //高齢者等避難
        case 113:
            let title:String! = "■高潮\n 【警戒レベル３】\n高齢者等避難\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "北", "都島", "福島", "此花", "中央","西","港","大正","天王寺","浪速","西淀川", "淀川", "東淀川", "旭", "城東","阿倍野","住之江","住吉","西成","水上","消防局")
            text2.text = "3号:北,都島,福島,此花,中央,西,港,大正,天王寺,浪速,西淀川,淀川,東淀川,旭,城東,阿倍野,住之江,住吉,西成,水上,消防局\n4号:その他の署"
            setLevel3(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //避難指示
        case 114:
            let title:String! = "■高潮\n【警戒レベル４】\n避難指示\n\n"
            let hosoku:String! = "※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            let gaitousyo = Set(arrayLiteral: "北", "都島", "福島", "此花", "中央","西","港","大正","天王寺","浪速","西淀川", "淀川", "東淀川", "旭", "城東","阿倍野","住之江","住吉","西成","水上","消防局")
            text2.text = "2号:北,都島,福島,此花,中央,西,港,大正,天王寺,浪速,西淀川,淀川,東淀川,旭,城東,阿倍野,住之江,住吉,西成,水上,消防局\n3号:その他の署"
            setLevel4(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
        //緊急安全確保
        case 115:
            let title:String! = "■高潮\n【警戒レベル５】\n緊急安全確保\n\n"
            let hosoku:String! = ""
            let gaitousyo = Set(arrayLiteral: "北", "都島", "福島", "此花", "中央","西","港","大正","天王寺","浪速","西淀川", "淀川", "東淀川", "旭", "城東","阿倍野","住之江","住吉","西成","水上","消防局")
            text2.text = "1号:北,都島,福島,此花,中央,西,港,大正,天王寺,浪速,西淀川,淀川,東淀川,旭,城東,阿倍野,住之江,住吉,西成,水上,消防局\n2号:その他の署"
            setLevel5(title: title, hosoku: hosoku, gaitousyo: gaitousyo)
            break
            
        default:
            text1.text=""
        }
        
        self.win1.addSubview(text1)
        self.win1.addSubview(text2)
        
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
        
        //戻るボタン生成
        btnBack.frame = CGRect(x: 0,y: 0,width: 100,height: 30)
        btnBack.backgroundColor = UIColor.blue
        btnBack.setTitle("戻る", for: UIControl.State())
        btnBack.setTitleColor(UIColor.white, for: UIControl.State())
        btnBack.layer.masksToBounds = true
        btnBack.layer.cornerRadius = 10.0
        btnBack.layer.position = CGPoint(x: self.win1.frame.width/2+60, y: self.win1.frame.height-20)
        btnBack.addTarget(self, action: #selector(self.onClickBack(_:)), for: .touchUpInside)
        self.win1.addSubview(btnBack)
        
        //該当署ボタン生成
        btnGaitousyo.frame = CGRect(x: 0,y: 0,width: 80,height: 30)
        btnGaitousyo.backgroundColor = UIColor.lightGray
        btnGaitousyo.setTitle("該当署", for: UIControl.State())
        btnGaitousyo.setTitleColor(UIColor.black, for: UIControl.State())
        btnGaitousyo.layer.masksToBounds = true
        btnGaitousyo.layer.cornerRadius = 0.0
        btnGaitousyo.layer.position = CGPoint(x: 56, y: self.win1.frame.height-145)
        btnGaitousyo.addTarget(self, action: #selector(self.onClickGaitousyo(_:)), for: .touchUpInside)
        self.win1.addSubview(btnGaitousyo)
    }
    
    //高齢者等避難が発令される見込みとなったとき
    func setLevel2(title: String, hosoku: String, gaitousyo: Set<String> ){
        var message:String! = ""
        //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
        if gaitousyo.contains(userDefaults.string(forKey: "mainStation")!){
            //４号招集なので、１号、２号、３号は参集なしの判定する
            if kubun == "４号招集" {
                if mainStation == "消防局" {
                    message = "４号非常招集\n\n\(mainStation)へ参集(所属担当者に確認すること)\n\n" + hosoku
                } else {
                    message = "４号非常招集\n\n\(mainStation)へ参集\n\n" + hosoku
                }
            } else {
                message = "招集なし"
            }
        } else {
            //その他の署は５号
            message = "第５非常警備\n\nー\n\n招集なし"
        }
        text1.text = title + message
    }
    
    //【警戒レベル３】高齢者等避難
    func setLevel3(title: String, hosoku: String, gaitousyo: Set<String>){
        var message:String! = ""
        if gaitousyo.contains(userDefaults.string(forKey: "mainStation")!){
            //３号招集対象者の判定
            if kubun == "３号招集" {
                if mainStation == "消防局" {
                    message = "３号非常招集(非番・日勤)\n\n\(mainStation)へ参集(所属担当者に確認すること)\n\n" + hosoku
                } else {
                    message = "３号非常招集(非番・日勤)\n\n\(mainStation)へ参集\n\n" + hosoku
                }
            } else if kubun == "４号招集" {
                if mainStation == "消防局" {
                    message = "３号非常招集(非番・日勤)\n\n\(mainStation)へ参集(所属担当者に確認すること)\n\n" + hosoku
                } else {
                    message = "３号非常招集(非番・日勤)\n\n\(mainStation)へ参集\n\n" + hosoku
                }
            } else {
                message = "招集なし"
            }
        } else {
            //該当署以外は４号招集なので、１号、２号、３号は参集なしの判定する
            if kubun == "４号招集" {
                if mainStation == "消防局" {
                    message = "４号非常招集\n\n\(mainStation)へ参集(所属担当者に確認すること)\n\n" + hosoku
                } else {
                    message = "４号非常招集\n\n\(mainStation)へ参集\n\n" + hosoku
                }
            } else {
                message = "招集なし"
            }
        }
        text1.text = title + message
    }
    
    //【警戒レベル４】避難指示
    func setLevel4(title: String, hosoku: String, gaitousyo: Set<String>){
        var message:String! = ""
        if gaitousyo.contains(userDefaults.string(forKey: "mainStation")!){
            //２号招集なので、１号は招集なしの判定する
            if kubun == "１号招集" {
                message = "招集なし"
            //２号、３号対象者は(非番・日勤)表示
            } else if kubun == "２号招集" || kubun == "３号招集" {
                    if mainStation == "消防局" || mainStation == "訓練センター" {
                        message = "２号非常招集(非番・日勤)\n\n\(mainStation)へ参集(所属担当者に確認すること)\n\n"
                    } else {
                        message = "２号非常招集(非番・日勤)\n\n\(mainStation)へ参集\n\n"
                    }
            //４号対象者
            } else {
                    if mainStation == "消防局" || mainStation == "訓練センター" {
                        message = "２号非常招集(非番・日勤)\n\n\(mainStation)へ参集(所属担当者に確認すること)\n\n"
                    } else {
                        message = "２号非常招集(非番・日勤)\n\n\(mainStation)へ参集\n\n"
                    }
            }
        } else {
            //該当署以外は３号招集なので、１号、２号は招集なしの判定する
            if kubun == "１号招集" || kubun == "２号招集" {
                message = "招集なし"
            //３号対象者は(非番・日勤)表示
            } else if kubun == "３号招集" {
                    if mainStation == "消防局" {
                        message = "３号非常招集(非番・日勤)\n\n\(mainStation)へ参集(所属担当者に確認すること)\n\n" + hosoku
                    } else {
                        message = "３号非常招集(非番・日勤)\n\n\(mainStation)へ参集\n\n" + hosoku
                    }
            //４号対象者
            } else {
                    if mainStation == "消防局" {
                        message = "３号非常招集(非番・日勤)\n\n\(mainStation)へ参集(所属担当者に確認すること)\n\n" + hosoku
                    } else {
                        message = "３号非常招集(非番・日勤)\n\n\(mainStation)へ参集\n\n" + hosoku
                    }
            }
        }
        text1.text = title + message
    }
    
    //【警戒レベル５】緊急安全確保
    func setLevel5(title: String, hosoku: String, gaitousyo: Set<String>){
        var message:String! = ""
        if gaitousyo.contains(userDefaults.string(forKey: "mainStation")!){
            //１号招集なので、全員(非番・日勤)表示
            if mainStation == "消防局" || mainStation == "訓練センター" {
                message = "１号非常招集\n\n\(mainStation)へ参集(所属担当者に確認すること)\n\n"
            } else {
                message = "１号非常招集\n\n\(mainStation)へ参集\n\n"
            }
        } else {
            //該当署以外は２号招集なので、１号は招集なしの判定する
            if kubun == "１号招集" {
                message = "招集なし"
            //２号、３号、４号対象者は(非番・日勤)表示
            } else {
                    if mainStation == "消防局" {
                        message = "２号非常招集(非番・日勤)\n\n\(mainStation)へ参集(所属担当者に確認すること)\n\n"
                    } else {
                        message = "２号非常招集(非番・日勤)\n\n\(mainStation)へ参集\n\n"
                    }
            }
        }
        text1.text = title + message
    }
    
    //該当署ボタン
    @objc func onClickGaitousyo(_ sender: UIButton){
        if (text2.isHidden) {
            text2.isHidden = false
        } else {
            text2.isHidden = true
        }
    }
    
    //閉じる
    @objc func onClickClose(_ sender: UIButton){
        win1.isHidden = true      //win1隠す
        text1.text = ""         //使い回しするのでテキスト内容クリア
        parent.view.alpha = 1.0 //元の画面明るく
        mViewController.view.alpha = 1.0 //明るく
    }
    
    //戻る
    @objc func onClickBack(_ sender: UIButton){
        win1.isHidden = true      //win1隠す
        text1.text = ""         //使い回しするのでテキスト内容クリア
        parent.view.alpha = 1.0 //元の画面明るく
        //
        switch backIndex {
        //淀川の水位選択に戻る
        case 1:
            mTyphoonSelectDialog2 = TyphoonSelectDialog2(index:1, parentView: parent)
            mTyphoonSelectDialog2.showInfo()
            break
        //大和川の水位選択に戻る
        case 2:
            mTyphoonSelectDialog2 = TyphoonSelectDialog2(index:2, parentView: parent)
            mTyphoonSelectDialog2.showInfo()
            break
        //神崎川の水位選択に戻る
        case 3:
            mTyphoonSelectDialog2 = TyphoonSelectDialog2(index:3, parentView: parent)
            mTyphoonSelectDialog2.showInfo()
            break
        //天竺川の水位選択に戻る
        case 12:
            mTyphoonSelectDialog2 = TyphoonSelectDialog2(index:12, parentView: parent)
            mTyphoonSelectDialog2.showInfo()
            break
        //古川の水位選択に戻る
        case 13:
            mTyphoonSelectDialog2 = TyphoonSelectDialog2(index:13, parentView: parent)
            mTyphoonSelectDialog2.showInfo()
            break
        //安威川の水位選択に戻る
        case 4:
            mTyphoonSelectDialog2 = TyphoonSelectDialog2(index:4, parentView: parent)
            mTyphoonSelectDialog2.showInfo()
            break
        //寝屋川の水位選択に戻る
        case 5:
            mTyphoonSelectDialog2 = TyphoonSelectDialog2(index:5, parentView: parent)
            mTyphoonSelectDialog2.showInfo()
            break
        //第二寝屋川の水位選択に戻る
        case 6:
            mTyphoonSelectDialog2 = TyphoonSelectDialog2(index:6, parentView: parent)
            mTyphoonSelectDialog2.showInfo()
            break
        //平野川の水位選択に戻る
        case 7:
            mTyphoonSelectDialog2 = TyphoonSelectDialog2(index:7, parentView: parent)
            mTyphoonSelectDialog2.showInfo()
            break
        //平野川分水路の水位選択に戻る
        case 8:
            mTyphoonSelectDialog2 = TyphoonSelectDialog2(index:8, parentView: parent)
            mTyphoonSelectDialog2.showInfo()
            break
        //古川の水位選択に戻る
        case 9:
            mTyphoonSelectDialog2 = TyphoonSelectDialog2(index:9, parentView: parent)
            mTyphoonSelectDialog2.showInfo()
            break
        //東除川の水位選択に戻る
        case 10:
            mTyphoonSelectDialog2 = TyphoonSelectDialog2(index:10, parentView: parent)
            mTyphoonSelectDialog2.showInfo()
            break
        //石川の水位選択に戻る
        case 15:
            mTyphoonSelectDialog2 = TyphoonSelectDialog2(index:15, parentView: parent)
            mTyphoonSelectDialog2.showInfo()
            break
        //西除川の水位選択に戻る
        case 14:
            mTyphoonSelectDialog2 = TyphoonSelectDialog2(index:14, parentView: parent)
            mTyphoonSelectDialog2.showInfo()
            break
        //高潮区域選択に戻る
        case 11:
            mTyphoonSelectDialog2 = TyphoonSelectDialog2(index:11, parentView: parent)
            mTyphoonSelectDialog2.showInfo()
            break
        default:
            break
        }
    }
}
