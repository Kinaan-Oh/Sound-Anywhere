//
//  DefaultZoneRepository.swift
//  Data
//
//  Created by 오현식 on 2022/04/23.
//

import Domain
import Resource
import RxSwift

public final class DefaultZoneRepository {
    private let firestore: FirestoreType
    private let disposeBag: DisposeBag
    
    public init(firestore: FirestoreType) {
        self.firestore = firestore
        self.disposeBag = DisposeBag()
    }
    
    // Call setDummy only if using FakeFirestore
    public func setDummy(dummy: [ZoneDTO]) {
        dummy.forEach { zoneDTO in
            firestore.setData(collection: "zone", document: zoneDTO.name, data: zoneDTO)
                .subscribe()
                .disposed(by: disposeBag)
        }
    }
}

// MARK: - ZoneRepositoryQuerying

extension DefaultZoneRepository: ZoneRepositoryQuerying {
    public func query() -> Single<[Zone]> {
        let zoneDTOs: Single<[ZoneDTO]> = firestore.getDocuments(collection: "zone")
        return zoneDTOs.map { $0.map { $0.toEntity() }.sorted(by: <) }
    }
    
    public func query(name: String) -> Single<Zone> {
        let zoneDTO: Single<ZoneDTO> = firestore.getDocument(collection: "zone", document: name)
        return zoneDTO.map { $0.toEntity() }
    }
}

// MARK: - ZoneRepositoryCommanding

extension DefaultZoneRepository: ZoneRepositoryCommanding {
    public func save(data: Zone) -> Completable {
        return firestore.setData(collection: "zone",
                                 document: "\(data.name)",
                                 data: ZoneDTO(zone: data))
    }
}
