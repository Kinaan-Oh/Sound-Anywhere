//
//  FirestoreType.swift
//  Data
//
//  Created by 오현식 on 2022/04/24.
//

import RxSwift

protocol FirestoreType {
    associatedtype T
    
    func getDocument(collection: String, document: String) -> Single<T>
    func getDocuments(collection: String) -> Single<[T]>
    func setData(collection: String, document: String, data: T) -> Completable
}
