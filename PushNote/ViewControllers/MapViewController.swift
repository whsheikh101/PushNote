//
//  MapViewController.swift
//  PushNote
//
//  Created by Waqas Haider Sheikh on 04/08/2015.
//  Copyright (c) 2015 com. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var lat_long: String? = ""
    var isFromNotification: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title  = "Location"
        // Do any additional setup after loading the view.
        self.addBackBtn()
       
        self.mapView.mapType = MKMapType.hybrid
        
        if let coordinates = lat_long {
            print(coordinates)
            var arrLatLong = coordinates.components(separatedBy: ",")
             let latitude: String = arrLatLong [0]
            let longitude: String = arrLatLong [1]
            let Location:CLLocationCoordinate2D = CLLocationCoordinate2DMake((latitude as NSString).doubleValue, (longitude as NSString).doubleValue)
            
            //set region
            var region:MKCoordinateRegion = MKCoordinateRegion()
            region.center = Location;
            
            //set span
            var span:MKCoordinateSpan = MKCoordinateSpan()
            span.latitudeDelta = 0.03
            span.longitudeDelta = 0.03
            region.span = span;
            
            self.mapView.setRegion(region, animated: true)
            
            let pin:MapPoint = MapPoint(coordinate: Location, title: "", subtitle:"")
            self.mapView.addAnnotation(pin)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func backBtnPressed1(_ sender: AnyObject) {
        if self.isFromNotification {
            self.navigationController?.view.removeFromSuperview()
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func shareMediaBtnPressed(_ sender: AnyObject) {
        let inviteViewController = self.storyboard?.instantiateViewController(withIdentifier: "InviteFriendsViewController")as!UINavigationController
        self.present(inviteViewController, animated: true, completion: nil);
        
    }
    @IBAction func shareFriendsBtnPressed(_ sender: AnyObject) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(!isFromNotification){
            self.tabBarController!.tabBar.isHidden = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(!isFromNotification){
            self.tabBarController!.tabBar.isHidden = false
        }
       
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
        if segue.identifier == "PushFriends" {
            var destController: ShareFriendsViewController = segue.destinationViewController as! ShareFriendsViewController
            destController.link = self.lat_long
            destController.titleWeb = self.titleWeb
            
        }
        else {
            var destController: ShareViewController = segue.destinationViewController as! ShareViewController
            destController.link = self.lat_long
            destController.titleWeb = self.titleWeb
            
        }
*/
    }
}
