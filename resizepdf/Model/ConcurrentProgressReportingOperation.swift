//
//  ConcurrentProgressReportingOperation.swift
//  resizepdf
//
//  Created by Prachi Gauriar on 7/6/2016.
//  Copyright © 2016 Prachi Gauriar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation


/// `ConcurrentProgressReportingOperation` is an abstract class that provides the basic boilerplate
/// code for concurrent operations. Specifically, it overrides `asynchronous` to return `true`, 
/// and adds read/write properties for `executing` and `finished` so that subclasses can easily set
/// operation state in their `start` methods. 
/// 
/// As a conveneince, the class also conforms to `ProgressReporting`. 
class ConcurrentProgressReportingOperation : Operation, ProgressReporting {
    // MARK: - Concurrent Operation subclass overrides

    override var isAsynchronous: Bool {
        return true
    }


    private var _executing: Bool = false

    /// A Boolean value indicating whether the operation is currently executing.
    /// Settings this value to `true` will automatically set `finished` to `false`.
    override var isExecuting: Bool {
        get { return _executing }
        set {
            willChangeValue(forKey: #keyPath(isExecuting))
            _executing = newValue
            didChangeValue(forKey: #keyPath(isExecuting))

            if isExecuting {
                isFinished = false
            }
        }
    }


    private var _finished: Bool = false

    /// A Boolean value indicating whether the operation has finished executing its task.
    /// Settings this value to `true` will automatically set `executing` to `false`.
    override var isFinished: Bool {
        get { return _finished }
        set {
            willChangeValue(forKey: #keyPath(isFinished))
            _finished = newValue
            didChangeValue(forKey: #keyPath(isFinished))

            if isFinished {
                isExecuting = false
            }
        }
    }


    // MARK: - ProgressReporting

    let progress = Progress(parent: nil, userInfo: nil)
}
