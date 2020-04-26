//
//  ViewController2.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2020/04/26.
//  Copyright © 2020年 tadakazu nakamichi. All rights reserved.
//

import UIKit

//グローバル変数
//internal var mViewController2: ViewController2!
//基礎データ入力ボタンからの画面切り替え判定変数　1:基礎データ入力　2:連絡網データ操作 3:アプリ説明書
internal var mScreen: Int!

class ViewController2: UIViewController {
    //別クラスのインスタンス保持用変数
    
    fileprivate var mInfoDialog: InfoDialog!
    fileprivate var mBousainetDialog: BousainetDialog!
    fileprivate var mEarthSelectDialog: EarthSelectDialog!
    fileprivate var mContactLoadDialog: ContactLoadDialog2!
    fileprivate var mPassInputDialog: PassInputDialog!
    //結果表示用クラス保持用
    internal var mEarthResultDialog: EarthResultDialog!
    
    //基礎データ入力、連絡網データ操作、アプリ説明書それぞれ３つのViewCOntroller設定
    private lazy var mDataViewController: DataViewController = {
        var viewController = DataViewController()
        add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var mContactViewController: ContactViewController = {
        var viewController = ContactViewController()
        add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var mGuideViewController: GuideViewController = {
        var viewController = GuideViewController()
        add(asChildViewController: viewController)
        return viewController
    }()
    
    //スタート
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //常にViewController2のインスタンス作成時には基礎データ入力画面になるように1をセット
        mScreen = 1
        
        //自分を保存：後でダイアログ表示の際に暗くするときの呼び出しに使うため
        mViewController2 = self
                                
        //子ViewControllerセット
        setupView()
        
        //ViewControllerを暗く
        mViewController.view.alpha = 0.1
    }
        
    private func setupView(){
        updateView()
    }
    
    internal func updateView(){
        switch mScreen {
        //基礎データ入力
        case 1:
            remove(asChildViewController: mContactViewController)
            remove(asChildViewController: mGuideViewController)
            add(asChildViewController: mDataViewController)
            
        //連絡網データ操作
        case 2:
            remove(asChildViewController: mDataViewController)
            remove(asChildViewController: mGuideViewController)
            add(asChildViewController: mContactViewController)
            
        //アプリ説明書
        case 3:
            remove(asChildViewController: mDataViewController)
            remove(asChildViewController: mContactViewController)
            add(asChildViewController: mGuideViewController)
                        
        default:
            break
        }
    }
    
    //子ViewController 追加、削除
    private func add(asChildViewController viewController: UIViewController){
        addChild(viewController)
        self.view.addSubview(viewController.view)
        viewController.view.frame = self.view.bounds
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

