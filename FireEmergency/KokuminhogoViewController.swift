//
//  KokuminhogoViewController.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2016/11/06.
//  Copyright © 2016年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class KokuminhogoViewController: UIViewController, UIScrollViewDelegate {
    //メイン画面
    let lblKokuminhogo   = UILabel(frame: CGRect.zero)
    let btnKokuminhogo1  = UIButton(frame: CGRect.zero)
    let btnKokuminhogo2  = UIButton(frame: CGRect.zero)
    let btnKokuminhogo3  = UIButton(frame: CGRect.zero)
    let btnKokuminhogo4  = UIButton(frame: CGRect.zero)
    let btnKokuminhogo5  = UIButton(frame: CGRect.zero)
    let btnKokuminhogo6  = UIButton(frame: CGRect.zero) // 2021.11.30　追加
    let btnClose         = UIButton(frame: CGRect.zero) // 2021.11.30　追加
    let padY1           = UIView(frame: CGRect.zero) //ボタンの間にはさむ見えないpaddingがわり
    let padY2           = UIView(frame: CGRect.zero)
    let padY3           = UIView(frame: CGRect.zero)
    let padY4           = UIView(frame: CGRect.zero)
    let padY5           = UIView(frame: CGRect.zero)
    let padY6           = UIView(frame: CGRect.zero)
    let btnKokuminhogoKankeikikan = UIButton(frame: CGRect.zero)
    let btnKokuminhogoBlackout    = UIButton(frame: CGRect.zero)
    let btnKokuminhogoRoad        = UIButton(frame: CGRect.zero)
    let btnKokuminhogoTel         = UIButton(frame: CGRect.zero)
    let btnKokuminhogoCaution     = UIButton(frame: CGRect.zero)
    let btnKokuminhogoBousaiNet   = UIButton(frame: CGRect.zero)
    let pad21            = UIView(frame: CGRect.zero) //ボタンの間にはさむ見えないpaddingがわり
    let pad22            = UIView(frame: CGRect.zero)
    let pad23            = UIView(frame: CGRect.zero)
    let pad31            = UIView(frame: CGRect.zero) //ボタンの間にはさむ見えないpaddingがわり
    let pad32            = UIView(frame: CGRect.zero)
    let pad33            = UIView(frame: CGRect.zero)
    //北朝鮮ミサイル　画像追加用
    fileprivate var scrollView = UIScrollView(frame: CGRect.zero)
    fileprivate var text0: UITextView!
    fileprivate var imageView1 = UIImageView(frame: CGRect.zero)
    fileprivate var text1: UITextView!
    fileprivate var imageView2 = UIImageView(frame: CGRect.zero)
    fileprivate var text2: UITextView!
    //別クラスのインスタンス保持用変数
    internal var mInfoDialog: InfoDialog!
    fileprivate var mBousainetDialog: BousainetDialog!
    fileprivate var mKokuminhogoSelectDialog: KokuminhogoSelectDialog!
    internal var mKokuminhogoResultDialog: KokuminhogoResultDialog!
    fileprivate var mPassInputDialog: PassInputDialog!
    //データ保存用
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.0, green:0.55, blue:0.0, alpha:1.0)
        //Button生成
        //非常警備基準（国民保護）
        lblKokuminhogo.text = "非常警備基準（国民保護）"
        lblKokuminhogo.textColor = UIColor.white
        lblKokuminhogo.textAlignment = NSTextAlignment.center
        lblKokuminhogo.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblKokuminhogo)
        //１号非常招集
        btnKokuminhogo1.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKokuminhogo1.layer.masksToBounds = true
        btnKokuminhogo1.setTitle("第１非常警備(１号招集)", for: UIControl.State())
        btnKokuminhogo1.setTitleColor(UIColor.black, for: UIControl.State())
        btnKokuminhogo1.setTitleColor(UIColor.red, for: UIControl.State.highlighted)
        btnKokuminhogo1.tag=5
        btnKokuminhogo1.translatesAutoresizingMaskIntoConstraints = false
        btnKokuminhogo1.addTarget(self, action: #selector(self.showKokuminhogo1(_:)), for: .touchUpInside)
        self.view.addSubview(btnKokuminhogo1)
        //２号非常招集
        btnKokuminhogo2.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKokuminhogo2.layer.masksToBounds = true
        btnKokuminhogo2.setTitle("第２非常警備(２号招集)", for: UIControl.State())
        btnKokuminhogo2.setTitleColor(UIColor.black, for: UIControl.State())
        btnKokuminhogo2.tag=6
        btnKokuminhogo2.translatesAutoresizingMaskIntoConstraints = false
        btnKokuminhogo2.addTarget(self, action: #selector(self.showKokuminhogo2(_:)), for: .touchUpInside)
        self.view.addSubview(btnKokuminhogo2)
        //３号非常招集
        btnKokuminhogo3.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKokuminhogo3.layer.masksToBounds = true
        btnKokuminhogo3.setTitle("第３非常警備(３号招集)", for: UIControl.State())
        btnKokuminhogo3.setTitleColor(UIColor.black, for: UIControl.State())
        btnKokuminhogo3.tag=7
        btnKokuminhogo3.translatesAutoresizingMaskIntoConstraints = false
        btnKokuminhogo3.addTarget(self, action: #selector(self.showKokuminhogo3(_:)), for: .touchUpInside)
        self.view.addSubview(btnKokuminhogo3)
        //４号非常招集
        btnKokuminhogo4.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKokuminhogo4.layer.masksToBounds = true
        btnKokuminhogo4.setTitle("第４非常警備(４号招集)", for: UIControl.State())
        btnKokuminhogo4.setTitleColor(UIColor.black, for: UIControl.State())
        btnKokuminhogo4.tag=8
        btnKokuminhogo4.translatesAutoresizingMaskIntoConstraints = false
        btnKokuminhogo4.addTarget(self, action: #selector(self.showKokuminhogo4(_:)), for: .touchUpInside)
        self.view.addSubview(btnKokuminhogo4)
        //５号非常招集
        btnKokuminhogo5.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKokuminhogo5.layer.masksToBounds = true
        btnKokuminhogo5.setTitle("第５非常警備", for: UIControl.State())
        btnKokuminhogo5.setTitleColor(UIColor.black, for: UIControl.State())
        btnKokuminhogo5.tag=9
        btnKokuminhogo5.translatesAutoresizingMaskIntoConstraints = false
        btnKokuminhogo5.addTarget(self, action: #selector(self.showKokuminhogo5(_:)), for: .touchUpInside)
        self.view.addSubview(btnKokuminhogo5)
        //北朝鮮ミサイル発射時等に係る体制　2021.11.30追加
        btnKokuminhogo6.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKokuminhogo6.layer.masksToBounds = true
        btnKokuminhogo6.setTitle("北朝鮮ミサイル発射時等に係る体制", for: UIControl.State())
        btnKokuminhogo6.setTitleColor(UIColor.black, for: UIControl.State())
        btnKokuminhogo6.tag=10
        btnKokuminhogo6.translatesAutoresizingMaskIntoConstraints = false
        btnKokuminhogo6.addTarget(self, action: #selector(self.showKokuminhogo6(_:)), for: .touchUpInside)
        self.view.addSubview(btnKokuminhogo6)
        
        //scroll生成
        scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
        scrollView.contentSize = CGSize(width: 300,height: 1000)
        scrollView.backgroundColor = UIColor(red:0.0, green:0.35, blue:0.0, alpha:1.0)
        self.view.addSubview(scrollView)
        
        //スクロールとピンチの画像を設定
        imageView1.image = UIImage(named: "scrollpinch")
        imageView1.frame = CGRect(x:self.view.frame.midX, y:0, width:200, height:100)
        imageView1.isHidden = true
        self.view.addSubview(imageView1)
        
        // デリゲートを設定
        self.scrollView.delegate = self
        // 最大倍率・最小倍率を設定する
        self.scrollView.maximumZoomScale = 5.0
        self.scrollView.minimumZoomScale = 1.0

        // imageView2をscrollViewいっぱいに生成
        imageView2.image = UIImage(named: "northkorea")
        imageView2.frame = CGRect(x:0,y:0,width:view.frame.width,height:450)
        //一旦隠しておく
        scrollView.isHidden = true
        scrollView.addSubview(imageView2)
        self.imageView2.contentMode = .scaleAspectFit
        
        //北朝鮮ミサイル発射時等に係る体制のImageViewを消すボタン　2021.11.30追加
        btnClose.backgroundColor = UIColor.orange
        btnClose.layer.masksToBounds = true
        btnClose.setTitle("体制　閉じる", for: UIControl.State())
        btnClose.layer.cornerRadius = 10.0
        btnClose.setTitleColor(UIColor.white, for: UIControl.State())
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        btnClose.addTarget(self, action: #selector(self.onClickClose(_:)), for: .touchUpInside)
        btnClose.isHidden = true
        self.view.addSubview(btnClose)
        
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
        //情報（関係機関）
        btnKokuminhogoKankeikikan.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKokuminhogoKankeikikan.layer.masksToBounds = true
        btnKokuminhogoKankeikikan.setTitle("情報(関係機関)", for: UIControl.State())
        btnKokuminhogoKankeikikan.titleLabel!.adjustsFontSizeToFitWidth = true
        btnKokuminhogoKankeikikan.setTitleColor(UIColor.black, for: UIControl.State())
        btnKokuminhogoKankeikikan.setTitleColor(UIColor.red, for: UIControl.State.highlighted)
        btnKokuminhogoKankeikikan.tag=9
        btnKokuminhogoKankeikikan.translatesAutoresizingMaskIntoConstraints = false
        btnKokuminhogoKankeikikan.addTarget(self, action: #selector(self.showInfoKankeikikan(_:)), for: .touchUpInside)
        self.view.addSubview(btnKokuminhogoKankeikikan)
        //情報（停電）
        btnKokuminhogoBlackout.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKokuminhogoBlackout.layer.masksToBounds = true
        btnKokuminhogoBlackout.setTitle("情報(停電)", for: UIControl.State())
        btnKokuminhogoBlackout.setTitleColor(UIColor.black, for: UIControl.State())
        btnKokuminhogoBlackout.setTitleColor(UIColor.red, for: UIControl.State.highlighted)
        btnKokuminhogoBlackout.tag=10
        btnKokuminhogoBlackout.translatesAutoresizingMaskIntoConstraints = false
        btnKokuminhogoBlackout.addTarget(self, action: #selector(self.showInfoBlackout(_:)), for: .touchUpInside)
        self.view.addSubview(btnKokuminhogoBlackout)
        //情報（道路）
        btnKokuminhogoRoad.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKokuminhogoRoad.layer.masksToBounds = true
        btnKokuminhogoRoad.setTitle("情報(道路)", for: UIControl.State())
        btnKokuminhogoRoad.setTitleColor(UIColor.black, for: UIControl.State())
        btnKokuminhogoRoad.setTitleColor(UIColor.red, for: UIControl.State.highlighted)
        btnKokuminhogoRoad.tag=11
        btnKokuminhogoRoad.translatesAutoresizingMaskIntoConstraints = false
        btnKokuminhogoRoad.addTarget(self, action: #selector(self.showInfoRoad(_:)), for: .touchUpInside)
        self.view.addSubview(btnKokuminhogoRoad)
        //連絡網
        btnKokuminhogoTel.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKokuminhogoTel.layer.masksToBounds = true
        btnKokuminhogoTel.setTitle("連絡網", for: UIControl.State())
        btnKokuminhogoTel.setTitleColor(UIColor.black, for: UIControl.State())
        btnKokuminhogoTel.tag=12
        btnKokuminhogoTel.translatesAutoresizingMaskIntoConstraints = false
        btnKokuminhogoTel.addTarget(self, action: #selector(self.showContactLoad(_:)), for: .touchUpInside)
        self.view.addSubview(btnKokuminhogoTel)
        //留意事項
        btnKokuminhogoCaution.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKokuminhogoCaution.layer.masksToBounds = true
        btnKokuminhogoCaution.setTitle("留意事項等", for: UIControl.State())
        btnKokuminhogoCaution.setTitleColor(UIColor.black, for: UIControl.State())
        btnKokuminhogoCaution.setTitleColor(UIColor.red, for: UIControl.State.highlighted)
        btnKokuminhogoCaution.tag=13
        btnKokuminhogoCaution.translatesAutoresizingMaskIntoConstraints = false
        btnKokuminhogoCaution.addTarget(self, action: #selector(self.showInfoCaution(_:)), for: .touchUpInside)
        self.view.addSubview(btnKokuminhogoCaution)
        //防災ネット
        btnKokuminhogoBousaiNet.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnKokuminhogoBousaiNet.layer.masksToBounds = true
        btnKokuminhogoBousaiNet.setTitle("防災ネット", for: UIControl.State())
        btnKokuminhogoBousaiNet.setTitleColor(UIColor.black, for: UIControl.State())
        btnKokuminhogoBousaiNet.tag=9
        btnKokuminhogoBousaiNet.translatesAutoresizingMaskIntoConstraints = false
        btnKokuminhogoBousaiNet.addTarget(self, action: #selector(self.showInfoBousainet(_:)), for: .touchUpInside)
        self.view.addSubview(btnKokuminhogoBousaiNet)
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
        mBousainetDialog = BousainetDialog(parentView: self)
        mKokuminhogoSelectDialog = KokuminhogoSelectDialog(parentView: self)
        mKokuminhogoResultDialog = KokuminhogoResultDialog(parentView: self) //このViewControllerを渡してあげる
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
            //非常召集基準（国民保護）ラベル
            Constraint(lblKokuminhogo, .bottom, to:padY2, .top, constant:0),
            Constraint(lblKokuminhogo, .centerX, to:self.view, .centerX, constant:8),
            Constraint(lblKokuminhogo, .width, to:self.view, .width, constant:0, multiplier:0.8)
            ])
        self.view.addConstraints([
            //padY2
            Constraint(padY2, .bottom, to:btnKokuminhogo1, .top, constant:0),
            Constraint(padY2, .leading, to:self.view, .leading, constant:0),
            Constraint(padY2, .height, to:self.view, .height, constant:0, multiplier:0.03)
            ])
        self.view.addConstraints([
            //第１非常警備ボタン
            Constraint(btnKokuminhogo1, .bottom, to:padY3, .top, constant:0),
            Constraint(btnKokuminhogo1, .centerX, to:self.view, .centerX, constant:8),
            Constraint(btnKokuminhogo1, .width, to:self.view, .width, constant:0, multiplier:0.8)
            ])
        self.view.addConstraints([
            //padY3
            Constraint(padY3, .bottom, to:btnKokuminhogo2, .top, constant:0),
            Constraint(padY3, .leading, to:self.view, .leading, constant:0),
            Constraint(padY3, .height, to:self.view, .height, constant:0, multiplier:0.03)
            ])
        self.view.addConstraints([
            //第２非常警備ボタン
            Constraint(btnKokuminhogo2, .bottom, to:padY4, .top, constant:0),
            Constraint(btnKokuminhogo2, .centerX, to:self.view, .centerX, constant:8),
            Constraint(btnKokuminhogo2, .width, to:self.view, .width, constant:0, multiplier:0.8)
            ])
        self.view.addConstraints([
            //padY4
            Constraint(padY4, .bottom, to:btnKokuminhogo3, .top, constant:0),
            Constraint(padY4, .leading, to:self.view, .leading, constant:0),
            Constraint(padY4, .height, to:self.view, .height, constant:0, multiplier:0.03)
            ])
        self.view.addConstraints([
            //第３非常警備ボタン Y座標の中心 -72に留意
            Constraint(btnKokuminhogo3, .centerY, to:self.view, .centerY, constant:-72),
            Constraint(btnKokuminhogo3, .centerX, to:self.view, .centerX, constant:8),
            Constraint(btnKokuminhogo3, .width, to:self.view, .width, constant:0, multiplier:0.8)
            ])
        self.view.addConstraints([
            //padY5
            Constraint(padY5, .top, to:btnKokuminhogo3, .bottom, constant:0),
            Constraint(padY5, .leading, to:self.view, .leading, constant:0),
            Constraint(padY5, .height, to:self.view, .height, constant:0, multiplier:0.03)
            ])
        self.view.addConstraints([
            //第４非常警備ボタン
            Constraint(btnKokuminhogo4, .top, to:padY5, .bottom, constant:0),
            Constraint(btnKokuminhogo4, .centerX, to:self.view, .centerX, constant:8),
            Constraint(btnKokuminhogo4, .width, to:self.view, .width, constant:0, multiplier:0.8)
            ])
        self.view.addConstraints([
            //padY6
            Constraint(padY6, .top, to:btnKokuminhogo4, .bottom, constant:0),
            Constraint(padY6, .leading, to:self.view, .leading, constant:0),
            Constraint(padY6, .height, to:self.view, .height, constant:0, multiplier:0.03)
            ])
        self.view.addConstraints([
            //第５非常警備ボタン
            Constraint(btnKokuminhogo5, .top, to:padY6, .bottom, constant:0),
            Constraint(btnKokuminhogo5, .centerX, to:self.view, .centerX, constant:8),
            Constraint(btnKokuminhogo5, .width, to:self.view, .width, constant:0, multiplier:0.8)
            ])
        self.view.addConstraints([
            //北朝鮮ミサイル発射時等に係る体制ボタン
            Constraint(btnKokuminhogo6, .top, to:btnKokuminhogo5, .bottom, constant:16),
            Constraint(btnKokuminhogo6, .centerX, to:self.view, .centerX, constant:8),
            Constraint(btnKokuminhogo6, .width, to:self.view, .width, constant:0, multiplier:0.8)
            ])
        self.view.addConstraints([
            //閉じるボタン
            Constraint(btnClose, .top, to:lblKokuminhogo, .top, constant:0),
            Constraint(btnClose, .leading, to:self.view, .leading, constant:8),
            Constraint(btnClose, .trailing, to:self.view, .centerX, constant:-8)
        ])
        self.view.addConstraints([
            //pad21
            Constraint(pad21, .bottom, to:btnKokuminhogoTel, .top, constant:-8),
            Constraint(pad21, .leading, to:self.view, .leading, constant:0),
            Constraint(pad21, .width, to:self.view, .width, constant:0, multiplier:0.024)
            ])
        self.view.addConstraints([
            //情報(関係機関)ボタン
            Constraint(btnKokuminhogoKankeikikan, .bottom, to:btnKokuminhogoTel, .top, constant:-8),
            Constraint(btnKokuminhogoKankeikikan, .leading, to:pad21, .trailing, constant:0),
            Constraint(btnKokuminhogoKankeikikan, .width, to:self.view, .width, constant:0, multiplier:0.3)
            ])
        self.view.addConstraints([
            //pad22
            Constraint(pad22, .bottom, to:btnKokuminhogoTel, .top, constant:-8),
            Constraint(pad22, .leading, to:btnKokuminhogoKankeikikan, .trailing, constant:0),
            Constraint(pad22, .width, to:self.view, .width, constant:0, multiplier:0.024)
            ])
        self.view.addConstraints([
            //情報(停電)ボタン
            Constraint(btnKokuminhogoBlackout, .bottom, to:btnKokuminhogoTel, .top, constant:-8),
            Constraint(btnKokuminhogoBlackout, .leading, to:pad22, .trailing, constant:0),
            Constraint(btnKokuminhogoBlackout, .width, to:btnKokuminhogoKankeikikan, .width, constant:0)
            ])
        self.view.addConstraints([
            //pad23
            Constraint(pad23, .bottom, to:btnKokuminhogoTel, .top, constant:-8),
            Constraint(pad23, .leading, to:btnKokuminhogoBlackout, .trailing, constant:0),
            Constraint(pad23, .width, to:self.view, .width, constant:0, multiplier:0.024)
            ])
        self.view.addConstraints([
            //情報(道路)ボタン
            Constraint(btnKokuminhogoRoad, .bottom, to:btnKokuminhogoTel, .top ,constant:-8),
            Constraint(btnKokuminhogoRoad, .leading, to:pad23, .trailing, constant:0),
            Constraint(btnKokuminhogoRoad, .width, to:btnKokuminhogoKankeikikan, .width, constant:0)
            ])
        self.view.addConstraints([
            //pad31
            Constraint(pad31, .top, to:btnKokuminhogoKankeikikan, .bottom, constant:8),
            Constraint(pad31, .leading, to:self.view, .leading, constant:0),
            Constraint(pad31, .width, to:self.view, .width, constant:0, multiplier:0.024)
            ])
        self.view.addConstraints([
            //連絡網ボタン
            Constraint(btnKokuminhogoTel, .bottom, to:self.view, .bottom, constant:-8),
            Constraint(btnKokuminhogoTel, .leading, to:pad31, .trailing, constant:0),
            Constraint(btnKokuminhogoTel, .width, to:self.view, .width, constant:0, multiplier:0.3)
            ])
        self.view.addConstraints([
            //pad32
            Constraint(pad32, .bottom, to:self.view, .bottom, constant:-8),
            Constraint(pad32, .leading, to:btnKokuminhogoTel, .trailing, constant:0),
            Constraint(pad32, .width, to:self.view, .width, constant:0, multiplier:0.024)
            ])
        self.view.addConstraints([
            //留意事項ボタン
            Constraint(btnKokuminhogoCaution, .bottom, to:self.view, .bottom, constant:-8),
            Constraint(btnKokuminhogoCaution, .leading, to:pad32, .trailing, constant:0),
            Constraint(btnKokuminhogoCaution, .width, to:btnKokuminhogoTel, .width, constant:0)
            ])
        self.view.addConstraints([
            //pad33
            Constraint(pad33, .bottom, to:self.view, .bottom, constant:-8),
            Constraint(pad33, .leading, to:btnKokuminhogoCaution, .trailing, constant:0),
            Constraint(pad33, .width, to:self.view, .width, constant:0, multiplier:0.024)
            ])
        self.view.addConstraints([
            //防災ネットボタン
            Constraint(btnKokuminhogoBousaiNet, .bottom, to:self.view, .bottom ,constant:-8),
            Constraint(btnKokuminhogoBousaiNet, .leading, to:pad33, .trailing, constant:0),
            Constraint(btnKokuminhogoBousaiNet, .width, to:btnKokuminhogoTel, .width, constant:0)
            ])
    }
    
    //１号非常召集
    @objc func showKokuminhogo1(_ sender: UIButton){
        mKokuminhogoResultDialog.showResult(1)
    }
    
    //２号非常召集
    @objc func showKokuminhogo2(_ sender: UIButton){
        mKokuminhogoResultDialog.showResult(2)
    }

    //３号非常召集
    @objc func showKokuminhogo3(_ sender: UIButton){
        mKokuminhogoResultDialog.showResult(3)
    }

    //４号非常召集
    @objc func showKokuminhogo4(_ sender: UIButton){
        mKokuminhogoResultDialog.showResult(4)
    }

    //５号非常召集
    @objc func showKokuminhogo5(_ sender: UIButton){
        mKokuminhogoResultDialog.showResult(5)
    }
    
    //北朝鮮ミサイル発射時に係る体制
    @objc func showKokuminhogo6(_ sender: UIButton){
        btnClose.isHidden   = false
        imageView1.isHidden = false
        scrollView.isHidden = false
        //画面下部ボタン消去
        btnKokuminhogoKankeikikan.isHidden = true
        btnKokuminhogoBlackout.isHidden    = true
        btnKokuminhogoRoad.isHidden        = true
        btnKokuminhogoTel.isHidden         = true
        btnKokuminhogoCaution.isHidden     = true
        btnKokuminhogoBousaiNet.isHidden   = true
    }
    
    //閉じるボタン
    @objc func onClickClose(_ sender: UIButton){
        btnClose.isHidden   = true
        imageView1.isHidden = true
        scrollView.isHidden = true
        //画面下部ボタン表示
        btnKokuminhogoKankeikikan.isHidden = false
        btnKokuminhogoBlackout.isHidden    = false
        btnKokuminhogoRoad.isHidden        = false
        btnKokuminhogoTel.isHidden         = false
        btnKokuminhogoCaution.isHidden     = false
        btnKokuminhogoBousaiNet.isHidden   = false
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView2
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // ズーム終了時の処理
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        // ズーム開始時の処理
    }

    func zoomForScale(scale:CGFloat, center: CGPoint) -> CGRect{
        var zoomRect: CGRect = CGRect()
        zoomRect.size.height = self.scrollView.frame.size.height / scale
        zoomRect.size.width = self.scrollView.frame.size.width  / scale
        zoomRect.origin.x = center.x - zoomRect.size.width / 2.0
        zoomRect.origin.y = center.y - zoomRect.size.height / 2.0
        return zoomRect
    }
    
    //情報(関係機関)
    @objc func showInfoKankeikikan(_ sender: UIButton){
        mInfoDialog.showInfo("kankeikikan")
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
    
    //留意事項等
    @objc func showInfoCaution(_ sender: UIButton){
        mKokuminhogoSelectDialog.showInfo()
    }
    
    //防災ネット
    @objc func showInfoBousainet(_ sender: UIButton){
        mBousainetDialog.showInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
