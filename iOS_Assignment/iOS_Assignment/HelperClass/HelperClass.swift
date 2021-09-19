//
//  HelperClass.swift
//  iOS_Assignment
//
//  Created by leo on 20/9/21.
//

import Foundation

let API = "https://api.500px.com/v1/photos?feature=popular&"

func getImageFromRestAPI(pageNo:String, completionClosure: @escaping (APIElementList)-> ()){
    let config = URLSessionConfiguration.default;
    let session = URLSession(configuration: config)
    let currentAPI = API + pageNo
    let url = NSURL(string: currentAPI)
    let task = session.dataTask(with: url! as URL, completionHandler: {data, response, error in
        
        if let err = error {
            print("Error: \(err)")
            return
        }
        
        let user = try?JSONDecoder().decode(APIElementList.self, from: data!)
        completionClosure(user!)
    })
    task.resume()
}

func numberFormat(from value: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter.string(from: value as NSNumber) ?? ""
}
