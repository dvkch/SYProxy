//
//  Proxy.swift
//  Proxy
//
//  Created by Stanislas Chevallier on 03/06/15.
//  Copyright (c) 2015 Syan. All rights reserved.
//

import Foundation

@objc(SYProxyModel)
public class Proxy: NSObject, NSCoding, NSSecureCoding {
    
    // MARK: Init
    public init(host: String, port: UInt16) {
        self.identifier = UUID().uuidString
        self.host = host
        self.port = port
        self.urlWildcardRules = []
    }
    
    // MARK: NSCoding
    public required init(coder: NSCoder) {
        self.identifier       = coder.decodeObject(of: NSString.self, forKey: "identifier") as! String
        self.host             = coder.decodeObject(of: NSString.self, forKey: "host") as! String
        self.port             = coder.decodeObject(of: NSNumber.self, forKey: "port")?.uint16Value ?? 0
        self.username         = coder.decodeObject(of: NSString.self, forKey: "username") as String?
        self.password         = coder.decodeObject(of: NSString.self, forKey: "password") as String?
        if #available(macOS 11.0, iOS 14.0, tvOS 14.0, *) {
            self.urlWildcardRules = (coder.decodeArrayOfObjects(ofClass: NSString.self, forKey: "urlWildcardRules") as [String]?) ?? []
        } else {
            self.urlWildcardRules = (coder.decodeObject(of: NSArray.self, forKey: "urlWildcardRules") as? [String]) ?? []
        }
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(self.identifier,       forKey: "identifier")
        coder.encode(self.host,             forKey: "host")
        coder.encode(self.port,             forKey: "port")
        coder.encode(self.username,         forKey: "username")
        coder.encode(self.password,         forKey: "password")
        coder.encode(self.urlWildcardRules, forKey: "urlWildcardRules")
    }
    
    public func copy() -> Self {
        let data = try! NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
        let copy = try! NSKeyedUnarchiver.unarchivedObject(ofClass: Self.self, from: data)!
        copy.identifier = UUID().uuidString
        return copy
    }

    public static var supportsSecureCoding: Bool {
        return true
    }
    
    // MARK: Properties
    public private(set) var identifier: String
    public var host: String
    public var port: UInt16
    public var username: String?
    public var password: String?
    public var urlWildcardRules: [String]
    
    // MARK: Method
    public func isValid(for url: URL) -> Bool {
        let predicates = urlWildcardRules.map { NSPredicate(format: "self LIKE %@", $0) }
        return predicates.contains(where: { $0.evaluate(with: url.absoluteString) })
    }
    
    // MARK: Equality
    public override func isEqual(_ object: Any?) -> Bool {
        return (object as? Proxy)?.identifier == identifier
    }
    
    public override var hash: Int {
        return identifier.hash
    }
}

public extension Array where Element: Proxy {
    public func first(matching url: URL) -> Element? {
        return self.first(where: { $0.isValid(for: url) })
    }
}
