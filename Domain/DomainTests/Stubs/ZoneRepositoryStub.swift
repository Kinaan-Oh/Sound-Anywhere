//
//  ZoneRepositoryStub.swift
//  DomainTests
//
//  Created by 오현식 on 2022/04/24.
//

import CoreLocation

import Domain
import RxSwift

final class ZoneRepositoryStub: ZoneRepositoryQuerying {
    private let queryReturnValue: Single<[Zone]>
    private let queryNameReturnValue: Single<Zone>
    
    init() {
        let zone = Zone(id: "",
                                name: "stub",
                                trackList: [],
                                coordinate: CLLocationCoordinate2D())
        queryReturnValue = Single<[Zone]>.just([zone])
        queryNameReturnValue = Single<Zone>.just(zone)
    }
    
    func query() -> Single<[Zone]> {
        return queryReturnValue
    }
    
    func query(name: String) -> Single<Zone> {
        return queryNameReturnValue
    }
}
