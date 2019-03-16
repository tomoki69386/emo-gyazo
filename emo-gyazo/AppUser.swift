//
//  AppUser.swift
//  emo-gyazo
//
//  Created by 築山朋紀 on 2019/03/17.
//  Copyright © 2019 tomoki. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

struct AppUser {
    private init() {}
    
    /// APIHost
    static var apiHost: String {
        get { return Defaults[.apiHost] }
        set { Defaults[.apiHost] = newValue }
    }
}

private extension DefaultsKeys {
    static let apiHost = DefaultsKey<String>("api_host")
}
