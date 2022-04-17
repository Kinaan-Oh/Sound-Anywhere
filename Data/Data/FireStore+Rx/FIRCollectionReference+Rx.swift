//
//  FIRCollectionReference+Rx.swift
//  Data
//
//  Created by 오현식 on 2022/04/17.
//

// Reference: https://github.com/RxSwiftCommunity/RxFirebase/blob/develop/Sources/Firestore/FIRCollectionReference%2BRx.swift

import FirebaseFirestore
import RxCocoa
import RxSwift

extension Reactive where Base: CollectionReference {
    public func addDocument(data: [String: Any]) -> Observable<DocumentReference> {
        return Observable<DocumentReference>.create { observer in
            var ref: DocumentReference?
            ref = self.base.addDocument(data: data) { error in
                if let error = error {
                    observer.onError(error)
                } else if let ref = ref {
                    observer.onNext(ref)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
