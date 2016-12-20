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
    private var parent: TyphoonViewController!
    private var win1: UIWindow!
    private var text1: UITextView!
    private var text2: UITextView!
    private var btnClose: UIButton!
    private var btnBack: UIButton!
    private var btnGaitousyo: UIButton!
    //データ保存用
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var mainStation: String!
    var tsunamiStation: String!
    var kubun: String!
    //戻るTyphoonSelectDialog2用
    var backIndex: Int!
    private var mTyphoonSelectDialog2: TyphoonSelectDialog2!
    
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
    func showResult(data :Int){
        //勤務消防署が保存されている場合は呼び出して格納
        if let _mainStation = userDefaults.stringForKey("mainStation"){
            if _mainStation == "消防局" || _mainStation == "教育訓練センター" {
                mainStation = _mainStation
            } else {
                mainStation = _mainStation + "消防署"
            }
        }
        //大津波・津波警報時参集指定署が保存されている場合は呼び出して格納
        if let _tsunamiStation = userDefaults.stringForKey("tsunamiStation"){
            if _tsunamiStation == "消防局" || _tsunamiStation == "教育訓練センター" {
                tsunamiStation = _tsunamiStation
            } else {
                tsunamiStation = _tsunamiStation + "消防署"
            }
        }
        //非常招集区分を呼び出して格納
        if let _kubun = userDefaults.stringForKey("kubun"){
            kubun = _kubun
        }
        //元の画面を暗く
        parent.view.alpha = 0.3
        //初期設定
        //Win1
        win1.backgroundColor = UIColor.whiteColor()
        win1.frame = CGRectMake(80,10,parent.view.frame.width-40,parent.view.frame.height/2+180)
        win1.layer.position = CGPointMake(parent.view.frame.width/2, parent.view.frame.height/2)
        win1.alpha = 1.0
        win1.layer.cornerRadius = 10
        //KeyWindowにする
        win1.makeKeyWindow()
        //表示
        self.win1.makeKeyAndVisible()
        
        //TextView生成
        text1.frame = CGRectMake(10,10, self.win1.frame.width - 20, self.win1.frame.height-60)
        text1.backgroundColor = UIColor.clearColor()
        text1.font = UIFont.systemFontOfSize(CGFloat(18))
        text1.textColor = UIColor.blackColor()
        text1.textAlignment = NSTextAlignment.Left
        text1.editable = false
        text1.scrollEnabled = true
        text1.dataDetectorTypes = .Link
        
        //該当署を表示するTextView生成
        text2.frame = CGRectMake(100,self.win1.frame.height/2+34, self.win1.frame.width/1.7, self.win1.frame.height/2+160)
        text2.backgroundColor = UIColor.clearColor()
        text2.font = UIFont.systemFontOfSize(CGFloat(12))
        text2.textColor = UIColor.blackColor()
        text2.textAlignment = NSTextAlignment.Left
        text2.editable = false
        text2.scrollEnabled = true
        text2.dataDetectorTypes = .Link
        text2.hidden = true //該当署ボタンを押すまで隠しておく
        
        //テキストの内容を場合分け
        switch data {
        //淀川（枚方）
        case 11:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let gaitousyo = Set(arrayLiteral: "北", "都島", "福島", "此花", "西淀川", "淀川", "東淀川", "旭", "消防局")
            text2.text = "北,都島,福島,此花,西淀川,淀川,東淀川,旭,消防局"
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo.contains(userDefaults.stringForKey("mainStation")!){
                text1.text="■淀川（枚方） 氾濫注意水位(水位4.5m)、水防警報(出動)\n\n第５非常警備(北,都島,福島,此花,西淀川,淀川,東淀川,旭,消防局)\n\n\(mainStation)\n\n招集なし"
            } else {
                text1.text="■淀川（枚方） 氾濫注意水位(水位4.5m)、水防警報(出動)\n\n第５非常警備(北,都島,福島,此花,西淀川,淀川,東淀川,旭,消防局)\n\nー\n\n招集なし"
            }
            break
        case 12:
            let gaitousyo = Set(arrayLiteral: "北", "都島", "福島", "此花", "西淀川", "淀川", "東淀川", "旭", "消防局")
            text2.text = "北,都島,福島,此花,西淀川,淀川,東淀川,旭,消防局"
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo.contains(userDefaults.stringForKey("mainStation")!){
                //４号招集なので、１号、２号、３号は参集なしの判定する
                if kubun == "４号招集" {
                    if mainStation == "消防局" {
                        text1.text="■淀川（枚方） 避難準備情報発令の見込み(1時間以内に水位5.4mに到達)\n\n４号招集(非番・日勤)\n\n\(mainStation)へ参集(所属担当者に確認すること)\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
                    } else {
                        text1.text="■淀川（枚方） 避難準備情報発令の見込み(1時間以内に水位5.4mに到達)\n\n４号招集(非番・日勤)\n\n\(mainStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
                    }
                } else {
                    text1.text="■淀川（枚方） 避難準備情報発令の見込み(1時間以内に水位5.4mに到達)\n\n４号招集(非番・日勤)\n\nー\n\n招集なし"
                }
            } else {
                text1.text="■淀川（枚方） 避難準備情報発令の見込み(1時間以内に水位5.4mに到達)\n\n４号招集(非番・日勤)\n\nー\n\n招集なし"
            }
            break
        case 13:
            let gaitousyo1 = Set(arrayLiteral: "北", "都島", "福島", "此花", "西淀川", "淀川", "東淀川", "旭", "消防局")
            let gaitousyo2 = Set(arrayLiteral: "中央", "西", "浪速", "東成", "生野", "城東", "鶴見", "西成")
            text2.text="流域署3号:北,都島,福島,此花,西淀川,淀川,東淀川,旭,消防局\n流域周辺署4号:中央,西,浪速,東成,生野,城東,鶴見,西成"
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo1.contains(userDefaults.stringForKey("mainStation")!){
                //３号招集なので、１号、２号は参集なしの判定する
                if kubun == "１号招集" || kubun == "２号招集" {
                    text1.text="■淀川（枚方） 避難準備情報(水位5.4m)\n\n３号招集(非番・日勤)\n\n招集なし"
                } else {
                    if mainStation == "消防局" {
                        text1.text="■淀川（枚方） 避難準備情報(水位5.4m)\n\n３号招集(非番・日勤)\n\n\(mainStation)へ参集(所属担当者に確認すること)\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
                    } else {
                        text1.text="■淀川（枚方） 避難準備情報(水位5.4m)\n\n３号招集(非番・日勤)\n\n\(mainStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
                    }
                }
            } else if gaitousyo2.contains(userDefaults.stringForKey("mainStation")!){
                //４号招集なので、１号、２号、３号は参集なしの判定する
                if kubun == "４号招集" {
                    if mainStation == "消防局" {
                        text1.text="■淀川（枚方） 避難準備情報(水位5.4m)\n\n４号招集(非番・日勤)\n\n\(mainStation)へ参集(所属担当者に確認すること)\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
                    } else {
                        text1.text="■淀川（枚方） 避難準備情報(水位5.4m)\n\n４号招集(非番・日勤)\n\n\(mainStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
                    }
                } else {
                    text1.text="■淀川（枚方） 避難準備情報(水位5.4m)\n\n４号招集(非番・日勤)\n\nー\n\n招集なし"
                }
            } else {
                text1.text="■淀川（枚方） 避難準備情報(水位5.4m)\n\n４号招集(非番・日勤)\n\nー\n\n招集なし"
            }
            break
        case 14:
            let gaitousyo1 = Set(arrayLiteral: "北", "都島", "福島", "此花", "西淀川", "淀川", "東淀川", "旭", "消防局")
            let gaitousyo2 = Set(arrayLiteral: "中央", "西", "浪速", "東成", "生野", "城東", "鶴見", "西成")
            let gaitousyo3 = Set(arrayLiteral: "港", "大正", "天王寺", "阿倍野", "住之江", "住吉", "東住吉", "平野", "水上")
            text2.text="流域署2号:北,都島,福島,此花,西淀川,淀川,東淀川,旭,消防局\n流域周辺署3号:中央,西,浪速,東成,生野,城東,鶴見,西成\nその他の署４号：港,大正,天王寺,阿倍野,住之江,住吉,東住吉,平野,水上"
            if gaitousyo1.contains(userDefaults.stringForKey("mainStation")!){
                //２号招集なので、１号は参集なしの判定する
                if kubun == "１号招集" {
                    text1.text="■淀川（枚方） 避難勧告(水位5.5m)\n\n２号招集(非番・日勤)\n\n招集なし"
                } else {
                    if mainStation == "消防局" {
                        text1.text="■淀川（枚方） 避難勧告(水位5.5m)\n\n２号招集(非番・日勤)\n\n\(mainStation)へ参集(所属担当者に確認すること)\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
                    } else {
                        text1.text="■淀川（枚方） 避難勧告(水位5.5m)\n\n２号招集(非番・日勤)\n\n\(mainStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
                    }
                }
            } else if gaitousyo2.contains(userDefaults.stringForKey("mainStation")!){
                //３号招集なので、１号、２号は参集なしの判定する
                if kubun == "１号招集" || kubun == "２号招集" {
                    text1.text="■淀川（枚方） 避難勧告(水位5.5m)\n\n３号招集(非番・日勤)\n\n招集なし"
                } else {
                    if mainStation == "消防局" {
                        text1.text="■淀川（枚方） 避難勧告(水位5.5m)\n\n３号招集(非番・日勤)\n\n\(mainStation)へ参集(所属担当者に確認すること)\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
                    } else {
                        text1.text="■淀川（枚方） 避難勧告(水位5.5m)\n\n３号招集(非番・日勤)\n\n\(mainStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
                    }
                }
            } else if gaitousyo3.contains(userDefaults.stringForKey("mainStation")!){
                //４号招集なので、１号、２号、３号は参集なしの判定する
                if kubun == "４号招集" {
                    if mainStation == "消防局" {
                        text1.text="■淀川（枚方） 避難勧告(水位5.5m)\n\n４号招集(非番・日勤)\n\n\(mainStation)へ参集(所属担当者に確認すること)\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
                    } else {
                        text1.text="■淀川（枚方） 避難勧告(水位5.5m)\n\n４号招集(非番・日勤)\n\n\(mainStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
                    }
                } else {
                    text1.text="■淀川（枚方） 避難勧告(水位5.5m)\n\n４号招集(非番・日勤)\n\nー\n\n招集なし"
                }
            } else {
                text1.text="■淀川（枚方） 避難勧告(水位5.5m)\n\n４号招集(非番・日勤)\n\nー\n\n招集なし"
            }
            break
        case 15:
            text2.text="２号:全署"
            //２号招集なので、１号は参集なしの判定する
            if kubun == "１号招集" {
                text1.text="■淀川（枚方） 避難指示(水位8.3m)\n\n２号招集(非番・日勤)\n\n招集なし"
            } else {
                if mainStation == "消防局" || mainStation == "教育訓練センター" {
                    text1.text="■淀川（枚方） 避難指示(水位8.3m)\n\n２号招集(非番・日勤)\n\n\(mainStation)へ参集(所属担当者に確認すること)\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
                } else {
                    text1.text="■淀川（枚方） 避難指示(水位8.3m)\n\n２号招集(非番・日勤)\n\n\(mainStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
                }
            }
            break
        //特別警報
        case 21:
            text1.text="■特別警報\n\n１号招集\n\n\(mainStation)へ参集"
            break
        //暴風（雪）警報
        case 22:
            //４号招集なので、１号、２号、３号は参集なしの判定する
            if kubun == "４号招集" {
                text1.text="■暴風(雪)警報\n\n４号招集(非番・日勤)\n\n\(mainStation)へ参集　所属担当者に確認すること\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            } else {
                text1.text="■暴風(雪)警報\n\n４号招集(非番・日勤)\n\n招集なし"
            }
            break
        //大雨警報
        case 23:
            if mainStation == "教育訓練センター" {
                text1.text="■大雨警報\n\n第５非常警備(全署、消防局)\n\nー\n\n招集なし"
            } else {
                text1.text="■大雨警報\n\n第５非常警備(全署、消防局)\n\n\(mainStation)\n\n招集なし"
            }
            break
        //大雪警報
        case 24:
            if mainStation == "教育訓練センター" {
                text1.text="■大雪警報\n\n第５非常警備(全署、消防局)\n\nー\n\n招集なし"
            } else {
                text1.text="■大雪警報\n\n第５非常警備(全署、消防局)\n\n\(mainStation)\n\n招集なし"
            }
            break
        //洪水警報
        case 25:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let gaitousyo = Set(arrayLiteral: "北", "都島", "福島", "此花", "中央", "西淀川", "淀川", "東淀川", "東成", "生野", "旭", "城東", "鶴見", "住之江", "住吉", "東住吉", "平野", "消防局")
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo.contains(userDefaults.stringForKey("mainStation")!){
                text1.text="■洪水警報\n\n第５非常警備(北、都島、福島、此花、中央、西淀川、淀川、東淀川、東成、生野、旭、城東、鶴見、住之江、住吉、東住吉、平野、消防局)\n\n\(mainStation)\n\n招集なし"
            } else {
                text1.text="■洪水警報\n\n第５非常警備(北、都島、福島、此花、中央、西淀川、淀川、東淀川、東成、生野、旭、城東、鶴見、住之江、住吉、東住吉、平野、消防局)\n\nー\n\n招集なし"
            }
            break
        //波浪警報
        case 26:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let gaitousyo = Set(arrayLiteral: "此花", "港", "大正", "西淀川", "住之江", "水上", "消防局")
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo.contains(userDefaults.stringForKey("mainStation")!){
                text1.text="■波浪警報\n\n第５非常警備(此花、港、大正、西淀川、住之江、水上、消防局)\n\n\(mainStation)\n\n招集なし"
            } else {
                text1.text="■洪水警報\n\n第５非常警備(此花、港、大正、西淀川、住之江、水上、消防局)\n\nー\n\n招集なし"
            }
            break
        //高潮警報
        case 27:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let gaitousyo = Set(arrayLiteral: "北", "都島", "福島", "此花", "中央", "西", "港", "大正", "浪速", "西淀川", "淀川", "住之江", "西成", "水上", "消防局")
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo.contains(userDefaults.stringForKey("mainStation")!){
                text1.text="■高潮警報\n\n第５非常警備(北、都島、福島、此花、中央、西、港、大正、浪速、西淀川、淀川、住之江、西成、水上、消防局)\n\n\(mainStation)\n\n招集なし"
            } else {
                text1.text="■高潮警報\n\n第５非常警備(北、都島、福島、此花、中央、西、港、大正、浪速、西淀川、淀川、住之江、西成、水上、消防局)\n\nー\n\n招集なし"
            }
            break
        //高潮注意報
        case 28:
            //勤務消防署がリストに該当するか判定　あえて大津波・津波警報時参集指定署ではないことに注意！
            let gaitousyo = Set(arrayLiteral: "北", "都島", "福島", "此花", "中央", "西", "港", "大正", "浪速", "西淀川", "淀川", "住之江", "西成", "水上", "消防局")
            //mainStationではすでに「消防署」の文字列を付け足してしまっているので上記リストとの比較はuserDefaultの格納値を使う
            if gaitousyo.contains(userDefaults.stringForKey("mainStation")!){
                text1.text="■高潮注意報\n\n第５非常警備(北、都島、福島、此花、中央、西、港、大正、浪速、西淀川、淀川、住之江、西成、水上、消防局)\n\n\(mainStation)\n\n招集なし"
            } else {
                text1.text="■高潮注意報\n\n第５非常警備(北、都島、福島、此花、中央、西、港、大正、浪速、西淀川、淀川、住之江、西成、水上、消防局)\n\nー\n\n招集なし"
            }
            break
        //
        case 31:
            text1.text="■大津波警報\n\n１号招集\n\n\(tsunamiStation)へ参集"
            break
        case 32:
            //３号招集なので、１号、２号は参集なしの判定する
            if kubun == "１号招集" || kubun == "２号招集" {
                text1.text="■津波警報\n\n３号招集(非番・日勤)\n\n招集なし"
            } else {
                text1.text="■津波警報\n\n３号招集(非番・日勤)\n\n\(tsunamiStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            }
            break
        case 33:
            //３号招集なので、１号、２号は参集なしの判定する
            if kubun == "１号招集" || kubun == "２号招集" {
                text1.text="■警報なし\n\n３号招集(非番・日勤)\n\n招集なし"
            } else {
                text1.text="■警報なし\n\n３号招集(非番・日勤)\n\n\(mainStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            }
            break
        //
        case 41:
            text1.text="■大津波警報\n\n１号招集\n\n\(tsunamiStation)へ参集"
            break
        case 42:
            //３号招集なので、１号、２号は参集なしの判定する
            if kubun == "１号招集" || kubun == "２号招集" {
                text1.text="■津波警報\n\n３号招集(非番・日勤)\n\n招集なし"
            } else {
                text1.text="■津波警報\n\n３号招集(非番・日勤)\n\n\(tsunamiStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
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
                text1.text="■警戒宣言が発令されたとき（東海地震予知情報）\n\n３号招集(非番・日勤)\n\n招集なし"
            } else {
                text1.text="■警戒宣言が発令されたとき（東海地震予知情報）\n\n３号招集(非番・日勤)\n\n\(mainStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            }
            break
        case 52:
            //４号招集なので、１号、２号、３号は参集なしの判定する
            if kubun == "４号招集" {
                text1.text="■東海地震注意報が発表されたとき\n\n４号招集(非番・日勤)\n\n\(mainStation)へ参集\n\n※平日の9時～17時30分は、原則、勤務中の毎日勤務者で活動体制を確保する"
            } else {
                text1.text="■東海地震注意報が発表されたとき\n\n４号招集(非番・日勤)\n\n招集なし"
            }
            break
        case 53:
            text1.text="■東海地震に関連する調査情報（臨時）が発表されたとき\n\n第５非常警備(全署、消防局)\n\n\(mainStation)\n\n招集なし"
            break
            
        default:
            text1.text=""
        }
        
        self.win1.addSubview(text1)
        self.win1.addSubview(text2)
        
        //閉じるボタン生成
        btnClose.frame = CGRectMake(0,0,100,30)
        btnClose.backgroundColor = UIColor.orangeColor()
        btnClose.setTitle("閉じる", forState: .Normal)
        btnClose.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnClose.layer.masksToBounds = true
        btnClose.layer.cornerRadius = 10.0
        btnClose.layer.position = CGPointMake(self.win1.frame.width/2-60, self.win1.frame.height-20)
        btnClose.addTarget(self, action: #selector(self.onClickClose(_:)), forControlEvents: .TouchUpInside)
        self.win1.addSubview(btnClose)
        
        //戻るボタン生成
        btnBack.frame = CGRectMake(0,0,100,30)
        btnBack.backgroundColor = UIColor.blueColor()
        btnBack.setTitle("戻る", forState: .Normal)
        btnBack.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnBack.layer.masksToBounds = true
        btnBack.layer.cornerRadius = 10.0
        btnBack.layer.position = CGPointMake(self.win1.frame.width/2+60, self.win1.frame.height-20)
        btnBack.addTarget(self, action: #selector(self.onClickBack(_:)), forControlEvents: .TouchUpInside)
        self.win1.addSubview(btnBack)
        
        //該当署ボタン生成
        btnGaitousyo.frame = CGRectMake(0,0,80,30)
        btnGaitousyo.backgroundColor = UIColor.grayColor()
        btnGaitousyo.setTitle("該当署", forState: .Normal)
        btnGaitousyo.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btnGaitousyo.layer.masksToBounds = true
        btnGaitousyo.layer.cornerRadius = 0.0
        btnGaitousyo.layer.position = CGPointMake(56, self.win1.frame.height/2+60)
        btnGaitousyo.addTarget(self, action: #selector(self.onClickGaitousyo(_:)), forControlEvents: .TouchUpInside)
        self.win1.addSubview(btnGaitousyo)
    }
    
    //該当署ボタン
    @objc func onClickGaitousyo(sender: UIButton){
        if (text2.hidden) {
            text2.hidden = false
        } else {
            text2.hidden = true
        }
    }
    
    //閉じる
    @objc func onClickClose(sender: UIButton){
        win1.hidden = true      //win1隠す
        text1.text = ""         //使い回しするのでテキスト内容クリア
        parent.view.alpha = 1.0 //元の画面明るく
    }
    
    //戻る
    @objc func onClickBack(sender: UIButton){
        win1.hidden = true      //win1隠す
        text1.text = ""         //使い回しするのでテキスト内容クリア
        parent.view.alpha = 1.0 //元の画面明るく
        //
        switch backIndex {
        case 1:
            //淀川の水位選択に戻る
            mTyphoonSelectDialog2 = TyphoonSelectDialog2(index:1, parentView: parent)
            mTyphoonSelectDialog2.showInfo()
            break
        case 2:
            mTyphoonSelectDialog2 = TyphoonSelectDialog2(index:2, parentView: parent)
            mTyphoonSelectDialog2.showInfo()
            break
        default:
            break
        }
    }
}