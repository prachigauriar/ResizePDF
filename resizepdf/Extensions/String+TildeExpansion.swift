//
//  String+TildeExpansion.swift
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


/// This extension simply adds `NSString`’s tilde path expansion methods to String so that they can be
/// used without casting.
extension String {
    /// A new string made by expanding the initial component of the receiver, if it begins with “~”
    /// or “~*user*”, to its full path value. Returns a new string matching the receiver if the
    /// receiver’s initial component can’t be expanded.
    ///
    /// - note:  This method only works with file paths (not, for example, string representations of URLs).
    var expandingTildeInPath: String {
        return (self as NSString).expandingTildeInPath
    }


    /// A new string based on the current string object. If the new string specifies a file in the current
    /// home directory, the home directory portion of the path is replaced with a tilde (~) character. If
    /// the string does not specify a file in the current home directory, this method returns a new string
    /// object whose path is unchanged from the path in the current string.
    ///
    /// - note: This method only works with file paths. It does not work for string representations of URLs.
    ///
    /// - note: For sandboxed apps in OS X, the current home directory is not the same as the user’s home
    ///     directory. For a sandboxed app, the home directory is the app’s home directory. So if you 
    ///     specified a path of `/Users/<current_user>/file.txt` for a sandboxed app, the returned path
    ///     would be unchanged from the original. However, if you specified the same path for an app not
    ///     in a sandbox, this method would replace the `/Users/<current_user>` portion of the path with
    ///     a tilde.
    var abbreviatingWithTildeInPath: String {
        return (self as NSString).abbreviatingWithTildeInPath
    }
}
