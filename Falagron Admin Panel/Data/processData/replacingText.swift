//
//  replacingText.swift
//  Falagron Admin Panel
//
//  Created by namik kaya on 25.05.2020.
//  Copyright © 2020 namikkaya86@gmail.com. All rights reserved.
//

import Cocoa

class replacingText: NSObject {
    var gender:GENDER_TYPE?
    
    func replacingData(name:String?, str:String?, genderType:GENDER_TYPE?) -> String? {
        guard let genderType = genderType, let str = str, let name = name else { return ""}
        
        let addStep1Str = genderType == GENDER_TYPE.men ? "\(name) \(previewTextAppealMenString)" : "\(name) \(previewTextAppealWomenString)"
        let replacedStep1 = str.replacingOccurrences(of: textAppealString, with: addStep1Str)
        
        let addStep2Str = genderType == GENDER_TYPE.men ? previewTextGenderWomenString : previewTextGenderMenString
        let replacedStep2 = replacedStep1.replacingOccurrences(of: textGenderString, with: addStep2Str)
        
        let addStep3Str = genderType == GENDER_TYPE.men ? previewTextSameGenderMenString : previewTextSameGenderWomenString
        let replacedStep3 = replacedStep2.replacingOccurrences(of: textSameGenderString, with: addStep3Str)
        
        return replacedStep3
    }
}
