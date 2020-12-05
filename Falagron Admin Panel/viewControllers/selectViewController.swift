//
//  editViewController.swift
//  Falagron Admin Panel
//
//  Created by namik kaya on 28.03.2020.
//  Copyright © 2020 namikkaya86@gmail.com. All rights reserved.
//

import Cocoa

class selectViewController: NSViewController, NSWindowDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)
        self.view.window?.title = "Falagron"
        self.view.window?.delegate = self
    }
 
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApplication.shared.terminate(self)
        return true
    }
    
    @IBAction func newFalAction(_ sender: Any) {
        gotoNewFalPage()
    }
    
    @IBAction func editFalAction(_ sender: Any) {
        gotoEditFalPage()
    }
    
    private func gotoNewFalPage(data:FalDataModel? = nil){
        let newFalVC: newFalViewController = self.storyboard?.instantiateController(withIdentifier: "newFalVC") as! newFalViewController
        if let data = data {
            newFalVC.falData = data
        }
        self.presentAsSheet(newFalVC)
    }
    
    private func gotoEditFalPage() {
        let editFalVC:editViewController = self.storyboard?.instantiateController(withIdentifier: "editVC") as! editViewController
        editFalVC.delegate = self
        self.presentAsSheet(editFalVC)
    }
    
}

extension selectViewController: editViewControllerDelegate {
    func didSelectData(data: editViewDataType?) {
        if let data = data {
            switch data {
            case .selectFalData(let data):
                gotoNewFalPage(data: data)
                break
            default:
                break
            }
        }
    }
}
