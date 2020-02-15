//
//  SignupViewController.swift
//  PushNote
//
//  Created by Danish Ghauri on 28/02/2016.
//  Copyright © 2016 Danish Ghauri. All rights reserved.
//

import UIKit
import Alamofire
class SignupViewController: BaseViewController {
    
    var arrCountryNames: Array<NSString>!
    var arrCountryCodes: Array<NSString>!
    var code = 0
    var lastEnteredCode = ""
    var isProfileImageAttached = false
    
    @IBOutlet weak var buttonAcceptTerms: UIButton?
    @IBOutlet weak var imageViewUserProfile: UIImageView?
    @IBOutlet weak var textFieldEmail: TextField?
    @IBOutlet weak var textFieldUsername: TextField?
    @IBOutlet weak var textFieldPasscode: TextField?
    @IBOutlet weak var textFieldConfirmPasscode: TextField?
    @IBOutlet weak var textFieldCountry: TextField?
    @IBOutlet weak var textFieldPhone: TextField?
    @IBOutlet weak var pickerView: UIPickerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure view
        configureView()
    }
    
    private func configureView() {
        
        title = "Sign Up"
        arrCountryNames = ["Afghanistan",
                           "Albania",
                           "Algeria",
                           "American Samoa",
                           "Andorra",
                           "Angola",
                           "Anguilla",
                           "Antarctica",
                           "Antigua and Barbuda",
                           "Argentina",
                           "Armenia",
                           "Aruba",
                           "Australia",
                           "Austria",
                           "Azerbaijan",
                           "Bahamas",
                           "Bahrain",
                           "Bangladesh",
                           "Barbados",
                           "Belarus",
                           "Belgium",
                           "Belize",
                           "Benin",
                           "Bermuda",
                           "Bhutan",
                           "Bolivia",
                           "Bosnia and Herzegovina",
                           "Botswana",
                           "Brazil",
                           "British Virgin Islands",
                           "Brunei",
                           "Bulgaria",
                           "Burkina Faso",
                           "Burma (Myanmar)",
                           "Burundi",
                           "Cambodia",
                           "Cameroon",
                           "Canada",
                           "Cape Verde",
                           "Cayman Islands",
                           "Central African Republic",
                           "Chad",
                           "Chile",
                           "China",
                           "Christmas Island",
                           "Cocos (Keeling) Islands",
                           "Colombia",
                           "Comoros",
                           "Cook Islands",
                           "Costa Rica",
                           "Croatia",
                           "Cuba",
                           "Cyprus",
                           "Czech Republic",
                           "Democratic Republic of the Congo",
                           "Denmark",
                           "Djibouti",
                           "Dominica",
                           "Dominican Republic",
                           "Ecuador",
                           "Egypt",
                           "El Salvador",
                           "Equatorial Guinea",
                           "Eritrea",
                           "Estonia",
                           "Ethiopia",
                           "Falkland Islands",
                           "Faroe Islands",
                           "Fiji",
                           "Finland",
                           "France",
                           "French Polynesia",
                           "Gabon",
                           "Gambia",
                           "Gaza Strip",
                           "Georgia",
                           "Germany",
                           "Ghana",
                           "Gibraltar",
                           "Greece",
                           "Greenland",
                           "Grenada",
                           "Guam",
                           "Guatemala",
                           "Guinea",
                           "Guinea-Bissau",
                           "Guyana",
                           "Haiti",
                           "Holy See (Vatican City)",
                           "Honduras",
                           "Hong Kong",
                           "Hungary",
                           "Iceland",
                           "India",
                           "Indonesia",
                           "Iran",
                           "Iraq",
                           "Ireland",
                           "Isle of Man",
                           "Israel",
                           "Italy",
                           "Ivory Coast",
                           "Jamaica",
                           "Japan",
                           "Jordan",
                           "Kazakhstan",
                           "Kenya",
                           "Kiribati",
                           "Kosovo",
                           "Kuwait",
                           "Kyrgyzstan",
                           "Laos",
                           "Latvia",
                           "Lebanon",
                           "Lesotho",
                           "Liberia",
                           "Libya",
                           "Liechtenstein",
                           "Lithuania",
                           "Luxembourg",
                           "Macau",
                           "Macedonia",
                           "Madagascar",
                           "Malawi",
                           "Malaysia",
                           "Maldives",
                           "Mali",
                           "Malta",
                           "Marshall Islands",
                           "Mauritania",
                           "Mauritius",
                           "Mayotte",
                           "Mexico",
                           "Micronesia",
                           "Moldova",
                           "Monaco",
                           "Mongolia",
                           "Montenegro",
                           "Montserrat",
                           "Morocco",
                           "Mozambique",
                           "Namibia",
                           "Nauru",
                           "Nepal",
                           "Netherlands",
                           "Netherlands Antilles",
                           "New Caledonia",
                           "New Zealand",
                           "Nicaragua",
                           "Niger",
                           "Nigeria",
                           "Niue",
                           "Norfolk Island",
                           "North Korea",
                           "Northern Mariana Islands",
                           "Norway",
                           "Oman",
                           "Pakistan",
                           "Palau",
                           "Panama",
                           "Papua New Guinea",
                           "Paraguay",
                           "Peru",
                           "Philippines",
                           "Pitcairn Islands",
                           "Poland",
                           "Portugal",
                           "Puerto Rico",
                           "Qatar",
                           "Republic of the Congo",
                           "Romania",
                           "Russia",
                           "Rwanda",
                           "Saint Barthelemy",
                           "Saint Helena",
                           "Saint Kitts and Nevis",
                           "Saint Lucia",
                           "Saint Martin",
                           "Saint Pierre and Miquelon",
                           "Saint Vincent and the Grenadines",
                           "Samoa",
                           "San Marino",
                           "Sao Tome and Principe",
                           "Saudi Arabia",
                           "Senegal",
                           "Serbia",
                           "Seychelles",
                           "Sierra Leone",
                           "Singapore",
                           "Slovakia",
                           "Slovenia",
                           "Solomon Islands",
                           "Somalia",
                           "South Africa",
                           "South Korea",
                           "Spain",
                           "Sri Lanka",
                           "Sudan",
                           "Suriname",
                           "Swaziland",
                           "Sweden",
                           "Switzerland",
                           "Syria",
                           "Taiwan",
                           "Tajikistan",
                           "Tanzania",
                           "Thailand",
                           "Timor-Leste",
                           "Togo",
                           "Tokelau",
                           "Tonga",
                           "Trinidad and Tobago",
                           "Tunisia",
                           "Turkey",
                           "Turkmenistan",
                           "Turks and Caicos Islands",
                           "Tuvalu",
                           "Uganda",
                           "Ukraine",
                           "United Arab Emirates",
                           "United Kingdom",
                           "United States",
                           "Uruguay",
                           "US Virgin Islands",
                           "Uzbekistan",
                           "Vanuatu",
                           "Venezuela",
                           "Vietnam",
                           "Wallis and Futuna",
                           "West Bank",
                           "Yemen",
                           "Zambia",
                           "Zimbabwe"]
        arrCountryCodes = ["93",
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
                           "1",
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
                           "1",
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
                           "263"]
        
        pickerView?.backgroundColor = UIColor.orange
        textFieldCountry?.inputView = pickerView
    }
    
    @IBAction func buttonActionProfileImage(_ sender: AnyObject, forEvent event: UIEvent) {
        
        let alert = UIAlertController(title: nil, message: "Picture taken Options", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Import from Gallery", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: {
                self.chooseFromLibrary()
            })
        }))
        alert.addAction(UIAlertAction(title: "Take Picture", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: {
                self.takePhoto()
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: {
                
            })
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func buttonActionSignup(_ sender: AnyObject, forEvent event: UIEvent) {
        
        guard isReachable() else {
            alert("Network is not available, please try again later.")
            return
        }
        
        guard textFieldEmail?.text?.isEmpty == false || textFieldUsername?.text?.isEmpty == false || textFieldPasscode?.text?.isEmpty == false || textFieldConfirmPasscode?.text?.isEmpty == false ||  textFieldCountry?.text?.isEmpty == false ||  textFieldPhone?.text?.isEmpty == false else {
            alert("All Fields are required")
            return
        }
        
        guard textFieldPasscode?.text == textFieldConfirmPasscode?.text else {
            alert("Confirm Password does not matched")
            return
        }
        
        guard buttonAcceptTerms?.isSelected == true else {
            alert("You must have to accept terms and conditions")
            return
        }
        
        var parameters = [String: AnyObject]()
        parameters = ["email": textFieldEmail?.text as AnyObject, "username": textFieldUsername?.text as AnyObject, "password": textFieldPasscode?.text as AnyObject,"country": textFieldCountry?.text as AnyObject,"phoneNumber": textFieldPhone?.text as AnyObject]
        
        showActivityIndicator()
        if isProfileImageAttached {
            
            let imgView = imageViewUserProfile
            let qualityOfServiceClass = DispatchQoS.QoSClass.background
            let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
            backgroundQueue.async { [weak self] in
                parameters["profile_image"] = imgView?.image!.jpegData(compressionQuality: 4.0)?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters) as AnyObject?
                imgView?.image!.jpegData(compressionQuality: 4.0)?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters) as AnyObject
                self?.signupWithParam(parameters)
            }
        } else {
            signupWithParam(parameters)
        }
    }
    
    func signupWithParam(_ param: Parameters) {
        
        Alamofire.request(baseUrl + "signup",method: HTTPMethod.post, parameters:param)
            .responseJSON { [weak self] response in
                
                if let jsonResponse = response.result.value as? NSDictionary {
                    print("json response \(jsonResponse)")
                    if (jsonResponse["status"] as! String == "SUCCESS") {
                        
                        let defaults = UserDefaults.standard;
                        defaults.set(jsonResponse.value(forKey: "data"), forKey: "userData")
                        defaults.synchronize();
                        let notificationController = self?.storyboard?.instantiateViewController(withIdentifier: "NotificationsSegue") as! NotificationsViewController
                        notificationController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                        self?.present(notificationController, animated: true, completion: nil)
                    } else {
                        let message = jsonResponse["msg"] as! String
                        self?.alert(message)
                    }
                }
                self?.hideActivityIndicator()
        }
    }
    
    @IBAction func checkUncheckBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func tosBtn(_ sender: UIButton) {
        
        let aboutController = self.storyboard?.instantiateViewController(withIdentifier: "AboutTextViewController") as? AboutTextViewController
        aboutController!.myTitle = "Terms"
        self.navigationController?.pushViewController(aboutController!, animated: true)
    }
}

extension SignupViewController: UIActionSheetDelegate {
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch buttonIndex {
        case 1: takePhoto()
        case 2: chooseFromLibrary()
        default: break
        }
    }
}

extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageViewUserProfile?.image = pickedImage
            imageViewUserProfile?.clipsToBounds = true
            self.isProfileImageAttached = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            
            let imagePickerControler = UIImagePickerController();
            imagePickerControler.delegate = self
            imagePickerControler.sourceType = UIImagePickerController.SourceType.camera;
            imagePickerControler.allowsEditing = true
            self.present(imagePickerControler, animated: true, completion: nil);
        }
    }
    
    func chooseFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            
            let imagePickerControler = UIImagePickerController()
            imagePickerControler.delegate = self;
            imagePickerControler.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePickerControler.allowsEditing = true
            self.present(imagePickerControler, animated: true, completion: nil);
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension SignupViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrCountryNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = arrCountryNames[row]
        return NSAttributedString(string: string as String, attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldCountry?.text = (self.arrCountryNames[row] as String)
    }
}
