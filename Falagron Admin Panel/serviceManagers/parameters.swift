//
//  parameters.swift
//  Falagron Admin Panel
//
//  Created by namik kaya on 11.04.2020.
//  Copyright © 2020 namikkaya86@gmail.com. All rights reserved.
//

import Foundation
import Firebase

enum GENDER_TYPE {
    case men
    case woman
}

let fallar:String = "fallar"

let falText:String = "falText"

let paragrafTipi:String = "paragrafTipi"
let paragrafTipi_Giris:String = "paragrafTipi_Giris"
let paragrafTipi_Gelisme:String = "paragrafTipi_Gelisme"
let paragrafTipi_Sonuc:String = "paragrafTipi_Sonuc"

let iliskiDurumu:String = "iliskiDurumu"
let iliskiDurumu_IliskisiVar:String = "iliskiDurumu_IliskisiVar"
let iliskiDurumu_IliskisiYok:String = "iliskiDurumu_IliskisiYok"
let iliskiDurumu_YeniAyrilmis:String = "iliskiDurumu_YeniAyrilmis"
let iliskiDurumu_Evli:String = "iliskiDurumu_Evli"
let iliskiDurumu_Nisanli:String = "iliskiDurumu_Nisanli"
let iliskiDurumu_YeniBosanmis:String = "iliskiDurumu_YeniBosanmis"

let kariyer:String = "kariyer"
let kariyer_Calisiyor:String = "kariyer_Calisiyor"
let kariyer_Calismiyor:String = "kariyer_Calismiyor"
let kariyer_Ogrenci:String = "kariyer_Ogrenci"
let kariyer_EvHanimi:String = "kariyer_EvHanimi"

let yargi:String = "yargi"
let yargi_Olumlu:String = "yargi_Olumlu"
let yargi_Olumsuz:String = "yargi_Olumsuz"

let textAppealString:String = "@%hitap%@"
let previewTextAppealWomenString:String = "Hanım"
let previewTextAppealMenString:String = "Bey"

let textGenderString:String = "@%gender%@" // karşı cins
let previewTextGenderMenString:String = "erkek"
let previewTextGenderWomenString:String = "kadın"

let textSameGenderString:String = "@%sameGender%@" // hem cins
let previewTextSameGenderMenString:String = "erkek"
let previewTextSameGenderWomenString:String = "kadın"

let purchaseString:String = "purchase"
let purchaseStatusString:String = "purchaseStatus"

let purchaseLoveString:String = "purchaseLove"
let purchaseLoveStatusString:String = "purchaseStatus"

extension String {
    static func random(length:Int)->String{
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""

        while randomString.utf8.count < length{
            let randomLetter = letters.randomElement()
            randomString += randomLetter?.description ?? ""
        }
        return randomString
    }
}

extension QueryDocumentSnapshot {

    func prepareForDecoding() -> [String: Any] {
        var data = self.data()
        data["documentId"] = self.documentID

        return data
    }

}

extension JSONDecoder {
    func decode<T>(_ type: T.Type, fromJSONObject object: Any) throws -> T where T: Decodable {
        return try decode(T.self, from: try JSONSerialization.data(withJSONObject: object, options: []))
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
