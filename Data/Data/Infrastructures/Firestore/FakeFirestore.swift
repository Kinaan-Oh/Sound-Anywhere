//
//  FakeFirestore.swift
//  Data
//
//  Created by 오현식 on 2022/04/23.
//

import RxSwift
import Foundation

final class FakeFirestore<T> {
    enum FirestoreError: Error {
        case documentNotExist
        case documentsNotExist
        case documentAleadyExist
    }
    
    final class Collection {
        final class Document {
            // MARK: - Document Properties, Methods
        
            var data: T?
            
            func setData(from data: T, completion: @escaping (Result<T, FirestoreError>) -> Void) {
                guard self.data != nil else {
                    self.data = data
                    completion(.success(data))
                    return
                }
                completion(.failure(.documentAleadyExist))
            }
            
            func getDocument(completion: @escaping (Result<T, FirestoreError>) -> Void) {
                guard let data = data else {
                    completion(.failure(.documentNotExist))
                    return
                }
                completion(.success(data))
            }
        }
        
        // MARK: - Collection Properties, Methods
        
        var collection: [String: Document] = [:]
        
        func document(name: String) -> Document {
            guard let document = collection[name] else {
                let newDocument = Document()
                collection[name] = newDocument
                return newDocument
            }
            return document
        }
        
        func getDocuments(completion: @escaping (Result<[T], FirestoreError>) -> Void) {
            let data = collection.compactMap { $0.value.data }
            
            if data.isEmpty {
                completion(.failure(.documentsNotExist))
            } else {
                completion(.success(data))
            }
        }
    }
    
    // MARK: - FakeFirestore Properties, Methods
    
    var db: [String: Collection] = [:]
    
    func collection(name: String) -> Collection {
        guard let collection = db[name] else {
            let newCollection = Collection()
            db[name] = newCollection
            return newCollection
        }
        return collection
    }
}


// MARK: - FirestoreType

extension FakeFirestore: FirestoreType {
    func setData(collection: String, document: String, data: T) -> Completable {
        Completable.create { observer in
            self.collection(name: collection)
                .document(name: document)
                .setData(from: data) { result in
                    switch result {
                    case .success(_):
                        observer(.completed)
                    case .failure(let error):
                        observer(.error(error))
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func getDocument(collection: String, document: String) -> Single<T> {
        return Single<T>.create { observer in
            self.collection(name: collection)
                .document(name: document)
                .getDocument { result in
                    switch result {
                    case .success(let data):
                        observer(.success(data))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func getDocuments(collection: String) -> Single<[T]> {
        return Single<[T]>.create { observer in
            self.collection(name: collection)
                .getDocuments { result in
                    switch result {
                    case .success(let data):
                        observer(.success(data))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }
            
            return Disposables.create()
        }
    }
}
