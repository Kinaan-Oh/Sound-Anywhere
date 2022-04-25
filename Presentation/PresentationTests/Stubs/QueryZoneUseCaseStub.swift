//
//  QueryZoneUseCaseStub.swift
//  PresentationTests
//
//  Created by 오현식 on 2022/04/26.
//

import CoreLocation

import Domain
import RxSwift


final class QueryZoneUseCaseStub: QueryZoneUseCase {
    private let queryReturnValue: Single<[Zone]> = Single.just([])
    private let queryNameReturnValue: Single<Zone> = Single.just(
        Zone(id: "", name: "Stub", trackList: [], coordinate: CLLocationCoordinate2D())
    )
    
    func query() -> Single<[Zone]> {
        return queryReturnValue
    }
    
    func query(name: String) -> Single<Zone> {
        return queryNameReturnValue
    }
}
