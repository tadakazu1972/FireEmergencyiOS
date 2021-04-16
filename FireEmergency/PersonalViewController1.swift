//
//  PersonalViewController1.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2021/02/11.
//  Copyright © 2021 tadakazu nakamichi. All rights reserved.
//

import UIKit

class PersonalViewController1: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    //メイン画面
    let lblData         = UILabel(frame: CGRect.zero)
    let lblId           = UILabel(frame: CGRect.zero)
    let txtId           = UITextField(frame: CGRect.zero)
    let lblClass        = UILabel(frame: CGRect.zero)
    let txtClass        = UITextField(frame: CGRect.zero)
    let picClass        = UIPickerView(frame: CGRect.zero)
    let classArray: NSArray = ["正監","監","司令長","司令","司令補","士長","士"]
    let lblAge          = UILabel(frame: CGRect.zero)
    let txtAge          = UITextField(frame: CGRect.zero)
    let picAge          = UIPickerView(frame: CGRect.zero)
    let ageArray: NSArray = ["18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70"]
    let lblSyozoku0     = UILabel(frame: CGRect.zero)
    let txtSyozoku0     = UITextField(frame: CGRect.zero)
    let picSyozoku0     = UIPickerView(frame: CGRect.zero)
    let syozoku0Array: NSArray = ["北","都島","福島","此花","中央","西","港","大正","天王寺","浪速","西淀川","淀川","東淀川","東成","生野","旭","城東","鶴見","住之江","阿倍野","住吉","東住吉","平野","西成","水上","消防局","訓練センター"]
    let lblName      = UILabel(frame: CGRect.zero)
    let txtName      = UITextField(frame: CGRect.zero)
    let lblRide         = UILabel(frame: CGRect.zero)
    let txtRide         = UITextField(frame: CGRect.zero)
    let picRide         = UIPickerView(frame: CGRect.zero)
    let rideArray: NSArray = ["ST","R","A","特殊隊","通信","日勤"]
    let lblShikaku        = UILabel(frame: CGRect.zero)
    let swtEngineer     = UISwitch(frame: CGRect.zero)
    let lblEngineer     = UILabel(frame: CGRect.zero)
    let swtParamedic    = UISwitch(frame: CGRect.zero)
    let lblParamedic    = UILabel(frame: CGRect.zero)
    let btnSave         = UIButton(frame: CGRect.zero)
    let btnCancel       = UIButton(frame: CGRect.zero)
    let btnNext         = UIButton(frame: CGRect.zero)
    //別クラスのインスタンス保持用変数
    fileprivate var mInfoDialog: InfoDialog!
    //所属(大分類)のインデックス保存用
    fileprivate var syozoku0Index : Int = 0
    //非常参集　職員情報　保存用
    let userDefaults = UserDefaults.standard
    //参集署選択ダイアログ
    fileprivate var mKinmusyoSelectDialog: KinmusyoSelectDialog!
    fileprivate var mKyokusyoSelectDialog: KyokusyoSelectDialog!
    //iPhoneSE(2016)=iPhone5画面判定用
    let iPhone5 : CGRect = CGRect(x: 0.0, y: 0.0, width: 320.0, height: 568.0)
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.view.backgroundColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
        //データ修正ラベル
        lblData.text = "職員情報　登録画面"
        lblData.adjustsFontSizeToFitWidth = true
        lblData.textColor = UIColor.black
        lblData.textAlignment = NSTextAlignment.center
        lblData.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblData)
        //職員番号ラベル
        lblId.text = "職員番号"
        lblId.adjustsFontSizeToFitWidth = true
        lblId.textColor = UIColor.black
        lblId.textAlignment = NSTextAlignment.left
        lblId.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblId)
        //職員番号テキストフィールド
        txtId.placeholder = "半角数字で入力"
        txtId.text = userDefaults.string(forKey: "personalId")
        txtId.adjustsFontSizeToFitWidth = true
        txtId.textColor = UIColor.black
        txtId.delegate = self
        txtId.borderStyle = UITextField.BorderStyle.bezel
        txtId.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(txtId)
        //階級ラベル
        lblClass.text = "階　　級"
        lblClass.adjustsFontSizeToFitWidth = true
        lblClass.textColor = UIColor.black
        lblClass.textAlignment = NSTextAlignment.left
        lblClass.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblClass)
        
        //pickerViewとともにポップアップするツールバーとボタンの設定
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(title:"選択", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.selectRow))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil) //小ワザ。上の選択ボタンを右寄せにするためのダミースペース
        toolbar.setItems([flexibleSpace, doneItem], animated: true)
        
        //階級テキストフィールド
        txtClass.text = userDefaults.string(forKey: "personalClass")
        txtClass.inputView = picClass //これでテキストフィールドとピッカービューを紐付け
        txtClass.inputAccessoryView = toolbar //上で設定したポップアップと紐付け
        txtClass.borderStyle = UITextField.BorderStyle.bezel
        txtClass.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(txtClass)
        //階級PickerView
        picClass.delegate = self
        picClass.dataSource = self
        picClass.translatesAutoresizingMaskIntoConstraints = false
        picClass.tag = 0
        picClass.selectRow(0, inComponent:0, animated:false)
        //年齢ラベル
        lblAge.text = "年　　齢"
        lblAge.adjustsFontSizeToFitWidth = true
        lblAge.textColor = UIColor.black
        lblAge.textAlignment = NSTextAlignment.left
        lblAge.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblAge)
        //年齢テキストフィールド
        txtAge.text = userDefaults.string(forKey: "personalAge")
        txtAge.inputView = picAge
        txtAge.inputAccessoryView = toolbar
        txtAge.borderStyle = UITextField.BorderStyle.bezel
        txtAge.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(txtAge)
        //年齢PickerView
        picAge.delegate = self
        picAge.dataSource = self
        picAge.translatesAutoresizingMaskIntoConstraints = false
        picAge.tag = 1
        picAge.selectRow(0, inComponent:0, animated:false) //呼び出したrow値でピッカー初期化
        //所属ラベル
        lblSyozoku0.text = "所　　属"
        lblSyozoku0.adjustsFontSizeToFitWidth = true
        lblSyozoku0.textAlignment = NSTextAlignment.left
        lblSyozoku0.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblSyozoku0)
        //所属テキストフィールド
        txtSyozoku0.borderStyle = UITextField.BorderStyle.bezel
        txtSyozoku0.text = userDefaults.string(forKey: "personalDepartment")
        txtSyozoku0.inputView = picSyozoku0
        txtSyozoku0.inputAccessoryView = toolbar
        txtSyozoku0.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(txtSyozoku0)
        //所属PickerView
        picSyozoku0.delegate = self
        picSyozoku0.dataSource = self
        picSyozoku0.translatesAutoresizingMaskIntoConstraints = false
        picSyozoku0.tag = 2
        picSyozoku0.selectRow(0, inComponent:0, animated:false) //呼び出したrow値でピッカー初期化
        //氏名ラベル
        lblName.text = "氏　　名"
        lblName.adjustsFontSizeToFitWidth = true
        lblName.textAlignment = NSTextAlignment.left
        lblName.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblName)
        //氏名テキストフィールド
        txtName.placeholder = "姓名の間に空白入れない"
        txtName.borderStyle = UITextField.BorderStyle.bezel
        txtName.text = userDefaults.string(forKey: "personalName")
        txtName.translatesAutoresizingMaskIntoConstraints = false
        txtName.delegate = self
        self.view.addSubview(txtName)
        //現在の乗組ラベル
        lblRide.text = "現在の乗組"
        lblRide.adjustsFontSizeToFitWidth = true
        lblRide.textAlignment = NSTextAlignment.left
        lblRide.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblRide)
        //現在の乗組テキストフィールド
        txtRide.borderStyle = UITextField.BorderStyle.bezel
        txtRide.text = userDefaults.string(forKey: "personalRide")
        txtRide.inputView = picRide
        txtRide.inputAccessoryView = toolbar
        txtRide.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(txtRide)
        //現在の乗組PickerView
        picRide.delegate = self
        picRide.dataSource = self
        picRide.translatesAutoresizingMaskIntoConstraints = false
        picRide.tag = 3
        picRide.selectRow(0, inComponent:0, animated:false) //呼び出したrow値でピッカー初期化
        
        //資格ラベル
        lblShikaku.text = "資　　格"
        lblShikaku.adjustsFontSizeToFitWidth = true
        lblShikaku.textAlignment = NSTextAlignment.left
        lblShikaku.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblShikaku)
        //機関員スイッチ
        swtEngineer.isOn = userDefaults.bool(forKey: "personalEngineer")
        swtEngineer.addTarget(self, action: #selector(changeswtEngineer(_:)), for: UIControl.Event.valueChanged)
        swtEngineer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(swtEngineer)
        //機関員ラベル
        lblEngineer.text = "機関員"
        lblEngineer.adjustsFontSizeToFitWidth = true
        lblEngineer.textColor = UIColor.black
        lblEngineer.textAlignment = NSTextAlignment.left
        lblEngineer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblEngineer)
        //救命士スイッチ
        swtParamedic.isOn = userDefaults.bool(forKey: "personalParamedic")
        swtParamedic.addTarget(self, action: #selector(changeswtParamedic(_:)), for: UIControl.Event.valueChanged)
        swtParamedic.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(swtParamedic)
        //救命士ラベル
        lblParamedic.text = "救命士"
        lblParamedic.adjustsFontSizeToFitWidth = true
        lblParamedic.textColor = UIColor.black
        lblParamedic.textAlignment = NSTextAlignment.left
        lblParamedic.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblParamedic)
        
        //キャンセルボタン
        btnCancel.backgroundColor = UIColor.blue
        btnCancel.layer.masksToBounds = true
        btnCancel.setTitle("戻る", for: UIControl.State())
        btnCancel.setTitleColor(UIColor.white, for: UIControl.State())
        btnCancel.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
        btnCancel.layer.cornerRadius = 8.0
        btnCancel.tag = 2
        btnCancel.addTarget(self, action: #selector(self.onClickbtnCancel(_:)), for: .touchUpInside)
        btnCancel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnCancel)
        //データ登録ボタン
        btnSave.backgroundColor = UIColor.red
        btnSave.layer.masksToBounds = true
        btnSave.setTitle("登録", for: UIControl.State())
        btnSave.setTitleColor(UIColor.white, for: UIControl.State())
        btnSave.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
        btnSave.layer.cornerRadius = 8.0
        btnSave.tag = 1
        btnSave.addTarget(self, action: #selector(self.onClickbtnSave(_:)), for: .touchUpInside)
        btnSave.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnSave)
        
        //参集署選択ボタン
        btnNext.backgroundColor = UIColor.red
        btnNext.layer.masksToBounds = true
        btnNext.setTitle("参集先　到着", for: UIControl.State())
        btnNext.setTitleColor(UIColor.white, for: UIControl.State())
        btnNext.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
        btnNext.layer.cornerRadius = 8.0
        btnNext.addTarget(self, action: #selector(self.onClickbtnNext(_:)), for: .touchUpInside)
        btnNext.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnNext)
        
        //テキストフィールドの入力時に表示されるキーボードがフォーカスを外れたら閉じるように監視
        let tapGestureResponder: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureResponder.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureResponder)
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
            //新規データ入力ラベル
            Constraint(lblData, .top, to:self.view, .top, constant:20),
            Constraint(lblData, .centerX, to:self.view, .centerX, constant:0),
            Constraint(lblData, .width, to:self.view, .width, constant:0, multiplier:0.8)
            ])
        self.view.addConstraints([
            //職員番号ラベル
            Constraint(lblId, .top, to:lblData, .bottom, constant:20),
            Constraint(lblId, .leading, to:self.view, .leading, constant:16),
            Constraint(lblId, .trailing, to:self.view, .centerX, constant:-16)
        ])
        self.view.addConstraints([
            //職員番号テキストフィールド
            Constraint(txtId, .top, to:lblData, .bottom, constant:20),
            Constraint(txtId, .leading, to:self.view, .centerX, constant:-32),
            Constraint(txtId, .trailing, to:self.view, .trailing, constant:-16)
            ])
        self.view.addConstraints([
            //階級ラベル
            Constraint(lblClass, .top, to:txtId, .bottom, constant:20),
            Constraint(lblClass, .leading, to:self.view, .leading, constant:16),
            Constraint(lblClass, .trailing, to:self.view, .centerX, constant:-16)
        ])
        self.view.addConstraints([
            //階級テキストフィールド
            Constraint(txtClass, .top, to:txtId, .bottom, constant:20),
            Constraint(txtClass, .leading, to:self.view, .centerX, constant:-32),
            Constraint(txtClass, .trailing, to:self.view, .trailing, constant:-16)
        ])
        self.view.addConstraints([
            //年齢ラベル
            Constraint(lblAge, .top, to:txtClass, .bottom, constant:20),
            Constraint(lblAge, .leading, to:self.view, .leading, constant:16),
            Constraint(lblAge, .trailing, to:self.view, .centerX, constant:-16)
        ])
        self.view.addConstraints([
            //年齢テキストフィールド
            Constraint(txtAge, .top, to:txtClass, .bottom, constant:20),
            Constraint(txtAge, .leading, to:self.view, .centerX, constant:-32),
            Constraint(txtAge, .trailing, to:self.view, .trailing, constant:-16)
            ])
        self.view.addConstraints([
            //所属ラベル
            Constraint(lblSyozoku0, .top, to:txtAge, .bottom, constant:20),
            Constraint(lblSyozoku0, .leading, to:self.view, .leading, constant:16),
            Constraint(lblSyozoku0, .width, to:self.view, .width, constant:0, multiplier:0.8)
            ])
        self.view.addConstraints([
            //所属テキストフィールド
            Constraint(txtSyozoku0, .top, to:txtAge, .bottom, constant:20),
            Constraint(txtSyozoku0, .leading, to:self.view, .centerX, constant:-32),
            Constraint(txtSyozoku0, .trailing, to:self.view, .trailing, constant:-16)
            ])
        self.view.addConstraints([
            //氏名ラベル
            Constraint(lblName, .top, to:txtSyozoku0, .bottom, constant:20),
            Constraint(lblName, .leading, to:self.view, .leading, constant:16),
            Constraint(lblName, .width, to:self.view, .width, constant:0, multiplier:0.8)
            ])
        self.view.addConstraints([
            //氏名テキストフィールド
            Constraint(txtName, .top, to:txtSyozoku0, .bottom, constant:20),
            Constraint(txtName, .leading, to:self.view, .centerX, constant:-32),
            Constraint(txtName, .trailing, to:self.view, .trailing, constant:-16)
            ])
        self.view.addConstraints([
            //現在の乗組ラベル
            Constraint(lblRide, .top, to:txtName, .bottom, constant:20),
            Constraint(lblRide, .leading, to:self.view, .leading, constant:16),
            Constraint(lblRide, .width, to:self.view, .width, constant:0, multiplier:0.8)
            ])
        self.view.addConstraints([
            //現在の乗組テキストフィールド
            Constraint(txtRide, .top, to:txtName, .bottom, constant:20),
            Constraint(txtRide, .leading, to:self.view, .centerX, constant:-32),
            Constraint(txtRide, .trailing, to:self.view, .trailing, constant:-16)
            ])
        self.view.addConstraints([
            //資格ラベル
            Constraint(lblShikaku, .top, to:txtRide, .bottom, constant:20),
            Constraint(lblShikaku, .leading, to:self.view, .leading, constant:16),
            Constraint(lblShikaku, .width, to:self.view, .width, constant:0, multiplier:0.8)
        ])
        self.view.addConstraints([
            //機関員ラベル
            Constraint(lblEngineer, .top, to:txtRide, .bottom, constant:28),
            Constraint(lblEngineer, .leading, to:self.view, .centerX, constant:32)
        ])
        self.view.addConstraints([
            //機関員スイッチ
            Constraint(swtEngineer, .top, to:txtRide, .bottom, constant:20),
            Constraint(swtEngineer, .trailing, to:self.view, .trailing, constant:-16)
        ])
        self.view.addConstraints([
            //救命士ラベル
            Constraint(lblParamedic, .top, to:lblEngineer, .bottom, constant:28),
            Constraint(lblParamedic, .leading, to:self.view, .centerX, constant:32)
        ])
        self.view.addConstraints([
            //救命士スイッチ
            Constraint(swtParamedic, .top, to:lblEngineer, .bottom, constant:20),
            Constraint(swtParamedic, .trailing, to:self.view, .trailing, constant:-16)
        ])
        //iPhoneSEのとき登録ボタンのカブりを防ぐ
        if Int(UIScreen.main.bounds.size.height)==Int(iPhone5.height){
            self.view.addConstraints([
                //キャンセルボタン
                Constraint(btnCancel, .bottom, to:self.view, .bottom, constant:-10),
                Constraint(btnCancel, .leading, to:self.view, .leading, constant:8),
                Constraint(btnCancel, .trailing, to:self.view, .centerX, constant:-8),
                Constraint(btnCancel, .height, to:self.view, .height, constant:0, multiplier:0.05)
            ])
        } else {
            self.view.addConstraints([
                //キャンセルボタン
                Constraint(btnCancel, .bottom, to:self.view, .bottom, constant:-10),
                Constraint(btnCancel, .leading, to:self.view, .leading, constant:8),
                Constraint(btnCancel, .trailing, to:self.view, .centerX, constant:-8)
            ])
        }
        //iPhoneSEのとき登録ボタンのカブりを防ぐ
        if Int(UIScreen.main.bounds.size.height)==Int(iPhone5.height){
            self.view.addConstraints([
                //参集署選択ボタン
                Constraint(btnNext, .bottom, to:self.view, .bottom, constant:-10),
                Constraint(btnNext, .leading, to:self.view, .centerX, constant:8),
                Constraint(btnNext, .trailing, to:self.view, .trailing, constant:-8),
                Constraint(btnNext, .height, to:self.view, .height, constant:0, multiplier:0.05)
            ])
        } else {
            self.view.addConstraints([
                //参集署選択ボタン
                Constraint(btnNext, .bottom, to:self.view, .bottom, constant:-10),
                Constraint(btnNext, .leading, to:self.view, .centerX, constant:8),
                Constraint(btnNext, .trailing, to:self.view, .trailing, constant:-8)
            ])
        }
        //iPhoneSEのとき登録ボタンのカブりを防ぐ
        if Int(UIScreen.main.bounds.size.height)==Int(iPhone5.height){
            self.view.addConstraints([
                //登録ボタン
                Constraint(btnSave, .bottom, to:btnCancel, .top, constant:-4),
                Constraint(btnSave, .centerX, to:self.view, .centerX, constant:0),
                Constraint(btnSave, .width, to:self.view, .width, constant:0, multiplier:0.5),
                Constraint(btnSave, .height, to:self.view, .height, constant:0, multiplier:0.05)
            ])
        } else {
            self.view.addConstraints([
                //登録ボタン
                Constraint(btnSave, .top, to:swtParamedic, .bottom, constant:20),
                Constraint(btnSave, .centerX, to:self.view, .centerX, constant:0),
                Constraint(btnSave, .width, to:self.view, .width, constant:0, multiplier:0.5)
            ])
        }
    }
    
    //氏名にスペースあったら削除 キーボード閉じる時、Rowに飛んだ時、登録ボタン押す時呼び出して使う
    private func trimSpaces(){
        //半角スペース
        txtName.text = txtName.text?.replacingOccurrences(of: " ", with: "")
        //全角スペース
        txtName.text = txtName.text?.replacingOccurrences(of: "　", with: "")
    }
    
    //テキストフィールドのキーボード閉じる処理
    @objc func dismissKeyboard() {
        //氏名からスペース削除
        self.trimSpaces()
        self.view.endEditing(true)
    }
    
    //表示例数
    func numberOfComponents(in pickerView: UIPickerView)-> Int{
        return 1
    }
    
    //表示行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int)-> Int{
        //返す行数
        var rowNum: Int = 1
        switch pickerView.tag {
        case 0:
            rowNum = classArray.count
            break
        case 1:
            rowNum = ageArray.count
            break
        case 2:
            rowNum = syozoku0Array.count
            break
        case 3:
            rowNum = rideArray.count
            break
        default:
            rowNum = classArray.count
            break
        }
        
        return rowNum
    }
    
    //表示内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String?{
        //返す列
        var picComponent: String?
        switch pickerView.tag {
        case 0:
            picComponent = classArray[row] as? String
            break
        case 1:
            picComponent = ageArray[row] as? String
            break
        case 2:
            picComponent = syozoku0Array[row] as? String
            break
        case 3:
            picComponent = rideArray[row] as? String
            break
        default:
            picComponent = classArray[row] as? String
            break
        }
        
        return picComponent
    }
    
    //選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row:Int, inComponent component:Int) {
        print("列:\(row)")
        switch pickerView.tag {
        case 0:
            txtClass.text = classArray[row] as? String
            break
        case 1:
            txtAge.text = ageArray[row] as? String
            break
        case 2:
            txtSyozoku0.text = syozoku0Array[row] as? String
            break
        case 3:
            txtRide.text = rideArray[row] as? String
            break
        default:
            break
        }
    }
    
    //ツールバーで選択ボタンを押した時
    @objc func selectRow(){
        //初起動で何も登録されていない場合、ピッカーを移動させずに選択ボタンを押した場合にnil防止として0番目を登録する
        //正監はケース少ないだろうが、年齢18、所属北は違うと気づくことを願って。
        if txtClass.text == "" { txtClass.text = classArray[0] as? String }
        if txtAge.text == "" { txtAge.text = ageArray[0] as? String }
        if txtSyozoku0.text == "" { txtSyozoku0.text = syozoku0Array[0] as? String }
        if txtRide.text == "" { txtRide.text = rideArray[0] as? String }
        //氏名からスペース削除
        self.trimSpaces()
        //キーボード消去
        txtClass.endEditing(true)
        txtAge.endEditing(true)
        txtSyozoku0.endEditing(true)
        txtName.endEditing(true)
        txtRide.endEditing(true)
    }
    
    //機関員スイッチ　切替
    @objc func changeswtEngineer(_ sender: UISwitch){
        // UISwitchの値を取得
        let onCheck: Bool = sender.isOn
        if onCheck {
            //オン
            userDefaults.set(true, forKey: "personalEngineer")
        } else {
            //オフ
            userDefaults.set(false, forKey: "personalEngineer")
        }
    }
    
    //機関員スイッチ　切替
    @objc func changeswtParamedic(_ sender: UISwitch){
        // UISwitchの値を取得
        let onCheck: Bool = sender.isOn
        if onCheck {
            //オン
            userDefaults.set(true, forKey: "personalParamedic")
        } else {
            //オフ
            userDefaults.set(false, forKey: "personalParamedic")
        }
    }
    
    //登録ボタンクリック
    @objc func onClickbtnSave(_ sender : UIButton){
        //入力チェック
        if checkPersonalData(){
            //登録しましたアラート　表示
            let dialog = UIAlertController(title: "登録しました", message: "修正が必要な場合は再度登録してください", preferredStyle: .alert)
            //ボタンのタイトル
            dialog.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))
            //実際に表示させる
            self.present(dialog, animated: true, completion: nil)
        }
    }
    
    func checkPersonalData()-> Bool {
        //職員番号７桁チェック
        if txtId.text!.count != 7 {
            //アラート　表示
            let dialog = UIAlertController(title: "職員番号が７桁になっていません", message: "職員番号は７桁半角数字で入力してください", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))
            //実際に表示させる
            self.present(dialog, animated: true, completion: nil)
            
            return false
        //氏名が空白かチェック
        } else if txtName.text == "" {
            //アラート　表示
            let dialog = UIAlertController(title: "氏名が入力されていません", message: "姓名の間に空白を入れない", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))
            //実際に表示させる
            self.present(dialog, animated: true, completion: nil)
            
            return false
        } else {
            //以下　登録処理
            //氏名からスペース削除
            self.trimSpaces()
            //userdefaultに書き込み
            userDefaults.set(txtId.text, forKey: "personalId")
            userDefaults.set(txtClass.text, forKey: "personalClass")
            userDefaults.set(txtAge.text, forKey: "personalAge")
            userDefaults.set(txtSyozoku0.text, forKey: "personalDepartment")
            userDefaults.set(txtName.text, forKey: "personalName")
            userDefaults.set(txtRide.text, forKey: "personalRide")
            
            return true
        }
    }
    
    //キャンセルボタンクリック
    @objc func onClickbtnCancel(_ sender : UIButton){
        //基礎データ入力へ遷移
        mScreen = 1
        mViewController2.updateView()
    }
    
    //参集先到着ボタンクリック
    @objc func onClickbtnNext(_ sender: UIButton){
        //焦って登録ボタンを押さずに参集先到着ボタンを押した場合も考慮して
        //入力データチェック、戻り値がtrueなら画面遷移
        if checkPersonalData() {
            //基礎データ画面を暗く
            mViewController2.view.alpha = 0.1
            //ダイアログ表示
            mKinmusyoSelectDialog = KinmusyoSelectDialog(parentView: self)
            mKinmusyoSelectDialog.showInfo()
            //mKyokusyoSelectDialog = KyokusyoSelectDialog(parentView: self)
            //mKyokusyoSelectDialog.showInfo()
        }
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

