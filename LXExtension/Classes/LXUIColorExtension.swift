//
/**
*
*File name:		LXUIColorExtension.swift
*History:		yoctech create on 2021/7/30       
*Description:
	
*/


import Foundation


extension UIColor {
    convenience init(r:UInt32 ,g:UInt32 , b:UInt32 , a:CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: a)
    }
    
    class var random: UIColor {
        return UIColor(r: arc4random_uniform(256),
                       g: arc4random_uniform(256),
                       b: arc4random_uniform(256))
    }
        
    // MARK: 16进制颜色
    
    /// 16进制转颜色
    /// - Parameters:
    ///   - hex: 16进制色值, 0xFFFFFF
    ///   - alpha: 透明度
    /// - Returns: 颜色
    class func hex(_ hex: Int, alpha: CGFloat = 1.0) -> UIColor {
        UIColor(red: CGFloat((((hex & 0xFF0000) >> 16 ))) / 255.0,
                  green: CGFloat((((hex & 0xFF00 ) >> 8 ))) / 255.0,
                  blue: CGFloat(((hex & 0xFF ))) / 255.0,
                  alpha: alpha)
    }
    
    /// 16进制字符串转颜色
    /// - Parameters:
    ///   - hexString: 16进制色值字符串, "FFFFFF"
    ///   - alpha: 透明度
    /// - Returns: 颜色
    class func hex(_ hexString: String, alpha: CGFloat = 1.0) -> UIColor {
        // 存储转换后的数值
        var red: UInt64 = 0, green: UInt64 = 0, blue: UInt64 = 0
        var hex = hexString
        // 如果传入的十六进制颜色有前缀，去掉前缀
        if hex.hasPrefix("0x") || hex.hasPrefix("0X") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
        } else if hex.hasPrefix("#") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
        }
        // 如果传入的字符数量不足6位按照后边都为0处理，当然你也可以进行其它操作
        if hex.count < 6 {
            for _ in 0..<6-hex.count {
                hex += "0"
            }
        }
        
        // 分别进行转换
        // 红
        Scanner(string: String(hex[..<hex.index(hex.startIndex, offsetBy: 2)])).scanHexInt64(&red)
        // 绿
        Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)])).scanHexInt64(&green)
        // 蓝
        Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 4)...])).scanHexInt64(&blue)
        
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    
    /// 动态颜色,根据浅色和深色模式取值
    /// - Parameters:
    ///   - light: 浅色模式颜色
    ///   - dark: 深色模式颜色
    /// - Returns: 最终的颜色
    class func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
        } else {
            return light
        }
    }
    
    /// 颜色转成图片
    func lx_toImage() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }


}
