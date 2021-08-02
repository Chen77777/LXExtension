//
/**
*
*File name:		LXExtension_NSAttributedString.swift
*History:		yoctech create on 2021/4/26       
*Description:
	
*/


import Foundation
import UIKit


extension NSAttributedString {
    
    /// 为NSAttributedString设置段落属性
    /// - Parameters:
    ///   - space: 行间距
    ///   - alignment: 对齐方式
    ///   - paragraphSpacingBefore: 段前间距
    ///   - paragraphSpacing: 段后间距
    /// - Returns: NSMutableAttributedString
    func lx_lineSpace(_ space: Float,
                   alignment: NSTextAlignment = .left,
                   paragraphSpacingBefore:Float = 0,
                   paragraphSpacing:Float = 0) -> NSMutableAttributedString{
        let mattr = NSMutableAttributedString.init(attributedString: self)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = CGFloat(space)
        style.paragraphSpacingBefore = CGFloat(paragraphSpacingBefore)
        style.paragraphSpacing = CGFloat(paragraphSpacing)
        style.alignment = alignment
        let attributes = [NSAttributedString.Key.paragraphStyle : style]
        mattr.addAttributes(attributes, range: NSRange.init(location: 0, length: self.length))
        return mattr
    }
    
    /// 拼接两个attributedString
    /// - Parameter attributedString: 另一个attributedString
    /// - Returns: NSMutableAttributedString
    func lx_append(_ attributedString: NSAttributedString) -> NSMutableAttributedString{
        let mattr = NSMutableAttributedString.init(attributedString: self)
        mattr.append(attributedString)
        return mattr
    }
    
    
    /// 根据固定宽度计算字符串所需高度
    /// - Parameters:
    ///   - width: 固定宽度
    /// - Returns: 所需高度
    func lx_needHeight(width: CGFloat) -> CGFloat {
        let size = self.boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size
        return size.height
    }
    
    /// 根据固定高度计算字符串所需宽度
    /// - Parameters:
    ///   - width: 固定高度
    /// - Returns: 所需宽度
    func lx_needWidth(height: CGFloat) -> CGFloat {
        let size = self.boundingRect(with: CGSize.init(width: CGFloat(MAXFLOAT), height: height), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size
        return size.width
    }

}
