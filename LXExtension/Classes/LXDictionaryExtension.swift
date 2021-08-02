//
/**
*
*File name:		LXDictionaryExtension.swift
*History:		yoctech create on 2021/7/30       
*Description:
	
*/


import Foundation



extension Dictionary{
    /// 从json文件里面读取字典
    /// - Parameter fileName: json文件名,不包含.json后缀
    /// - Returns: 结果字典,如果读取失败则返回空字典
    static func lx_fromJsonFile(_ fileName :String) -> Dictionary {
        var path: String
        if fileName.contains("/") {
            path = fileName
        }else{
            path = Bundle.main.path(forResource: fileName, ofType: "json") ?? ""
        }
        if path.isEmpty {
            return [:]
        }
        let filePath = URL(fileURLWithPath: path)
        do {
            let data = try Data.init(contentsOf: filePath)
            let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            let jsonDic = jsonData as! Dictionary
            return jsonDic
        } catch _ {
            return [:]
        }
    }
    
    /// 字典转json字符串
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
    
}
