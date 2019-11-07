//
//  RealmEndpointObject.swift
//  RealmEndpoint
//
//  Created by Jay Lyerly on 11/5/19.
//  Copyright © 2019 Oak City Labs. All rights reserved.
//

import Foundation
import RealmSwift

open class RealmEndpointBaseObject: Object {
    open var realmTags = List<RealmTag>()    
}
