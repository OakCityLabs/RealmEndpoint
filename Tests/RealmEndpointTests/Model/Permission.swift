//
//  Permission.swift
//  RealmEndpointTests
//
//  Created by Jay Lyerly on 11/5/19.
//  Copyright © 2019 Oak City Labs. All rights reserved.
//

import Foundation
import RealmSwift

class Permission: Object {

    @objc open dynamic var name: String = ""
    @objc open dynamic var level: Int = -1

}
