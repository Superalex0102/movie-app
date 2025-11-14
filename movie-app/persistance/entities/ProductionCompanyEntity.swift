//
//  ProductionCompanyEntity.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 26..
//

import RealmSwift

class ProductionCompanyEntity: Object {
    @Persisted var id: Int
    @Persisted var logoPath: String?
    @Persisted var name: String
    @Persisted var originCountry: String

    convenience init(from model: ProductionCompany) {
        self.init()
        self.id = model.id
        self.logoPath = model.logoPath
        self.name = model.name
        self.originCountry = model.originCountry
    }

    var toDomain: ProductionCompany {
        ProductionCompany(id: id, logoPath: logoPath ?? "", name: name, originCountry: originCountry)
    }
}
