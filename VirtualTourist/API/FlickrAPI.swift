//
//  Fliker API.swift
//  VirtualTourist
//
//  Created by manar AL-Towaim on 13/07/2019.
//  Copyright © 2019 manar AL-Towaim. All rights reserved.
//

import Foundation
import MapKit

class FlickrAPI {
    
    static func getPhotoURLs (by coordinate: CLLocationCoordinate2D,pageNumber: Int, completion: @escaping([URL]?, EasyError?)-> Void) {
        
        guard let requestUrl = getURL(by: coordinate, and: pageNumber) else{
            completion(nil, EasyError(error: nil, customError: "\n error in the request url \n"))
            return
        }
        let request = URLRequest(url: requestUrl)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                completion(nil,EasyError(error: error,customError:  nil))
                return
            }
            
            guard  let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                completion(nil,EasyError(error: nil, customError: "status code not found"))
                return}
            
            guard statusCode >= 200 && statusCode <= 299 else {
                completion(nil,EasyError(error: nil, customError: "request is not succesful status code: \(statusCode)"))
                return
            }
            
            guard let data = data else {
                completion (nil, EasyError(error: nil, customError: "data not found"))
                return
            }
            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                completion(nil,EasyError(error: nil, customError: "could not parse the data"))
                return
            }
            
            guard let stat = result["stat"] as? String, stat == "ok" else {
                completion(nil, EasyError(error: nil, customError: "stat is not ok error: \(result)"))
                return
            }
            
            guard let Dictionary = result["photos"] as? [String:Any] else {
                completion(nil, EasyError(error: nil, customError: "Cannot find the key 'photos' in: \(result)"))
                return
            }
            
            guard let photosArray = Dictionary["photo"] as? [[String:Any]] else {
                completion(nil, EasyError(error: nil, customError: "Cannot find the key 'photo' in \(Dictionary)"))
                return
            }
            
            let photosURLs = photosArray.compactMap { photoDictionary -> URL? in
                guard let url = photoDictionary["url_m"] as? String else { return nil}
                return URL(string: url)
            }
          
            completion (photosURLs, nil)
        }
        task.resume()
    }
    
    
    
    static func getURL (by coordinate: CLLocationCoordinate2D,and pageNumber: Int) -> URL? {
        let queryParametars = [
            "api_key": "4fbc27a1954cc823bf68e3c7a086c9cd",
            "method": "flickr.photos.search",
            "format": "json",
            "safe_search": "1" , // 1 for safe
            "extras": "url_m",
            "nojsoncallback": "1", // for raw json
            "per_page": 5,// picture per page
            "page": pageNumber, // current page number
            "bbox": bbox(by: coordinate) // a squer around the pin where pics com from
            ] as [String: Any]
        
        var URLcomponents = URLComponents()
        URLcomponents.scheme = "https"
        URLcomponents.host = "api.flickr.com"
        URLcomponents.path = "/services/rest"
        URLcomponents.queryItems = [URLQueryItem]()
        
        for (key, value) in queryParametars {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            URLcomponents.queryItems!.append(queryItem)
        }
        return URLcomponents.url
        
    }
    
    static func bbox (by coordinate: CLLocationCoordinate2D) -> String{
        
        let long = coordinate.longitude
        let lat = coordinate.latitude
//        max(lat/long) = min((lat/long) + bboxhalf(hight/width),(lat/long)range
        let maxLat = min(lat + 1.0, 90)
        let maxLong = min(long + 1.0, 180)
//        min(lat/long) = max((lat/long) - bboxhalf(hight/width), -(lat/long)range
        let minLat = max(lat - 1.0, -90)
        let minLong = max(long - 1.0, -180)
        
        
        return "\(minLong),\(minLat),\(maxLong),\(maxLat),"
    }
    
    
}
