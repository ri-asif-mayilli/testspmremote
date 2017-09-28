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

internal struct RSdkBrowserDTO : Codable {

    internal var transactionDate         : Date?
    internal var netspeed                : String?
    internal var fraudscore              : Int? = 0
    internal var evidence_mail_allowed   : Bool?
    internal var city                    : String?
    internal var verified_os             : String?
    internal var ip                      : String?
    internal var screen_x                : Int?
    internal var referrer_domain         : String?
    internal var location                : String?
    internal var verified_useragent      : String?
    internal var latitude                : String?
    internal var duplicate               : Bool?
    internal var screen_y_available      : Int?
    internal var screen_dpi              : String?
    internal var plugin_wmv              : String?
    internal var domain                  : String?
    internal var evidence_status         : String?
    internal var exactid_created         : String?
    internal var isp                     : String?
    internal var regioncode              : String?
    internal var plugin_qt               : String?
    internal var plugin_af               : String?
    internal var site                    : String?
    internal var smartid_created         : String?
    internal var os                      : String?
    internal var useragent               : String?
    internal var plugin_ar               : String?
    internal var plugin_sl               : String?
    internal var fraudscore_raw          : Int?
    internal var support_flash           : Bool?
    internal var longitude               : String?
    internal var plugin_java             : String?
    internal var continent               : String?
    internal var scoring_completed       : Bool?
    internal var device_type             : String?
    internal var support_js              : Int?
    internal var screen_x_available      : Int?
    internal var support_java            : Bool = false
    internal var is_tor_ip               : Bool = false
    internal var languages               : String?
    internal var verified_languages      : String?
    internal var countryname             : String?
    internal var exactid                 : String?
    internal var support_cookie          : Bool?
    internal var support_geo             : Bool?
    internal var plugin_rp               : String?
    internal var new_device              : Bool
    internal var proxy                   : Bool
    internal var token                   : String?
    internal var confidencelevel         : Int?
    internal var regionname              : String?
    internal var smartid                 : String?
    internal var fraudscore_rulematches  : String?
    internal var referrer                : String?
    internal var org                     : String?
    internal var screen_y                : Int?
    internal var countrycode             : String?
    internal var ghostdevice             : Bool
    internal var confidencelevelhistory  : Int?
    internal var created                 : String?
    internal var matching_completed      : Bool
    internal var anonymous_proxy         : Bool
}
