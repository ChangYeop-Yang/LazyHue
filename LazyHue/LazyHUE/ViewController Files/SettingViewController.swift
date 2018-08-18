//
//  SettingViewController.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 18..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import UIKit
import MessageUI
import AudioToolbox

class SettingViewController: UIViewController {
    
    // MARK: - Enum
    private enum tag: Int {
        case developerINFO = 100
        case sendEMAIL     = 200
        case opensource    = 300
    }
    
    // MARK: - Typealias
    private typealias Index = (index: IndexPath, name: String)

    // MARK: - Outlet Variables
    private var settingTV: UITableView!
    private let userDefault: UserDefaults = UserDefaults.standard
    
    // MARK: - Variables
    private let settingTableIndexPath: [Index] = [
        (IndexPath(row: 0, section: 0), "Arduino"),
        (IndexPath(row: 1, section: 0), "Developer Infromation")
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let segueTV = segue.destination as? UITableViewController {
            segueTV.tableView.delegate = self
            settingTV = segueTV.tableView
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // MARK: UserDefaults
        let arduinoSW: UISwitch = settingTV.cellForRow(at: settingTableIndexPath.first!.index)!.accessoryView as! UISwitch
        arduinoSW.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
        arduinoSW.setOn(userDefault.bool(forKey: ARUDINO_ENABLE_KEY), animated: false)
    }
    
    // MARK: - Action Method
    @objc private func switchChanged(mySwitch: UISwitch) {
        userDefault.set(mySwitch.isOn, forKey: ARUDINO_ENABLE_KEY)
        showWhisperToast(title: "Success change arduino function state.", background: .moss, textColor: .white)
    }
}

// MARK: - UITableViewDelegate Extension
extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let tagVal: Int = tableView.cellForRow(at: indexPath)?.tag, let tagNum = tag(rawValue: tagVal) {
            switch tagNum {
                case .developerINFO:
                    if let url: URL = URL(string: "http://yeop9657.blog.me") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                case .sendEMAIL:
                    if MFMailComposeViewController.canSendMail() {
                        let mail: MFMailComposeViewController = MFMailComposeViewController()
                        mail.mailComposeDelegate = self
                        mail.setSubject("Inquiry SAIOT inconvenient comment")
                        mail.setToRecipients(["yeop9657@outlook.com"])
                        mail.setMessageBody("Please, Input inconvenient comment.", isHTML: false)
                        present(mail, animated: true, completion: nil)
                    }
                case .opensource:
                    if let url: URL = URL(string: "http://yeop9657.blog.me/221067037683") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
            }
        }
    }
}

// MARK: - MFMailComposeViewController Delegate
extension SettingViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            print("Success E-mail send to developer.")
        case .cancelled:
            print("Cancel E-mail send to developer.")
        case .saved:
            print("Save E-mail content into disk.");
        case .failed:
            print("Fail E-mail send to developer.")
        }
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}