//
//  RealmObjectEndpointTests.swift
//  RealmEndpointTests
//
//  Created by Jay Lyerly on 11/5/19.
//  Copyright © 2019 Oak City Labs. All rights reserved.
//

import RealmEndpoint
import RealmSwift
import XCTest

class RealmObjectEndpointTests: XCTestCase {
    
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
        let endpoint = RealmObjectEndpoint<User>(realmConfig: config, serverUrl: serverUrl, pathPrefix: "")
        let data = User.sampleJsonData!
        
        XCTAssertEqual(realm.objects(User.self).count, 0)
        XCTAssertEqual(endpoint.results?.count, 0)

        // parse and check the returned object
        do {
            let user = try! endpoint.parse(data: data)
            XCTAssertEqual(user.firstName, "Barry")
            XCTAssertEqual(user.lastName, "Allen")
            XCTAssertEqual(user.objId, "949-123")
        }

        // check the User objects in realm
        do {
            let users = realm.objects(User.self)
            XCTAssertEqual(users.count, 1)
            let user = users.first!
            XCTAssertEqual(user.firstName, "Barry")
            XCTAssertEqual(user.lastName, "Allen")
            XCTAssertEqual(user.objId, "949-123")
        }
        
        // check the User objects in the endpoint's results
        do {
            XCTAssertNotNil(endpoint.results)
            let users = endpoint.results!
            XCTAssertEqual(users.count, 1)
            let user = users.first!
            XCTAssertEqual(user.firstName, "Barry")
            XCTAssertEqual(user.lastName, "Allen")
            XCTAssertEqual(user.objId, "949-123")
        }
    }
    
    func loadDataTags() {
        try! RealmTag.create(fromTags: DataTag.allCases, in: realm)
    }
    
    func addSeveralUsers() {
        XCTAssertEqual(realm.objects(User.self).count, 0)
        let endpoint = RealmArrayEndpoint<User>(realmConfig: config,
                                                serverUrl: serverUrl,
                                                pathPrefix: "")
        try! endpoint.parse(data: User.sampleJsonListData!)
        XCTAssertEqual(realm.objects(User.self).count, 3)
    }
    
    func testTag() {
        loadDataTags()
        addSeveralUsers()
        
        let endpoint = RealmObjectEndpoint<User>(realmConfig: config,
                                                 dataTags: [DataTag.mine],
                                                 serverUrl: serverUrl,
                                                 pathPrefix: "")
        try! endpoint.parse(data: User.sampleJsonData!)
        
        let user = endpoint.results?.first
        XCTAssertNotNil(user)
        XCTAssertEqual(user!.firstName, "Barry")
    }
    
    func testResultFactory() {
        loadDataTags()
        addSeveralUsers()
        
        let resultsFactory: ((Realm) -> Results<User>)? = {
            $0.objects(User.self).filter("objId == %@", "949-456")
        }
        
        let endpoint = RealmObjectEndpoint<User>(realmConfig: config,
                                                 resultsFactory: resultsFactory,
                                                 serverUrl: serverUrl,
                                                 pathPrefix: "")
        try! endpoint.parse(data: User.sampleJsonData!)
        
        let user = endpoint.results?.first
        XCTAssertNotNil(user)
        // The item returned should be Conner b/c that matches the hardcoded ID in the `resultsFactory`
        // even though the parsed data is for Barry.
        XCTAssertEqual(user!.firstName, "Conner")
    }
    
    func testPostParse() {
        let postParse: ((User, Realm) -> Void) = { user, realm in
            user.firstName = "Jefferson"
            user.lastName = "Pierce"
        }
        let endpoint = RealmObjectEndpoint<User>(realmConfig: config,
                                                 serverUrl: serverUrl,
                                                 pathPrefix: "",
                                                 postParse: postParse)
        try! endpoint.parse(data: User.sampleJsonData!)
        
        let user = endpoint.results?.first
        XCTAssertNotNil(user)
        // The item returned should be Jefferson with Barry's ID b/c we overwrote it in postParse
        // even though the parsed data is for Barry.
        XCTAssertEqual(user!.firstName, "Jefferson")
        XCTAssertEqual(user!.lastName, "Pierce")
        XCTAssertEqual(user!.objId, "949-123")
    }
    
    static var allTests = [
        ("testParse", testParse),
        ("testTag", testTag),
        ("testResultFactory", testResultFactory),
        ("testPostParse", testPostParse)
    ]
}
