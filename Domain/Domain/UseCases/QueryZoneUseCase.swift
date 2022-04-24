//
//  QueryZoneUseCase.swift
//  Domain
//
//  Created by 오현식 on 2022/04/24.
//

import RxSwift

public protocol QueryZoneUseCase {
    func query() -> Single<[Zone]>
    func query(name: String) -> Single<Zone>
}

final class DefaultQueryZoneUseCase: QueryZoneUseCase {
    private let zoneRepository: ZoneRepositoryQuerying
    
    init(zoneRepository: ZoneRepositoryQuerying) {
        self.zoneRepository = zoneRepository
    }
    
    func query() -> Single<[Zone]> {
        return zoneRepository.query()
    }
    
    func query(name: String) -> Single<Zone> {
        return zoneRepository.query(name: name)
    }
}
