//
//  PinExtention.swift
//  VirtualTourist
//
//  Created by manar AL-Towaim on 16/07/2019.
//  Copyright © 2019 manar AL-Towaim. All rights reserved.
//


import MapKit

extension Pin {
    var coordinate: CLLocationCoordinate2D {
        
        set{
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
        
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
    }
    
    func compare (coordinate: CLLocationCoordinate2D)-> Bool{
        return (latitude == coordinate.latitude && longitude == coordinate.longitude)
    }
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
    
}
