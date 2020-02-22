//
//  AppUtility.swift
//  PushNote
//
//  Created by Khurram Iqbal on 20/02/2020.
//  Copyright © 2020 Ihsan Bhatti. All rights reserved.
//

import UIKit

class AppUtility: NSObject {
    var countryCodes = ["93",
       "355",
       "213",
       "1684",
       "376",
       "244",
       "1264",
       "672",
       "1268",
       "54",
       "374",
       "297",
       "61",
       "43",
       "994",
       "1242",
       "973",
       "880",
       "1246",
       "375",
       "32",
       "501",
       "229",
       "1441",
       "975",
       "591",
       "387",
       "267",
       "55",
       "1284",
       "673",
       "359",
       "226",
       "95",
       "257",
       "855",
       "237",
       "238",
       "1345",
       "236",
       "235",
       "56",
       "86",
       "61",
       "61",
       "57",
       "269",
       "682",
       "506",
       "385",
       "53",
       "357",
       "420",
       "243",
       "45",
       "253",
       "1767",
       "1809",
       "593",
       "20",
       "503",
       "240",
       "291",
       "372",
       "251",
       "500",
       "298",
       "679",
       "358",
       "33",
       "689",
       "241",
       "220",
       "970",
       "995",
       "49",
       "233",
       "350",
       "30",
       "299",
       "1473",
       "1671",
       "502",
       "224",
       "245",
       "592",
       "509",
       "39",
       "504",
       "852",
       "36",
       "354",
       "91",
       "62",
       "98",
       "964",
       "353",
       "44",
       "972",
       "39",
       "225",
       "1876",
       "81",
       "962",
       "7",
       "254",
       "686",
       "381",
       "965",
       "996",
       "856",
       "371",
       "961",
       "266",
       "231",
       "218",
       "423",
       "370",
       "352",
       "853",
       "389",
       "261",
       "265",
       "60",
       "960",
       "223",
       "356",
       "692",
       "222",
       "230",
       "262",
       "52",
       "691",
       "373",
       "377",
       "976",
       "382",
       "1664",
       "212",
       "258",
       "264",
       "674",
       "977",
       "31",
       "599",
       "687",
       "64",
       "505",
       "227",
       "234",
       "683",
       "672",
       "850",
       "1670",
       "47",
       "968",
       "92",
       "680",
       "507",
       "675",
       "595",
       "51",
       "63",
       "870",
       "48",
       "351",
       "1",
       "974",
       "242",
       "40",
       "7",
       "250",
       "590",
       "290",
       "1869",
       "1758",
       "1599",
       "508",
       "1784",
       "685",
       "378",
       "239",
       "966",
       "221",
       "381",
       "248",
       "232",
       "65",
       "421",
       "386",
       "677",
       "252",
       "27",
       "82",
       "34",
       "94",
       "249",
       "597",
       "268",
       "46",
       "41",
       "963",
       "886",
       "992",
       "255",
       "66",
       "670",
       "228",
       "690",
       "676",
       "1868",
       "216",
       "90",
       "993",
       "1649",
       "688",
       "256",
       "380",
       "971",
       "44",
       "598",
       "1340",
       "998",
       "678",
       "58",
       "84",
       "681",
       "970",
       "967",
       "260",
       "263"];
    static let sharedInstance = AppUtility()
    
    private override init(){}
    
     func removeCountryCode(_ phoneNumber:String) -> String {
          var number:NSString = phoneNumber as NSString
          number = number.replacingOccurrences(of: "+", with: "") as NSString
          let predicate: NSPredicate = NSPredicate(format: "%@ BEGINSWITH[cd] self", number)
          let arr = self.countryCodes as NSArray
          let arrResult = arr.filtered(using: predicate) as NSArray
          if arrResult.count > 0 {
              number = number.substring(from: (arrResult[0] as! NSString).length) as NSString
          }
          return number as String;
      }
    func isReachable() -> Bool {
           
           var zeroAddress = sockaddr_in()
           zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
           zeroAddress.sin_family = sa_family_t(AF_INET)
           
           let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
               $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                   SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
               }
           }
           
           var flags = SCNetworkReachabilityFlags()
           if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
               return false
           }
           let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
           let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
           return (isReachable && !needsConnection)
       }
    
    
    func alert(_ message:String,controller:UIViewController) {
        let alert = UIAlertController(title: appName, message:message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            // Put here any code that you would like to execute when
            // the user taps that OK button (may be empty in your case if that's just
            // an informative alert)
        }
        alert.addAction(action)
        controller.present(alert, animated: true){}
        
    }
}

