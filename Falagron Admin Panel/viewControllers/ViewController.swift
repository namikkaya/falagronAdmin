//
//  ViewController.swift
//  Falagron Admin Panel
//
//  Created by namik kaya on 28.03.2020.
//  Copyright © 2020 namikkaya86@gmail.com. All rights reserved.
//

import Cocoa
import FirebaseAuth

class ViewController: BaseViewController {
    private let TAG:String = "ViewController"

    var handle:AuthStateDidChangeListenerHandle?
    private var user:User?
    
    @IBOutlet weak var userNameText: NSTextField!
    @IBOutlet weak var passwordText: NSSecureTextField!
    
    var fbsMananager:FBSManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)
        self.view.window?.title = "Falagron"
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        fbsMananager = FBSManager.sharedInstance
        fbsMananager?.delegate.add(delegate: self)
        fbsMananager?.checkUserAuth()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        fbsMananager?.delegate.remove(delegate: self)
        fbsMananager = nil
    }
    
    @IBAction func gotoButtonAction(_ sender: Any) {
        print("text: \(userNameText.stringValue)")
        if userNameText.stringValue.isEmpty || passwordText.stringValue.isEmpty {
            let _ = dialogOKCancel(title: "Boş bırakma", description: "kullanıcı adı ve şifre boş olamaz", okButton: "Tamam")
            return
        }
        fbsMananager?.fetchLogin(email: userNameText.stringValue, password: passwordText.stringValue)
    }
    
    private func gotoEditPage(){
        let editVC: selectViewController = self.storyboard?.instantiateController(withIdentifier: "selectVC") as! selectViewController
        self.presentAsModalWindow(editVC)
        view.window?.close()
    }
}

extension ViewController: FBSManagerDelegate {
    func FBSManagerUpdateData(FBSMessage: FBSManagerStatus?) {
        guard let message = FBSMessage else { return }
        switch message {
        case .userUpdate(_, let myUser):
            user = myUser
            gotoEditPage()
            break
        case .userFetchLogin(let error, let authResult):
            if error != nil {
                let _ = self.dialogOKCancel(title: "HATA", description: error?.localizedDescription ?? "", okButton: "TAMAM")
                return
            }
            user = authResult?.user
            gotoEditPage()
        default:
            break
        }
    }
}
