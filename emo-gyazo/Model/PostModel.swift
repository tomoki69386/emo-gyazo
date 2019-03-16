//
//  PostModel.swift
//  emo-gyazo
//
//  Created by 築山朋紀 on 2019/03/17.
//  Copyright © 2019 tomoki. All rights reserved.
//

import Foundation

struct PostModel: Codable {
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case image = "image_url"
    }
}
