//
//  FBSManager.swift
//  Falagron Admin Panel
//
//  Created by namik kaya on 11.04.2020.
//  Copyright © 2020 namikkaya86@gmail.com. All rights reserved.
//

import Cocoa
import FirebaseAuth
import Firebase
import InstantSearchClient

protocol FBSManagerDelegate:class {
    func FBSManagerUpdateData(FBSMessage:FBSManagerStatus?)
}
                                                                                                                
extension FBSManagerDelegate {
    func FBSManagerUpdateData(FBSMessage:FBSManagerStatus?) {}
}

enum FBSManagerStatus {
    case userUpdate(Auth?, User?)
    case userFetchLogin(Error?, AuthDataResult?)
    case fetchFilterFal(QuerySnapshot?, Error?)
    case searchKeyword(QuerySnapshot?, Error?)
    case updateFal([String : Any]??, Error?)
    case updateSearchKeyword(QuerySnapshot?, Error?)
    case saveFalComplete([String : Any]??, Error?)
}

class FBSManager: NSObject {
    private let TAG:String = "FireServiceManager"
    static let sharedInstance: FBSManager = {
        let instance = FBSManager()
        return instance
    }()
    
    var index:Index?
    
    override init() {
        super.init()
        index = client.index(withName: "fallar")
    }
    
    let client = Client(appID: "L20S1HKTT1", apiKey: "0949fc400d08dafdae83ea98d3bbdea7")
    let db = Firestore.firestore()
    let delegate = MulticastDelegate<FBSManagerDelegate>()
    private var handle:AuthStateDidChangeListenerHandle?
    private var user:User?
    
    func checkUserAuth(completion: @escaping (Bool) -> () = { _ in }) {
        handle = Auth.auth().addStateDidChangeListener {  [weak self] (auth, user) in
            guard let strongSelf = self else { return }
            if user != nil {
                print("\(strongSelf.TAG): online")
                strongSelf.user = user
                strongSelf.delegate.invoke { (_delegate) in
                    _delegate.FBSManagerUpdateData(FBSMessage: .userUpdate(auth, user))
                }
            }else{
                print("\(strongSelf.TAG): offline")
            }
        }
    }
    
    func fetchLogin(email:String, password:String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if error == nil {
                strongSelf.user = authResult?.user
            }
            strongSelf.delegate.invoke { (_delegate) in
                _delegate.FBSManagerUpdateData(FBSMessage: .userFetchLogin(error, authResult))
            }
        }
    }
    
    func writeFal(giris:Bool? = false,
                          gelisme:Bool? = false,
                          sonuc:Bool? = false,
                          evli:Bool? = false,
                          iliskisiVar:Bool? = false,
                          yeniAyrilmis:Bool? = false,
                          yeniBosanmis:Bool? = false,
                          iliskisiYok:Bool? = false,
                          nisanli:Bool? = false,
                          ogrenci:Bool? = false,
                          evHanimi:Bool? = false,
                          calisiyor:Bool? = false,
                          calismiyor:Bool? = false,
                          olumlu:Bool? = false,
                          olumsuz:Bool? = false,
                          purchase:Bool? = false,
                          falString:String? = ""){
        
        let _iliskiDurumu = [iliskiDurumu_Evli:evli,
                            iliskiDurumu_IliskisiVar:iliskisiVar,
                            iliskiDurumu_YeniAyrilmis:yeniAyrilmis,
                            iliskiDurumu_YeniBosanmis:yeniBosanmis,
                            iliskiDurumu_IliskisiYok:iliskisiYok,
                            iliskiDurumu_Nisanli:nisanli]
        
        let _paragrafTipi = [paragrafTipi_Giris:giris,
                             paragrafTipi_Gelisme:gelisme,
                             paragrafTipi_Sonuc:sonuc]
        
        let _kariyer = [kariyer_Ogrenci:ogrenci,
                       kariyer_EvHanimi:evHanimi,
                       kariyer_Calisiyor:calisiyor,
                       kariyer_Calismiyor:calismiyor]
        
        let _yargi = [yargi_Olumlu:olumlu,
                     yargi_Olumsuz:olumsuz]
        
        let _purchase = [purchaseStatusString:purchase]
        
        let _randomString = String.random(length: 16)
        
        let data = [falText: falString ?? "",
                    iliskiDurumu: _iliskiDurumu,
                    paragrafTipi: _paragrafTipi,
                    kariyer: _kariyer,
                    yargi: _yargi,
                    purchaseString : _purchase,
                    "id": _randomString
                    ] as [String : Any]
        
        var ref: DocumentReference? = nil
        ref = db.collection(fallar).addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                guard let index = self.index else { return }
                let dict:[String:String] = ["id":_randomString, "falText":falString!]
                index.addObject(dict, withID: _randomString, requestOptions: nil) { (data:[String : Any]?, error:Error?) in
                    if error != nil {
                        self.delegate.invoke { (_delegate) in
                            _delegate.FBSManagerUpdateData(FBSMessage: .saveFalComplete(nil, error))
                        }
                    }else{
                        self.delegate.invoke { (_delegate) in
                            _delegate.FBSManagerUpdateData(FBSMessage: .saveFalComplete(data, nil))
                        }
                    }
                }
                
            }
        }
    }
    
    func updateEqualId(falId:String?,
                       giris:Bool? = false,
                       gelisme:Bool? = false,
                       sonuc:Bool? = false,
                       evli:Bool? = false,
                       iliskisiVar:Bool? = false,
                       yeniAyrilmis:Bool? = false,
                       yeniBosanmis:Bool? = false,
                       iliskisiYok:Bool? = false,
                       nisanli:Bool? = false,
                       ogrenci:Bool? = false,
                       evHanimi:Bool? = false,
                       calisiyor:Bool? = false,
                       calismiyor:Bool? = false,
                       olumlu:Bool? = false,
                       olumsuz:Bool? = false,
                       purchase:Bool? = false,
                       falString:String? = ""){
        
        let _iliskiDurumu = [iliskiDurumu_Evli:evli,
                            iliskiDurumu_IliskisiVar:iliskisiVar,
                            iliskiDurumu_YeniAyrilmis:yeniAyrilmis,
                            iliskiDurumu_YeniBosanmis:yeniBosanmis,
                            iliskiDurumu_IliskisiYok:iliskisiYok,
                            iliskiDurumu_Nisanli:nisanli]
        
        let _paragrafTipi = [paragrafTipi_Giris:giris,
                             paragrafTipi_Gelisme:gelisme,
                             paragrafTipi_Sonuc:sonuc]
        
        let _kariyer = [kariyer_Ogrenci:ogrenci,
                       kariyer_EvHanimi:evHanimi,
                       kariyer_Calisiyor:calisiyor,
                       kariyer_Calismiyor:calismiyor]
        
        let _yargi = [yargi_Olumlu:olumlu,
                     yargi_Olumsuz:olumsuz]
        
        let _purchase = [purchaseStatusString:purchase]
        
        let data = [falText: falString ?? "",
                    iliskiDurumu: _iliskiDurumu,
                    paragrafTipi: _paragrafTipi,
                    kariyer: _kariyer,
                    yargi: _yargi,
                    purchaseString : _purchase,
                    ] as [String : Any]
        
        guard let id = falId else {
            let errorTemp = NSError(domain: "Id bulunamadı.", code: 99091, userInfo: ["Description":"Arama indexi bulunamadı"])
            self.delegate.invoke { (_delegate) in
                _delegate.FBSManagerUpdateData(FBSMessage: .updateFal(nil, errorTemp))
            }
            return
        }
        
        //
        let refQuery = db.collection(fallar).whereField("id", isEqualTo: id)
        refQuery.getDocuments { (snapshot, error) in
            if error != nil {
                self.delegate.invoke { (_delegate) in
                    _delegate.FBSManagerUpdateData(FBSMessage: .updateFal(nil, error))
                }
                return
            }
            
            let document = snapshot!.documents.first
            document!.reference.updateData(data) { (error) in
                if error == nil {
                    guard let index = self.index else {
                        let errorTemp = NSError(domain: "Hata index yok", code: 99090, userInfo: ["Description":"Arama indexi bulunamadı"])
                        self.delegate.invoke { (_delegate) in
                            _delegate.FBSManagerUpdateData(FBSMessage: .updateFal(nil, errorTemp))
                        }
                        return
                    }
                    index.deleteObject(withID: id, requestOptions: nil) { (data:[String : Any]?, error:Error?) in
                        if error == nil {
                            let dict:[String:String] = ["id":id, "falText":falString!]
                            index.addObject(dict, withID: id, requestOptions: nil) { (data:[String : Any]?, error:Error?) in
                                self.delegate.invoke { (_delegate) in
                                    _delegate.FBSManagerUpdateData(FBSMessage: .updateFal(data, error))
                                }
                            }
                        }
                    }
                    
                }else {
                    
                }
            }
        }
        
    }
    
    func fetchFilterFal(giris:Bool? = false,
                         gelisme:Bool? = false,
                         sonuc:Bool? = false,
                         evli:Bool? = false,
                         iliskisiVar:Bool? = false,
                         yeniAyrilmis:Bool? = false,
                         yeniBosanmis:Bool? = false,
                         iliskisiYok:Bool? = false,
                         nisanli:Bool? = false,
                         ogrenci:Bool? = false,
                         evHanimi:Bool? = false,
                         calisiyor:Bool? = false,
                         calismiyor:Bool? = false,
                         olumlu:Bool? = false,
                         olumsuz:Bool? = false,
                         purchase:Bool? = false){
        let refQuery = db.collection(fallar)
            .whereField("\( paragrafTipi).\(paragrafTipi_Giris)", isEqualTo: giris!)
            .whereField("\(paragrafTipi).\(paragrafTipi_Gelisme)", isEqualTo: gelisme!)
            .whereField("\(paragrafTipi).\(paragrafTipi_Sonuc)", isEqualTo: sonuc!)
            .whereField("\(iliskiDurumu).\(iliskiDurumu_Evli)", isEqualTo: evli!)
            .whereField("\(iliskiDurumu).\(iliskiDurumu_IliskisiVar)", isEqualTo: iliskisiVar!)
            .whereField("\(iliskiDurumu).\(iliskiDurumu_IliskisiYok)", isEqualTo: iliskisiYok!)
            .whereField("\(iliskiDurumu).\(iliskiDurumu_Nisanli)", isEqualTo: nisanli!)
            .whereField("\(iliskiDurumu).\(iliskiDurumu_YeniAyrilmis)", isEqualTo: yeniAyrilmis!)
            .whereField("\(iliskiDurumu).\(iliskiDurumu_YeniBosanmis)", isEqualTo: yeniAyrilmis!)
            .whereField("\(kariyer).\(kariyer_Ogrenci)", isEqualTo: ogrenci!)
            .whereField("\(kariyer).\(kariyer_EvHanimi)", isEqualTo: evHanimi!)
            .whereField("\(kariyer).\(kariyer_Calisiyor)", isEqualTo: calisiyor!)
            .whereField("\(kariyer).\(kariyer_Calismiyor)", isEqualTo: calismiyor!)
            .whereField("\(yargi).\(yargi_Olumlu)", isEqualTo: olumlu!)
            .whereField("\(yargi).\(yargi_Olumsuz)", isEqualTo: olumsuz!)
            .whereField("\(purchaseString).\(purchaseStatusString)", isEqualTo: purchase!)
        refQuery.getDocuments { (snapshot, error) in
            self.delegate.invoke { (_delegate) in
                _delegate.FBSManagerUpdateData(FBSMessage: .fetchFilterFal(snapshot, error))
            }
        }
    }
    
    func searchKeyword(keyword:String) {
        guard let index = self.index else {
            let errorTemp = NSError(domain: "Hata index yok", code: 99090, userInfo: ["Description":"Arama indexi bulunamadı"])
            self.delegate.invoke { (_delegate) in
                _delegate.FBSManagerUpdateData(FBSMessage: .searchKeyword(nil, errorTemp))
            }
            return
        }
        index.search(Query(query: keyword)) { (dict:[String : Any]?, error:Error?) in
            if error != nil {
                self.delegate.invoke { (_delegate) in
                    _delegate.FBSManagerUpdateData(FBSMessage: .searchKeyword(nil, error))
                }
            }else {
                guard let dict = dict else { return }
                guard let hits = dict["hits"] as? NSArray, hits.count > 0 else {
                    let errorTemp = NSError(domain: "Arama sonucunda hiç bir şey dönmedi.", code: 99101, userInfo: ["Description":"Arama sonucunda hiç bir şey dönmedi."])
                    self.delegate.invoke { (_delegate) in
                        _delegate.FBSManagerUpdateData(FBSMessage: .searchKeyword(nil, errorTemp))
                    }
                    return
                }
                var searchArray:[String] = []
                hits.forEach { (data) in
                    if let data = data as? NSDictionary{
                        if let idString = data["id"] as? String {
                            searchArray.append(idString)
                        }
                    }
                }
                if searchArray.count > 0 {
                    let refQuery = self.db.collection(fallar).whereField("id", in: searchArray)
                    refQuery.getDocuments { (snapShot, error) in
                        self.delegate.invoke { (_delegate) in
                            _delegate.FBSManagerUpdateData(FBSMessage: .searchKeyword(snapShot, error))
                        }
                    }
                }
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
