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

import Darwin

typealias TimeElapsed = Double

func timeElapsed(_ title: String? = nil, _ operation: () throws -> Void) rethrows -> TimeElapsed {
    let startTime = mach_absolute_time()
    try operation()
    let timeElapsed = mach_absolute_time() - startTime
    if let title = title {
        print(title, timeElapsed)
    }
    
    var info = mach_timebase_info_data_t()
    mach_timebase_info(&info);
    
    /* Convert to nanoseconds */
    var timeElapsedNanos = timeElapsed * UInt64(info.numer)
    timeElapsedNanos /= UInt64(info.denom)

    return Double(timeElapsedNanos) / 1000000.0
}

extension Collection where Element == TimeElapsed {
    var total: Element {
        return reduce(0, +)
    }

    var average: Element {
        return isEmpty ? 0 : total / Double(count)
    }
}
