
import Foundation
import RealmSwift

class Permission: Object {

    @objc open dynamic var name: String = ""
    @objc open dynamic var level: Int = -1

}
