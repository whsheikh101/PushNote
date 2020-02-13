//
//  WeatherViewController.swift
//  PushNote
//
//  Created by Waqas Haider Sheikh on 06/08/2015.
//  Copyright (c) 2015 com. All rights reserved.
//

import UIKit
import Alamofire
class WeatherViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,NSURLConnectionDelegate {

    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var autocompleteTextfield: AutoCompleteTextField!
    
    fileprivate var responseData:NSMutableData?
    var arrWeathers:NSMutableArray = NSMutableArray()
    fileprivate var connection:NSURLConnection?
    var userId:String = ""
    var _keyboardHeight:CGFloat = 0
    
    fileprivate let googleMapsKey = "AIzaSyAGlEpow-WhDRkkl8imJ9qCMLqFTLFf8EA"
    
    fileprivate let baseURLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addBackBtn()
        self.title = "WEATHER"

        //Notifications
        
        
        
     
       // NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIResponder.keyboardWillShowNotification, object: nil)
       // NotificationCenter.default.addObserver(self, selector: #selector(WeatherViewController.keyboardWillShowNot(_:)), name: NSNotification.Name.UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)

        
        
       
        //NotificationCenter.default.removeObserver(T##observer: Any##Any, name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
        
       
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(WeatherViewController.keyboardWillShowNot(_:)),
            name: UIResponder.keyboardDidShowNotification, object: nil)
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(WeatherViewController.keyboardWillHideNot(_:)),
            name: UIResponder.keyboardDidShowNotification, object: nil)
        
        
        
        
        let defaults = UserDefaults.standard;
        self.userId = defaults.value(forKeyPath: "userData.user_id") as! String
        
        configureTextField()
        handleTextFieldInterfaces()
        
        //Call Webservice to Get Weather List
        if !self.isReachable() {
            return
        }
        
       self.showActivityIndicator()
        
        Alamofire.request(baseUrl + "getweather", parameters: ["weather_user_id" : self.userId])
            .responseJSON { response in
                
                if let jsonResponse = response.result.value  as? NSDictionary{
                   
                    if (jsonResponse["status"] as! String == "SUCCESS") {
                        let arr:NSArray = jsonResponse["data"] as! NSArray
                        for  dictionary in  arr{
                            let dic = dictionary as! NSDictionary; let weatherObject:Weather = Weather()
                            weatherObject.weather_user_id = dic["weather_user_id"] as! String
                            weatherObject.weather_id = dic["weather_id"] as! NSString
                            weatherObject.weather_city = dic["weather_city"] as! String
                            weatherObject.weather_latlng = dic["weather_latlng"] as! String
                            
                            self.arrWeathers.add(weatherObject)
                        }
                        self.weatherTableView.reloadData()
                    }
                    else {
                        let alert :UIAlertView = UIAlertView(title: "", message: jsonResponse["msg"] as? String, delegate: nil, cancelButtonTitle: "OK")
                        alert.show();
                    }
                }
               self.hideActivityIndicator()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARk: Notification Methods
     @objc  func keyboardWillShowNot(_ notification:Notification){
        let dictionary:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardRect:CGRect? = (dictionary.object(forKey: UIResponder.keyboardFrameEndUserInfoKey) as AnyObject).cgRectValue
        _keyboardHeight = keyboardRect!.size.height > keyboardRect!.size.width ? keyboardRect!.size.width : keyboardRect!.size.height;
        self.weatherTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: _keyboardHeight, right: 0)
    }
    @objc func keyboardWillHideNot(_ notification:Notification){
    _keyboardHeight = 0;
        self.weatherTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: _keyboardHeight, right: 0)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: UITableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrWeathers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:WeatherCell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as! WeatherCell
        let weatherObject:Weather = arrWeathers.object(at: indexPath.row) as! Weather
        cell.locationLabel.text = weatherObject.weather_city
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(DeviceType.IS_IPAD) {
             return 56.0;
        }else{
             return 41.0
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            //Call Webservice to Delete Weather
            if !self.isReachable() {
                return
            }
            
           self.showActivityIndicator()
            let weatherObject:Weather = arrWeathers.object(at: indexPath.row) as! Weather; let params : Parameters = ["weather_user_id" : self.userId, "weather_id":weatherObject.weather_id];
            Alamofire.request(baseUrl + "deleteweather", parameters:params)
                .responseJSON { response in
                    
                    if let jsonResponse = response.result.value  as? NSDictionary{
                        print(jsonResponse)
                        if (jsonResponse["status"] as! String == "SUCCESS") {
                            
                            self.arrWeathers.removeObject(at: indexPath.row);
                            self.weatherTableView.deleteRows(at: [NSIndexPath(row: indexPath.row, section: indexPath.section) as IndexPath], with: UITableView.RowAnimation.automatic)
                            let alert :UIAlertView = UIAlertView(title: "", message: jsonResponse["msg"] as? String, delegate: nil, cancelButtonTitle: "OK")
                            alert.show();
                        }
                        else {
                            let alert :UIAlertView = UIAlertView(title: "", message: jsonResponse["msg"] as? String, delegate: nil, cancelButtonTitle: "OK")
                            alert.show();
                        }
                    }
                    self.hideActivityIndicator()
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weatherObject:Weather = arrWeathers.object(at: indexPath.row) as! Weather
        let weatherDetailViewController:WeatherDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "weatherDetailViewController") as! WeatherDetailViewController
        weatherDetailViewController.lat_long = weatherObject.weather_latlng
        weatherDetailViewController.location = weatherObject.weather_city
//         self.tabBarController!.tabBar.isHidden = true
        self.navigationController?.pushViewController(weatherDetailViewController, animated: true)
    }
    
    //MARK: Private Functions
    fileprivate func configureTextField(){
        autocompleteTextfield.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        autocompleteTextfield.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        autocompleteTextfield.autoCompleteCellHeight = 35.0
        autocompleteTextfield.maximumAutoCompleteCount = 20
        autocompleteTextfield.hidesWhenSelected = true
        autocompleteTextfield.hidesWhenEmpty = true
        autocompleteTextfield.enableAttributedText = true
        var attributes = [NSAttributedString.Key:AnyObject]()
       
        attributes[NSAttributedString.Key.foregroundColor] = UIColor.black
        attributes[NSAttributedString.Key.font] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        
        autocompleteTextfield.autoCompleteAttributes = attributes
    }
    
    fileprivate func handleTextFieldInterfaces(){
        autocompleteTextfield.onTextChange = {[weak self] text in
            if !text.isEmpty{
                if self!.connection != nil{
                    self!.connection!.cancel()
                    self!.connection = nil
                }
                let urlString = "\(self!.baseURLString)?key=\(self!.googleMapsKey)&input=\(text)&fields=name,rating,formatted_phone_number&offset=3"
               
                print(urlString)
                
                let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)
                if url != nil{
                    let urlRequest = URLRequest(url: url!)
                    self!.connection = NSURLConnection(request: urlRequest, delegate: self)
                }
            }
        }
        
        autocompleteTextfield.onSelect = {[weak self] text, indexpath in
            Location.geocodeAddressString(text, completion: { (placemark, error) -> Void in
                print(placemark)
                if placemark != nil{
                   // let lat_long = String(format: "%@,%@",String(stringInterpolationSegment: placemark!.location!.coordinate.latitude),String(stringInterpolationSegment: placemark!.location!.coordinate.longitude))
                    
                    let lat_long :  String =
                                 String(describing:  placemark!.location!.coordinate.latitude)
                               + ","
                               + String(describing: placemark!.location!.coordinate.longitude)
                    let cityName:String = text.components(separatedBy: ",").first!
                    
                    //Call Webservice to Add New City
                    if !self!.isReachable() {
                        return
                    }
                    let params : Parameters = ["weather_user_id" : self!.userId,
                                               "weather_latlng":lat_long,
                                               "weather_city":cityName
                    ];
                    self!.showActivityIndicator()
                    Alamofire.request(baseUrl + "addweather", parameters:params)
                        .responseJSON { response in
                            
                            if let jsonResponse = response.result.value as? NSDictionary {
                                print(jsonResponse)
                                if (jsonResponse["status"] as! String == "SUCCESS") {
                                    let weatherObject:Weather = Weather()
                                    let weatherIDNSString:NSString? = NSString(format: "%@", jsonResponse["weather_id"] as! NSNumber)
                                    weatherObject.weather_user_id = jsonResponse["weather_user_id"] as! String
                                    weatherObject.weather_id = weatherIDNSString!
                                    weatherObject.weather_city = jsonResponse["weather_city"] as! String
                                    weatherObject.weather_latlng = jsonResponse["weather_latlng"] as! String
                                    
                                    self!.arrWeathers.add(weatherObject)
                                    self!.weatherTableView.reloadData()
                                    self?.autocompleteTextfield.text = ""
                                }
                                else {
                                    self!.alert(jsonResponse["msg"] as! String)
                                    
                                }
                            }
                            self!.hideActivityIndicator()
                    }
                }
            })
        }
    }
    
    //MARK: NSURLConnectionDelegate
    func connection(_ connection: NSURLConnection, didReceiveResponse response: URLResponse) {
        responseData = NSMutableData()
    }
    
    func connection(_ connection: NSURLConnection, didReceiveData data: Data) {
        responseData?.append(data)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        if responseData != nil{
            do{
                if let result = try JSONSerialization.jsonObject(with: responseData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary{
                    print(result)
                    let status = result["status"] as? String
                    if status == "OK"{
                        if let predictions = result["predictions"] as? NSArray{
                            var locations = [String]()
                            for dict in predictions as! [NSDictionary]{
                                locations.append(dict["description"] as! String)
                            }
                            self.autocompleteTextfield.autoCompleteStrings = locations
                        }
                    }
                    else{
                        self.autocompleteTextfield.autoCompleteStrings = nil
                    }
                }
            }
            catch{
                print(error)
            }
        }
    }
    
    func connection(_ connection: NSURLConnection, didFailWithError error: NSError) {
        print("Error: \(error.localizedDescription)")
    }
}
