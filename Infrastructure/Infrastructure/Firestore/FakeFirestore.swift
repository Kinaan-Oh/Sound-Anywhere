//
//  FakeFirestore.swift
//  Data
//
//  Created by 오현식 on 2022/04/23.
//

import Data
import RxSwift

public final class FakeFirestore: FirestoreType {
    enum FakeFireStoreError: Error {
        case collectionNotExist
        case documentNotExist
    }

    var db: [String: [String: Any]] = [:]

    public init() {}

    public func setData<DTO: Encodable>(collection: String, document: String, data: DTO) -> Completable {
        Completable.create { observer in
            if self.db[collection] == nil {
                self.db[collection] = [document: data]
            } else {
                self.db[collection]![document] = data
            }
            observer(.completed)
            
            return Disposables.create()
        }
    }

    public func getDocument<DTO: Decodable>(collection: String, document: String) -> Single<DTO> {
        Single.create { observer in
            if let collection = self.db[collection],
               let document = collection[document] as? DTO {
                observer(.success(document))
            } else {
                observer(.failure(FakeFireStoreError.documentNotExist))
            }

            return Disposables.create()
        }
    }

    public func getDocuments<DTO: Decodable>(collection: String) -> Single<[DTO]> {
        Single.create { observer in
            if let collection = self.db[collection] {
                let documents = collection.map({ $0.value as? DTO }).compactMap { $0 }
                observer(.success(documents))
            } else {
                observer(.failure(FakeFireStoreError.collectionNotExist))
            }

            return Disposables.create()
        }
    }
}
