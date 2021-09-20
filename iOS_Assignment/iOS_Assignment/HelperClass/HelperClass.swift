//
//  HelperClass.swift
//  iOS_Assignment
//
//  Created by leo on 20/9/21.
//

import Foundation

func getImageFromRestAPI(pageNo:Int, completionClosure: @escaping (APIElementList)-> ()){
    guard let urlName = URL(string: "https://api.500px.com/v1/photos?feature=popular&page=\(pageNo)") else {
        return
    }
    let urlRequest = URLRequest(url: urlName as URL)

    let task = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
         
        if let err = error {
            print("Error: \(err)")
            return
        }
        let user = try?JSONDecoder().decode(APIElementList.self, from: data!)
        completionClosure(user!)
    }
    task.resume()
}

func numberFormat(from value: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter.string(from: value as NSNumber) ?? ""
}
