//
//  HTTPHandler.swift
//  SimpleSwiftApp
//
//  Created by Chau, Cuong | DCMS on 2020/11/02.
//  Copyright © 2020 Chau, Cuong | DCMS. All rights reserved.
//

import Foundation

class HTTPHandler {
    static func getJson(urlStrParam: String, completionHandler: @escaping(Data?) -> (Void)) {
        let urlStr = urlStrParam.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlStr!)
        
        print("URL \(url!)")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: { (data, response, error) -> (Void) in
            if let data = data {
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                print("status code: \(statusCode)")
                
                if(statusCode == 200) {
                    completionHandler(data as Data)
                }
            } else if let error = error {
                print("error in http: \(error.localizedDescription)")
                completionHandler(nil)
            }
            print("nice")
        })
        
        task.resume()
    }
}
