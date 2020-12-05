//
//  newFalViewController.swift
//  Falagron Admin Panel
//
//  Created by namik kaya on 28.03.2020.
//  Copyright © 2020 namikkaya86@gmail.com. All rights reserved.
//

import Cocoa
import Firebase
enum falType {
    case new
    case edit
}

class newFalViewController: BaseViewController {
    
    var fbsManager:FBSManager?
    var falData:FalDataModel?
    var type:falType? = .new
    
    
    // MARK: - View
    
    @IBOutlet weak var girisButton: NSButton!
    @IBOutlet weak var gelismeButton: NSButton!
    @IBOutlet weak var sonucButton: NSButton!
    @IBOutlet weak var calisiyorButton: NSButton!
    @IBOutlet weak var calismiyorButton: NSButton!
    @IBOutlet weak var ogrenciButton: NSButton!
    @IBOutlet weak var evHanimiButton: NSButton!
    @IBOutlet weak var iliskisiVarButton: NSButton!
    @IBOutlet weak var iliskisiYokButton: NSButton!
    @IBOutlet weak var yeniAyrilmisButton: NSButton!
    @IBOutlet weak var yeniBosanmisButton: NSButton!
    @IBOutlet weak var evliButton: NSButton!
    @IBOutlet weak var nisanliButton: NSButton!
    @IBOutlet weak var olumluButton: NSButton!
    @IBOutlet weak var olumsuzButton: NSButton!
    @IBOutlet weak var purchaseButton: NSButton!
    
    @IBOutlet weak var falInputText: NSScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = falData else { return }
        type = .edit
        configureEdit(data: data)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        fbsManager = FBSManager.sharedInstance
        fbsManager?.delegate.add(delegate: self)
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        fbsManager?.delegate.remove(delegate: self)
        fbsManager = nil
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)
        self.view.frame.size = CGSize(width: 1280, height: 720)
    }
    
    @IBAction func addAppeal(_ sender: Any) {
        falInputText.documentView?.insertText(textAppealString)
    }
    
    @IBAction func addGender(_ sender: Any) {
        falInputText.documentView?.insertText(textGenderString)
    }
    
    @IBAction func addSameGender(_ sender: Any) {
        falInputText.documentView?.insertText(textSameGenderString)
    }
    
    
    private func configureEdit(data:FalDataModel) {
        if let falText = data.falText {
            falInputText.documentView?.insertText(falText)
        }
        if let girisParagraf = data.paragrafTipi?.paragrafTipi_Giris {
            girisButton.state = girisParagraf.boolToState
        }
        if let gelismeParagraf = data.paragrafTipi?.paragrafTipi_Gelisme {
            gelismeButton.state = gelismeParagraf.boolToState
        }
        if let sonucParagraf = data.paragrafTipi?.paragrafTipi_Sonuc {
            sonucButton.state = sonucParagraf.boolToState
        }
        if let iliskiDurumu_Evli = data.iliskiDurumu?.iliskiDurumu_Evli {
            evliButton.state = iliskiDurumu_Evli.boolToState
        }
        if let iliskiDurumu_iliskisiVar = data.iliskiDurumu?.iliskiDurumu_IliskisiVar {
            iliskisiVarButton.state = iliskiDurumu_iliskisiVar.boolToState
        }
        if let iliskiDurumu_iliskisiYok = data.iliskiDurumu?.iliskiDurumu_IliskisiYok {
            iliskisiYokButton.state = iliskiDurumu_iliskisiYok.boolToState
        }
        if let iliskiDurumu_nisanli = data.iliskiDurumu?.iliskiDurumu_Nisanli {
            nisanliButton.state = iliskiDurumu_nisanli.boolToState
        }
        if let iliskiDurumu_yeniAyrilmis = data.iliskiDurumu?.iliskiDurumu_YeniAyrilmis {
            yeniAyrilmisButton.state = iliskiDurumu_yeniAyrilmis.boolToState
        }
        if let calisiyor = data.kariyer?.kariyer_Calisiyor {
            calisiyorButton.state = calisiyor.boolToState
        }
        if let calismiyor = data.kariyer?.kariyer_Calismiyor {
            calismiyorButton.state = calismiyor.boolToState
        }
        if let evhanimi = data.kariyer?.kariyer_EvHanimi {
            evHanimiButton.state = evhanimi.boolToState
        }
        if let ogrenci = data.kariyer?.kariyer_Ogrenci {
            ogrenciButton.state = ogrenci.boolToState
        }
        if let yargiOlumlu = data.yargi?.yargi_Olumlu {
            olumluButton.state = yargiOlumlu.boolToState
        }
        if let yargiOlumsuz = data.yargi?.yargi_Olumsuz {
            olumsuzButton.state = yargiOlumsuz.boolToState
        }
        if let iliskiDurumu_YeniBosanmis = data.iliskiDurumu?.iliskiDurumu_YeniBosanmis {
            yeniBosanmisButton.state = iliskiDurumu_YeniBosanmis.boolToState
        }
        if let purchase = data.purchase?.purchaseStatus {
            purchaseButton.state = purchase.boolToState
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        let status = dialogOKCancel(title: "Çıkmak istediğinize emin misin?",
                                    description: "Kaydetmeden çıkış yaparsan yaptığın bütün değişiklikleri kaybedersin. Bu işlemi gerçekten yapmak istediğine emin misin?",
                                    okButton: "Çık", cancelButton: "İptal")
        if status {
            dismiss(self)
        }
    }
    
    @IBAction func saveFal(_ sender: Any) {
        if type == .new {
            newFalSave()
        }else {
            updateFal(falId: falData?.id)
        }
    }
    
    private func newFalSave() {
        let myTextView: NSTextView = falInputText.documentView! as! NSTextView
        let myText:String = myTextView.string
        preloaderVC.sharedInstance.openPreloader(vc: self)
        fbsManager?.writeFal(giris: girisButton.state.rawValue.bool,
                             gelisme: gelismeButton.state.rawValue.bool,
                             sonuc: sonucButton.state.rawValue.bool,
                             evli: evliButton.state.rawValue.bool,
                             iliskisiVar: iliskisiVarButton.state.rawValue.bool,
                             yeniAyrilmis: yeniAyrilmisButton.state.rawValue.bool,
                             yeniBosanmis: yeniBosanmisButton.state.rawValue.bool,
                             iliskisiYok: iliskisiYokButton.state.rawValue.bool,
                             nisanli: nisanliButton.state.rawValue.bool,
                             ogrenci: ogrenciButton.state.rawValue.bool,
                             evHanimi: evHanimiButton.state.rawValue.bool,
                             calisiyor: calisiyorButton.state.rawValue.bool,
                             calismiyor: calismiyorButton.state.rawValue.bool,
                             olumlu: olumluButton.state.rawValue.bool,
                             olumsuz: olumsuzButton.state.rawValue.bool,
                             purchase: purchaseButton.state.rawValue.bool,
                             falString: myText)
    }
    
    
    func saveComplete(data:[String : Any]??, error:Error?) {
        preloaderVC.sharedInstance.closePreloader(vc: self)
        if error != nil {
            let _ = dialogOKCancel(title: "", description: error?.localizedDescription ?? "", okButton: "Tamam")
        }else {
            if let data = data, data?.count ?? 0 > 0 {
                let status = dialogOKCancel(title: "Kayıt işlemi",
                                            description: "Kayıt işlemi başarı ile tamamlandı.",
                                            okButton: "Tamam")
                if status {
                    dismiss(self)
                }
            }
            else {
                let _ = dialogOKCancel(title: "", description: "Boş veya dönmeyen data", okButton: "Tamam")
            }
        }
    }
    
    
    func getFilterFal(snapshot:QuerySnapshot?, error:Error?){
        preloaderVC.sharedInstance.closePreloader(vc: self)
        if error != nil {
            let _ = dialogOKCancel(title: "", description: error?.localizedDescription ?? "", okButton: "Tamam")
        }else {
            
        }
    }
    
    /**
     Usage:  Fal güncelleme
     - Parameter : falId : Fal id firestore da root parameter olarak tutulur
     */
    private func updateFal (falId:String?) {
        guard let falId = falId else {
            let _ = dialogOKCancel(title: "", description: "Tanımlı bir fal olduğuna emin misin? Bu hatayı geliştiricilerle paylaşabilirsin.", okButton: "Tamam")
            return
        }
        preloaderVC.sharedInstance.openPreloader(vc: self)
        let myTextView: NSTextView = falInputText.documentView! as! NSTextView
        let myText:String = myTextView.string
        fbsManager?.updateEqualId(falId:falId,
                                giris: girisButton.state.rawValue.bool,
                                gelisme: gelismeButton.state.rawValue.bool,
                                sonuc: sonucButton.state.rawValue.bool,
                                evli: evliButton.state.rawValue.bool,
                                iliskisiVar: iliskisiVarButton.state.rawValue.bool,
                                yeniAyrilmis: yeniAyrilmisButton.state.rawValue.bool,
                                yeniBosanmis: yeniBosanmisButton.state.rawValue.bool,
                                iliskisiYok: iliskisiYokButton.state.rawValue.bool,
                                nisanli: nisanliButton.state.rawValue.bool,
                                ogrenci: ogrenciButton.state.rawValue.bool,
                                evHanimi: evHanimiButton.state.rawValue.bool,
                                calisiyor: calisiyorButton.state.rawValue.bool,
                                calismiyor: calismiyorButton.state.rawValue.bool,
                                olumlu: olumluButton.state.rawValue.bool,
                                olumsuz: olumsuzButton.state.rawValue.bool,
                                purchase: purchaseButton.state.rawValue.bool,
                                falString: myText)
    }
    
    func updateComplete(data:[String : Any]??, error:Error?) {
        preloaderVC.sharedInstance.closePreloader(vc: self)
        if error != nil {
            let _ = dialogOKCancel(title: "", description: error?.localizedDescription ?? "", okButton: "Tamam")
        }else {
            if let data = data, data?.count ?? 0 > 0 {
                let status = dialogOKCancel(title: "Kayıt işlemi",
                                            description: "Kayıt işlemi başarı ile tamamlandı.",
                                            okButton: "Tamam")
                if status {
                    dismiss(self)
                }
            }else {
                let _ = dialogOKCancel(title: "", description: "Boş veya dönmeyen data", okButton: "Tamam")
            }
            
        }
    }
    
    @IBAction func previewButtonAction(_ sender: Any) {
        let previewVC: previewController = self.storyboard?.instantiateController(withIdentifier: "previewVC") as! previewController
        let myTextView: NSTextView = falInputText.documentView! as! NSTextView
        let myText:String = myTextView.string
        previewVC.textString = myText
        self.presentAsSheet(previewVC)
    }
    
}

extension newFalViewController:FBSManagerDelegate {
    func FBSManagerUpdateData(FBSMessage: FBSManagerStatus?) {
        guard let message = FBSMessage else { return }
        switch message {
        case .fetchFilterFal(let snapshot,let error):
            getFilterFal(snapshot: snapshot, error: error)
            break
        case .saveFalComplete(let data, let error):
            saveComplete(data: data, error: error)
            break
        case .updateFal(let data, let error):
            updateComplete(data: data, error: error)
            break
        default:
            break
        }
    }
}

extension Int {
    var bool: Bool {
        return self == 1 ? true : false
    }
}

extension Bool {
    var boolToState:NSControl.StateValue {
        return self == true ? .on : .off
    }
}
