
import Foundation

//extension UITableView: LXNameSpaceWrappable {}

extension LXNameSpaceWrapper where Base: UITableView {
    
    func registerCellClass(_ aClass: UITableViewCell.Type) {
        let name = String(describing: aClass)
        base.register(aClass, forCellReuseIdentifier: name)
    }
    func registerCellNib(_ aClass: UITableViewCell.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        base.register(nib, forCellReuseIdentifier: name)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ aClass: T.Type) -> T! {
        let name = String(describing: aClass)
        guard let cell = base.dequeueReusableCell(withIdentifier: name) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }
    func dequeueReusableCell<T: UITableViewCell>(_ aClass: T.Type, indexPath: IndexPath) -> T! {
        let name = String(describing: aClass)
        guard let cell = base.dequeueReusableCell(withIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }
    
    
    func registerHeaderFooterNib<T: UIView>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        base.register(nib, forHeaderFooterViewReuseIdentifier: name)
    }
    
    func registerHeaderFooterClass<T: UIView>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        base.register(aClass, forHeaderFooterViewReuseIdentifier: name)
    }
    
    func dequeueReusableHeaderFooter<T: UIView>(_ aClass: T.Type) -> T! {
        let name = String(describing: aClass)
        guard let cell = base.dequeueReusableHeaderFooterView(withIdentifier: name) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }
    
}
