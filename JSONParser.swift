//
//  JSONParser.swift
//  SimpleSwiftApp
//
//  Created by Chau, Cuong | DCMS on 2020/11/02.
//  Copyright © 2020 Chau, Cuong | DCMS. All rights reserved.
//

import Foundation

class JSONParser {
    static func parse(data: Data) -> [String: AnyObject]? {
        let options = JSONSerialization.ReadingOptions()
        do{
            let json = try JSONSerialization.jsonObject(with: (data), options: options) as? [String: AnyObject]
            
            return json!
        } catch(let parseError) {
            print("Parse Error: \(parseError.localizedDescription)")
        }
        
        return nil
    }
}
