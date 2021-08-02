//
/**
 *
 *File name:		LXNameSpace.swift
 *History:		yoctech create on 2021/4/26
 *Description:
 
 */


import Foundation

public struct LXNameSpaceWrapper<Base: Any> {
    
    let base: Base
    
    init(_ base: Base) {
        self.base = base
    }
    
}

public protocol LXNameSpaceWrappable: Any {
    associatedtype T
    var lx: T { get }
    static var lx: T.Type { get }
}

public extension LXNameSpaceWrappable {
    var lx: LXNameSpaceWrapper<Self> {
        get { return LXNameSpaceWrapper<Self>(self) }
    }
    
    static var lx: LXNameSpaceWrapper<Self>.Type {
        get { return LXNameSpaceWrapper<Self>.self }
    }
}

