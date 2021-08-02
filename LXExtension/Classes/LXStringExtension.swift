//
/**
*
*File name:		LXExtension_String.swift
*History:		yoctech create on 2021/7/30       
*Description:
	
*/


import Foundation
import UIKit
import CommonCrypto

extension String {
    
    // MARK: 字符串转换
    
    /// 字符串转日期
    /// - Parameter dateFormat: 日期格式
    /// - Returns: 目标日期
    func lx_date(_ dateFormat: String?) -> Date? {
        let formartter = DateFormatter.init()
        formartter.dateFormat = dateFormat ?? "yyyy-MM-dd"
        return formartter.date(from: self)
    }
    
    /// 字符串转json对象
    /// - Returns: Any对象,需要转换成Dictionary或者Array使用
    func lx_toJsonObject() -> Any? {
        let jsonData:Data = self.data(using: .utf8)!
        
        let obj = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        return obj
    }
    
    /// base64编码
    func lx_toBase64() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }

    /// base64解码
    func lx_fromBase64() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    /// MD5编码
    /// - Parameter isLowercase: 是否全部小写, 默认是
    /// - Returns: MD5字符串
    func lx_toMd5(_ isLowercase : Bool = true) -> String? {
        let utf8 = self.cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        if isLowercase {
            return digest.reduce("") { $0 + String(format:"%02x", $1) }
        }else{
            return digest.reduce("") { $0 + String(format:"%02X", $1) }
        }
    }

    
    /// 转换成二维码
    /// - Returns: 目标图片
    func toQRCode() -> UIImage? {
        let data = self.data(using: String.Encoding.ascii)
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 20, y: 20)
        guard let output = filter.outputImage?.transformed(by: transform) else { return nil }
        return UIImage(ciImage: output)
    }
    
    //MARK:- NSAttributedString相关方法
    
    /// 转换成NSAttributedString格式的HTML富文本
    /// - Returns: 结果NSAttributedString
    func lx_toHtmlAttributed() -> NSAttributedString{
        if self.isEmpty {
            return "".lx_toAttributed()
        }
        guard let data = self.data(using: String.Encoding.unicode) else { return "".lx_toAttributed() }
        if data.isEmpty {
            return "".lx_toAttributed()
        }
        do{
            let attr = try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
            return attr
        }catch _ {
            return self.lx_toAttributed()
        }
    }

    
    /// 转换成NSAttributedString
    /// - Parameters:
    ///   - color: 文字颜色
    ///   - font: 文字字体
    /// - Returns: 结果NSAttributedString
    func lx_toAttributed(color:UIColor? = nil, font: UIFont? = nil) -> NSAttributedString{
        let attr = NSMutableAttributedString.init(string: self)
        if let realColor = color {
            attr.addAttribute(NSAttributedString.Key.foregroundColor, value: realColor, range: NSRange(location: 0, length: self.count))
        }
        
        if let realFont = font {
            attr.addAttribute(NSAttributedString.Key.font, value: realFont, range: NSRange(location: 0, length: self.count))
        }
        
        return attr
    }
    
    /// 转换成NSAttributedString格式的图片附件
    /// - Parameter font: 需要的字体大小
    /// - Returns: 结果NSAttributedString
    func lx_toImageAttributed(_ font: UIFont) -> NSAttributedString{
        let image : UIImage? = UIImage(named: self)
        if image == nil {
            return NSAttributedString.init()
        }
        let attacment = NSTextAttachment()
        attacment.image = UIImage(named: self)
        
        attacment.bounds = CGRect(x: 2, y: CGFloat(font.descender) / 2, width: (font.pointSize * image!.size.width/image!.size.height), height: (font.pointSize))
        let attrImageStr = NSAttributedString(attachment: attacment)
        
        return attrImageStr
    }
    
    /// 给字符串设置行间距,需要转换成NSAttributedString
    /// - Parameter space: 行间距
    /// - Returns: 结果NSAttributedString
    func lx_lineSpace(_ space: Float) -> NSAttributedString{
        let style = NSMutableParagraphStyle()
        style.lineSpacing = CGFloat(space)
        let attributes = [NSAttributedString.Key.paragraphStyle : style]
        return NSAttributedString(string: self, attributes:attributes)
    }
    
    
    /// 根据固定宽度计算字符串所需高度
    /// - Parameters:
    ///   - width: 固定宽度
    ///   - font: 字体大小
    /// - Returns: 所需高度
    func lx_needHeight(width: CGFloat, font:UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font : font]
        let string = self as NSString?
        
        let size = string?.boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil).size
        return size?.height ?? 0
    }
    
    /// 根据固定高度计算字符串所需宽度
    /// - Parameters:
    ///   - width: 固定高度
    ///   - font: 字体大小
    /// - Returns: 所需宽度
    func lx_needWidth(height: CGFloat, font:UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font : font]
        let string = self as NSString?
        let size = string?.boundingRect(with: CGSize.init(width: CGFloat(MAXFLOAT), height: height), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil).size
        return size?.width ?? 0
    }

}

extension String {
    
    var length: Int {
        ///更改成其他的影响含有emoji协议的签名
        return self.count
    }
    
    /// 随机字母字符串生成,26字母,包含大小写
    /// - Parameter length: 字符串长度
    /// - Returns: 随机字符串
    static func lx_random(length:Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var ranStr = ""
        for _ in 0..<length {
            let index = Int(arc4random_uniform(UInt32(characters.count)))
            ranStr.append(characters[index])
        }
        return ranStr
    }
    
    /// 从json文件里面读取字符串
    /// - Parameter fileName: json文件名,不包含.json后缀
    /// - Returns: 结果字符串,如果读取失败则返回空字符串
    static func lx_fromJsonFile(_ fileName :String) -> String {
        var path: String
        if fileName.contains("/") {
            path = fileName
        }else{
            path = Bundle.main.path(forResource: fileName, ofType: "json") ?? ""
        }
        if path.isEmpty {
            return ""
        }
        let filePath = URL(fileURLWithPath: path)
        do {
            let data = try Data.init(contentsOf: filePath)
            let str = String.init(data: data, encoding: .utf8) ?? ""
            return str
        } catch _ {
            return ""
        }
    }

    /// 根据下标获取字符串某一个字符
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(self.count, r.lowerBound)), upper: min(self.count, max(0, r.upperBound))))
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    

}
