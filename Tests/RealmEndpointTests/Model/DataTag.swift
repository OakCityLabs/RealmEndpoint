//
//  DataTag.swift
//  RealmEndpointTests
//
//  Created by Jay Lyerly on 11/5/19.
//  Copyright © 2019 Oak City Labs. All rights reserved.
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
