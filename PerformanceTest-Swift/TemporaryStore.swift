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
import Foundation

private func ensurePathExists(path: URL) throws {
    if !FileManager.default.fileExists(atPath: path.path) {
        try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
    }
}

private func topLevelTemporaryDirectory() -> URL {
    return URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("objectbox-perf-test")
}

internal func newTemporaryDirectory() throws -> URL {
    let path = topLevelTemporaryDirectory().appendingPathComponent(UUID().uuidString)
    try ensurePathExists(path: path)
    return path
}
