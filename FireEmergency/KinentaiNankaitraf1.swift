//
//  KinentaiNankaitraf1.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2017/01/18.
//  Copyright © 2017年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class KinentaiNankaitraf1 : UITextField, UIPickerViewDelegate, UIPickerViewDataSource {
    //ボタン押したら出るUIWindow
    fileprivate var parent: KinentaiViewController!
    fileprivate var win1: UIWindow!
    fileprivate var text1: UITextView!
    fileprivate var textField1: UITextField!
    fileprivate var pic1: UIPickerView!
    let pic1Array: NSArray = ["山梨県中・西部","長野県南部","静岡県東部","静岡県中部","静岡県西部","駿河湾","駿河湾南方沖","新島・神津島近海","愛知県東部","愛知県西部","遠州灘","三河湾","岐阜県美濃東部","三重県北部","三重県中部","三重県南部","伊勢湾","三重県南東沖","和歌山県北部","和歌山県南部","和歌山県南方沖","紀伊水道","奈良県","淡路島付近","播磨灘","徳島県北部","徳島県南部","香川県東部","香川県西部","瀬戸内海中部","愛媛県東予","愛媛県中予","愛媛県南予","伊予灘","豊後水道","高知県東部","高知県中部","高知県西部","土佐湾","四国沖","大分県南部","宮崎県北部平野部","日向灘","九州地方南東沖","その他"]
    fileprivate var label2: UITextView!
    fileprivate var label3: UITextView! // 2021-12-12 add
    //2019-02-03 削除
    /*fileprivate var text2: UITextView!
    fileprivate var textField2: UITextField!
    fileprivate var pic2: UIPickerView!
    let pic2Array: NSArray = ["山梨県","長野県","岐阜県","静岡県","愛知県","三重県","その他"]
    fileprivate var text3: UITextView!
    fileprivate var textField3: UITextField!
    fileprivate var pic3: UIPickerView!
    let pic3Array: NSArray = ["兵庫県","奈良県","和歌山県","その他"]
    fileprivate var text4: UITextView!
    fileprivate var textField4: UITextField!
    fileprivate var pic4: UIPickerView!
    let pic4Array: NSArray = ["徳島県","香川県","愛媛県","高知県","大分県","宮崎県","その他"]*/
    fileprivate var btnClose: UIButton!
    fileprivate var btnAction: UIButton!
    fileprivate var mKinentaiResultDialog: KinentaiResultDialog!
    //fileprivate var mKinentaiSelectDialog: KinentaiSelectDialog!  //2018-09-26 追加->2019-02-03 削除
    fileprivate var mKinentaiSelectDialog3: KinentaiSelectDialog3! //2019-02-03 追加
    
    // 2019-02-03 追加
    class CheckBox: UIButton {
        // Images
        let checkedImage = UIImage(named: "ic_check_box.png")! as UIImage
        let uncheckedImage = UIImage(named: "ic_check_box_outline_blank.png")! as UIImage
        
        // Bool property
        var isChecked: Bool = false {
            didSet{
                if isChecked == true {
                    self.setImage(checkedImage, for: UIControl.State.normal)
                } else {
                    self.setImage(uncheckedImage, for: UIControl.State.normal)
                }
            }
        }
        
        override func awakeFromNib() {
            self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
            self.isChecked = false
        }
        
        @objc func buttonClicked(sender: UIButton) {
            if sender == self {
                isChecked = !isChecked
            }
        }
    }
    fileprivate var chk1: CheckBox!
    fileprivate var chk2: CheckBox!
    fileprivate var chk3: CheckBox!
    fileprivate var chk4: CheckBox! //2021-12-12追加
    
    //UITextFieldを便宜的に親として継承しているため。UIViewControllerを継承したくないための策。
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //コンストラクタ
    init(parentView: KinentaiViewController){
        super.init(frame: CGRect.zero)

        parent      = parentView
        win1        = UIWindow()
        text1       = UITextView()
        textField1  = UITextField()
        pic1        = UIPickerView()
        label2      = UITextView()
        //2021-12-12 add
        label3      = UITextView()
        //2019-02-03 削除
        /*
        text2       = UITextView()
        textField2  = UITextField()
        pic2        = UIPickerView()
        text3       = UITextView()
        textField3  = UITextField()
        pic3        = UIPickerView()
        text4       = UITextView()
        textField4  = UITextField()
        pic4        = UIPickerView()*/
        btnClose    = UIButton()
        btnAction   = UIButton()
        
        // 2019-02-03 追加
        chk1 = CheckBox()
        chk2 = CheckBox()
        chk3 = CheckBox()
        // 2021-12-12 追加
        chk4 = CheckBox()
    }
    
    //デコンストラクタ
    deinit{
        parent      = nil
        win1        = nil
        
        text1       = nil
        textField1  = nil
        pic1        = nil
        
        label2      = nil
        //2021-12-12 add
        label3      = nil
        //2019-02-03 削除
        /*
        text2       = nil
        textField2  = nil
        pic2        = nil
        
        text3       = nil
        textField3  = nil
        pic3        = nil
        
        text4       = nil
        textField4  = nil
        pic4        = nil*/
        
        btnClose    = nil
        btnAction   = nil
        
        // 2019-02-03 追加
        chk1 = nil
        chk2 = nil
        chk3 = nil
        // 2021-12-12 追加
        chk4 = nil
    }
    
    //表示
    func showResult(){
        //元の画面を暗く
        parent.view.alpha = 0.3
        mViewController.view.alpha = 0.3
        //初期設定
        //Win1
        win1.backgroundColor = UIColor.white
        win1.frame = CGRect(x: 80,y: 10,width: parent.view.frame.width-40,height: parent.view.frame.height)
        win1.layer.position = CGPoint(x: parent.view.frame.width/2, y: parent.view.frame.height/2+72) //+72調整
        win1.alpha = 1.0
        win1.layer.cornerRadius = 10
        //KeyWindowにする
        win1.makeKey()
        //表示
        self.win1.makeKeyAndVisible()
        
        //１セット目
        //text1生成
        text1.frame = CGRect(x: 10,y: 10, width: self.win1.frame.width - 20, height: self.win1.frame.height-60)
        text1.backgroundColor = UIColor.clear
        text1.font = UIFont.systemFont(ofSize: CGFloat(14))
        text1.textColor = UIColor.black
        text1.textAlignment = NSTextAlignment.left
        text1.isEditable = false
        text1.isScrollEnabled = true
        text1.dataDetectorTypes = .link
        text1.text = "南海トラフ地震アクションプラン\n\n次の①②を満たした場合に適用\n\n①震央地名が次のいずれかに該当"
        self.win1.addSubview(text1)
        //textField1
        textField1.frame = CGRect(x: 10,y: 100, width: self.win1.frame.width - 20, height: 60)
        textField1.backgroundColor = UIColor.clear
        textField1.font = UIFont.systemFont(ofSize: (CGFloat(14)))
        textField1.textAlignment = NSTextAlignment.center
        textField1.text = pic1Array[0] as? String
        textField1.inputView = pic1 //ここでpickerView1と紐付け
        //pickerViewとともにポップアップするツールバーとボタンの設定
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(title:"選択", style: UIBarButtonItem.Style.plain, target: self, action: #selector(KinentaiNankaitraf1.done))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil) //小ワザ。上の選択ボタンを右寄せにするためのダミースペース
        toolbar.setItems([flexibleSpace, doneItem], animated: true)
        textField1.inputAccessoryView = toolbar
        self.win1.addSubview(textField1)
        //pic1
        pic1.delegate = self
        pic1.dataSource = self
        pic1.translatesAutoresizingMaskIntoConstraints = false
        pic1.tag = 1
        pic1.selectRow(0, inComponent:0, animated:false) //呼び出したrow値でピッカー初期化
        
        //label2生成
        label2.text = "②中部地方、近畿地方、四国・九州地方の３地域のいずれにおいても、震度６強以上が観測された場合、又は大津波警報が発表された場合"
        label2.frame = CGRect(x: 10,y: 140, width: self.win1.frame.width - 20, height: 90)
        label2.backgroundColor = UIColor.clear
        label2.font = UIFont.systemFont(ofSize: (CGFloat(14)))
        label2.textColor = UIColor.black
        label2.textAlignment = NSTextAlignment.left
        self.win1.addSubview(label2)
        
        //2019-02-03 削除
        /*
        //２セット目
        //text2生成
        text2.frame = CGRect(x: 10,y: 200, width: 100, height: 60)
        text2.backgroundColor = UIColor.clear
        text2.font = UIFont.systemFont(ofSize: CGFloat(14))
        text2.textColor = UIColor.black
        text2.textAlignment = NSTextAlignment.left
        text2.isEditable = false
        text2.isScrollEnabled = true
        text2.text = "■中部地方"
        self.win1.addSubview(text2)
        //textField2
        textField2.frame = CGRect(x: 60,y: 187, width: self.win1.frame.width - 20, height: 60)
        textField2.backgroundColor = UIColor.clear
        textField2.font = UIFont.systemFont(ofSize: (CGFloat(14)))
        textField2.textAlignment = NSTextAlignment.center
        textField2.text = pic2Array[0] as? String
        textField2.inputView = pic2 //ここでpic2と紐付け
        //pickerViewとともにポップアップするツールバーとボタンの設定
        textField2.inputAccessoryView = toolbar
        self.win1.addSubview(textField2)
        //pic2
        pic2.delegate = self
        pic2.dataSource = self
        pic2.translatesAutoresizingMaskIntoConstraints = false
        pic2.tag = 2
        pic2.selectRow(0, inComponent:0, animated:false) //呼び出したrow値でピッカー初期化
        
        //３セット目
        //text3生成
        text3.frame = CGRect(x: 10,y: 240, width: 100, height: 60)
        text3.backgroundColor = UIColor.clear
        text3.font = UIFont.systemFont(ofSize: CGFloat(14))
        text3.textColor = UIColor.black
        text3.textAlignment = NSTextAlignment.left
        text3.isEditable = false
        text3.isScrollEnabled = true
        text3.text = "■近畿地方"
        self.win1.addSubview(text3)
        //textField3
        textField3.frame = CGRect(x: 60,y: 227, width: self.win1.frame.width - 20, height: 60)
        textField3.backgroundColor = UIColor.clear
        textField3.font = UIFont.systemFont(ofSize: (CGFloat(14)))
        textField3.textAlignment = NSTextAlignment.center
        textField3.text = pic3Array[0] as? String
        textField3.inputView = pic3 //ここでpic21と紐付け
        //pickerViewとともにポップアップするツールバーとボタンの設定
        textField3.inputAccessoryView = toolbar
        self.win1.addSubview(textField3)
        //pic3
        pic3.delegate = self
        pic3.dataSource = self
        pic3.translatesAutoresizingMaskIntoConstraints = false
        pic3.tag = 3
        pic3.selectRow(0, inComponent:0, animated:false) //呼び出したrow値でピッカー初期化
        
        //４セット目
        //text4生成
        text4.frame = CGRect(x: 10,y: 280, width: 110, height: 60)
        text4.backgroundColor = UIColor.clear
        text4.font = UIFont.systemFont(ofSize: CGFloat(12))
        text4.textColor = UIColor.black
        text4.textAlignment = NSTextAlignment.left
        text4.isEditable = false
        text4.isScrollEnabled = true
        text4.text = "■四国・九州地方"
        self.win1.addSubview(text4)
        //textField4
        textField4.frame = CGRect(x: 60,y: 267, width: self.win1.frame.width - 20, height: 60)
        textField4.backgroundColor = UIColor.clear
        textField4.font = UIFont.systemFont(ofSize: (CGFloat(14)))
        textField4.textAlignment = NSTextAlignment.center
        textField4.text = pic4Array[0] as? String
        textField4.inputView = pic4 //ここでpic21と紐付け
        //pickerViewとともにポップアップするツールバーとボタンの設定
        textField4.inputAccessoryView = toolbar
        self.win1.addSubview(textField4)
        //pic4
        pic4.delegate = self
        pic4.dataSource = self
        pic4.translatesAutoresizingMaskIntoConstraints = false
        pic4.tag = 4
        pic4.selectRow(0, inComponent:0, animated:false) //呼び出したrow値でピッカー初期化
        */
        
        // checkbox生成　2019-02-03 追加
        chk1.frame = CGRect(x:10, y:210, width:self.win1.frame.width-20, height:60)
        chk1.setTitle("中部地方：山梨県、長野県、岐阜県、静岡県、愛知県、三重県", for: UIControl.State())
        chk1.setTitleColor(UIColor.black, for: UIControl.State())
        chk1.titleLabel?.font = UIFont.systemFont(ofSize: (CGFloat(14)))
        chk1.titleLabel?.numberOfLines = 2
        chk1.awakeFromNib()
        self.win1.addSubview(chk1)
        
        chk2.frame = CGRect(x:10, y:270, width:self.win1.frame.width-20, height:60)
        chk2.setTitle("近畿地方：兵庫県、奈良県、和歌山県                          ", for: UIControl.State())
        chk2.setTitleColor(UIColor.black, for: UIControl.State())
        chk2.titleLabel?.font = UIFont.systemFont(ofSize: (CGFloat(14)))
        chk2.titleLabel?.numberOfLines = 2
        chk2.awakeFromNib()
        self.win1.addSubview(chk2)
        
        chk3.frame = CGRect(x:10, y:330, width:self.win1.frame.width-20, height:60)
        chk3.setTitle("四国・九州地方：徳島県、香川県、愛媛県、高知県、大分県、宮崎県", for: UIControl.State())
        chk3.setTitleColor(UIColor.black, for: UIControl.State())
        chk3.titleLabel?.font = UIFont.systemFont(ofSize: (CGFloat(14)))
        chk3.titleLabel?.numberOfLines = 2
        chk3.awakeFromNib()
        self.win1.addSubview(chk3)
        
        //2021-12-12 add
        //label3生成
        label3.text = "又は"
        label3.frame = CGRect(x: 10,y: 390, width: self.win1.frame.width - 20, height: 30)
        label3.backgroundColor = UIColor.clear
        label3.font = UIFont.systemFont(ofSize: (CGFloat(14)))
        label3.textColor = UIColor.black
        label3.textAlignment = NSTextAlignment.left
        self.win1.addSubview(label3)
        
        chk4.frame = CGRect(x:10, y:420, width:self.win1.frame.width-20, height:60)
        chk4.setTitle("発生した地震がＭ8.0以上の場合(南海トラフ地震臨時情報(巨大地震警戒)が発表される可能性がある場合)", for: UIControl.State())
        chk4.setTitleColor(UIColor.black, for: UIControl.State())
        chk4.titleLabel?.font = UIFont.systemFont(ofSize: (CGFloat(14)))
        chk4.titleLabel?.numberOfLines = 3
        chk4.awakeFromNib()
        self.win1.addSubview(chk4)
        
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
        
        //判定ボタン生成
        btnAction.frame = CGRect(x: 0,y: 0,width: 100,height: 30)
        btnAction.backgroundColor = UIColor.red
        btnAction.setTitle("判定", for: UIControl.State())
        btnAction.setTitleColor(UIColor.white, for: UIControl.State())
        btnAction.layer.masksToBounds = true
        btnAction.layer.cornerRadius = 10.0
        btnAction.layer.position = CGPoint(x: self.win1.frame.width/2+60, y: self.win1.frame.height-20)
        btnAction.addTarget(self, action: #selector(self.onClickAction(_:)), for: .touchUpInside)
        self.win1.addSubview(btnAction)
    }
    
    //表示例数
    func numberOfComponents(in pickerView: UIPickerView)-> Int{
        return 1
    }
    
    //表示行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int)-> Int{
        //返す行数
        var rowNum: Int = 0
        switch pickerView.tag {
        case 1:
            rowNum = pic1Array.count
            break
        //2019-02-03 削除
        /*
        case 2:
            rowNum = pic2Array.count
            break
        case 3:
            rowNum = pic3Array.count
            break
        case 4:
            rowNum = pic4Array.count
            break*/
        default:
            rowNum = pic1Array.count
            break
        }

        return rowNum
    }
    
    //表示内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String? {
        //返す列
        var picComponent: String?
        switch pickerView.tag {
        case 1:
            picComponent = pic1Array[row] as? String
            break
        //2019-02-03 削除
        /*
        case 2:
            picComponent = pic2Array[row] as? String
            break
        case 3:
            picComponent = pic3Array[row] as? String
            break
        case 4:
            picComponent = pic4Array[row] as? String
            break*/
        default:
            picComponent = pic1Array[row] as? String
            break
        }

        return picComponent
    }
    
    //選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row:Int, inComponent component:Int) {
        print("列:\(row)")
        switch pickerView.tag {
        case 1:
            textField1.text = pic1Array[row] as? String
            break
        //2019-02-03 削除
        /*
        case 2:
            textField2.text = pic2Array[row] as? String
            break
        case 3:
            textField3.text = pic3Array[row] as? String
            break
        case 4:
            textField4.text = pic4Array[row] as? String
            break*/
        default:
            break
        }
    }
    
    //ツールバーの選択ボタンを押した時
    @objc func done() {
        textField1.endEditing(true) //これで閉じる
        //2019-02-03 削除
        /*
        textField2.endEditing(true)
        textField3.endEditing(true)
        textField4.endEditing(true)*/
    }
    
    //閉じる
    @objc func onClickClose(_ sender: UIButton){
        win1.isHidden = true      //win1隠す
        text1.text = ""         //使い回しするのでテキスト内容クリア
        parent.view.alpha = 1.0 //元の画面明るく
        mViewController.view.alpha = 1.0
    }
    
    //判定
    @objc func onClickAction(_ sender: UIButton){
        win1.isHidden = true      //win1隠す
        text1.text = ""         //使い回しするのでテキスト内容クリア
        parent.view.alpha = 1.0 //元の画面明るく
        //対応の結果であるアクションプランを表示
        var i: Int8 = 0
        if chk1.isChecked {i += 1}
        if chk2.isChecked {i += 1}
        if chk3.isChecked {i += 1}
        //対応の結果であるアクションプランを表示
        if (textField1.text != "その他" && i==3) || chk4.isChecked {
            // 2018-09-26 遷移先を選択用ダイアログに変更
            /* mKinentaiResultDialog = KinentaiResultDialog(parentView: parent)
            mKinentaiResultDialog.showResult(34, item: 0) */
            //2019-02-03 追加
            /*mKinentaiSelectDialog = KinentaiSelectDialog(index: 34, parentView: parent)
            mKinentaiSelectDialog.showInfo()*/
            mKinentaiSelectDialog3 = KinentaiSelectDialog3(index: 3, parentView: parent)
            mKinentaiSelectDialog3.showInfo()            
        } else {
            mKinentaiResultDialog = KinentaiResultDialog(parentView: parent)
            mKinentaiResultDialog.showResult(35, item: 0)
        }
    }
}
