//
//  KinentaiViewController.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2016/09/11.
//  Copyright © 2016年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class KinentaiViewController: UIViewController {
    //メイン画面
    let lblKinentai     = UILabel(frame: CGRect.zero)
    let btnKinentai1    = UIButton(frame: CGRect.zero)
    let btnKinentai2    = UIButton(frame: CGRect.zero)
    let btnKinentai3    = UIButton(frame: CGRect.zero)
    let btnKinentai4    = UIButton(frame: CGRect.zero)
    let btnKinentai5    = UIButton(frame: CGRect.zero)
    let padY1           = UIView(frame: CGRect.zero) //ボタンの間にはさむ見えないpaddingがわり
    let padY2           = UIView(frame: CGRect.zero)
    let padY3           = UIView(frame: CGRect.zero)
    let padY4           = UIView(frame: CGRect.zero)
    let padY5           = UIView(frame: CGRect.zero)
    let padY6           = UIView(frame: CGRect.zero)
    let btnKinentaiEarthquake = UIButton(frame: CGRect.zero)
    let btnKinentaiBlackout   = UIButton(frame: CGRect.zero)
    let btnKinentaiRoad       = UIButton(frame: CGRect.zero)
    let btnKinentaiTel        = UIButton(frame: CGRect.zero)
    let btnKinentaiRiver      = UIButton(frame: CGRect.zero)
    let btnKinentaiWeather    = UIButton(frame: CGRect.zero)
    let btnKinentaiKinen      = UIButton(frame: CGRect.zero)
    let pad21            = UIView(frame: CGRect.zero) //ボタンの間にはさむ見えないpaddingがわり
    let pad22            = UIView(frame: CGRect.zero)
    let pad23            = UIView(frame: CGRect.zero)
    let pad31            = UIView(frame: CGRect.zero) //ボタンの間にはさむ見えないpaddingがわり
    let pad32            = UIView(frame: CGRect.zero)
    let pad33            = UIView(frame: CGRect.zero)
    //別クラスのインスタンス保持用変数
    fileprivate var mInfoDialog: InfoDialog!
    fileprivate var mKinentaiSelectDialog: KinentaiSelectDialog!
    fileprivate var mKinentaiSelectDialogSingleMultiple: KinentaiSelectDialogSingleMultiple!
    fileprivate var mKinentaiSelectDialog2: KinentaiSelectDialog2!
    fileprivate var mPassInputDialog: PassInputDialog!
    //結果表示用クラス保持用
    internal var mEarthResultDialog: EarthResultDialog!
    //データ保存用
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.8, green:0.15, blue:0.1, alpha:1.0)
        //Button生成
        //緊急消防援助隊出場基準表
        lblKinentai.text = "緊急消防援助隊出場基準表"
        lblKinentai.textColor = UIColor.yellow
        lblKinentai.textAlignment = NSTextAlignment.center
        lblKinentai.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblKinentai)
        //地震(震央「陸」)
        btnKinentai1.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKinentai1.layer.masksToBounds = true
        btnKinentai1.setTitle("地震(震央「陸」)", for: UIControl.State())
        btnKinentai1.setTitleColor(UIColor.black, for: UIControl.State())
        btnKinentai1.setTitleColor(UIColor.red, for: UIControl.State.highlighted)
        btnKinentai1.tag=5
        btnKinentai1.translatesAutoresizingMaskIntoConstraints = false
        btnKinentai1.addTarget(self, action: #selector(self.showSelectKinentai1(_:)), for: .touchUpInside)
        self.view.addSubview(btnKinentai1)
        //地震(震央「海」)
        btnKinentai2.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKinentai2.layer.masksToBounds = true
        btnKinentai2.setTitle("地震(震央「海域」)", for: UIControl.State())
        btnKinentai2.setTitleColor(UIColor.black, for: UIControl.State())
        btnKinentai2.tag=6
        btnKinentai2.translatesAutoresizingMaskIntoConstraints = false
        btnKinentai2.addTarget(self, action: #selector(self.showSelectKinentai2(_:)), for: .touchUpInside)
        self.view.addSubview(btnKinentai2)
        //アクションプラン
        btnKinentai3.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKinentai3.layer.masksToBounds = true
        btnKinentai3.setTitle("アクションプラン", for: UIControl.State())
        btnKinentai3.setTitleColor(UIColor.black, for: UIControl.State())
        btnKinentai3.tag=7
        btnKinentai3.translatesAutoresizingMaskIntoConstraints = false
        btnKinentai3.addTarget(self, action: #selector(self.showSelectKinentai3(_:)), for: .touchUpInside)
        self.view.addSubview(btnKinentai3)
        //大津波警報
        btnKinentai4.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKinentai4.layer.masksToBounds = true
        btnKinentai4.setTitle("大津波警報", for: UIControl.State())
        btnKinentai4.setTitleColor(UIColor.black, for: UIControl.State())
        btnKinentai4.tag=8
        btnKinentai4.translatesAutoresizingMaskIntoConstraints = false
        btnKinentai4.addTarget(self, action: #selector(self.showSelectKinentai4(_:)), for: .touchUpInside)
        self.view.addSubview(btnKinentai4)
        //2020-10-31 追加
        btnKinentai5.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKinentai5.layer.masksToBounds = true
        btnKinentai5.setTitle("噴火警報(居住区域)", for: UIControl.State())
        btnKinentai5.setTitleColor(UIColor.black, for: UIControl.State())
        btnKinentai5.tag=9
        btnKinentai5.translatesAutoresizingMaskIntoConstraints = false
        btnKinentai5.addTarget(self, action: #selector(self.showSelectKinentai5(_:)), for: .touchUpInside)
        self.view.addSubview(btnKinentai5)
        /* 2020-04-24 削除
        //特殊災害(NBC含む)
        btnKinentai5.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKinentai5.layer.masksToBounds = true
        btnKinentai5.setTitle("特殊災害(NBC含む)", for: UIControl.State())
        btnKinentai5.setTitleColor(UIColor.black, for: UIControl.State())
        btnKinentai5.tag=9
        btnKinentai5.translatesAutoresizingMaskIntoConstraints = false
        btnKinentai5.addTarget(self, action: #selector(self.showSelectKinentai5(_:)), for: .touchUpInside)
        self.view.addSubview(btnKinentai5)
        */
        //垂直方向のpad
        padY1.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(padY1)
        padY2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(padY2)
        padY3.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(padY3)
        padY4.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(padY4)
        padY5.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(padY5)
        padY6.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(padY6)
        //情報（地震）
        btnKinentaiEarthquake.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKinentaiEarthquake.layer.masksToBounds = true
        btnKinentaiEarthquake.setTitle("情報(地震)", for: UIControl.State())
        btnKinentaiEarthquake.setTitleColor(UIColor.black, for: UIControl.State())
        btnKinentaiEarthquake.setTitleColor(UIColor.red, for: UIControl.State.highlighted)
        btnKinentaiEarthquake.tag=10
        btnKinentaiEarthquake.translatesAutoresizingMaskIntoConstraints = false
        btnKinentaiEarthquake.addTarget(self, action: #selector(self.showInfoEarthquake(_:)), for: .touchUpInside)
        self.view.addSubview(btnKinentaiEarthquake)
        //情報(停電)
        btnKinentaiBlackout.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKinentaiBlackout.layer.masksToBounds = true
        btnKinentaiBlackout.setTitle("情報(停電)", for: UIControl.State())
        btnKinentaiBlackout.setTitleColor(UIColor.black, for: UIControl.State())
        btnKinentaiBlackout.setTitleColor(UIColor.red, for: UIControl.State.highlighted)
        btnKinentaiBlackout.tag=11
        btnKinentaiBlackout.translatesAutoresizingMaskIntoConstraints = false
        btnKinentaiBlackout.addTarget(self, action: #selector(self.showInfoBlackout(_:)), for: .touchUpInside)
        self.view.addSubview(btnKinentaiBlackout)
        //情報(道路)
        btnKinentaiRoad.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKinentaiRoad.layer.masksToBounds = true
        btnKinentaiRoad.setTitle("情報(道路)", for: UIControl.State())
        btnKinentaiRoad.setTitleColor(UIColor.black, for: UIControl.State())
        btnKinentaiRoad.setTitleColor(UIColor.red, for: UIControl.State.highlighted)
        btnKinentaiRoad.tag=12
        btnKinentaiRoad.translatesAutoresizingMaskIntoConstraints = false
        btnKinentaiRoad.addTarget(self, action: #selector(self.showInfoRoad(_:)), for: .touchUpInside)
        self.view.addSubview(btnKinentaiRoad)
        //連絡網
        btnKinentaiTel.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKinentaiTel.layer.masksToBounds = true
        btnKinentaiTel.setTitle("連絡網", for: UIControl.State())
        btnKinentaiTel.setTitleColor(UIColor.black, for: UIControl.State())
        btnKinentaiTel.tag=13
        btnKinentaiTel.translatesAutoresizingMaskIntoConstraints = false
        btnKinentaiTel.addTarget(self, action: #selector(self.showContactLoad(_:)), for: .touchUpInside)
        self.view.addSubview(btnKinentaiTel)
        //情報(河川)
        btnKinentaiRiver.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKinentaiRiver.layer.masksToBounds = true
        btnKinentaiRiver.setTitle("情報(河川)", for: UIControl.State())
        btnKinentaiRiver.setTitleColor(UIColor.black, for: UIControl.State())
        btnKinentaiRiver.setTitleColor(UIColor.red, for: UIControl.State.highlighted)
        btnKinentaiRiver.tag=14
        btnKinentaiRiver.translatesAutoresizingMaskIntoConstraints = false
        btnKinentaiRiver.addTarget(self, action: #selector(self.showInfoRiver(_:)), for: .touchUpInside)
        self.view.addSubview(btnKinentaiRiver)
        //情報(気象)
        btnKinentaiWeather.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKinentaiWeather.layer.masksToBounds = true
        btnKinentaiWeather.setTitle("情報(気象)", for: UIControl.State())
        btnKinentaiWeather.setTitleColor(UIColor.black, for: UIControl.State())
        btnKinentaiWeather.tag=15
        btnKinentaiWeather.translatesAutoresizingMaskIntoConstraints = false
        btnKinentaiWeather.addTarget(self, action: #selector(self.showInfoWeather(_:)), for: .touchUpInside)
        self.view.addSubview(btnKinentaiWeather)
        //情報(緊援)
        btnKinentaiKinen.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKinentaiKinen.layer.masksToBounds = true
        btnKinentaiKinen.setTitle("情報(緊援)", for: UIControl.State())
        btnKinentaiKinen.setTitleColor(UIColor.black, for: UIControl.State())
        btnKinentaiKinen.tag=16
        btnKinentaiKinen.translatesAutoresizingMaskIntoConstraints = false
        btnKinentaiKinen.addTarget(self, action: #selector(self.showInfoKinen(_:)), for: .touchUpInside)
        self.view.addSubview(btnKinentaiKinen)
        //pad
        pad21.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pad21)
        pad22.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pad22)
        pad23.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pad23)
        //pad
        pad31.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pad31)
        pad32.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pad32)
        pad33.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pad33)
        
        //ボタン押したら表示するDialog生成
        mInfoDialog = InfoDialog(parentView: self) //このViewControllerを渡してあげる
        mPassInputDialog = PassInputDialog(parentView: self)
        
        //passCheckをfalseで初期化
        userDefaults.set(false, forKey: "passCheck")
    }
    
    //制約ひな型
    func Constraint(_ item: AnyObject, _ attr: NSLayoutConstraint.Attribute, to: AnyObject?, _ attrTo: NSLayoutConstraint.Attribute, constant: CGFloat = 0.0, multiplier: CGFloat = 1.0, relate: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = UILayoutPriority.required) -> NSLayoutConstraint {
        let ret = NSLayoutConstraint(
            item:       item,
            attribute:  attr,
            relatedBy:  relate,
            toItem:     to,
            attribute:  attrTo,
            multiplier: multiplier,
            constant:   constant
        )
        ret.priority = priority
        return ret
    }
    
    override func viewDidLayoutSubviews(){
        //制約
        self.view.addConstraints([
            //緊急消防援助隊出場基準表ラベル
            Constraint(lblKinentai, .bottom, to:padY2, .top, constant:0),
            Constraint(lblKinentai, .centerX, to:self.view, .centerX, constant:8),
            Constraint(lblKinentai, .width, to:self.view, .width, constant:0, multiplier:0.8)
        ])
        self.view.addConstraints([
            //padY2
            Constraint(padY2, .bottom, to:btnKinentai1, .top, constant:0),
            Constraint(padY2, .leading, to:self.view, .leading, constant:0),
            Constraint(padY2, .height, to:self.view, .height, constant:0, multiplier:0.03)
        ])
        self.view.addConstraints([
            //地震(震央「陸」)
            Constraint(btnKinentai1, .bottom, to:padY3, .top, constant:0),
            Constraint(btnKinentai1, .centerX, to:self.view, .centerX, constant:8),
            Constraint(btnKinentai1, .width, to:self.view, .width, constant:0, multiplier:0.8)
        ])
        self.view.addConstraints([
            //padY3
            Constraint(padY3, .bottom, to:btnKinentai2, .top, constant:0),
            Constraint(padY3, .leading, to:self.view, .leading, constant:0),
            Constraint(padY3, .height, to:self.view, .height, constant:0, multiplier:0.03)
        ])
        self.view.addConstraints([
            //地震(震央「海」)
            Constraint(btnKinentai2, .bottom, to:padY4, .top, constant:0),
            Constraint(btnKinentai2, .centerX, to:self.view, .centerX, constant:8),
            Constraint(btnKinentai2, .width, to:self.view, .width, constant:0, multiplier:0.8)
        ])
        self.view.addConstraints([
            //padY4
            Constraint(padY4, .bottom, to:btnKinentai3, .top, constant:0),
            Constraint(padY4, .leading, to:self.view, .leading, constant:0),
            Constraint(padY4, .height, to:self.view, .height, constant:0, multiplier:0.03)
        ])
        self.view.addConstraints([
            //アクションプラン　Y座標の中心　-72に留意
            Constraint(btnKinentai3, .centerY, to:self.view, .centerY, constant:-72),
            Constraint(btnKinentai3, .centerX, to:self.view, .centerX, constant:8),
            Constraint(btnKinentai3, .width, to:self.view, .width, constant:0, multiplier:0.8)
        ])
        self.view.addConstraints([
            //padY5
            Constraint(padY5, .top, to:btnKinentai3, .bottom, constant:0),
            Constraint(padY5, .leading, to:self.view, .leading, constant:0),
            Constraint(padY5, .height, to:self.view, .height, constant:0, multiplier:0.03)
        ])
        self.view.addConstraints([
            //大津波警報・噴火
            Constraint(btnKinentai4, .top, to:padY5, .bottom, constant:0),
            Constraint(btnKinentai4, .centerX, to:self.view, .centerX, constant:8),
            Constraint(btnKinentai4, .width, to:self.view, .width, constant:0, multiplier:0.8)
        ])
        self.view.addConstraints([
            //padY6
            Constraint(padY6, .top, to:btnKinentai4, .bottom, constant:0),
            Constraint(padY6, .leading, to:self.view, .leading, constant:0),
            Constraint(padY6, .height, to:self.view, .height, constant:0, multiplier:0.03)
        ])
        //2021-10-31 追加
        self.view.addConstraints([
            //噴火
            Constraint(btnKinentai5, .top, to:padY6, .bottom, constant:0),
            Constraint(btnKinentai5, .centerX, to:self.view, .centerX, constant:8),
            Constraint(btnKinentai5, .width, to:self.view, .width, constant:0, multiplier:0.8)
        ])
        /* 2020-04-24 削除
        self.view.addConstraints([
            //特殊災害(NBC含む)
            Constraint(btnKinentai5, .top, to:padY6, .bottom, constant:0),
            Constraint(btnKinentai5, .centerX, to:self.view, .centerX, constant:8),
            Constraint(btnKinentai5, .width, to:self.view, .width, constant:0, multiplier:0.8)
        ])
        */
        self.view.addConstraints([
            //pad21
            Constraint(pad21, .bottom, to:btnKinentaiTel, .top, constant:-8),
            Constraint(pad21, .leading, to:self.view, .leading, constant:0),
            Constraint(pad21, .width, to:self.view, .width, constant:0, multiplier:0.024)
        ])
        self.view.addConstraints([
            //情報(地震)ボタン
            Constraint(btnKinentaiEarthquake, .bottom, to:btnKinentaiTel, .top, constant:-8),
            Constraint(btnKinentaiEarthquake, .leading, to:pad21, .trailing, constant:0),
            Constraint(btnKinentaiEarthquake, .width, to:self.view, .width, constant:0, multiplier:0.3)
        ])
        self.view.addConstraints([
            //pad22
            Constraint(pad22, .bottom, to:btnKinentaiTel, .top, constant:-8),
            Constraint(pad22, .leading, to:btnKinentaiEarthquake, .trailing, constant:0),
            Constraint(pad22, .width, to:self.view, .width, constant:0, multiplier:0.024)
        ])
        self.view.addConstraints([
            //情報(停電)ボタン
            Constraint(btnKinentaiBlackout, .bottom, to:btnKinentaiTel, .top, constant:-8),
            Constraint(btnKinentaiBlackout, .leading, to:pad22, .trailing, constant:0),
            Constraint(btnKinentaiBlackout, .width, to:btnKinentaiEarthquake, .width, constant:0)
        ])
        self.view.addConstraints([
            //pad23
            Constraint(pad23, .bottom, to:btnKinentaiTel, .top, constant:-8),
            Constraint(pad23, .leading, to:btnKinentaiBlackout, .trailing, constant:0),
            Constraint(pad23, .width, to:self.view, .width, constant:0, multiplier:0.024)
        ])
        self.view.addConstraints([
            //情報(道路)ボタン
            Constraint(btnKinentaiRoad, .bottom, to:btnKinentaiTel, .top ,constant:-8),
            Constraint(btnKinentaiRoad, .leading, to:pad23, .trailing, constant:0),
            Constraint(btnKinentaiRoad, .width, to:btnKinentaiEarthquake, .width, constant:0)
        ])
        self.view.addConstraints([
            //pad31
            Constraint(pad31, .top, to:btnKinentaiEarthquake, .bottom, constant:8),
            Constraint(pad31, .leading, to:self.view, .leading, constant:0),
            Constraint(pad31, .width, to:self.view, .width, constant:0, multiplier:0.024)
        ])
        self.view.addConstraints([
            //連絡網ボタン
            Constraint(btnKinentaiTel, .bottom, to:self.view, .bottom, constant:-8),
            Constraint(btnKinentaiTel, .leading, to:pad31, .trailing, constant:0),
            Constraint(btnKinentaiTel, .width, to:self.view, .width, constant:0, multiplier:0.3)
        ])
        self.view.addConstraints([
            //pad32
            Constraint(pad32, .bottom, to:self.view, .bottom, constant:-8),
            Constraint(pad32, .leading, to:btnKinentaiTel, .trailing, constant:0),
            Constraint(pad32, .width, to:self.view, .width, constant:0, multiplier:0.024)
        ])
        self.view.addConstraints([
            //情報(河川)
            Constraint(btnKinentaiRiver, .bottom, to:self.view, .bottom, constant:-8),
            Constraint(btnKinentaiRiver, .leading, to:pad32, .trailing, constant:0),
            Constraint(btnKinentaiRiver, .width, to:btnKinentaiTel, .width, constant:0)
        ])
        self.view.addConstraints([
            //pad33
            Constraint(pad33, .bottom, to:self.view, .bottom, constant:-8),
            Constraint(pad33, .leading, to:btnKinentaiRiver, .trailing, constant:0),
            Constraint(pad33, .width, to:self.view, .width, constant:0, multiplier:0.024)
        ])
        self.view.addConstraints([
            //情報(気象)
            Constraint(btnKinentaiWeather, .bottom, to:self.view, .bottom ,constant:-8),
            Constraint(btnKinentaiWeather, .leading, to:pad33, .trailing, constant:0),
            Constraint(btnKinentaiWeather, .width, to:btnKinentaiTel, .width, constant:0)
        ])
        self.view.addConstraints([
            //情報(緊援)
            Constraint(btnKinentaiKinen, .bottom, to:btnKinentaiBlackout, .top ,constant:-8),
            Constraint(btnKinentaiKinen, .leading, to:btnKinentaiBlackout, .leading, constant:0),
            Constraint(btnKinentaiKinen, .width, to:btnKinentaiBlackout, .width, constant:0)
        ])
    }
    
    //地震(震央「陸」)
    @objc func showSelectKinentai1(_ sender: UIButton){
        mKinentaiSelectDialogSingleMultiple = KinentaiSelectDialogSingleMultiple(index: 1, parentView: self)
        mKinentaiSelectDialogSingleMultiple.showInfo()
    }
    
    //地震(震央「海域」)
    @objc func showSelectKinentai2(_ sender: UIButton){
        mKinentaiSelectDialogSingleMultiple = KinentaiSelectDialogSingleMultiple(index: 2, parentView: self)
        mKinentaiSelectDialogSingleMultiple.showInfo()
        //mKinentaiSelectDialog = KinentaiSelectDialog(index: 2, parentView: self)
        //mKinentaiSelectDialog.showInfo()
    }
    
    //アクションプラン
    @objc func showSelectKinentai3(_ sender: UIButton){
        mKinentaiSelectDialog = KinentaiSelectDialog(index: 3, parentView: self)
        mKinentaiSelectDialog.showInfo()
    }
    
    //大津波警報 2021-10-31改修
    @objc func showSelectKinentai4(_ sender: UIButton){
        mKinentaiSelectDialogSingleMultiple = KinentaiSelectDialogSingleMultiple(index: 3, parentView: self)
        mKinentaiSelectDialogSingleMultiple.showInfo()
        //mKinentaiSelectDialog = KinentaiSelectDialog(index: 4, parentView: self)
        //mKinentaiSelectDialog.showInfo()
    }
    //2021-10-31 追加
    //噴火
    @objc func showSelectKinentai5(_ sender: UIButton){
        //噴火はKinentaiSelectDialogをすっとばしていきなり都道府県選択のKinentaiSelectDIalog2を呼び出す
        mKinentaiSelectDialog2 = KinentaiSelectDialog2(index: 42, parentView: self)
        mKinentaiSelectDialog2.showInfo()
        //元画面を暗くしてから遷移
        mViewController.view.alpha = 0.3
    }
    /* 2020-04-24 削除
    //特殊災害(NBC含む)
    @objc func showSelectKinentai5(_ sender: UIButton){
        //特殊災害はKinentaiSelectDialogをすっとばしていきなり都道府県選択のKinentaiSelectDIalog2を呼び出す
        mKinentaiSelectDialog2 = KinentaiSelectDialog2(index: 51, parentView: self)
        mKinentaiSelectDialog2.showInfo()
    }
    */
    
    //情報(地震)
    @objc func showInfoEarthquake(_ sender: UIButton){
        mInfoDialog.showInfo("earthquake")
    }
    
    //情報（停電）
    @objc func showInfoBlackout(_ sender: UIButton){
        mInfoDialog.showInfo("blackout")
    }
    
    //情報（道路）
    @objc func showInfoRoad(_ sender: UIButton){
        mInfoDialog.showInfo("road")
    }
    
    //連絡網
    @objc func showContactLoad(_ sender: UIButton){
        //初期設定のままだと設定画面に遷移
        if userDefaults.string(forKey: "password") == "nil" {
            //PasViewController呼び出し
            let data:PassViewController = PassViewController()
            let nav = UINavigationController(rootViewController: data)
            nav.setNavigationBarHidden(true, animated: false) //これをいれないとNavigationBarが表示されてうざい
            self.present(nav, animated: true, completion: nil)
        } else if !userDefaults.bool(forKey: "passCheck"){
            //パスワードチェック呼び出し
            mPassInputDialog.showResult()
        } else {
            //合っていれば表示
            let data:ContactSearchViewController = ContactSearchViewController()
            let nav = UINavigationController(rootViewController: data)
            nav.setNavigationBarHidden(true, animated: false) //これをいれないとNavigationBarが表示されてうざい
            self.present(nav, animated: true, completion: nil)
        }
    }

    //情報(河川)
    @objc func showInfoRiver(_ sender: UIButton){
        mInfoDialog.showInfo("river")
    }
    
    //情報(気象)
    @objc func showInfoWeather(_ sender: UIButton){
        mInfoDialog.showInfo("weather")
    }
    
    //情報(気象)
    @objc func showInfoKinen(_ sender: UIButton){
        mInfoDialog.showInfo("kinen")
    }
    
    /*緊急会陰除隊だけは、大阪市以外の他都市でも使うときのために以下は残しておく
    //基礎データ入力画面遷移
    @objc func onClickbtnData(_ sender : UIButton){
        //データ入力ViewControllerの存在を確認
        if isDataViewController  {
            //存在したなら自らを消滅するのみ
            self.dismiss(animated: true, completion: nil)
            isKinentaiViewController = false
        } else {
            //dataViewControllerのインスタンス生成
            let data:DataViewController = DataViewController()
            isDataViewController = true
            //navigationControllerのrootViewControllerにdataViewControllerをセット
            let nav = UINavigationController(rootViewController: data)
            nav.setNavigationBarHidden(true, animated: false) //これをいれないとNavigationBarが表示されてうざい
            //画面遷移
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    //震災画面遷移
    @objc func onClickbtnEarthquake(_ sender : UIButton){
        //震災ViewControllerの存在を確認
        if isViewController  {
            //存在したなら自らを消滅するのみ
            self.dismiss(animated: true, completion: nil)
            isKinentaiViewController = false
        } else {
            //dataViewControllerのインスタンス生成
            let data:ViewController = ViewController()
            isViewController = true
            //navigationControllerのrootViewControllerにKokuminhogoViewControllerをセット
            let nav = UINavigationController(rootViewController: data)
            nav.setNavigationBarHidden(true, animated: false) //これをいれないとNavigationBarが表示されてうざい
            //画面遷移
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    //風水害画面遷移
    @objc func onClickbtnTyphoon(_ sender : UIButton){
        //風水害ViewControllerの存在を確認
        if isTyphoonViewController  {
            //存在したなら自らを消滅するのみ
            self.dismiss(animated: true, completion: nil)
            isKinentaiViewController = false
        } else {
            //インスタンス生成
            let data:TyphoonViewController = TyphoonViewController()
            isTyphoonViewController = true
            //navigationControllerのrootViewControllerにTyphoonViewControllerをセット
            let nav = UINavigationController(rootViewController: data)
            nav.setNavigationBarHidden(true, animated: false) //これをいれないとNavigationBarが表示されてうざい
            //画面遷移
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    //国民保護画面遷移
    @objc func onClickbtnKokuminhogo(_ sender : UIButton){
        //国民保護ViewControllerの存在を確認
        if isKokuminhogoViewController  {
            //存在したなら自らを消滅するのみ
            self.dismiss(animated: true, completion: nil)
            isKinentaiViewController = false
        } else {
            //KokuminhogoViewControllerのインスタンス生成
            let data:KokuminhogoViewController = KokuminhogoViewController()
            isKokuminhogoViewController = true
            //navigationControllerのrootViewControllerにKokuminhogoViewControllerをセット
            let nav = UINavigationController(rootViewController: data)
            nav.setNavigationBarHidden(true, animated: false) //これをいれないとNavigationBarが表示されてうざい
            //画面遷移
            self.present(nav, animated: true, completion: nil)
        }
    }
 */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

