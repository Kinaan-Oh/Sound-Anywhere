//
//  ZoneRepository.swift
//  Domain
//
//  Created by 오현식 on 2022/04/23.
//

import RxSwift

public protocol ZoneRepositoryCommanding {
}

public protocol ZoneRepositoryQuerying {
    func fetchZones() -> Single<[Zone]>
}

