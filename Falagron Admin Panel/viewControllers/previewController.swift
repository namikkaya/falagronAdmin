//
//  previewController.swift
//  Falagron Admin Panel
//
//  Created by namik kaya on 25.05.2020.
//  Copyright © 2020 namikkaya86@gmail.com. All rights reserved.
//

import Cocoa

class previewController: BaseViewController {
    var textString:String?
    var replacingManager:replacingText!

    @IBOutlet weak var previewText: NSScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        replacingManager = replacingText()
        configuration()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)
        self.view.frame.size = CGSize(width: 450, height: 300)
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(self)
    }
    
    func configuration() {
        guard let str = textString else {
            
            return
        }
        let newStr = replacingManager.replacingData(name: "Buse", str: str, genderType: .woman)
        if let newStr = newStr {
            previewText.documentView?.insertText(newStr)
        }
    }
}
