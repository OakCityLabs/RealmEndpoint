//
//  User.swift
//  RealmEndpointTests
//
//  Created by Jay Lyerly on 11/5/19.
//  Copyright © 2019 Oak City Labs. All rights reserved.
//

import Foundation
import RealmEndpoint

class User: RealmEndpointBaseObject {

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
        "firstName": "Barry",
        "lastName": "Allen",
        "objId": "949-123"
    ]
    
    static let sampleJsonData: Data? = """
        {
            "id": "949-123",
            "first_name": "Barry",
            "last_name": "Allen"
        }
    """.data(using: .utf8)
    
    static let sampleJsonListData: Data? = """
        [
            {
                "id": "949-456",
                "first_name": "Conner",
                "last_name": "Kent"
            },
            {
                "id": "949-494",
                "first_name": "Barry",
                "last_name": "Allen"
            },
            {
                "id": "949-123",
                "first_name": "Wally",
                "last_name": "West"
            }
        ]
    """.data(using: .utf8)

}
