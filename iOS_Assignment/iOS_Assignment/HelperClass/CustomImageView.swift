//
//  customImageView.swift
//  Practice
//
//  Created by leo on 20/9/21.
//

import UIKit

class CustomImageView: UIImageView {
    func loadImage(from url:URL){
        let config = URLSessionConfiguration.default;
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url as URL, completionHandler: {data, response, error in
            guard
                let data = data,
                let newImage = UIImage(data: data)
            else{
                print("Could not load image")
                return
            }
            DispatchQueue.main.async{
                self.image = newImage
            }
        })
        task.resume()
    }
}
