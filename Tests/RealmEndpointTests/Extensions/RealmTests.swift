//
//  RealmTests.swift
//  RealmEndpointTests
//
//  Created by Jay Lyerly on 11/5/19.
//  Copyright © 2019 Oak City Labs. All rights reserved.
//

import RealmEndpoint
import RealmSwift
import XCTest

class RealmTests: XCTestCase {
    
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

    func testResults() {
        let results = realm.results(User.self, primaryKey: "949-123")
        XCTAssertEqual(results.count, 0)
        
        realm.beginWrite()
        realm!.create(User.self, value: User.sampleDict, update: .modified)
        try! realm.commitWrite()
        
        XCTAssertEqual(results.count, 1)

    }
}
