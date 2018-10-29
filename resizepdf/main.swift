//
//  main.swift
//  resizepdf
//
//  Created by Prachi Gauriar on 10/17/2017.
//  Copyright © 2017 Prachi Gauriar.
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

import CoreGraphics
import Foundation


/// Prints command-line usage and exits with status 1.
func printUsageAndExit() -> Never  {
    exit(status: 1, "Usage: \(ProcessInfo.processInfo.processName) inputPDF outputPDF width height")
}


/// Converts the specified file path into a file URL and returns it if it’s reachable.
/// - Parameter path: The file path to convert into a URL. If relative, the returned URL is
///   relative to the process’s current working directory. If the path begins with a “~” or
///   “~*user*”, the tilde is expanded before converting it into a URL.
/// - Returns: A file URL for the specified file path if it is reachable; `nil` otherwise.
func validatedFileURL(forPath path: String) -> URL? {
    let url = URL(fileURLWithPath: path.expandingTildeInPath)
    
    guard let isReachable = try? url.checkResourceIsReachable() , isReachable else {
        return nil
    }
    
    return url
}


/// Parses the processes’s command-line arguments and returns them in a tuple. If an error
/// occurs while parsing command-line arguments, prints an error message and exits.
//
/// - Returns: A tuple containing the command-line arguments.
func parseCommandLineArguments() -> (inputURL: URL, outputURL: URL, outputSize: CGSize) {
    let userArguments = ProcessInfo.processInfo.userArguments
    guard userArguments.count == 4 else {
        printUsageAndExit()
    }
    
    let inputPath = userArguments[0]
    guard let inputURL = validatedFileURL(forPath: inputPath) else {
        exit(status: 2, "Could not open PDF \(inputPath)")
    }
    
    let outputFileURL = URL(fileURLWithPath: userArguments[1].expandingTildeInPath)
    
    let widthString = userArguments[2]
    guard let width = Double(widthString), width > 0 else {
        exit(status: 3, "Width \(widthString) is not a non-negative double")
    }

    let heightString = userArguments[3]
    guard let height = Double(heightString), width > 0 else {
        exit(status: 4, "Height \(heightString) is not a non-negative double")
    }

    return (inputURL, outputFileURL, CGSize(width: width, height: height))
}


// MARK: - Main

// Parse the command-line arguments
let (inputURL, outputURL, outputSize) = parseCommandLineArguments()

// Create and start a resize operation with those arguments
let operation = PDFResizeOperation(inputURL: inputURL, outputURL: outputURL, outputSize: outputSize)
operation.start()

// If an error occurred, print an appropriate error message
if let error = operation.error {
    switch error {
    case let .couldNotOpenFileURL(fileURL):
        exit(status: 5, "Could not open input PDF \(fileURL.path.abbreviatingWithTildeInPath).")
    case let  .couldNotCreateOutputPDF(fileURL):
        exit(status: 6, "Could not create output PDF \(fileURL.path.abbreviatingWithTildeInPath).")
    }
}

// Otherwise print success
print("Successfully combined PDFs and saved output to \(outputURL.path.abbreviatingWithTildeInPath).")
