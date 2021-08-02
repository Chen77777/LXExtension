//
/**
*
*File name:		LXUIViewControllerExtension.swift
*History:		yoctech create on 2021/8/2       
*Description:
	
*/


import Foundation


extension UIViewController{
    
    /// 返回到指定class类型的VC
    /// - Parameters:
    ///   - vctype: vc的class类型,如果不是push出来的页面,就自动使用dismiss
    ///   - animated: 是否使用消失动画
    func lx_pop(vctype: AnyClass = UIViewController.self,animated: Bool = true) {
        if self is UINavigationController {
            let nav = self as! UINavigationController
            if vctype == UIViewController.self  {
                nav.popViewController(animated: animated)
            }else{
                let arr = nav.viewControllers
                var huntVc: UIViewController?
                for vc in arr.reversed() {
                    if vc.isMember(of: vctype) {
                        huntVc = vc
                        break
                    }
                }
                if huntVc != nil {
                    nav.popToViewController(huntVc!, animated: animated)
                }else{
                    nav.popViewController(animated: animated)
                }
            }
        }
        else if (self.navigationController != nil) {
            let nav = self.navigationController!
            if vctype == UIViewController.self  {
                nav.popViewController(animated: animated)
            }else{
                let arr = nav.viewControllers
                var huntVc: UIViewController?
                for vc in arr.reversed() {
                    if vc.isMember(of: vctype) {
                        huntVc = vc
                        break
                    }
                }
                if huntVc != nil {
                    nav.popToViewController(huntVc!, animated: animated)
                }else{
                    nav.popViewController(animated: animated)
                }
            }
        }
        else{
            self.dismiss(animated: animated, completion: nil)
        }
    }
    
    /// 返回到根页面, 如果不是push出来的页面,就直接disMiss
    /// - Parameter animated: 是否使用动画效果
    func lx_popRoot(animated: Bool = true) {
        if self is UINavigationController {
            let nav = self as! UINavigationController
            nav.popToRootViewController(animated: animated)
        }
        else if (self.navigationController != nil) {
            self.navigationController?.popToRootViewController(animated: animated)
        }
        else{
            self.dismiss(animated: animated, completion: nil)
        }
    }
    
    
    /// 根据传入内容自动跳转下一个页面,自动选择push方式或者present方式
    /// - Parameters:
    ///   - obj: 传入内容,支持VC对象, VC类, VC类字符串。VC类,和VC类字符串不支持xib和storyBoard方式创建,只支持纯代码
    ///   - animated: 是否使用动态效果
    /// - Returns: 结果,如果成功创建并跳转,则返回true.
    @discardableResult
    func lx_push(obj:Any,animated:Bool = true) -> Bool {
        if obj is String {
            //动态获取命名空间(CFBundleExecutable这个键对应的值就是项目名称,也就是命名空间)
            let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
            //将字符串转化为类
            //默认情况下,命名空间就是项目名称,但是命名空间是可以修改的
            let cls:AnyClass? = NSClassFromString(nameSpace + "." + (obj as! String))
            //通过类创建对象
            //将anyClass转换为指定的类型
            guard let viewControllerCls = cls as? UIViewController.Type else {
                return false
            }
            //通过class创建对象
            let vc = viewControllerCls.init()
            return self.lx_pushViewController(vc: vc, animated: animated)
        }
        else if obj is UIViewController.Type {
            let viewControllerCls = obj as! UIViewController.Type
            let vc = viewControllerCls.init()
            return self.lx_pushViewController(vc: vc, animated: animated)
        }

        else if obj is UIViewController {
            return self.lx_pushViewController(vc: (obj as! UIViewController), animated: animated)
        }
        return false
    }
    
    /// 跳转到新的VC页面,自动选择push方式或者present方式
    /// - Parameters:
    ///   - vc: 新的vc对象
    ///   - animated: 是否使用动画
    /// - Returns: 跳转结果
    func lx_pushViewController(vc:UIViewController,animated:Bool = true) -> Bool {
        vc.hidesBottomBarWhenPushed = true
        if self is UINavigationController {
            let nav = self as! UINavigationController
            nav.pushViewController(vc, animated: animated)
        }
        else if self is UITabBarController {
            let tabbar = self as! UITabBarController
            if let selectVc = tabbar.selectedViewController {
                return selectVc.lx_push(obj: vc, animated: true)
            }else{
                self.present(vc, animated: animated, completion: nil)
            }
            
        }
        else if (self.navigationController != nil) {
            self.navigationController?.pushViewController(vc, animated: animated)
        }
        else{
            self.present(vc, animated: animated, completion: nil)
        }
        return true
    }
}
