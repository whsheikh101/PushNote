//
//  Constants.swift
//  WhoIsHere
//
//  Created by Danish Ghauri on 23/12/2015.
//  Copyright © 2015 reve. All rights reserved.
//


let IPAD_SCALING_FACTOR: CGFloat = 1.5


struct ScreenSize {
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X        = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}

let SEGUE_LOGIN = "LoginSegue"
let SEGUE_TAB = "TabSegue"
let SEGUE_INDEX_SUB_LISTING = "IndexSubListingSegue"
let SEGUE_DETAILS = "DetailSegue"
let SEGUE_NOTIFICATIONS = "NotificationsSegue"
let SEGUE_PRIVACY = "PrivacyViewController"
let SEGUE_TERMS = "TermViewController"
let SEGUE_DASHBOARD = "Dashboard"

