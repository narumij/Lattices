/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    These are the base protocol classes for dealing with elements in our document browser.
*/

/* LICENSE.txt
 Sample code project: ShapeEdit: Building a Simple iCloud Document App
 Version: 1.3

 IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.

 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.

 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.

 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 */

import Foundation

/// The base protocol for all collection view objects to display in our UI.
protocol ModelObject: class {
    var displayName: String { get }
    
    var subtitle: String { get }
    
    var URL: Foundation.URL { get }
}

/**
    Represents an animation as computed on the query's results set. Each animation 
    can add, remove, update or move a row.
*/
enum DocumentBrowserAnimation {
    case reload
    case delete(index: Int)
    case add(index: Int)
    case update(index: Int)
    case move(fromIndex: Int, toIndex: Int)
}

/**
    We need to implement the `Equatable` protocol on our animation objects so we
    can match them later.
*/
extension DocumentBrowserAnimation: Equatable { }

func ==(lhs: DocumentBrowserAnimation, rhs: DocumentBrowserAnimation) -> Bool {
    switch (lhs, rhs) {
        case (.reload, .reload):
            return true
            
        case let (.delete(left), .delete(right)) where left == right:
            return true
            
        case let (.add(left), .add(right)) where left == right:
            return true
            
        case let (.update(left), .update(right)) where left == right:
            return true
            
        case let (.move(leftFrom, leftTo), .move(rightFrom, rightTo)) where leftFrom == rightFrom && leftTo == rightTo:
            return true
            
        default:
            return false
    }
}

/*
    We implement the `CustomDebugStringConvertible` protocol for pretty printing 
    purposes while debugging.
*/
extension DocumentBrowserAnimation: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
            case .reload:
                return "Reload"
                
            case .delete(let i):
                return "Delete(\(i))"
                
            case .add(let i):
                return "Add(\(i))"
                
            case .update(let i):
                return "Update(\(i))"
                
            case .move(let f, let t):
                return "Move(\(f)->\(t))"
        }
    }
}
