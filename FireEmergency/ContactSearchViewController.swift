//
//  ContactSearchViewController.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2017/02/26.
//  Copyright © 2017年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class ContactSearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    //メイン画面
    let lblData         = UILabel(frame: CGRect.zero)
    let btnSelectAll    = UIButton(frame: CGRect.zero)
    let lblSearch1      = UILabel(frame: CGRect.zero)
    let lblSearch2      = UILabel(frame: CGRect.zero)
    let lblKubun        = UILabel(frame: CGRect.zero)
    let txtKubun        = UITextField(frame: CGRect.zero)
    let picKubun        = UIPickerView(frame: CGRect.zero)
    let kubunArray: NSArray = ["すべて","１号招集","２号招集","３号招集","４号招集"]
    let lblSyozoku0     = UILabel(frame: CGRect.zero)
    let txtSyozoku0     = UITextField(frame: CGRect.zero)
    let picSyozoku0     = UIPickerView(frame: CGRect.zero)
    let syozoku0Array: NSArray = ["すべて","消防局","北","都島","福島","此花","中央","西","港","大正","天王寺","浪速","西淀川","淀川","東淀川","東成","生野","旭","城東","鶴見","住之江","阿倍野","住吉","東住吉","平野","西成","水上","訓練センター"]
    let lblSyozoku      = UILabel(frame: CGRect.zero)
    let txtSyozoku      = UITextField(frame: CGRect.zero)
    let picSyozoku      = UIPickerView(frame: CGRect.zero)
    let syozokuArray: NSArray = [["すべて"],
                                 ["すべて","総務課","人事課","施設課","予防課","規制課","警防課","司令課","救急課"],
                                 ["すべて","北本署","梅田","浮田","南森町","与力","大淀町","本庄"],
                                 ["すべて","都島本署","高倉","東野田"],
                                 ["すべて","福島本署","上福島","海老江"],
                                 ["すべて","此花本署","桜島","西九条"],
                                 ["すべて","中央本署","東雲","道頓堀","南坂町","上町"],
                                 ["すべて","西本署","江戸堀","新町"],
                                 ["すべて","港本署","田中"],
                                 ["すべて","大正本署","泉尾","鶴町"],
                                 ["すべて","天王寺本署","元町"],
                                 ["すべて","浪速本署","恵美須","立葉","浪速出張所"],
                                 ["すべて","西淀川本署","佃","大和田","竹島"],
                                 ["すべて","淀川本署","十三橋","加島","東三国"],
                                 ["すべて","東淀川本署","豊里","小松","井高野","柴島","西淡路"],
                                 ["すべて","東成本署","中本","深江"],
                                 ["すべて","生野本署","勝山","中川","巽"],
                                 ["すべて","旭本署","新森","赤川"],
                                 ["すべて","城東本署","放出","中浜","関目"],
                                 ["すべて","鶴見本署","今津","矢田"],
                                 ["すべて","住之江本署","平林","加賀屋","南港"],
                                 ["すべて","阿倍野本署","清明通","阪南"],
                                 ["すべて","住吉本署","苅田","万代"],
                                 ["すべて","東住吉本署","北田辺","杭全","矢田"],
                                 ["すべて","平野本署","加美","長吉","喜連","加美正覚寺"],
                                 ["すべて","西成本署","海道","津守"],
                                 ["すべて","水上"],
                                 ["すべて","訓練センター"]]
    let lblKinmu        = UILabel(frame: CGRect.zero)
    let txtKinmu        = UITextField(frame: CGRect.zero)
    let picKinmu        = UIPickerView(frame: CGRect.zero)
    let kinmuArray: NSArray = ["すべて","日勤","１部","２部"]
    let btnSearch       = UIButton(frame: CGRect.zero)
    let btnCancel       = UIButton(frame: CGRect.zero)
    //別クラスのインスタンス保持用変数
    fileprivate var mInfoDialog: InfoDialog!
    fileprivate var mContactLoadDialog2: ContactLoadDialog2!
    //所属(大分類)のインデックス保存用
    fileprivate var syozoku0Index : Int = 0
    //SQLite用
    internal var mDBHelper: DBHelper!
    //ContactUpdateSelectDialogから送られてくる各テキストフィールドに放り込むデータ保存用
    fileprivate var mSelected: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mDBHelper = DBHelper()
        
        self.view.backgroundColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
        //連絡網ラベル
        lblData.text = "連絡網"
        lblData.adjustsFontSizeToFitWidth = true
        lblData.textColor = UIColor.black
        lblData.textAlignment = NSTextAlignment.left
        lblData.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblData)
        //全部選択ボタン
        btnSelectAll.backgroundColor = UIColor.lightGray
        btnSelectAll.layer.masksToBounds = true
        btnSelectAll.setTitle("データ全件一覧表示", for: UIControl.State())
        btnSelectAll.setTitleColor(UIColor.black, for: UIControl.State())
        btnSelectAll.setTitleColor(UIColor.red, for: UIControl.State.highlighted)
        btnSelectAll.layer.cornerRadius = 8.0
        btnSelectAll.addTarget(self, action: #selector(self.onClickbtnSelectAll(_:)), for: .touchUpInside)
        btnSelectAll.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnSelectAll)
        //グループ検索ラベル
        lblSearch1.text = "■グループ検索"
        lblSearch1.adjustsFontSizeToFitWidth = true
        lblSearch1.textAlignment = NSTextAlignment.left
        lblSearch1.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblSearch1)
        //グループ検索の説明文ラベル
        lblSearch2.text = "以下の条件を設定し「検索」を押してください"
        lblSearch2.adjustsFontSizeToFitWidth = true
        lblSearch2.textAlignment = NSTextAlignment.left
        lblSearch2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblSearch2)
        
        //pickerViewとともにポップアップするツールバーとボタンの設定
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(title:"選択", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.selectRow))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil) //小ワザ。上の選択ボタンを右寄せにするためのダミースペース
        toolbar.setItems([flexibleSpace, doneItem], animated: true)
        
        //非常招集区分ラベル
        lblKubun.text = "・非常招集区分"
        lblKubun.adjustsFontSizeToFitWidth = true
        lblKubun.textAlignment = NSTextAlignment.left
        lblKubun.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblKubun)
        //非常招集区分テキストフィールド
        txtKubun.borderStyle = UITextField.BorderStyle.bezel
        txtKubun.text = kubunArray[0] as? String
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
        lblSyozoku0.text = "・所属(大分類)"
        lblSyozoku0.adjustsFontSizeToFitWidth = true
        lblSyozoku0.textAlignment = NSTextAlignment.left
        lblSyozoku0.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblSyozoku0)
        //所属(大分類)テキストフィールド
        txtSyozoku0.borderStyle = UITextField.BorderStyle.bezel
        txtSyozoku0.text = syozoku0Array[0] as? String
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
        lblSyozoku.text = "・所属(小分類)"
        lblSyozoku.adjustsFontSizeToFitWidth = true
        lblSyozoku.textAlignment = NSTextAlignment.left
        lblSyozoku.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblSyozoku)
        //所属(小分類)テキストフィールド
        txtSyozoku.borderStyle = UITextField.BorderStyle.bezel
        txtSyozoku.text = "すべて"
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
        lblKinmu.text = "・勤務区分"
        lblKinmu.adjustsFontSizeToFitWidth = true
        lblKinmu.textAlignment = NSTextAlignment.left
        lblKinmu.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblKinmu)
        //勤務区分テキストフィールド
        txtKinmu.borderStyle = UITextField.BorderStyle.bezel
        txtKinmu.text = kinmuArray[0] as? String
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
        btnCancel.addTarget(self, action: #selector(self.onClickbtnCancel(_:)), for: .touchUpInside)
        btnCancel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnCancel)
        //検索ボタン
        btnSearch.backgroundColor = UIColor.red
        btnSearch.layer.masksToBounds = true
        btnSearch.setTitle("検索", for: UIControl.State())
        btnSearch.setTitleColor(UIColor.white, for: UIControl.State())
        btnSearch.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
        btnSearch.layer.cornerRadius = 8.0
        btnSearch.addTarget(self, action: #selector(self.onClickbtnSearch(_:)), for: .touchUpInside)
        btnSearch.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnSearch)
        
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
            //全件一覧表示ボタン
            Constraint(btnSelectAll, .top, to:lblData, .bottom, constant:24),
            Constraint(btnSelectAll, .leading, to:self.view, .leading, constant:16),
            Constraint(btnSelectAll, .trailing, to:self.view, .trailing, constant:-16)
            ])
        self.view.addConstraints([
            //グループ検索ラベル
            Constraint(lblSearch1, .top, to:btnSelectAll, .bottom, constant:36),
            Constraint(lblSearch1, .leading, to:self.view, .leading, constant:16),
            Constraint(lblSearch1, .trailing, to:self.view, .trailing, constant:-16)
            ])
        self.view.addConstraints([
            //グループ検索の説明ラベル
            Constraint(lblSearch2, .top, to:lblSearch1, .bottom, constant:24),
            Constraint(lblSearch2, .leading, to:self.view, .leading, constant:16),
            Constraint(lblSearch2, .trailing, to:self.view, .trailing, constant:-16)
            ])
        self.view.addConstraints([
            //非常招集区分ラベル
            Constraint(lblKubun, .top, to:lblSearch2, .bottom, constant:24),
            Constraint(lblKubun, .leading, to:self.view, .leading, constant:16),
            Constraint(lblKubun, .width, to:self.view, .width, constant:0, multiplier:0.8)
            ])
        self.view.addConstraints([
            //非常招集区分テキストフィールド
            Constraint(txtKubun, .top, to:lblSearch2, .bottom, constant:24),
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
            //検索ボタン
            Constraint(btnSearch, .bottom, to:self.view, .bottom, constant:-10),
            Constraint(btnSearch, .leading, to:self.view, .centerX, constant:8),
            Constraint(btnSearch, .trailing, to:self.view, .trailing, constant:-8),
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
    
    //全件一覧表示ボタンクリック
    @objc func onClickbtnSelectAll(_ sender : UIButton){
        mDBHelper.selectAll()
        mContactLoadDialog2 = ContactLoadDialog2(parentView: self, resultFrom: mDBHelper.resultArray)
        mContactLoadDialog2.showResult()
    }
    
    //検索ボタンクリック
    @objc func onClickbtnSearch(_ sender : UIButton){
        //DBにつないでselect文実行
        mDBHelper.select(txtKubun.text!, syozoku0: txtSyozoku0.text!, syozoku: txtSyozoku.text!, kinmu: txtKinmu.text!)
        mContactLoadDialog2 = ContactLoadDialog2(parentView: self, resultFrom: mDBHelper.resultArray)
        mContactLoadDialog2.showResult()
    }
    
    //キャンセルボタンクリック
    @objc func onClickbtnCancel(_ sender : UIButton){
        //自己を破棄し、呼び出し元へ遷移
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
