//
//  editViewController.swift
//  Falagron Admin Panel
//
//  Created by namik kaya on 19.04.2020.
//  Copyright © 2020 namikkaya86@gmail.com. All rights reserved.
//

import Cocoa
import WebKit
import Firebase

protocol editViewControllerDelegate:class {
    func didSelectData(data:editViewDataType?)
}

extension editViewControllerDelegate {
    func didSelectData(data:editViewDataType?) {}
}

enum editViewDataType {
    case selectFalData(FalDataModel)
}

class editViewController: BaseViewController, WKUIDelegate, WKNavigationDelegate {
    weak var delegate:editViewControllerDelegate?
    
    @IBOutlet weak var searchText: NSSearchField!
    
    private var searchingStatus:Bool? = false
    
    private var sendData:editViewDataType?
    
    let webView = WKWebView()
    private var fbsManager:FBSManager?
    @IBOutlet weak var tableView: NSTableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.doubleAction = #selector(doubleClickOnResultRow)
            tableView.allowsExpansionToolTips = true
        }
    }
    
    var searchList:[FalDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText.delegate = self
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)
        self.view.frame.size = CGSize(width: 1280, height: 720)
        fbsManager = FBSManager.sharedInstance
        fbsManager?.delegate.add(delegate: self)
        
        
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        webView.frame = CGRect(x: 0, y: 0, width: 400, height: 270)
        view.addSubview(webView)
         
        let url = URL(string: "https://www.google.com")
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        fbsManager?.delegate.remove(delegate: self)
        fbsManager = nil
        
        if sendData != nil {
            delegate?.didSelectData(data: sendData)
        }
    }
    
    @IBAction func closeButtonEvent(_ sender: Any) {
        let status = dialogOKCancel(title: "Çıkmak istediğinize emin misin?", description: "Kaydetmeden çıkış yaparsan yaptığın bütün değişiklikleri kaybedersin. Bu işlemi gerçekten yapmak istediğine emin misin?", okButton: "Çık", cancelButton: "İptal")
        if status {
            dismiss(self)
        }
    }
    
    @IBAction func searchKeywordButtonEvent(_ sender: Any) {
        let myKeyword:String = searchText.stringValue
        searchKeyword(keywords: myKeyword)
    }
    
    private func searchKeyword(keywords:String) {
        guard let _searchingStatus = searchingStatus, !_searchingStatus else { print("arama yapılyıor bekle")
            return
        }
        preloaderVC.sharedInstance.openPreloader(vc: self)
        searchingStatus = true
        fbsManager?.searchKeyword(keyword: keywords)
    }
    
    func getSearchFal(snapshot:QuerySnapshot?, error:Error?){
        searchingStatus = false
        preloaderVC.sharedInstance.closePreloader(vc: self)
        if error != nil {
            let _ = dialogOKCancel(title: "", description: error?.localizedDescription ?? "", okButton: "Tamam")
        }else {
            searchList.removeAll()
            if let snapshot = snapshot, snapshot.documents.count > 0 {
                for document in snapshot.documents {
                    if let falData = try? JSONDecoder().decode(FalDataModel.self, fromJSONObject: document.data()) {
                        searchList.append(falData)
                    }
                }
                tableView.reloadData()
            }else {
                let _ = dialogOKCancel(title: "", description: "Boş veya dönmeyen data", okButton: "Tamam")
            }
        }
    }
}

extension editViewController:NSSearchFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
            let myKeyword:String = searchText.stringValue
            searchKeyword(keywords: myKeyword)
            return true
        }/* else if (commandSelector == #selector(NSResponder.deleteForward(_:))) {
            // Do something against DELETE key
            return true
        } else if (commandSelector == #selector(NSResponder.deleteBackward(_:))) {
            // Do something against BACKSPACE key
            return true
        } else if (commandSelector == #selector(NSResponder.insertTab(_:))) {
            // Do something against TAB key
            return true
        } else if (commandSelector == #selector(NSResponder.cancelOperation(_:))) {
            // Do something against ESCAPE key
            return true
        }*/

        // return true if the action was handled; otherwise false
        return false
    }
    
}

extension editViewController:FBSManagerDelegate {
    func FBSManagerUpdateData(FBSMessage: FBSManagerStatus?) {
        guard let message = FBSMessage else { return }
        switch message {
        case .searchKeyword(let snapshot,let error):
            getSearchFal(snapshot: snapshot, error: error)
        default:
            break
        }
    }
}

extension editViewController:NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cellIdentifier: String = ""
        var text:String = ""
        var toolTip:String?
        if tableColumn == tableView.tableColumns[0] {
            text = searchList[row].id
            cellIdentifier = "falId"
        } else if tableColumn == tableView.tableColumns[1] {
            text = searchList[row].falText ?? ""
            toolTip = text
            cellIdentifier = "falText"
        }

        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            if let tt = toolTip {
                cell.textField?.toolTip = tt
            }
            return cell
        }

        return NSView()
    }
    
    // Liste çift click edildiğinde tetiklenir
    @objc func doubleClickOnResultRow() {
        if searchList.isEmpty { return }
        if searchList[safe:tableView.clickedRow] != nil {
            sendData = editViewDataType.selectFalData(searchList[tableView.clickedRow])
            dismiss(self)
        }
        
    }
    
}
