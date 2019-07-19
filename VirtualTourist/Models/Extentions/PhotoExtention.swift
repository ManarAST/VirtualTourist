//
//  PhotoExtention.swift
//  VirtualTourist
//
//  Created by manar AL-Towaim on 16/07/2019.
//  Copyright © 2019 manar AL-Towaim. All rights reserved.
//


import UIKit

extension Photo {
    func set (image: UIImage) {
        self.image = image.pngData()
    }
    
    func getPhoto () -> UIImage? {
        return (image == nil) ? nil : UIImage(data: image!)
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
    
    
    func loadImage(url: URL, completion: @escaping (UIImage?, EasyError?)-> Void){
        
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            guard error == nil else{
               completion(nil,EasyError(error: nil, customError: "problim downloading the actual pic => \(error!.localizedDescription)"))
                return
            }
            guard let data = data else {
                completion(nil, EasyError(error: nil, customError: "error while downloading pic => data found to be nil"))
                return
            }
            
           
            let downloadedImage = UIImage(data: data)
            guard let image = downloadedImage else {
                completion(nil, EasyError(error: nil, customError: "something happend in terning the data to a UIImage"))
                return
            }
            completion(image, nil)
            
        }.resume()
        
    }
}
