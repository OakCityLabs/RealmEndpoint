//
//  RealmTagTests.swift
//  
//
//  Created by Jay Lyerly on 11/5/19.
//

import Foundation
import RealmEndpoint
import RealmSwift
import XCTest

class RealmTagTests: XCTestCase {

    var realm: Realm!
    
    override func setUp() {
        super.setUp()
        realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: UUID().uuidString))
    }
    
    override func tearDown() {
        realm = nil
        super.tearDown()
    }
    
    func testTags() {
        try! RealmTag.create(fromTags: DataTag.allCases, in: realm)    

        realm.beginWrite()
        let user = realm!.create(User.self, value: User.sampleDict, update: .modified)
        try! realm.commitWrite()
        
        XCTAssertEqual(user.realmTags.count, 0)
        
        // Add a tag
        try! realm.add(tags: [DataTag.mine], to: [user])
        
        XCTAssertEqual(user.realmTags.count, 1)
        XCTAssertEqual(user.realmTags.first!.objId, DataTag.mine.objId)

        // Add the same tag
        try! realm.add(tags: [DataTag.mine], to: [user])

        XCTAssertEqual(user.realmTags.count, 1)
        XCTAssertEqual(user.realmTags.first!.objId, DataTag.mine.objId)

        // Add another tag
        try! realm.add(tags: [DataTag.theirs], to: [user])

        XCTAssertEqual(user.realmTags.count, 2)
        XCTAssertEqual(user.realmTags.first!.objId, DataTag.mine.objId)
        XCTAssertEqual(user.realmTags.last!.objId, DataTag.theirs.objId)

        // Remove the first one
        try! realm.remove(tags: [DataTag.mine], from: User.self)

        XCTAssertEqual(user.realmTags.count, 1)
        XCTAssertEqual(user.realmTags.first!.objId, DataTag.theirs.objId)

        // Remove the seconds one
        try! realm.remove(tags: [DataTag.theirs], from: User.self)

        XCTAssertEqual(user.realmTags.count, 0)
    }
    
    func testCreate() {
        XCTAssertEqual(DataTag.allCases.count, 3)           // sanity check
        try! RealmTag.create(fromTags: DataTag.allCases, in: realm)
        
        XCTAssertEqual(realm.objects(RealmTag.self).count, 3)
        DataTag.allCases.forEach { (dataTag) in
            let realmTag = dataTag.realmTag(realm: realm)
            XCTAssertNotNil(dataTag.realmTag(realm: realm))
            XCTAssertEqual(realmTag?.objId, dataTag.objId)
            XCTAssertEqual(realmTag?.name, dataTag.name)
        }
    }
    
}
