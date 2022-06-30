//
//  DefaultFirestore.swift
//  Data
//
//  Created by 오현식 on 2022/04/24.
//

import Data
import FirebaseFirestore
import FirebaseFirestoreSwift
import RxSwift

public final class DefaultFireStore: FirestoreType {

    private let db = Firestore.firestore()
    
    public init() {}
    
    public func setData<DTO: Encodable>(collection: String, document: String, data: DTO) -> Completable {
        Completable.create { observer in
            do {
                try self.db.collection(collection).document(document)
                    .setData(from: data, completion: { error in
                        if error == nil { observer(.completed) }
                    })
            } catch let error {
                observer(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    public func getDocument<DTO: Decodable>(collection: String, document: String) -> Single<DTO> {
        Single.create { observer in
            self.db.collection(collection).document(document)
                .getDocument(as: DTO.self) { result in
                    switch result {
                    case .success(let data):
                        observer(.success(data))
                    case.failure(let error):
                        observer(.failure(error))
                    }
                }

            return Disposables.create()
        }
    }

    public func getDocuments<DTO: Decodable>(collection: String) -> Single<[DTO]> {
        Single.create { observer in
            self.db.collection(collection)
                .getDocuments { querySnapShot, error in
                    if let error = error {
                        observer(.failure(error))
                    } else {
                        let documents = querySnapShot!.documents
                        let result = Result {
                            try documents.map { try $0.data(as: DTO.self) }.compactMap { $0 }
                        }
                        
                        switch result {
                        case .success(let data):
                            observer(.success(data))
                        case .failure(let error):
                            observer(.failure(error))
                        }
                    }
                }

            return Disposables.create()
        }
    }
}
