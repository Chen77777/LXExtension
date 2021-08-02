//
/**
*
*File name:		LXUIFontExtension.swift
*History:		yoctech create on 2021/8/2       
*Description:
	
*/


import Foundation


extension UIFont {
    static func font(_ size:Float) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(size), weight: .regular)
    }
    static func fontSemibold(_ size:Float) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(size), weight: .semibold)
    }
    static func fontBold(_ size:Float) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(size), weight: .bold)
    }
    static func fontMedium(_ size:Float) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(size), weight: .medium)
    }

    //MARK:- 等宽字体
    
    static func fontNum(_ size:Float) -> UIFont {
        return UIFont.monospacedDigitSystemFont(ofSize: CGFloat(size), weight: .regular)
    }
    static func fontNumBold(_ size:Float) -> UIFont {
        return UIFont.monospacedDigitSystemFont(ofSize: CGFloat(size), weight: .bold)
    }
    static func fontNumMedium(_ size:Float) -> UIFont {
        return UIFont.monospacedDigitSystemFont(ofSize: CGFloat(size), weight: .medium)
    }
    static func fontNumSemibold(_ size:Float) -> UIFont {
        return UIFont.monospacedDigitSystemFont(ofSize: CGFloat(size), weight: .semibold)
    }

    
}
