//
//  RealmArrayEndpointTests.swift
//  RealmEndpointTests
//
//  Created by Jay Lyerly on 11/5/19.
//  Copyright © 2019 Oak City Labs. All rights reserved.
//

import RealmEndpoint
import RealmSwift
import XCTest

class RealmArrayEndpointTests: XCTestCase {
    
    var realm: Realm!
    var config: Realm.Configuration!
    let serverUrl = URL(string: "http://oakcity.io/api")!

    override func setUp() {
        super.setUp()
        config = Realm.Configuration(inMemoryIdentifier: UUID().uuidString)
        realm = try! Realm(configuration: config)
    }
    
    override func tearDown() {
        config = nil
        realm = nil
        super.tearDown()
    }

    func testParse() {
        let endpoint = RealmArrayEndpoint<User>(realmConfig: config,
                                                serverUrl: serverUrl,
                                                pathPrefix: "")
        let data = User.sampleJsonListData!
        
        XCTAssertEqual(realm.objects(User.self).count, 0)
        XCTAssertEqual(endpoint.results?.count, 0)

        // parse and check the returned object
        do {
            let users = try! endpoint.parse(data: data)
            XCTAssertEqual(users.count, 3)
            XCTAssertEqual(users[0].firstName, "Conner")
            XCTAssertEqual(users[1].firstName, "Barry")
            XCTAssertEqual(users[2].firstName, "Wally")
        }

        // check the User objects in realm
        do {
            let users = realm.objects(User.self)
            XCTAssertEqual(users.count, 3)
            let user = users.first!
            XCTAssertEqual(user.firstName, "Conner")
            XCTAssertEqual(user.lastName, "Kent")
            XCTAssertEqual(user.objId, "949-456")
        }
        
        // check the results object
        do {
            XCTAssertNotNil(endpoint.results)
            let users = endpoint.results!
            XCTAssertEqual(users.count, 3)
            XCTAssertEqual(users[0].firstName, "Conner")
            XCTAssertEqual(users[0].lastName, "Kent")
            XCTAssertEqual(users[0].objId, "949-456")

            XCTAssertEqual(users[1].firstName, "Barry")
            XCTAssertEqual(users[1].lastName, "Allen")
            XCTAssertEqual(users[1].objId, "949-494")

            XCTAssertEqual(users[2].firstName, "Wally")
            XCTAssertEqual(users[2].lastName, "West")
            XCTAssertEqual(users[2].objId, "949-123")
        }
    }
    
    func testTag() {
        try! RealmTag.create(fromTags: DataTag.allCases, in: realm)
        let endpoint = RealmArrayEndpoint<User>(realmConfig: config, serverUrl: serverUrl, pathPrefix: "")
        let taggedUsers = realm.objects(User.self).filter("ANY realmTags.objId = %@", DataTag.ours.objId)
        
        // initial condition
        XCTAssertEqual(realm.objects(User.self).count, 0)

        try! endpoint.parse(data: User.sampleJsonListData!)

        // loaded 3 users
        XCTAssertEqual(realm.objects(User.self).count, 3)
        // no users are tagged
        XCTAssertEqual(taggedUsers.count, 0)

        let taggedEndpoint = RealmArrayEndpoint<User>(realmConfig: config,
                                                      dataTags: [DataTag.ours],
                                                      serverUrl: serverUrl,
                                                      pathPrefix: "")
        try! taggedEndpoint.parse(data: User.sampleJsonListData!)

        // still have 3 users
        XCTAssertEqual(realm.objects(User.self).count, 3)
        // all three are tagged
        XCTAssertEqual(taggedUsers.count, 3)
    }

    func testResultFactory() {
        let resultsFactory: ((Realm) -> Results<User>)? = {
            $0.objects(User.self).sorted(byKeyPath: #keyPath(User.firstName), ascending: true)
        }
        
        let endpoint = RealmArrayEndpoint<User>(realmConfig: config,
                                                resultsFactory: resultsFactory,
                                                serverUrl: serverUrl,
                                                pathPrefix: "")
        let data = User.sampleJsonListData!
        
        XCTAssertEqual(realm.objects(User.self).count, 0)
        XCTAssertEqual(endpoint.results?.count, 0)

        try! endpoint.parse(data: data)
        
        // results should be sorted by first name
        XCTAssertNotNil(endpoint.results)
        let users = endpoint.results!
        XCTAssertEqual(users.count, 3)
        XCTAssertEqual(users[0].firstName, "Barry")
        XCTAssertEqual(users[0].lastName, "Allen")
        XCTAssertEqual(users[0].objId, "949-494")
        
        XCTAssertEqual(users[1].firstName, "Conner")
        XCTAssertEqual(users[1].lastName, "Kent")
        XCTAssertEqual(users[1].objId, "949-456")
        
        XCTAssertEqual(users[2].firstName, "Wally")
        XCTAssertEqual(users[2].lastName, "West")
        XCTAssertEqual(users[2].objId, "949-123")
    }
    
    func testPostParse() {
        let postParse: (([User], Realm) -> Void) = { users, realm in
            for user in users {
                user.firstName = String(user.firstName.reversed())
            }
        }
        
        let endpoint = RealmArrayEndpoint<User>(realmConfig: config,
                                                serverUrl: serverUrl,
                                                pathPrefix: "",
                                                postParse: postParse)
        let data = User.sampleJsonListData!
        
        XCTAssertEqual(realm.objects(User.self).count, 0)
        XCTAssertEqual(endpoint.results?.count, 0)

        try! endpoint.parse(data: data)
        
        // results should have first name reversed
        XCTAssertNotNil(endpoint.results)
        let users = endpoint.results!
        XCTAssertEqual(users.count, 3)
        XCTAssertEqual(users[0].firstName, "rennoC")
        
        XCTAssertEqual(users[1].firstName, "yrraB")
        
        XCTAssertEqual(users[2].firstName, "yllaW")
    }
    
    static var allTests = [
        ("testParse", testParse),
        ("testTag", testTag),
        ("testResultFactory", testResultFactory),
        ("testPostParse", testPostParse)
    ]
}
