//
//  QueryZoneUseCase.swift
//  Domain
//
//  Created by 오현식 on 2022/04/24.
//

import RxCommon
import RxSwift

public protocol QueryZoneUseCase {
    func query() -> Single<[Zone]>
    func query(name: String) -> Single<Zone>
}

public final class DefaultQueryZoneUseCase: QueryZoneUseCase {
    private let zoneRepository: ZoneRepositoryQuerying
    
    public init(zoneRepository: ZoneRepositoryQuerying) {
        self.zoneRepository = zoneRepository
    }
    
    public func query() -> Single<[Zone]> {
        return zoneRepository.query()
    }
    
    public func query(name: String) -> Single<Zone> {
        return zoneRepository.query(name: name)
    }
}
