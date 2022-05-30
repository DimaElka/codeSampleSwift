//
//  SingleAnimatableSectionModel.swift
//  Mir
//
//  Created by Dmitry Rogov on 06.12.2021.
//

import RxDataSources

public struct SingleAnimatableSectionModel<ItemType: IdentifiableType & Equatable> {
    private var model: String = "singleAnimatableSectionModel"
    public var items: [Item]

    public init(items: [ItemType]) {
        self.items = items
    }
}

extension SingleAnimatableSectionModel: AnimatableSectionModelType {
    public typealias Identity = String
    public typealias Item = ItemType

    public var identity: String {
        return model
    }

    public init(original: SingleAnimatableSectionModel, items: [Item]) {
        self.model = original.model
        self.items = items
    }
    
    public var hashValue: Int {
        return self.model.identity.hashValue
    }
}

extension SingleAnimatableSectionModel: Equatable {
    public static func == (lhs: SingleAnimatableSectionModel, rhs: SingleAnimatableSectionModel) -> Bool {
        return lhs.items == rhs.items
    }
}

extension Equatable where Self: RxDataSources.IdentifiableType {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.identity == rhs.identity
    }
}
