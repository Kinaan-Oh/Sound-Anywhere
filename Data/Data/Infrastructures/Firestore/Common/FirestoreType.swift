//
//  FirestoreType.swift
//  Data
//
//  Created by 오현식 on 2022/04/24.
//

import RxSwift

public protocol FirestoreType {
    func setData<DTO: Encodable>(collection: String, document: String, data: DTO) -> Completable
    func getDocument<DTO: Decodable>(collection: String, document: String) -> Single<DTO>
    func getDocuments<DTO: Decodable>(collection: String) -> Single<[DTO]>
}
