ObjectBox Performance Test
==========================

This project is a small faceless application that performs a large number of CRUD operations and measures their running time.

This is useful for catching performance regressions and generally getting an idea of where the Swift
binding is performance-wise.

Running a Test
--------------

To run the test

- Perform normal CocoaPods/ObjectBox setup if you haven't already:
    - `pod install`
    - `Pods/ObjectBox/setup.rb`
- open Xcode
- choose `Product` > `Archive` to get a release build
- When the Organizer window opens, right-click (anywhere but the build's title) and choose "Show in Finder" 
- Right-click the build in Finder and choose "Show Package Contents"
- Drill down into the subfolders `Products/Applications/PerformanceTest.app/Contents/MacOS`
- Run the `PerformanceTest` executable in Terminal

Running the tests in Xcode will result in a debug build running and results being very slow.
