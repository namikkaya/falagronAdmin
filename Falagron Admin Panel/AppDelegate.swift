//
//  AppDelegate.swift
//  Falagron Admin Panel
//
//  Created by namik kaya on 28.03.2020.
//  Copyright © 2020 namikkaya86@gmail.com. All rights reserved.
//

import Cocoa
import Firebase
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    override init() {
        super.init()
        FirebaseApp.configure()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

