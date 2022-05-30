//
//  ActionsEndpoint.swift
//  Mir
//
//  Created by Dmitry Rogov on 08.12.2021.
//

import Foundation
import Moya

enum ActionsEndpoint {
    case actions(page: Int)
    case action(id: String)
    
    case feedback(feedback: Feedback)
}

extension ActionsEndpoint: TargetType {
    var baseURL: URL {
        return URL(string: "https://mir.REDACTED.ru/")!
    }
    
    var path: String {
        switch self {
        case .actions: return "actions"
        case .action: return "action"
        case .feedback: return "feedback"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var sampleData: Data {
        var data: Data? = nil
        switch self {
        case .actions(let page):
            guard let path = Bundle.main.path(forResource: "actionsPage\(page)", ofType: "json") else {
                break
            }
            data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        case .action(let id):
            let jsonId = id.last ?? "1"
            guard let path = Bundle.main.path(forResource: "action\(jsonId)", ofType: "json") else {
                break
            }
            data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        case .feedback:
            data = Data()
        }
        return data ?? Data()
    }
}
