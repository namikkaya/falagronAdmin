//
//  SearchResultData.swift
//  Falagron Admin Panel
//
//  Created by namik kaya on 2.05.2020.
//  Copyright © 2020 namikkaya86@gmail.com. All rights reserved.
//

import Foundation


struct FalDataModel: Decodable {
    var id:String
    var falText:String?
    var iliskiDurumu:IliskiDurumu?
    var kariyer:Kariyer?
    var paragrafTipi:ParagrafTipi?
    var yargi:Yargi?
    var purchase:Purchase?
    var purchaseLove:PurchaseLove?
}

struct IliskiDurumu: Decodable {
    var iliskiDurumu_Evli:Bool?
    var iliskiDurumu_IliskisiVar:Bool?
    var iliskiDurumu_IliskisiYok:Bool?
    var iliskiDurumu_Nisanli:Bool?
    var iliskiDurumu_YeniAyrilmis:Bool?
    var iliskiDurumu_YeniBosanmis:Bool?
}

struct Kariyer: Decodable {
    var kariyer_Calisiyor:Bool?
    var kariyer_Calismiyor:Bool?
    var kariyer_EvHanimi:Bool?
    var kariyer_Ogrenci:Bool?
}

struct ParagrafTipi: Decodable {
    var paragrafTipi_Giris:Bool?
    var paragrafTipi_Gelisme:Bool?
    var paragrafTipi_Sonuc:Bool?
}

struct Yargi: Decodable {
    var yargi_Olumlu:Bool?
    var yargi_Olumsuz:Bool?
}

struct Purchase: Decodable {
    var purchaseStatus:Bool?
}

struct PurchaseLove: Decodable {
    var purchaseStatus:Bool?
}

