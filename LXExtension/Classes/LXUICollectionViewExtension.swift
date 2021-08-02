//
/**
*
*File name:		LXExtension_UICollectionView.swift
*History:		yoctech create on 2021/4/26       
*Description:
	
*/


import Foundation
import UIKit
//extension UICollectionView: LXNameSpaceWrappable {}

extension LXNameSpaceWrapper where Base: UICollectionView {
    func registerCellClass(_ aClass: UICollectionViewCell.Type) {
        let name = String(describing: aClass)
        base.register(aClass, forCellWithReuseIdentifier: name)
    }
    func registerCellNib(_ aClass: UICollectionViewCell.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        base.register(nib, forCellWithReuseIdentifier: name)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ aClass: T.Type, indexPath: IndexPath) -> T! {
        let name = String(describing: aClass)
        guard let cell = base.dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }
    
    
    func registerHeaderNib<T: UICollectionReusableView>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        base.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: name)
    }
    
    func registerHeaderClass<T: UICollectionReusableView>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        base.register(aClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: name)
    }
    
    func registerFooterNib<T: UICollectionReusableView>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        base.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: name)
    }
    
    func registerFooterClass<T: UICollectionReusableView>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        base.register(aClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: name)
    }

    func dequeueReusableHeader<T: UIView>(_ aClass: T.Type, indexPath: IndexPath) -> T! {
        let name = String(describing: aClass)
        guard let cell = base.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }
    
    func dequeueReusableFooter<T: UIView>(_ aClass: T.Type, indexPath: IndexPath) -> T! {
        let name = String(describing: aClass)
        guard let cell = base.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }

}
