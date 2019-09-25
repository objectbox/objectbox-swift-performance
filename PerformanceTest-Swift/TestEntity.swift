//
// Copyright © 2019 ObjectBox Ltd. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import ObjectBox

class TestEntity: Entity {
    var id: EntityId<TestEntity> = 0
    var string: String = ""
    var boolean: Bool = false
    var float: Float = 0
    var double: Double = 0
    var byte: Int8 = 0
    var short: Int16 = 0
    var int: Int32 = 0
    var long: Int64 = 0

    required init() {}
}

extension TestEntity {
    static func random(index: Int) -> TestEntity {
        let result = TestEntity()
        result.boolean = (arc4random() % 2 == 1)
        result.float = Float(arc4random()) / Float(arc4random())
        result.double = Double(arc4random()) / Double(arc4random())
        result.byte = arc4random()
        result.short = arc4random()
        result.int = arc4random()
        result.long = arc4random()
        result.string = "\(arc4random()) MyString \(index)"
        return result
    }
}

func arc4random<T: ExpressibleByIntegerLiteral>() -> T {
    var r: T = 0
    arc4random_buf(&r, MemoryLayout<T>.size)
    return r
}

