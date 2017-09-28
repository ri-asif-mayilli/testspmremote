//
//  BrowserInfo.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 11.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation

//
//  BrowserInfo.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 04.09.17.
//  Copyright © 2017 RISK.IDENT GMBH. All rights reserved.
//

import Foundation

public struct RSdkBrowserDTO : Codable {

    public var transactionDate         : Date?
    public var netspeed                : String?
    public var fraudscore              : Int? = 0
    public var evidence_mail_allowed   : Bool?
    public var city                    : String?
    public var verified_os             : String?
    public var ip                      : String?
    public var screen_x                : Int?
    public var referrer_domain         : String?
    public var location                : String?
    public var verified_useragent      : String?
    public var latitude                : String?
    public var duplicate               : Bool?
    public var screen_y_available      : Int?
    public var screen_dpi              : String?
    public var plugin_wmv              : String?
    public var domain                  : String?
    public var evidence_status         : String?
    public var exactid_created         : String?
    public var isp                     : String?
    public var regioncode              : String?
    public var plugin_qt               : String?
    public var plugin_af               : String?
    public var site                    : String?
    public var smartid_created         : String?
    public var os                      : String?
    public var useragent               : String?
    public var plugin_ar               : String?
    public var plugin_sl               : String?
    public var fraudscore_raw          : Int?
    public var support_flash           : Bool?
    public var longitude               : String?
    public var plugin_java             : String?
    public var continent               : String?
    public var scoring_completed       : Bool?
    public var device_type             : String?
    public var support_js              : Int?
    public var screen_x_available      : Int?
    public var support_java            : Bool = false
    public var is_tor_ip               : Bool = false
    public var languages               : String?
    public var verified_languages      : String?
    public var countryname             : String?
    public var exactid                 : String?
    public var support_cookie          : Bool?
    public var support_geo             : Bool?
    public var plugin_rp               : String?
    public var new_device              : Bool
    public var proxy                   : Bool
    public var token                   : String?
    public var confidencelevel         : Int?
    public var regionname              : String?
    public var smartid                 : String?
    public var fraudscore_rulematches  : String?
    public var referrer                : String?
    public var org                     : String?
    public var screen_y                : Int?
    public var countrycode             : String?
    public var ghostdevice             : Bool
    public var confidencelevelhistory  : Int?
    public var created                 : String?
    public var matching_completed      : Bool
    public var anonymous_proxy         : Bool
}
