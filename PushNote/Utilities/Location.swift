//
//  Location.swift
//  AutocompleteTextfieldSwift
//
//  Created by Mylene Bayan on 2/22/15.
//  Copyright (c) 2015 MaiLin. All rights reserved.
//

import Foundation
import CoreLocation

class Location{
  
  class func geocodeAddressString(_ address:String, completion:@escaping (_ placemark:CLPlacemark?, _ error:NSError?)->Void){
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
      if error == nil{
        if placemarks!.count > 0{
          completion((placemarks![0] as CLPlacemark), error as NSError?)
        }
      }
      else{
        completion(nil, error as NSError?)
      }
    })
  }
  
  class func reverseGeocodeLocation(_ location:CLLocation,completion:@escaping (_ placemark:CLPlacemark?, _ error:NSError?)->Void){
    let geoCoder = CLGeocoder()
    geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
      if error != nil{
        print("Error Reverse Geocoding Location: \(error!.localizedDescription)")
        completion(nil, error as NSError?)
        return
      }
      
      let placemark = placemarks![0] 
      completion(placemark, nil)
      
    })
  }
  
  class func addressFromPlacemark(_ placemark:CLPlacemark)->String{
    var address = ""
    let name = placemark.addressDictionary!["Name"] as? String
    let city = placemark.addressDictionary!["City"] as? String
    let state = placemark.addressDictionary!["State"] as? String
    let country = placemark.country
    
    if name != nil{
      address = constructAddressString(address, newString: name!)
    }
    if city != nil{
      address = constructAddressString(address, newString: city!)
    }
    if state != nil{
      address = constructAddressString(address, newString: state!)
    }
    if country != nil{
      address = constructAddressString(address, newString: country!)
    }
    return address
  }
  
  fileprivate class func constructAddressString(_ string:String, newString:String)->String{
    var address = string
    if !address.isEmpty{
      address = address + ", \(newString)"
    }
    else{
      address = address + newString
    }
    return address
  }
}
