////
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
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let options = Options()
        
        let testEntityData: [TestEntity] = (0 ..< options.count).map(TestEntity.random(index:))
        var store: Store! = try! Store(directoryPath: newTemporaryDirectory().path, maxDbSizeInKByte: UInt64(options.count))
        
        var results: [RunResult] = []
        for _ in (0 ..< options.runs) {
            results.append(try! run(Parameters(
                entities: testEntityData,
                options: options,
                store: store)))
        }
        
        let average = results.average
        print(average)
        print(average.spreadsheetFormatted)
        
        // Cleaning up
        let path = store.directoryPath
        store = nil
        try! FileManager.default.removeItem(atPath: path)
        
        NSApplication.shared.terminate(self)
    }
}
