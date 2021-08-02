//
/**
*
*File name:		LXUIImageExtension.swift
*History:		yoctech create on 2021/7/30       
*Description:
	
*/


import Foundation
extension UIImage {
    public enum LXAlignment : Int {

        case center = 0

        case top = 1

        case topLeading = 2

        case leading = 3

        case bottomLeading = 4

        case bottom = 5

        case bottomTrailing = 6

        case trailing = 7

        case topTrailing = 8
    }
    
    /// 根据颜色生成图片
    /// - Parameter color: 颜色
    /// - Returns: 图片
    class func lx_with(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 使用ImageIO生成图片
    /// - Parameters:
    ///   - data: 图片数据
    ///   - maxPixelSize: 图片最大宽/高尺寸 ，设置后图片会根据最大宽/高 来等比例缩放图片
    /// - Returns: 最终图片,可能为空
    class func lx_with(data: Data, maxPixelSize: CGFloat) -> UIImage? {
        guard let provider = CGDataProvider.init(data: data as CFData) else { return nil }
        guard let source = CGImageSourceCreateWithDataProvider(provider, nil) else { return nil }
        let dic = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelSize,
            kCGImageSourceCreateThumbnailWithTransform: true
        ] as CFDictionary
        guard let imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, dic) else { return nil }
        let image = UIImage.init(cgImage: imageRef)
        return image
    }
    
    
    /// 修改图片尺寸
    /// - Parameter size: 目标尺寸
    /// - Returns: 最终图片
    func lx_resize(size: CGSize) -> UIImage {
        guard let cgImg = self.cgImage else { return self }
        let contentWidth = Int(size.width)
        let contentHeight = Int(size.height)
        let rect = CGRect.init(origin: .zero, size: size)
        let alphaInfo = cgImg.alphaInfo
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext.init(data: nil, width: contentWidth, height: contentHeight, bitsPerComponent: 8, bytesPerRow: 4 * contentWidth, space: colorSpace, bitmapInfo: alphaInfo.rawValue) else { return self }
        context.draw(cgImg, in: rect)
        guard let imageRef = context.makeImage() else { return self }
        let img = UIImage.init(cgImage: imageRef)
        context.clear(rect);
        return img
    }
    
    /// 裁剪图片
    /// - Parameter rect: 目标区域
    /// - Returns: 最终图片
    func lx_clip(in rect: CGRect) -> UIImage {
        guard let cgImg = self.cgImage?.cropping(to: rect) else { return self }
        return UIImage.init(cgImage: cgImg)
    }
    
    /// 裁剪图片
    /// - Parameters:
    ///   - size: 目标尺寸,如果尺寸宽或高超过图片宽高,那么会等比缩小
    ///   - alignment: 区域位置,可以调整裁剪区域的位置
    /// - Returns: 最终图片
    func lx_clip(in size: CGSize, alignment:LXAlignment) -> UIImage {
        
        let widthLessThanHeight = self.size.width * size.height <= self.size.height * size.width
        let width = widthLessThanHeight ? self.size.width : self.size.height * size.width / size.height
        let height = widthLessThanHeight ? self.size.width * size.height / size.width : size.height
        
        var rect = CGRect.init(x: (self.size.width - width)/2, y: (self.size.height - height)/2, width: width, height: height)
        switch alignment {
        case .center:
            break
        case .top:
            rect = CGRect.init(x: (self.size.width - width)/2, y: 0, width: width, height: height)
        case .topLeading:
            rect = CGRect.init(x: 0, y: 0, width: width, height: height)
        case .leading:
            rect = CGRect.init(x: 0, y: (self.size.height - height)/2, width: width, height: height)
        case .bottomLeading:
            rect = CGRect.init(x: 0, y: self.size.height - height, width: width, height: height)
        case .bottom:
            rect = CGRect.init(x: (self.size.width - width)/2, y: self.size.height - height, width: width, height: height)
        case .bottomTrailing:
            rect = CGRect.init(x: self.size.width - width, y: self.size.height - height, width: width, height: height)
        case .trailing:
            rect = CGRect.init(x: self.size.width - width, y: (self.size.height - height)/2, width: width, height: height)
        case .topTrailing:
            rect = CGRect.init(x: (self.size.width - width)/2, y: 0, width: width, height: height)
        }
        return self.lx_clip(in: rect)
    }
    
    
    /// 修正图片的方向,如果图片不是up,就重新绘制
    func lx_fixOrientation() -> UIImage {
        var transform = CGAffineTransform.identity
        switch self.imageOrientation {
        case .up:
            return self
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
        default:
            break
        }
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: 1, y: -1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: 1, y: -1)
        default:
            break
        }

        guard let ctx = CGContext.init(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace ?? CGColorSpaceCreateDeviceRGB(), bitmapInfo: self.cgImage!.bitmapInfo.rawValue) else { return self }
        ctx.concatenate(transform)
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect.init(x: 0, y: 0, width: self.size.height, height: self.size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height))
        }
        guard let cgImg = ctx.makeImage() else { return self }
        
        return UIImage.init(cgImage: cgImg)
    }
    
    
    /// 图片高斯模糊
    /// - Parameter value: 高斯模糊的半径
    /// - Returns: 模糊后的图片
    func lx_blurImage(value: CGFloat) -> UIImage {
        
        guard let inputImg = self.ciImage,
              let filter = CIFilter.init(name: "CIGaussianBlur")
        else {
            return self
        }
        filter.setValue(inputImg, forKey: kCIInputImageKey)
        filter.setValue(value, forKey: kCIInputRadiusKey)
        
        let rect =  CGRect (origin:  CGPoint .zero, size: self.size)
        let context = CIContext(options: nil)
        guard let outputImg = filter.outputImage,
              let cgImage = context.createCGImage(outputImg, from: rect)
        else {
            return self
        }
        
        return UIImage.init(cgImage: cgImage)

    }
    
    
    /// 压缩图片;先在不改变图片宽高的情况下进行6次二分压缩,如果依然超过目标bytes,则进行宽高等比压缩,压缩到目标bytes为止
    /// - Parameter kbytes: 目标的byte值,单位KB,精确范围为-0.1
    /// - Returns: 压缩后的图片二进制数据
    /// - Note: ⚠️如果放在主线程压缩图片,可能会阻塞线程,需要放在其它线程
    func lx_compressed(kbytes: CGFloat) -> Data {
        var compression: CGFloat = 1
        var imgData = UIImageJPEGRepresentation(self, compression)!
        //iOS单位转换是1KB = 1000B
        let aimBytes = kbytes * 1000
        
        if CGFloat(imgData.count) < aimBytes {
            return imgData
        }
        var maxValue: CGFloat = 1
        var minValue: CGFloat = 0
        compression = pow(2, -6)
        imgData = UIImageJPEGRepresentation(self, compression)!
        //6次二分法压缩图片
        if CGFloat(imgData.count) < aimBytes {
            for _ in 0...6 {
                compression = (maxValue + minValue) / 2
                imgData = UIImageJPEGRepresentation(self, compression)!
                if CGFloat(imgData.count) < aimBytes * 0.9 {
                    maxValue = compression
                } else if CGFloat(imgData.count) > aimBytes {
                    minValue = compression
                } else {
                    break
                }
            }
        }
        guard var img = UIImage.init(data: imgData) else { return imgData }
        while CGFloat(imgData.count) > aimBytes {
            let ratio = aimBytes / CGFloat(imgData.count)
            let size = CGSize.init(width: Int(Float(img.size.width) * sqrtf(Float(ratio))), height: Int(Float(img.size.height) * sqrtf(Float(ratio))))
            if let aimg = UIImage.lx_with(data: imgData, maxPixelSize: max(size.width, size.height)) {
                img = aimg
                imgData = UIImageJPEGRepresentation(aimg, compression)!
            }else {
                break
            }
        }
        return imgData
    }
    
    
}
