//
//  preloaderVC.swift
//  Falagron Admin Panel
//
//  Created by namik kaya on 2.05.2020.
//  Copyright © 2020 namikkaya86@gmail.com. All rights reserved.
//

import Cocoa

class preloaderVC: NSViewController {
    var isOpen:Bool = false
    @IBOutlet weak var circularPreloader: NSProgressIndicator!
    
    static let sharedInstance: preloaderVC = {
        let instance = preloaderVC()
        return instance
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    override func awakeFromNib() {
        view.wantsLayer = true
        self.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)
        self.view.frame.size = CGSize(width: 360, height: 240)
    }
    
    func openPreloader(vc:NSViewController) {
        if isOpen { return }
        vc.presentAsSheet(preloaderVC.sharedInstance)
        circularPreloader.isHidden = false
        circularPreloader.isIndeterminate = true
        circularPreloader.usesThreadedAnimation = true
        circularPreloader.startAnimation(nil)
        isOpen = true
    }
    
    func closePreloader(vc:NSViewController) {
        if !isOpen { return }
        vc.dismiss(preloaderVC.sharedInstance)
        isOpen = false
    }
}
