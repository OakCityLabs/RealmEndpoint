//
//  RealmEndpointBaseObjectTests.swift
//  
//
//  Created by Jay Lyerly on 11/6/19.
//

import RealmEndpoint
import RealmSwift
import XCTest

class RealmEndpointBaseObjectTests: XCTestCase {

    func makeUser() -> User {
        let idStr = UUID().uuidString
        let user = User()
        user.objId = idStr
        user.firstName = "Bob\(idStr)"
        user.lastName = "Bobo\(idStr)"
        return user
    }
    
    func testContains() {
        let targetUser = makeUser()
        
        let notIncluded = List<User>()
        notIncluded.append(makeUser())
        notIncluded.append(makeUser())
        notIncluded.append(makeUser())
        
        XCTAssertFalse(notIncluded.contains(targetUser))
        
        let included = List<User>()
        included.append(makeUser())
        included.append(targetUser)
        included.append(makeUser())

        XCTAssertTrue(included.contains(targetUser))
    }
}
