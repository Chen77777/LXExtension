//
/**
*
*File name:		LXArrayExtension.swift
*History:		yoctech create on 2021/7/30       
*Description:
	
*/


import Foundation

extension Array{
    
    /// 数组转json字符串
    func lx_toJson() -> String {
        if (!JSONSerialization.isValidJSONObject(self)) {
            return ""
        }
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return ""
        }
        guard let str = String.init(data: data, encoding: String.Encoding.utf8) else {
            return ""
        }
        return str.replacingOccurrences(of: "\\/", with: "/")
    }
    
    /// 从json文件里面读取数组
    /// - Parameter fileName: json文件名,不包含.json后缀
    /// - Returns: 结果数组,如果读取失败则返回空数组
    static func lx_fromJsonFile(_ fileName :String) -> Array {
        var path: String
        if fileName.contains("/") {
            path = fileName
        }else{
            path = Bundle.main.path(forResource: fileName, ofType: "json") ?? ""
        }
        if path.isEmpty {
            return []
        }
        let filePath = URL(fileURLWithPath: path)
        do {
            let data = try Data.init(contentsOf: filePath)
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            let jsonArr = jsonData as! Array
            return jsonArr
        } catch _ {
            return []
        }
    }
    
    /// 安全下标获取,即使下标超出也不会闪退而是返回nil
    subscript (safe index: Int) -> Element? {
        return (0..<count).contains(index) ? self[index] : nil
    }
    
}

public extension Array where Element: Equatable {
   
   /// 去除数组重复元素
   /// - Returns: 去除数组重复元素后的数组
   func lx_removeDuplicate() -> Array {
      return self.enumerated().filter { (index,value) -> Bool in
           return self.firstIndex(of: value) == index
       }.map { (_, value) in
           value
       }
   }
}
