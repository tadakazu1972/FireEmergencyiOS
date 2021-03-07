//
//  DataViewController.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2016/09/11.
//  Copyright © 2016年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class DataViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    //メイン画面
    let btnData         = UIButton(frame: CGRect.zero)
    let btnPersonal     = UIButton(frame: CGRect.zero)
    let btnBack         = UIButton(frame: CGRect.zero)
    let btnContact      = UIButton(frame: CGRect.zero) //連絡網データ操作起動の入口ボタン
    let lblData         = UILabel(frame: CGRect.zero)
    let lblKinmu        = UILabel(frame: CGRect.zero)
    let picKinmu        = UIPickerView(frame: CGRect.zero)
    let kinmuArray: NSArray = ["消防局","北","都島","福島","此花","中央","西","港","大正","天王寺","浪速","西淀川","淀川","東淀川","東成","生野","旭","城東","鶴見","住之江","阿倍野","住吉","東住吉","平野","西成","水上","訓練センター"]
    let lblTsunami      = UILabel(frame: CGRect.zero)
    let picTsunami      = UIPickerView(frame: CGRect.zero)
    let lblKubun        = UILabel(frame: CGRect.zero)
    let picKubun        = UIPickerView(frame: CGRect.zero)
    let kubunArray: NSArray = ["１号招集","２号招集","３号招集","４号招集"]
    let btnSave         = UIButton(frame: CGRect.zero)
    let btnEarthquake1  = UIButton(frame: CGRect.zero)
    let btnEarthquake2  = UIButton(frame: CGRect.zero)
    let btnEarthquake3  = UIButton(frame: CGRect.zero)
    let btnEarthquake4  = UIButton(frame: CGRect.zero)
    let btnEarthquake5  = UIButton(frame: CGRect.zero)
    let padY1           = UIView(frame: CGRect.zero) //ボタンの間にはさむ見えないpaddingがわり
    let padY2           = UIView(frame: CGRect.zero)
    let padY3           = UIView(frame: CGRect.zero)
    let padY4           = UIView(frame: CGRect.zero)
    let padY5           = UIView(frame: CGRect.zero)
    let padY6           = UIView(frame: CGRect.zero)
    //別クラスのインスタンス保持用変数
    fileprivate var mInfoDialog: InfoDialog!
    //データ保存用
    let userDefaults = UserDefaults.standard
    var mainStation: String?
    var mainStationRow: Int?
    var tsunamiStation: String?
    var tsunamiStationRow: Int?
    var kubun: String?
    var kubunRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //自身を明るく
        self.view.backgroundColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
        self.view.alpha = 1.0
        //背後にある画面を暗く
        mViewController.view.alpha = 0.1
        //Button生成
        //アプリ説明書
        btnData.backgroundColor = UIColor(red:0.0, green:0.55, blue:0.0, alpha:1.0)
        btnData.layer.masksToBounds = true
        btnData.setTitle("アプリ説明書", for: UIControl.State())
        btnData.setTitleColor(UIColor.white, for: UIControl.State())
        btnData.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
        btnData.layer.cornerRadius = 8.0
        btnData.tag = 0
        btnData.translatesAutoresizingMaskIntoConstraints = false
        btnData.addTarget(self, action: #selector(self.onClickbtnGuide(_:)), for: .touchUpInside)
        self.view.addSubview(btnData)
        //非常参集職員情報登録画面遷移ボタン
        btnPersonal.backgroundColor = UIColor.red
        btnPersonal.layer.masksToBounds = true
        btnPersonal.setTitle("非常参集受付　職員情報入力", for: UIControl.State())
        btnPersonal.setTitleColor(UIColor.white, for: UIControl.State())
        btnPersonal.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
        btnPersonal.layer.cornerRadius = 8.0
        btnPersonal.tag = 0
        btnPersonal.translatesAutoresizingMaskIntoConstraints = false
        btnPersonal.addTarget(self, action: #selector(self.onClickbtnPersonal(_:)), for: .touchUpInside)
        self.view.addSubview(btnPersonal)
        //戻る
        btnBack.backgroundColor = UIColor.blue
        btnBack.layer.masksToBounds = true
        btnBack.setTitle("戻る", for: UIControl.State())
        btnBack.setTitleColor(UIColor.white, for: UIControl.State())
        btnBack.layer.cornerRadius = 8.0
        btnBack.tag=1
        btnBack.addTarget(self, action: #selector(self.onClickbtnBack(_:)), for: .touchUpInside)
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnBack)
        //あなたのデータを入力してください
        lblData.text = "所属等を設定し、登録ボタンを押してください"
        lblData.adjustsFontSizeToFitWidth = true
        lblData.textColor = UIColor.black
        lblData.textAlignment = NSTextAlignment.center
        lblData.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblData)
        //勤務消防署ラベル
        lblKinmu.text = "■勤務消防署"
        lblKinmu.adjustsFontSizeToFitWidth = true
        lblKinmu.textAlignment = NSTextAlignment.left
        lblKinmu.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblKinmu)
        //勤務消防署PickerView
        picKinmu.delegate = self
        picKinmu.dataSource = self
        picKinmu.translatesAutoresizingMaskIntoConstraints = false
        picKinmu.tag = 1
        mainStation = userDefaults.string(forKey: "mainStation") //保存した値を呼び出し
        mainStationRow = userDefaults.integer(forKey: "mainStationRow") //保存した値を呼び出し
        picKinmu.selectRow(mainStationRow!, inComponent:0, animated:false) //呼び出したrow値でピッカー初期化
        self.view.addSubview(picKinmu)
        //大津波・津波警報時参集指定署ラベル
        lblTsunami.text = "■大津波警報・津波警報時(震度5弱以上)参集指定署"
        lblTsunami.adjustsFontSizeToFitWidth = true
        lblTsunami.textAlignment = NSTextAlignment.left
        lblTsunami.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblTsunami)
        //大津波・津波警報時参集指定署PickerView
        picTsunami.delegate = self
        picTsunami.dataSource = self
        picTsunami.translatesAutoresizingMaskIntoConstraints = false
        picTsunami.tag = 2
        tsunamiStation = userDefaults.string(forKey: "tsunamiStation")
        tsunamiStationRow = userDefaults.integer(forKey: "tsunamiStationRow")
        picTsunami.selectRow(tsunamiStationRow!, inComponent:0, animated:false)
        self.view.addSubview(picTsunami)
        //非常招集区分ラベル
        lblKubun.text = "■非常招集区分"
        lblKubun.adjustsFontSizeToFitWidth = true
        lblKubun.textAlignment = NSTextAlignment.left
        lblKubun.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblKubun)
        //非常招集区分PickerView
        picKubun.delegate = self
        picKubun.dataSource = self
        picKubun.translatesAutoresizingMaskIntoConstraints = false
        picKubun.tag = 3
        kubun = userDefaults.string(forKey: "kubun")
        kubunRow = userDefaults.integer(forKey: "kubunRow")
        picKubun.selectRow(kubunRow!, inComponent:0, animated:false)
        self.view.addSubview(picKubun)
        //データ登録ボタン
        btnSave.backgroundColor = UIColor.red
        btnSave.layer.masksToBounds = true
        btnSave.setTitle("登録", for: UIControl.State())
        btnSave.setTitleColor(UIColor.white, for: UIControl.State())
        btnSave.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
        btnSave.layer.cornerRadius = 8.0
        btnSave.tag = 5
        btnSave.addTarget(self, action: #selector(self.onClickbtnSave(_:)), for: .touchUpInside)
        btnSave.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnSave)
        //垂直方向のpad
        padY1.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(padY1)
        padY2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(padY2)
        
        //連絡網データ操作
        btnContact.backgroundColor = UIColor.blue
        btnContact.layer.masksToBounds = true
        btnContact.setTitle("連絡網データ操作", for: UIControl.State())
        btnContact.setTitleColor(UIColor.white, for: UIControl.State())
        btnContact.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
        btnContact.layer.cornerRadius = 8.0
        btnContact.tag = 6
        btnContact.addTarget(self, action: #selector(self.onClickbtnContact(_:)), for: .touchUpInside)
        btnContact.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnContact)
        
        //ボタン押したら表示するDialog生成
        mInfoDialog = InfoDialog(parentView: self) //このViewControllerを渡してあげる
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
            //非常参集職員情報遷移ボタン
            Constraint(btnPersonal, .top, to:self.view, .top, constant:20),
            Constraint(btnPersonal, .leading, to:self.view, .leading, constant:8),
            Constraint(btnPersonal, .trailing, to:self.view, .trailingMargin, constant:8)
        ])
        self.view.addConstraints([
            //戻るボタン
            Constraint(btnBack, .top, to:btnPersonal, .bottom, constant:8),
            Constraint(btnBack, .leading, to:self.view, .leading, constant:8),
            Constraint(btnBack, .trailing, to:self.view, .centerX, constant:-8)
        ])
        self.view.addConstraints([
            //アプリ説明書ボタン
            Constraint(btnData, .top, to:self.btnPersonal, .bottom, constant:8),
            Constraint(btnData, .leading, to:self.view, .centerX, constant:8),
            Constraint(btnData, .trailing, to:self.view, .trailingMargin, constant:8)
        ])
        self.view.addConstraints([
            //padY1
            Constraint(padY1, .top, to:btnBack, .bottom, constant:0),
            Constraint(padY1, .leading, to:self.view, .leading, constant:0),
            Constraint(padY1, .height, to:self.view, .height, constant:0, multiplier:0.01)
            ])
        self.view.addConstraints([
            //あなたのデータを入力してくださいラベル
            Constraint(lblData, .top, to:padY1, .bottom, constant:8),
            Constraint(lblData, .centerX, to:self.view, .centerX, constant:8),
            Constraint(lblData, .width, to:self.view, .width, constant:0, multiplier:0.8)
            ])
        self.view.addConstraints([
            //勤務消防署ラベル
            Constraint(lblKinmu, .top, to:lblData, .bottom, constant:8),
            Constraint(lblKinmu, .leading, to:self.view, .leading, constant:16),
            Constraint(lblKinmu, .width, to:self.view, .width, constant:0, multiplier:0.8)
            ])
        self.view.addConstraints([
            //勤務消防署PickerView
            Constraint(picKinmu, .top, to:lblKinmu, .top, constant:0),
            Constraint(picKinmu, .centerX, to:self.view, .centerX, constant:0),
            Constraint(picKinmu, .height, to:self.view, .height, constant:0, multiplier:0.2)
            ])
        self.view.addConstraints([
            //大津波・津波警報時参集指定署ラベル
            Constraint(lblTsunami, .top, to:picKinmu, .bottom, constant:0),
            Constraint(lblTsunami, .leading, to:self.view, .leading, constant:16),
            Constraint(lblTsunami, .width, to:self.view, .width, constant:0, multiplier:0.8)
            ])
        self.view.addConstraints([
            //大津波・津波警報時参集指定署PickerView
            Constraint(picTsunami, .top, to:lblTsunami, .top, constant:0),
            Constraint(picTsunami, .centerX, to:self.view, .centerX, constant:0),
            Constraint(picTsunami, .height, to:self.view, .height, constant:0, multiplier:0.2)
            ])
        self.view.addConstraints([
            //非常招集区分ラベル
            Constraint(lblKubun, .top, to:picTsunami, .bottom, constant:0),
            Constraint(lblKubun, .leading, to:self.view, .leading, constant:16),
            Constraint(lblKubun, .width, to:self.view, .width, constant:0, multiplier:0.8)
            ])
        self.view.addConstraints([
            //非常招集区分PickerView
            Constraint(picKubun, .top, to:lblKubun, .top, constant:0),
            Constraint(picKubun, .centerX, to:self.view, .centerX, constant:0),
            Constraint(picKubun, .height, to:self.view, .height, constant:0, multiplier:0.2)
            ])
        self.view.addConstraints([
            //登録ボタン
            Constraint(btnSave, .bottom, to:btnContact, .top, constant:-20),
            Constraint(btnSave, .centerX, to:self.view, .centerX, constant:8),
            Constraint(btnSave, .width, to:self.view, .width, constant:8, multiplier:0.5)
            ])
        self.view.addConstraints([
            //アプリ説明書ボタン
            Constraint(btnContact, .bottom, to:self.view, .bottom, constant:-8),
            Constraint(btnContact, .leading, to:self.view, .leading, constant:8),
            Constraint(btnContact, .trailing, to:self.view, .trailingMargin, constant:8)
            ])
    }
    
    //表示例数
    func numberOfComponents(in pickerView: UIPickerView)-> Int{
        return 1
    }
    
    //表示行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int)-> Int{
        //返す行数
        var rowNum: Int
        //３種類のピッカーをタグで場合分け
        if (pickerView.tag==1){
            rowNum = kinmuArray.count
        } else if (pickerView.tag==2){
            rowNum = kinmuArray.count
        } else {
            rowNum = kubunArray.count
        }
        return rowNum
    }
    
    //表示内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String?{
        //返す列
        var picComponent: String?
        //３種類のピッカーをタグで場合分け
        if (pickerView.tag==1){
            picComponent = kinmuArray[row] as? String
        } else if (pickerView.tag==2){
            picComponent = kinmuArray[row] as? String
        } else {
            picComponent = kubunArray[row] as? String
        }
        return picComponent
    }
    
    //選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row:Int, inComponent component:Int) {
        print("列:\(row)")
        if (pickerView.tag==3){
            print("値:\(kubunArray[row])")
        } else {
        print("値:\(kinmuArray[row])")
        }
        //３種類のピッカーをタグで場合分け
        if (pickerView.tag==1){
            //一時保存
            mainStation = kinmuArray[row] as? String
            mainStationRow = row
        } else if (pickerView.tag==2){
            //一時保存
            tsunamiStation = kinmuArray[row] as? String
            tsunamiStationRow = row
        } else {
            //一時保存
            kubun = kubunArray[row] as? String
            kubunRow = row
        }
    }
    
    //登録ボタンクリック
    @objc func onClickbtnSave(_ sender : UIButton){
        userDefaults.set(mainStation, forKey:"mainStation")
        userDefaults.set(mainStationRow!, forKey:"mainStationRow")
        userDefaults.set(tsunamiStation, forKey:"tsunamiStation")
        userDefaults.set(tsunamiStationRow!, forKey:"tsunamiStationRow")
        userDefaults.set(kubun, forKey:"kubun")
        userDefaults.set(kubunRow!, forKey:"kubunRow")
        
        //アラート表示
        let alert = UIAlertController(title:"", message: "登録しました", preferredStyle: UIAlertController.Style.alert)
        let alertCancel = UIAlertAction(title:"閉じる", style: UIAlertAction.Style.cancel, handler:nil)
        alert.addAction(alertCancel)
        self.present(alert, animated:true, completion: nil)
    }
    
    //戻る
    @objc func onClickbtnBack(_ sender : UIButton){
        self.dismiss(animated: true)
        mViewController.view.alpha = 1.0
    }
    
    //連絡網データ操作遷移
    @objc func onClickbtnContact(_ sender : UIButton){
        mScreen = 2
        mViewController2.updateView()
    }
    
    //アプリ説明書
    @objc func onClickbtnGuide(_ sender : UIButton){
        mScreen = 3
        mViewController2.updateView()
    }
    
    //非常参集　職員情報登録画面遷移
    @objc func onClickbtnPersonal(_ sender : UIButton){
        mScreen = 4
        mViewController2.updateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
