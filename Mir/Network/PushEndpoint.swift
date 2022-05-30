//
//  PushEndpoint.swift
//  Mir
//
//  Created by Dmitry Rogov on 08.12.2021.
//

import Moya

enum PushEndpoint {
    case sendPushToken(token: String, deviceName: String)
}

extension PushEndpoint: TargetType {
    var baseURL: URL {
        return URL(string: "https://mir.REDACTED.ru/")!
    }
    
    var path: String {
        switch self {
        case .sendPushToken: return "api/device"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        switch self {
        case .sendPushToken(let token, let deviceName):
            let params = ["token": token,
                          "name": deviceName]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
