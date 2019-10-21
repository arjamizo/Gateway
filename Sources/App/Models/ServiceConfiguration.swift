//
//  ServiceConfiguration.swift
//  App
//
//  Created by Szymon Lorenz on 21/10/19.
//

import Foundation

struct ServiceConfiguration: Decodable {
    var host: URL?
    var loginRequired: Bool
}
