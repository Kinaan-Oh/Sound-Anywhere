//
//  FirestoreType.swift
//  Data
//
//  Created by 오현식 on 2022/04/24.
//

import RxSwift

protocol FirestoreCommanding {
    associatedtype T

    func setData(collection: String, document: String, data: T) -> Completable
}

protocol FirestoreQuerying {
    associatedtype T
    
    func getDocument(collection: String, document: String) -> Single<T>
    func getDocuments(collection: String) -> Single<[T]>
}

typealias FirestoreType = FirestoreCommanding & FirestoreQuerying
