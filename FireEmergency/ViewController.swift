//
//  ViewController.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2016/09/11.
//  Copyright © 2016年 tadakazu nakamichi. All rights reserved.
//

import UIKit

//グローバル変数
internal var mViewController: ViewController!
internal var mViewController2: ViewController2!

class ViewController: UIViewController {
    //メイン画面
    var mSegment: UISegmentedControl!
    let btnData         = UIButton(frame: CGRect.zero)
    let btnPersonal     = UIButton(frame: CGRect.zero)
    //別クラスのインスタンス保持用変数
    //fileprivate var mViewController: ViewController!
    fileprivate var mInfoDialog: InfoDialog!
    fileprivate var mBousainetDialog: BousainetDialog!
    fileprivate var mEarthSelectDialog: EarthSelectDialog!
    fileprivate var mContactLoadDialog: ContactLoadDialog2!
    fileprivate var mPassInputDialog: PassInputDialog!
    //結果表示用クラス保持用
    internal var mEarthResultDialog: EarthResultDialog!
    //データ保存用
    let userDefaults = UserDefaults.standard
    //SQLite用
    internal var mDBHelper: DBHelper!
    
    //震災、風水害、国民保護、緊援隊それぞれ４つのViewController設定
    private lazy var mEarthquakeViewController: EarthquakeViewController = {
        var viewController = EarthquakeViewController()
        add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var mTyphoonViewController: TyphoonViewController = {
        var viewController = TyphoonViewController()
        add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var mKokuminhogoViewController: KokuminhogoViewController = {
        var viewController = KokuminhogoViewController()
        add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var mKinentaiViewController: KinentaiViewController = {
        var viewController = KinentaiViewController()
        add(asChildViewController: viewController)
        return viewController
    }()
    
    //スタート
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //自分を保存：後でダイアログ表示の際に暗くするときの呼び出しに使うため
        mViewController = self
        //基礎データ入力、連絡網データ操作、アプリ説明書のViewController2生成
        mViewController2 = ViewController2()
        //DB生成
        mDBHelper = DBHelper()
        mDBHelper.createTable()
        
        //初回起動判定
        if userDefaults.bool(forKey: "firstLaunch"){
            //初回起動時処理 一度も基礎データ入力されないorデータ入力画面でもスピナーをさわらない場合はセットされない=結果でnilが表示される　それを防止
            //基礎データ
            userDefaults.set("消防局", forKey: "mainStation")
            userDefaults.set("消防局", forKey: "tsunamiStation")
            userDefaults.set("１号招集", forKey: "kubun")
            //非常参集　職員情報
            userDefaults.set("", forKey: "personalId")
            userDefaults.set("", forKey: "personalClass")
            userDefaults.set("", forKey: "personalAge")
            userDefaults.set("", forKey: "personalDepartment")
            userDefaults.set("", forKey: "personalName")
            userDefaults.set(false, forKey: "personalEngineer")
            userDefaults.set(false, forKey: "personalParamdic")
            
            //DBダミーデータ生成
            mDBHelper.insert("大阪　太郎",tel: "09099999999",mail: "tadakazu1972@gmail.com",kubun: "４号招集",syozoku0: "消防局",syozoku: "警防課",kinmu: "日勤")
            mDBHelper.insert("浪速　緑",tel: "07077777777",mail: "ta-nakamichi@city.osaka.lg.jp",kubun: "３号招集",syozoku0: "北消防署",syozoku: "与力",kinmu: "１部")
            
            //２回目以降ではfalseに
            userDefaults.set(false, forKey: "firstLaunch")
        }
        
        //親ViewController背景
        self.view.backgroundColor = UIColor(red:0.9, green:0.7, blue:0.2, alpha:1.0)
        
        //SegmentedControll生成
        let segItems = ["震災","風水害","国民保護","緊援隊"]
        mSegment = UISegmentedControl(items: segItems)
        mSegment.frame = CGRect(x: 10, y:92, width: UIScreen.main.bounds.size.width-20, height:40)
        if #available(iOS 13.0, *) {
            mSegment.selectedSegmentTintColor = UIColor(red:0.3, green:0.61, blue:0.93, alpha:1.0)
        } else {
            // Fallback on earlier versions
            mSegment.tintColor = UIColor(red:0.3, green:0.61, blue:0.93, alpha:1.0)
        }
        mSegment.backgroundColor = UIColor(red:0.96, green:0.98, blue:1.00, alpha:1.0)
        //選択されたセグメントのフォントと文字色
        mSegment.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "HiraKakuProN-W6", size:14.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        //通常のセグメントのフォントと文字色
        mSegment.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "HiraKakuProN-W3", size:14.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        //セグメントの選択
        mSegment.selectedSegmentIndex = 0
        mSegment.addTarget(self, action: #selector(segmentChanged(_:)), for:UIControl.Event.valueChanged)
        self.view.addSubview(mSegment)
        //Button生成
        //基礎データ入力
        btnData.backgroundColor = UIColor.blue
        btnData.layer.masksToBounds = true
        btnData.setTitle("基礎データ入力", for: UIControl.State())
        btnData.setTitleColor(UIColor.white, for: UIControl.State())
        btnData.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
        btnData.layer.cornerRadius = 8.0
        btnData.tag = 0
        btnData.addTarget(self, action: #selector(self.onClickbtnData(_:)), for: .touchUpInside)
        btnData.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnData)
        
        //非常参集職員情報登録画面遷移ボタン
        btnPersonal.backgroundColor = UIColor.red
        btnPersonal.layer.masksToBounds = true
        btnPersonal.setTitle("非常参集受付", for: UIControl.State())
        btnPersonal.setTitleColor(UIColor.white, for: UIControl.State())
        btnPersonal.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
        btnPersonal.layer.cornerRadius = 8.0
        btnPersonal.tag = 0
        btnPersonal.translatesAutoresizingMaskIntoConstraints = false
        btnPersonal.addTarget(self, action: #selector(self.onClickbtnPersonal(_:)), for: .touchUpInside)
        self.view.addSubview(btnPersonal)
        
        //ボタン押したら表示するDialog生成
        mInfoDialog = InfoDialog(parentView: self) //このViewControllerを渡してあげる
        mBousainetDialog = BousainetDialog(parentView: self)
        mPassInputDialog = PassInputDialog(parentView: self)
        
        //passCheckをfalseで初期化
        userDefaults.set(false, forKey: "passCheck")
        
        //子ViewControllerセット
        setupView()
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
            //基礎データ入力ボタン
            Constraint(btnData, .top, to:self.view, .top, constant:44),
            Constraint(btnData, .leading, to:self.view, .leading, constant:8),
            Constraint(btnData, .trailing, to:self.view, .centerX, constant:-8)
        ])
        self.view.addConstraints([
            //非常参集受付ボタン
            Constraint(btnPersonal, .top, to:self.view, .top, constant:44),
            Constraint(btnPersonal, .leading, to:self.view, .centerX, constant:8),
            Constraint(btnPersonal, .trailing, to:self.view, .trailingMargin, constant:8)
        ])
    }
    
    private func setupView(){
        updateView()
    }
    
    private func updateView(){
        switch mSegment.selectedSegmentIndex {
        //震災
        case 0:
            remove(asChildViewController: mTyphoonViewController)
            remove(asChildViewController: mKokuminhogoViewController)
            remove(asChildViewController: mKinentaiViewController)
            add(asChildViewController: mEarthquakeViewController)
            //親ViewController背景
            self.view.backgroundColor = UIColor(red:0.9, green:0.7, blue:0.2, alpha:1.0)
            //データ登録ボタン背景色
            btnData.backgroundColor = UIColor.blue
        //風水害
        case 1:
            remove(asChildViewController: mEarthquakeViewController)
            remove(asChildViewController: mKokuminhogoViewController)
            remove(asChildViewController: mKinentaiViewController)
            add(asChildViewController: mTyphoonViewController)
            //親ViewController背景
            self.view.backgroundColor = UIColor(red:0.2, green:0.2, blue:0.9, alpha:1.0)
            //データ登録ボタン背景色
            btnData.backgroundColor = UIColor.red
        //国民保護
        case 2:
            remove(asChildViewController: mEarthquakeViewController)
            remove(asChildViewController: mTyphoonViewController)
            remove(asChildViewController: mKinentaiViewController)
            add(asChildViewController: mKokuminhogoViewController)
            //親ViewController背景
            self.view.backgroundColor = UIColor(red:0.0, green:0.55, blue:0.0, alpha:1.0)
            //データ登録ボタン背景色
            btnData.backgroundColor = UIColor.blue
        //緊援隊
        case 3:
            remove(asChildViewController: mEarthquakeViewController)
            remove(asChildViewController: mTyphoonViewController)
            remove(asChildViewController: mKokuminhogoViewController)
            add(asChildViewController: mKinentaiViewController)
            //親ViewController背景
            self.view.backgroundColor = UIColor(red:0.8, green:0.15, blue:0.1, alpha:1.0)
            //データ登録ボタン背景色
            btnData.backgroundColor = UIColor.blue
        default:
            break
        }
    }
    
    //セグメントが変更された
    @objc func segmentChanged(_ segment:UISegmentedControl){
        updateView()
    }
    
    //子ViewController 追加、削除
    private func add(asChildViewController viewController: UIViewController){
        addChild(viewController)
        self.view.addSubview(viewController.view)
        //viewController.view.frame = self.view.bounds
        viewController.view.frame = CGRect(x: 0, y: 144, width: self.view.bounds.size.width, height: self.view.bounds.height-144)
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //子ViewControllerへ通知
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController){
        //子ViewControllerへ通知
        viewController.willMove(toParent: nil)
        //子ViewをSuperviewから削除
        viewController.view.removeFromSuperview()
        //子ViewControllerへ通知
        viewController.removeFromParent()
    }
    
    //基礎データ入力画面遷移
    @objc func onClickbtnData(_ sender : UIButton){
        //自身を暗く
        self.view.alpha = 0.0
        //常に基礎データ入力画面に遷移するよう設定
        mScreen = 1
        mViewController2.updateView()
        //navigationControllerのrootViewControllerにViewController2をセット
        let nav = UINavigationController(rootViewController: mViewController2)
        nav.setNavigationBarHidden(true, animated: false) //これをいれないとNavigationBarが表示されてうざい
        //画面遷移
        self.present(nav, animated: true, completion: nil)        
    }
    
    //非常参集　職員情報登録画面遷移
    @objc func onClickbtnPersonal(_ sender : UIButton){
        //自身を暗く
        self.view.alpha = 0.0
        mScreen = 4
        mViewController2.updateView()
        //navigationControllerのrootViewControllerにViewController2をセット
        let nav = UINavigationController(rootViewController: mViewController2)
        nav.setNavigationBarHidden(true, animated: false) //これをいれないとNavigationBarが表示されてうざい
        //画面遷移
        self.present(nav, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

