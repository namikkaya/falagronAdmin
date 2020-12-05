//
//  BaseViewController.swift
//  Falagron Admin Panel
//
//  Created by namik kaya on 28.03.2020.
//  Copyright © 2020 namikkaya86@gmail.com. All rights reserved.
//

import Cocoa

class BaseViewController: NSViewController {

    func dialogOKCancel(title: String, description: String, okButton:String? = nil, cancelButton:String? = nil) -> Bool {
        let alert: NSAlert = NSAlert()
        alert.messageText = title
        alert.informativeText = description
        alert.alertStyle = NSAlert.Style.warning
        if let okButton = okButton {
            alert.addButton(withTitle: okButton)
        }
        if let cancelButton = cancelButton {
            alert.addButton(withTitle: cancelButton)
        }
        let res = alert.runModal()
        if res == NSApplication.ModalResponse.alertFirstButtonReturn {
            return true
        }
        return false
    }
    
}
