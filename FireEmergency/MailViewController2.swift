//
//  MailViewController2.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2021/02/15.
//  Copyright © 2021 tadakazu nakamichi. All rights reserved.
//

import Foundation
import MessageUI

class MailViewController2: UIViewController, MFMailComposeViewControllerDelegate {
    
    var mAddressArray: [String] = []
    //非常参集　職員情報　保存用
    let userDefaults = UserDefaults.standard
    var message: String = ""
    var personalId: String = ""
    var personalClass: String = ""
    var personalAge: String = ""
    var personalDepartment: String = ""
    var personalName: String = ""
    var personalRide: String = ""
    var personalEngineer: String = ""
    var personalParamedic: String = ""
    
    init(addressArray: [String]) {
        super.init(nibName: nil, bundle: nil)
        mAddressArray = addressArray
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendMail()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sendMail(){
        if MFMailComposeViewController.canSendMail()==false {
            print("メール送信に失敗しました")
            return
        }
        
        let mailViewController = MFMailComposeViewController()
        let address: String = mAddressArray[0]
        var recipients: [String] = []
        recipients.append(address)
        
        mailViewController.mailComposeDelegate = self
        mailViewController.setSubject(mAddressArray[1])
        mailViewController.setToRecipients(recipients)
        
        //メール本文の作成 userDefaultからの呼び出しを連結
        personalId = userDefaults.string(forKey:"personalId")!
        personalClass = userDefaults.string(forKey:"personalClass")!
        personalAge = userDefaults.string(forKey:"personalAge")! + "歳"
        personalDepartment = userDefaults.string(forKey:"personalDepartment")!
        personalName = userDefaults.string(forKey:"personalName")!
        personalRide = userDefaults.string(forKey:"personalRide")!
        if userDefaults.bool(forKey:"personalEngineer"){
            personalEngineer = "有"
        } else {
            personalEngineer = "無"
        }
        if userDefaults.bool(forKey:"personalParamedic"){
            personalParamedic = "有"
        } else {
            personalParamedic = "無"
        }
        message = "\(personalId) \(personalClass) \(personalAge) \(personalDepartment) \(personalName) \(personalRide) \(personalEngineer) \(personalParamedic)"
        mailViewController.setMessageBody(message, isHTML: false)
        
        self.present(mailViewController, animated:true, completion:nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result  {
        case .cancelled:
            //自らを削除
            self.dismiss(animated: true, completion: nil)
            break
        case .saved:
            //自らを削除
            self.dismiss(animated: true, completion: nil)
            break
        case .sent:
            //自らを削除
            self.dismiss(animated: true, completion: nil)
            break
        case .failed:
            //自らを削除
            self.dismiss(animated: true, completion: nil)
            break
        default:
            break
        }
        //自らを削除
        self.dismiss(animated: true, completion: nil)
    }
}

