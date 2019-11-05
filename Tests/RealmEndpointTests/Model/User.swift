//
//  User.swift
//  RealmEndpointTests
//
//  Created by Jay Lyerly on 11/5/19.
//  Copyright © 2019 Oak City Labs. All rights reserved.
//

import Foundation
import RealmEndpoint
import RealmSwift

class User: RealmEndpointObject {

    @objc open dynamic var firstName: String = ""
    @objc open dynamic var lastName: String = ""

    override class var realmCodableKeys: [String: String] {
        return [
            "firstName": "first_name",
            "lastName": "last_name",
            "objId": "id"
        ]
    }
    
    static let sampleDict: [String: Any] = [
        "firstName": "Larry",
        "lastName": "Bird",
        "objId": "949-123"
    ]
    
    static let sampleJsonData: Data? = """
        {
            "id": "949-123",
            "first_name": "Larry",
            "last_name": "Bird"
        }
    """.data(using: .utf8)
}
