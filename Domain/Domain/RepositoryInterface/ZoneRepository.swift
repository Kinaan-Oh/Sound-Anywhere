//
//  ZoneRepository.swift
//  Domain
//
//  Created by 오현식 on 2022/04/23.
//

import RxSwift

public protocol ZoneRepositoryQuerying {
    func query() -> Single<[Zone]>
    func query(name: String) -> Single<Zone>
}

public protocol ZoneRepositoryCommanding {
    func save(data: Zone) -> Completable
}
 
public typealias ZoneRepository = ZoneRepositoryQuerying & ZoneRepositoryCommanding
