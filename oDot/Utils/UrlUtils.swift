//
//  UrlUtils.swift
//  oDot
//
//  Created by Andrew on 09/07/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import Foundation

class UrlUtils {
    static let avatarImageBaseUrl = "https://steamcdn-a.akamaihd.net"
    class func buildAvatarImageUrl(avatarUrlPiece: String) -> URL? {
        return URL(string: self.avatarImageBaseUrl + avatarUrlPiece)
    }
}
