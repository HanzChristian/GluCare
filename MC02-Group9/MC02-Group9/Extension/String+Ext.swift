//
//  String+Ext.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 15/12/22.
//

import Foundation

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
