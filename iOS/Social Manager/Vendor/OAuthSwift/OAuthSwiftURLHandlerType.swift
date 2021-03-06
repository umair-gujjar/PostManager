//
//  OAuthSwiftURLHandlerType.swift
//  OAuthSwift
//
//  Created by phimage on 11/05/15.
//  Copyright (c) 2015 Dongri Jin. All rights reserved.
//

import Foundation

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

@objc public protocol OAuthSwiftURLHandlerType {
    func handle(url: NSURL)
}

public class OAuthSwiftOpenURLExternally: OAuthSwiftURLHandlerType {
    class var sharedInstance : OAuthSwiftOpenURLExternally {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : OAuthSwiftOpenURLExternally? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = OAuthSwiftOpenURLExternally()
        }
        return Static.instance!
    }
    
    @objc public func handle(url: NSURL) {
        #if os(iOS)
            #if !OAUTH_APP_EXTENSIONS
                UIApplication.sharedApplication().openURL(url)
            #endif
        #elseif os(OSX)
            NSWorkspace.sharedWorkspace().openURL(url)
        #endif
    }
}

// Open url using NSExtensionContext
public class ExtensionContextURLHandler: OAuthSwiftURLHandlerType {
    
    private var extensionContext: NSExtensionContext
    
    public init(extensionContext: NSExtensionContext) {
        self.extensionContext = extensionContext
    }
    
    @objc public func handle(url: NSURL) {
        extensionContext.openURL(url, completionHandler: nil)
    }
}