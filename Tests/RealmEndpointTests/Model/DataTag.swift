//
//  DataTag.swift
//  
//
//  Created by Jay Lyerly on 11/5/19.
//

import Foundation
import RealmEndpoint

enum DataTag: String, DataTaggable, CaseIterable {
    
    var objId: String {
        return rawValue
    }
    
    var name: String {
        return rawValue
    }

    case mine, theirs, ours
    
}
