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

import ObjectBox

struct Parameters {
    let entities: [TestEntity]
    let options: Options
    let store: Store
}

struct RunResult {
    var timeInsert: TimeElapsed = -1
    var memInsert: MemoryUsage = MemoryUsage(0)
    var timeLoad: TimeElapsed = -1
    var timeLoadProps: TimeElapsed = -1
    var memLoadProps: MemoryUsage = MemoryUsage(0)
    var timeUpdate: TimeElapsed = -1
    var memUpdate: MemoryUsage = MemoryUsage(0)
    var timeCount: TimeElapsed = -1
    var timeQuery: TimeElapsed = -1
    var timeRemove: TimeElapsed = -1

    /// Output for the spreadsheet:
    /// time: insert, update, load, access, remove
    /// mem:  insert, load&access, update
    var spreadsheetFormatted: String {
        return "times:\n\(Int(timeInsert))\t\(Int(timeUpdate))\t\(Int(timeLoad))\t\(Int(timeLoadProps))\t\(Int(timeRemove))\nmem:\n\(memInsert)\t\(memLoadProps)\t\(memUpdate)\n"
    }
}

extension Array where Element == RunResult {
    var average: RunResult {
        return RunResult(
            timeInsert: self.lazy.map { $0.timeInsert }.average,
            memInsert: self.lazy.map { $0.memInsert }.average,
            timeLoad: self.lazy.map { $0.timeLoad }.average,
            timeLoadProps: self.lazy.map { $0.timeLoadProps }.average,
            memLoadProps: self.lazy.map { $0.memLoadProps }.average,
            timeUpdate: self.lazy.map { $0.timeUpdate }.average,
            memUpdate: self.lazy.map { $0.memUpdate }.average,
            timeCount: self.lazy.map { $0.timeCount }.average,
            timeQuery: self.lazy.map { $0.timeQuery }.average,
            timeRemove: self.lazy.map { $0.timeRemove }.average)
    }
}

func run(_ parameters: Parameters) throws -> RunResult {
    var result = RunResult()
    let store = parameters.store
    let box = store.box(for: TestEntity.self)

    // Reset
    try box.removeAll()

    result.timeInsert = try timeElapsed("Bulk insert") {
        try box.put(parameters.entities)
    }
    print(parameters.options.count, "Entities inserted")
    result.memInsert = reportMemory("after insert")

    var loadedEntities: [TestEntity] = []
    result.timeLoad = try timeElapsed("Bulk load") {
        loadedEntities = try box.all()
    }
    _ = timeElapsed("Loop") {
        for _ in loadedEntities {
            // nop
        }
    }
    result.timeLoadProps = timeElapsed("Iterate") {
        loadedEntities.forEach {
            _ = $0.boolean
            _ = $0.byte
            _ = $0.string
            _ = $0.float
            _ = $0.double
            _ = $0.long
            _ = $0.int
            _ = $0.short
        }
    }
    print(loadedEntities.count, "Entities loaded")
    result.memLoadProps = reportMemory("after loading properties")

    loadedEntities = loadedEntities.map { entity in
        entity.long = entity.long / 2
        return entity
    }
    result.timeUpdate = try timeElapsed("Update") {
        try box.put(loadedEntities)
    }
    result.memUpdate = reportMemory("after update")
    loadedEntities = []

    var count: Int = 0
    result.timeCount = try timeElapsed {
        try store.runInReadOnlyTransaction {
            // Count 10x because values are so low
            for _ in (0 ..< 10) {
                count = try box.count()
            }
        }
    }
    print(count, "Entities counted 10x")

    // TODO: Implement query test

    var removeCount: UInt64 = 0
    result.timeRemove = try timeElapsed {
        removeCount = try box.removeAll()
    }
    print(removeCount, "Entities removed")

    return result
}
