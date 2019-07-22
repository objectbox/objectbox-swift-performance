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

struct MemoryUsage: CustomStringConvertible {
    let byteSize: UInt64
    var mebibyteSize: String { return String(format: "%.2f",  Double(byteSize) / 1024 / 1024) }
    var description: String { return "\(mebibyteSize)" }

    init(_ byteSize: UInt64) {
        self.byteSize = byteSize
    }
}


extension Collection where Element == MemoryUsage {
    var total: Element {
        return MemoryUsage(self.map { $0.byteSize }.reduce(0, +))
    }

    var average: Element {
        return MemoryUsage(isEmpty ? 0 : total.byteSize / UInt64(count))
    }
}

@discardableResult
func reportMemory(_ label: String? = nil) -> MemoryUsage {
    var info = mach_task_basic_info()
    var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4

    let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
        $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
            task_info(mach_task_self_,
                      task_flavor_t(MACH_TASK_BASIC_INFO),
                      $0,
                      &count)
        }
    }

    if kerr == KERN_SUCCESS {
        let usage = MemoryUsage(info.resident_size)
        print("Memory in use \(label.map { " (\($0))" } ?? ""): \(usage.byteSize) B, \(usage.mebibyteSize) MiB")
        return usage
    }
    else {
        print("Error with task_info(): " +
            (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error"))
        return MemoryUsage(0)
    }
}
