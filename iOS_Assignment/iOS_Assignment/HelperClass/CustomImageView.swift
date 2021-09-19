//
//  customImageView.swift
//  Practice
//
//  Created by leo on 20/9/21.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    var task: URLSessionDataTask?
    func loadImage(from url:URL){
        if let task = task{
            task.cancel()
        }
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage{
            self.image = imageFromCache
        }
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
            imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
            DispatchQueue.main.async{
                self.image = newImage
            }
        })
        task.resume()
    }
}
