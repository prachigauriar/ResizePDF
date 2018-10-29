//
//  CommandLineHelpers.swift
//  resizepdf
//
//  Created by Prachi Gauriar on 7/5/2016.
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


/// This extension to ProcessInfo adds computed properties for accessing user arguments, i.e.,
/// arguments actually specified by the user as opposed to the operating system.
extension ProcessInfo {
    /// The number of arguments entered by the user.
    /// This is simply one less than the total number of process arguments.
    var userArgumentCount: Int {
        return arguments.count - 1
    }


    /// The arguments entered by the user.
    /// This is simply all the process’s arguments excluding the first.
    var userArguments: [String] {
        guard userArgumentCount > 0 else {
            return []
        }

        return Array(arguments.suffix(from: 1))
    }
}

/// `StandardErrorStream`s are `OutputStream`s that write to the standard error device.
///
/// They can be used with `print(_:to:)` to write console output to standard error:
///
/// ```
/// var standardError = StandardErrorStream()
/// print("Error: …", to: standardError)
/// ```
struct StandardErrorStream : TextOutputStream {
    mutating func write(_ string: String) {
        fputs(string, stderr)
    }
}


/// Prints `message` to the standard error stream and exits with the specified status code.
///
/// - Parameters:
///   - status: The status code with which to exit.
///   - message: The message to output to the standard error stream.
/// - Returns: Never.
func exit(status: Int32, _ message: String) -> Never {
    var standardErrorStream = StandardErrorStream()
    print(message, to: &standardErrorStream)
    exit(status)
}
