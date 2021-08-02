//
/**
*
*File name:		LXExtension_UIView.swift
*History:		yoctech create on 2021/7/30       
*Description:
	
*/


import Foundation
import UIKit

extension UIView: LXNameSpaceWrappable {}

extension LXNameSpaceWrapper where Base: UIView {
    enum LXGradientDirection {
        case leftToRight,topToBottom
        case leftTopToRithtBottom,leftBottomToRithtTop
    }
    
    ///设置背景渐变色
    func backgroundGradient(colors:[UIColor], direction:LXGradientDirection, locations:[Float] = []) {
        
        let newGradient = CAGradientLayer.init()
        newGradient.frame = base.bounds
        let gradient = base.layer as? CAGradientLayer ?? newGradient
        let cgColors: [CGColor] = colors.map { (color) -> CGColor in
            return color.cgColor
        }
        let locationNumbers: [NSNumber] = locations.map { (value) -> NSNumber in
            return NSNumber.init(value: value)
        }
        //设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
        switch direction {
        case .topToBottom:
            gradient.startPoint = CGPoint.init(x: 0, y: 0)
            gradient.endPoint = CGPoint.init(x: 0, y: 1)
        case .leftToRight:
            gradient.startPoint = CGPoint.init(x: 0, y: 0)
            gradient.endPoint = CGPoint.init(x: 1, y: 0)
        case .leftTopToRithtBottom:
            gradient.startPoint = CGPoint.init(x: 0, y: 0)
            gradient.endPoint = CGPoint.init(x: 1, y: 1)
        case .leftBottomToRithtTop:
            gradient.startPoint = CGPoint.init(x: 0, y: 1)
            gradient.endPoint = CGPoint.init(x: 1, y: 0)

        }
        gradient.colors = cgColors;
        if !locationNumbers.isEmpty {
            gradient.locations = locationNumbers
        }
    }

    
    /// 添加阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - offset: 阴影偏移角度,以元组形式传入,默认(0, 2)
    ///   - radius: 阴影圆角,默认10
    ///   - opacity: 阴影不透明度.默认0.05
    ///   - masksToBounds: masksToBounds属性,默认false
    func addShadow(_ color:UIColor = .black,
                     offset:(CGFloat,CGFloat) = (0,2),
                     radius:CGFloat = 10,
                     opacity: CGFloat = 0.05,
                     masksToBounds: Bool = false) {
        base.layer.shadowColor = color.cgColor
        base.layer.shadowOffset = CGSize.init(width: offset.0, height: offset.1);
        base.layer.shadowRadius = radius;
        base.layer.shadowOpacity = Float(opacity);
        base.layer.masksToBounds = masksToBounds;
    }
    
    /// 设置圆角
    /// - Parameter value: 圆角半径
    func cornerRadius(_ value :CGFloat) {
        base.layer.cornerRadius = value
    }
    
    /// 设置部分圆角
    /// - Parameters:
    ///   - value: 圆角半径
    ///   - corners: 圆角位置,可以传入多个位置
    func partCornerRadius(_ value :CGFloat, corners:UIRectCorner) {
        if #available(iOS 11.0, *) {
            base.layer.cornerRadius = value
            if !corners.contains(.allCorners) {
                base.layer.maskedCorners = CACornerMask.init(rawValue: corners.rawValue)
            }
        }else{
            base.layoutIfNeeded()
            let maskPath = UIBezierPath(roundedRect: base.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: value, height: value))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = base.bounds
            maskLayer.path = maskPath.cgPath
            base.layer.mask = maskLayer
        }
    }
    
    /// 设置描边
    /// - Parameters:
    ///   - width: 描边宽度
    ///   - color: 描边颜色
    func border(_ width:CGFloat, _ color: UIColor) {
        base.layer.borderColor = color.cgColor
        base.layer.borderWidth = width
    }
    
    /// 批量添加子View
    /// - Parameter views: 子view数组
    func addSubviews(_ views : UIView? ...) {
        for view in views {
            if view != nil {
                base.addSubview(view!)
            }
        }
    }
    
    /// 移除所有的子view
    func removeAllSubviews() {
        let views = base.subviews
        for view in views {
            view.removeFromSuperview()
        }
    }
    //截屏
    func snapView() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, false, UIScreen.main.scale)
       // iOS7.0 之后系统提供的截屏的功能
        base.drawHierarchy(in: base.bounds, afterScreenUpdates: true)

       let snapdImage = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
       return snapdImage!
    }
    
    
    /// 根据响应链获取最近的UIViewController
    /// - Returns: 最近的VC,如果获取不到就返回nil
    func currentVC() -> UIViewController? {
        var nextResponder: UIResponder? = base
        repeat {
            nextResponder = nextResponder?.next

            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        } while nextResponder != nil

        return nil
    }

}

extension UIView {
    /// 修改layer的类型
    open class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    //MARK:- frame相关属性
    
    var lx_x: CGFloat {
        get {
            return self.frame.minX
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    var lx_y: CGFloat {
        get {
            return self.frame.minY
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var lx_width: CGFloat {
        get {
            return self.frame.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }

    var lx_height: CGFloat {
        get {
            return self.frame.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    var lx_center: CGPoint {
        get {
            return CGPoint(x: self.frame.midX, y: self.frame.midY)
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue.x - frame.width / 2
            frame.origin.y = newValue.y - frame.height / 2
            self.frame = frame
        }
    }

}
