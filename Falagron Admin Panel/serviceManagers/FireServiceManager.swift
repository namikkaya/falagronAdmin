//
//  FireServiceManager.swift
//  Falagron Admin Panel
//
//  Created by namik kaya on 11.04.2020.
//  Copyright © 2020 namikkaya86@gmail.com. All rights reserved.
//

import Cocoa
import FirebaseAuth

protocol FBSManagerDelegate:class {
    func FBSManagerUserUpdate(user:User?, auth:Auth?)
}
                                                                                                                
extension FBSManagerDelegate {
    func FBSManagerUserUpdate(user:User?, auth:Auth?) {}
}

class FBSManager: NSObject {
    private let TAG:String = "FireServiceManager"
    
    let delegate = MulticastDelegate<FBSManagerDelegate>()
    
    static let sharedInstance: FBSManager = {
        let instance = FBSManager()
        return instance
    }()
    
    private var handle:AuthStateDidChangeListenerHandle?
    private var user:User?
    
    private func checkUserAuth(completion: @escaping (Bool) -> ()) {
        handle = Auth.auth().addStateDidChangeListener {  [weak self] (auth, user) in
            guard let strongSelf = self else { return }
            if user != nil {
                print("\(strongSelf.TAG): online")
                strongSelf.user = user
                
                
            }else{
                print("\(strongSelf.TAG): offline")
            }
        }
    }
}

class MulticastDelegate <T> {
    private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()
    
    func add(delegate: T) {
        delegates.add(delegate as AnyObject)
    }
    
    func remove(delegate: T) {
        for oneDelegate in delegates.allObjects.reversed() {
            if oneDelegate === delegate as AnyObject {
                delegates.remove(oneDelegate)
            }
        }
    }
    
    func invoke(invocation: (T) -> ()) {
        for delegate in delegates.allObjects.reversed() {
            invocation(delegate as! T)
        }
    }
}

func += <T: AnyObject> (left: MulticastDelegate<T>, right: T) {
    left.add(delegate: right)
}

func -= <T: AnyObject> (left: MulticastDelegate<T>, right: T) {
    left.remove(delegate: right)
}
