//
//  NetworkManager.swift
//  Mir
//
//  Created by Dmitry Rogov on 08.12.2021.
//

import Foundation
import Moya

class NetworkManager {
    
    static let shared = NetworkManager()

    let actionsProvider: MoyaProvider<ActionsEndpoint>
    let pushProvider: MoyaProvider<PushEndpoint>

    private init() {
        let loggerPlugin = NetworkLoggerPlugin()
        
        actionsProvider = MoyaProvider<ActionsEndpoint>(stubClosure: MoyaProvider.delayedStub(2.0), plugins: [])
        pushProvider = MoyaProvider<PushEndpoint>(plugins: [loggerPlugin])
    }
}
