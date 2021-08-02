//
/**
*
*File name:		LXUIApplicationExtension.swift
*History:		yoctech create on 2021/7/30       
*Description:
	
*/


import Foundation

extension UIApplication {
    var rootViewController: UIViewController? {
        if #available(iOS 13.0, *) {
            let keyWindow = connectedScenes
                //                .filter({ $0.activationState == .foregroundActive })
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows
                .first(where: { $0.isKeyWindow })
            return keyWindow?.rootViewController
        } else {
            return keyWindow?.rootViewController
        }
    }
    
    var topViewController: UIViewController? {
        var resultVC: UIViewController? = rootViewController
        while (resultVC?.presentedViewController != nil) || resultVC is UINavigationController || resultVC is UITabBarController {
            if resultVC?.presentedViewController != nil {
                resultVC = resultVC?.presentedViewController
            } else if resultVC is UINavigationController {
                resultVC = (resultVC as? UINavigationController)?.topViewController
            } else if resultVC is UITabBarController {
                resultVC = (resultVC as? UITabBarController)?.selectedViewController
            }
        }
        return resultVC
    }
}

