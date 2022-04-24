//
//  DefaultZoneRepository.swift
//  Data
//
//  Created by 오현식 on 2022/04/23.
//

import Domain
import Resource
import RxSwift

final class DefaultZoneRepository<Firestore> where Firestore: FirestoreType, Firestore.T == ZoneDTO {
    private let firestore: Firestore
    private let disposeBag: DisposeBag
    
    init(firestore: Firestore) {
        self.firestore = firestore
        self.disposeBag = DisposeBag()
    }
    
    // Call setDummy only if using FakeFirestore
    func setDummy(dummy: [ZoneDTO]) {
        dummy.forEach { zoneDTO in
            firestore.setData(collection: "zone", document: zoneDTO.name, data: zoneDTO)
                .subscribe()
                .disposed(by: disposeBag)
        }
    }
}

// MARK: - ZoneRepositoryQuerying

extension DefaultZoneRepository: ZoneRepositoryQuerying {
    func query() -> Single<[Zone]> {
        return firestore.getDocuments(collection: "zone")
            .map { $0.map { $0.toEntity() } }
    }
    
    func query(name: String) -> Single<Zone> {
        return firestore.getDocument(collection: "zone", document: name)
            .map { $0.toEntity() }
    }
}

// MARK: - ZoneRepositoryCommanding

extension DefaultZoneRepository: ZoneRepositoryCommanding {
    func save(data: Zone) -> Completable {
        return firestore.setData(collection: "zone", document: "\(data.name)", data: ZoneDTO(zone: data))
    }
}
