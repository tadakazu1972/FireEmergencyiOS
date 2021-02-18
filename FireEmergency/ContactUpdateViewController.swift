//
//  ContactUpdateViewController.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2017/02/19.
//  Copyright © 2017年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class ContactUpdateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    //メイン画面
    let lblData         = UILabel(frame: CGRect.zero)
    let txtName         = UITextField(frame: CGRect.zero)
    let txtTel          = UITextField(frame: CGRect.zero)
    let txtMail         = UITextField(frame: CGRect.zero)
    let lblKubun        = UILabel(frame: CGRect.zero)
    let txtKubun        = UITextField(frame: CGRect.zero)
    let picKubun        = UIPickerView(frame: CGRect.zero)
    let kubunArray: NSArray = ["１号招集","２号招集","３号招集","４号招集"]
    let lblSyozoku0     = UILabel(frame: CGRect.zero)
    let txtSyozoku0     = UITextField(frame: CGRect.zero)
    let picSyozoku0     = UIPickerView(frame: CGRect.zero)
    let syozoku0Array: NSArray = ["消防局","北","都島","福島","此花","中央","西","港","大正","天王寺","浪速","西淀川","淀川","東淀川","東成","生野","旭","城東","鶴見","住之江","阿倍野","住吉","東住吉","平野","西成","水上","訓練センター"]
    let lblSyozoku      = UILabel(frame: CGRect.zero)
    let txtSyozoku      = UITextField(frame: CGRect.zero)
    let picSyozoku      = UIPickerView(frame: CGRect.zero)
    let syozokuArray: NSArray = [["総務課","人事課","施設課","予防課","規制課","警防課","司令課","救急課"],
                                 ["北本署","梅田","浮田","南森町","与力","大淀町","本庄"],
                                 ["都島本署","高倉","東野田"],
                                 ["福島本署","上福島","海老江"],
                                 ["此花本署","桜島","西九条"],
                                 ["中央本署","東雲","道頓堀","南坂町","上町"],
                                 ["西本署","江戸堀","新町"],
                                 ["港本署","田中"],
                                 ["大正本署","泉尾","鶴町"],
                                 ["天王寺本署","元町"],
                                 ["浪速本署","恵美須","立葉","浪速出張所"],
                                 ["西淀川本署","佃","大和田","竹島"],
                                 ["淀川本署","十三橋","加島","東三国"],
                                 ["東淀川本署","豊里","小松","井高野","柴島","西淡路"],
                                 ["東成本署","中本","深江"],
                                 ["生野本署","勝山","中川","巽"],
                                 ["旭本署","新森","赤川"],
                                 ["城東本署","放出","中浜","関目"],
                                 ["鶴見本署","今津","矢田"],
                                 ["住之江本署","平林","加賀屋","南港"],
                                 ["阿倍野本署","清明通","阪南"],
                                 ["住吉本署","苅田","万代"],
                                 ["東住吉本署","北田辺","杭全","矢田"],
                                 ["平野本署","加美","長吉","喜連","加美正覚寺"],
                                 ["西成本署","海道","津守"],
                                 ["水上"],
                                 ["訓練センター"]]
    let lblKinmu        = UILabel(frame: CGRect.zero)
    let txtKinmu        = UITextField(frame: CGRect.zero)
    let picKinmu        = UIPickerView(frame: CGRect.zero)
    let kinmuArray: NSArray = ["日勤","１部","２部"]
    let btnSave         = UIButton(frame: CGRect.zero)
    let btnCancel       = UIButton(frame: CGRect.zero)
    //別クラスのインスタンス保持用変数
    fileprivate var mInfoDialog: InfoDialog!
    //所属(大分類)のインデックス保存用
    fileprivate var syozoku0Index : Int = 0
    //SQLite用
    internal var mDBHelper: DBHelper!
    //ContactUpdateSelectDialogから送られてくる各テキストフィールドに放り込むデータ保存用
    fileprivate var mSelected: [String] = []
    
    init(selected: [String]) {
        super.init(nibName: nil, bundle: nil)
        mSelected = selected
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mDBHelper = DBHelper()
        
        self.view.backgroundColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
        //データ修正ラベル
        lblData.text = "データ修正"
        lblData.adjustsFontSizeToFitWidth = true
        lblData.textColor = UIColor.black
        lblData.textAlignment = NSTextAlignment.left
        lblData.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblData)
        //名前テキストフィールド
        txtName.text = mSelected[0]
        txtName.adjustsFontSizeToFitWidth = true
        txtName.textColor = UIColor.black
        txtName.delegate = self
        txtName.borderStyle = UITextField.BorderStyle.bezel
        txtName.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(txtName)
        //電話番号テキストフィールド
        txtTel.text = mSelected[1]
        txtTel.adjustsFontSizeToFitWidth = true
        txtTel.textColor = UIColor.black
        txtTel.delegate = self
        txtTel.borderStyle = UITextField.BorderStyle.bezel
        txtTel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(txtTel)
        //メールアドレステキストフィールド
        txtMail.text = mSelected[2]
        txtMail.adjustsFontSizeToFitWidth = true
        txtMail.textColor = UIColor.black
        txtMail.delegate = self
        txtMail.borderStyle = UITextField.BorderStyle.bezel
        txtMail.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(txtMail)
        
        //pickerViewとともにポップアップするツールバーとボタンの設定
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(title:"選択", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.selectRow))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil) //小ワザ。上の選択ボタンを右寄せにするためのダミースペース
        toolbar.setItems([flexibleSpace, doneItem], animated: true)
        
        //非常招集区分ラベル
        lblKubun.text = "■非常招集区分"
        lblKubun.adjustsFontSizeToFitWidth = true
        lblKubun.textAlignment = NSTextAlignment.left
        lblKubun.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblKubun)
        //非常招集区分テキストフィールド
        txtKubun.borderStyle = UITextField.BorderStyle.bezel
        txtKubun.text = mSelected[3]
        txtKubun.inputView = picKubun //これでテキストフィールドとピッカービューを紐付け
        txtKubun.inputAccessoryView = toolbar //上で設定したポップアップと紐付け
        txtKubun.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(txtKubun)
        //非常招集区分PickerView
        picKubun.delegate = self
        picKubun.dataSource = self
        picKubun.translatesAutoresizingMaskIntoConstraints = false
        picKubun.tag = 1
        picKubun.selectRow(0, inComponent:0, animated:false)
        
        //所属(大分類)ラベル
        lblSyozoku0.text = "■所属(大分類)"
        lblSyozoku0.adjustsFontSizeToFitWidth = true
        lblSyozoku0.textAlignment = NSTextAlignment.left
        lblSyozoku0.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblSyozoku0)
        //所属(大分類)テキストフィールド
        txtSyozoku0.borderStyle = UITextField.BorderStyle.bezel
        txtSyozoku0.text = mSelected[4]
        txtSyozoku0.inputView = picSyozoku0
        txtSyozoku0.inputAccessoryView = toolbar
        txtSyozoku0.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(txtSyozoku0)
        //所属(大分類)PickerView
        picSyozoku0.delegate = self
        picSyozoku0.dataSource = self
        picSyozoku0.translatesAutoresizingMaskIntoConstraints = false
        picSyozoku0.tag = 2
        picSyozoku0.selectRow(0, inComponent:0, animated:false) //呼び出したrow値でピッカー初期化
        
        //所属(小分類)ラベル
        lblSyozoku.text = "■所属(小分類)"
        lblSyozoku.adjustsFontSizeToFitWidth = true
        lblSyozoku.textAlignment = NSTextAlignment.left
        lblSyozoku.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblSyozoku)
        //所属(小分類)テキストフィールド
        txtSyozoku.borderStyle = UITextField.BorderStyle.bezel
        txtSyozoku.text = mSelected[5]
        txtSyozoku.inputView = picSyozoku
        txtSyozoku.inputAccessoryView = toolbar
        txtSyozoku.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(txtSyozoku)
        //所属(小分類)PickerView
        picSyozoku.delegate = self
        picSyozoku.dataSource = self
        picSyozoku.translatesAutoresizingMaskIntoConstraints = false
        picSyozoku.tag = 3
        picSyozoku.selectRow(0, inComponent:0, animated:false)
        
        //勤務区分ラベル
        lblKinmu.text = "■勤務区分"
        lblKinmu.adjustsFontSizeToFitWidth = true
        lblKinmu.textAlignment = NSTextAlignment.left
        lblKinmu.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblKinmu)
        //勤務区分テキストフィールド
        txtKinmu.borderStyle = UITextField.BorderStyle.bezel
        txtKinmu.text = mSelected[6]
        txtKinmu.inputView = picKinmu
        txtKinmu.inputAccessoryView = toolbar
        txtKinmu.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(txtKinmu)
        //勤務区分ピッカービュー
        picKinmu.delegate = self
        picKinmu.dataSource = self
        picKinmu.translatesAutoresizingMaskIntoConstraints = false
        picKinmu.tag = 4
        picKinmu.selectRow(0, inComponent:0, animated:false)
        
        //キャンセルボタン
        btnCancel.backgroundColor = UIColor.blue
        btnCancel.layer.masksToBounds = true
        btnCancel.setTitle("キャンセル", for: UIControl.State())
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
            //新規データ入力ラベル
            Constraint(lblData, .top, to:self.view, .top, constant:28),
            Constraint(lblData, .leading, to:self.view, .leading, constant:16),
            Constraint(lblData, .width, to:self.view, .width, constant:0, multiplier:0.8)
            ])
        self.view.addConstraints([
            //名前テキストフィールド
            Constraint(txtName, .top, to:lblData, .bottom, constant:24),
            Constraint(txtName, .leading, to:self.view, .leading, constant:16),
            Constraint(txtName, .trailing, to:self.view, .trailing, constant:-16)
            ])
        self.view.addConstraints([
            //電話テキストフィールド
            Constraint(txtTel, .top, to:txtName, .bottom, constant:24),
            Constraint(txtTel, .leading, to:self.view, .leading, constant:16),
            Constraint(txtTel, .trailing, to:self.view, .trailing, constant:-16)
            ])
        self.view.addConstraints([
            //メールアドレステキストフィールド
            Constraint(txtMail, .top, to:txtTel, .bottom, constant:24),
            Constraint(txtMail, .leading, to:self.view, .leading, constant:16),
            Constraint(txtMail, .trailing, to:self.view, .trailing, constant:-16)
            ])
        self.view.addConstraints([
            //非常招集区分ラベル
            Constraint(lblKubun, .top, to:txtMail, .bottom, constant:24),
            Constraint(lblKubun, .leading, to:self.view, .leading, constant:16),
            Constraint(lblKubun, .width, to:self.view, .width, constant:0, multiplier:0.8)
            ])
        self.view.addConstraints([
            //非常招集区分テキストフィールド
            Constraint(txtKubun, .top, to:txtMail, .bottom, constant:24),
            Constraint(txtKubun, .leading, to:self.view, .centerX, constant:0),
            Constraint(txtKubun, .trailing, to:self.view, .trailing, constant:-16)
            ])
        self.view.addConstraints([
            //所属(大分類)ラベル
            Constraint(lblSyozoku0, .top, to:lblKubun, .bottom, constant:24),
            Constraint(lblSyozoku0, .leading, to:self.view, .leading, constant:16),
            Constraint(lblSyozoku0, .width, to:self.view, .width, constant:0, multiplier:0.8)
            ])
        self.view.addConstraints([
            //所属(大分類)テキストフィールド
            Constraint(txtSyozoku0, .top, to:lblKubun, .bottom, constant:24),
            Constraint(txtSyozoku0, .leading, to:self.view, .centerX, constant:0),
            Constraint(txtSyozoku0, .trailing, to:self.view, .trailing, constant:-16)
            ])
        self.view.addConstraints([
            //所属(小分類)ラベル
            Constraint(lblSyozoku, .top, to:lblSyozoku0, .bottom, constant:24),
            Constraint(lblSyozoku, .leading, to:self.view, .leading, constant:16),
            Constraint(lblSyozoku, .width, to:self.view, .width, constant:0, multiplier:0.8)
            ])
        self.view.addConstraints([
            //所属(小分類)テキストフィールド
            Constraint(txtSyozoku, .top, to:lblSyozoku0, .bottom, constant:24),
            Constraint(txtSyozoku, .leading, to:self.view, .centerX, constant:0),
            Constraint(txtSyozoku, .trailing, to:self.view, .trailing, constant:-16)
            ])
        self.view.addConstraints([
            //勤務区分ラベル
            Constraint(lblKinmu, .top, to:lblSyozoku, .bottom, constant:24),
            Constraint(lblKinmu, .leading, to:self.view, .leading, constant:16),
            Constraint(lblKinmu, .width, to:self.view, .width, constant:0, multiplier:0.8)
            ])
        self.view.addConstraints([
            //勤務区分テキストフィールド
            Constraint(txtKinmu, .top, to:lblSyozoku, .bottom, constant:24),
            Constraint(txtKinmu, .leading, to:self.view, .centerX, constant:0),
            Constraint(txtKinmu, .trailing, to:self.view, .trailing, constant:-16)
            ])
        self.view.addConstraints([
            //キャンセルボタン
            Constraint(btnCancel, .bottom, to:self.view, .bottom, constant:-10),
            Constraint(btnCancel, .leading, to:self.view, .leading, constant:8),
            Constraint(btnCancel, .trailing, to:self.view, .centerX, constant:-8)
            ])
        self.view.addConstraints([
            //登録ボタン
            Constraint(btnSave, .bottom, to:self.view, .bottom, constant:-10),
            Constraint(btnSave, .leading, to:self.view, .centerX, constant:8),
            Constraint(btnSave, .trailing, to:self.view, .trailing, constant:-8),
            ])
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
        case 1:
            rowNum = kubunArray.count
            break
        case 2:
            rowNum = syozoku0Array.count
            break
        case 3:
            rowNum = (syozokuArray[syozoku0Index] as AnyObject).count
            break
        case 4:
            rowNum = kinmuArray.count
            break
        default:
            rowNum = kubunArray.count
            break
        }
        
        return rowNum
    }
    
    //表示内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String?{
        //返す列
        var picComponent: String?
        switch pickerView.tag {
        case 1:
            picComponent = kubunArray[row] as? String
            break
        case 2:
            picComponent = syozoku0Array[row] as? String
            break
        case 3:
            picComponent = (syozokuArray[syozoku0Index] as! NSArray)[row] as? String
            break
        case 4:
            picComponent = kinmuArray[row] as? String
            break
        default:
            picComponent = kubunArray[row] as? String
            break
        }
        
        return picComponent
    }
    
    //選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row:Int, inComponent component:Int) {
        print("列:\(row)")
        switch pickerView.tag {
        case 1:
            txtKubun.text = kubunArray[row] as? String
            break
        case 2:
            txtSyozoku0.text = syozoku0Array[row] as? String
            //所属(小分類)の表示を変更
            syozoku0Index = row
            txtSyozoku.text = (syozokuArray[syozoku0Index] as! NSArray)[0] as? String
            break
        case 3:
            txtSyozoku.text = (syozokuArray[syozoku0Index] as! NSArray)[row] as? String
            break
        case 4:
            txtKinmu.text = kinmuArray[row] as? String
            break
        default:
            break
        }
    }
    
    //ツールバーで選択ボタンを押した時
    @objc func selectRow(){
        txtKubun.endEditing(true) //閉じるアクション
        txtSyozoku0.endEditing(true)
        txtSyozoku.endEditing(true)
        txtKinmu.endEditing(true)
    }
    
    //登録ボタンクリック
    @objc func onClickbtnSave(_ sender : UIButton){
        
        //DBに書き込み
        mDBHelper.update(txtName.text!, tel: txtTel.text!, mail: txtMail.text!, kubun: txtKubun.text!, syozoku0: txtSyozoku0.text!, syozoku: txtSyozoku.text!, kinmu: txtKinmu.text!, _id: mSelected[7])
        
        //画面遷移
        let data:ContactViewController = ContactViewController()
        let nav = UINavigationController(rootViewController: data)
        nav.setNavigationBarHidden(true, animated: false) //これをいれないとNavigationBarが表示されてうざい
        self.present(nav, animated: true, completion: nil)
    }
    
    //キャンセルボタンクリック
    @objc func onClickbtnCancel(_ sender : UIButton){
        //KinentaiViewControllerのインスタンス生成
        let data:ContactViewController = ContactViewController()
        
        //navigationControllerのrootViewControllerにKinentaiViewControllerをセット
        let nav = UINavigationController(rootViewController: data)
        nav.setNavigationBarHidden(true, animated: false) //これをいれないとNavigationBarが表示されてうざい
        
        //画面遷移
        self.present(nav, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
