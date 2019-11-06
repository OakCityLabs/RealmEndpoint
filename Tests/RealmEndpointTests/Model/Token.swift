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

class Token: RealmEndpointBaseObject {

    @objc open dynamic var domain: String = ""
    @objc open dynamic var level: Int = -1
    @objc open dynamic var expiration: Date?

    var permissions = List<Permission>()

    override class var realmCodableKeys: [String: String] {
        return [
            "objId": "id"
        ]
    }
    
    static let sampleJsonData: Data? = """
        {
          "domain" : "waynetech.com",
          "expiration" : "2020-11-30T00:00:00.000Z",
          "level" : 7,
          "permissions" : [
            {
              "level" : 0,
              "name" : "janitor"
            },
            {
              "level" : 7,
              "name" : "ceo"
            },
            {
              "level" : 99,
              "name" : "batman"
            }
          ]
        }
        """.data(using: .utf8)
}
