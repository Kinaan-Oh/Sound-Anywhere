//
//  FIRQuery+Rx.swift
//  Data
//
//  Created by 오현식 on 2022/04/17.
//

// Reference: https://github.com/RxSwiftCommunity/RxFirebase/blob/develop/Sources/Firestore/FIRQuery%2BRx.swift

import FirebaseFirestore
import RxCocoa
import RxSwift

extension Reactive where Base: Query {
    public func getDocuments() -> Observable<QuerySnapshot> {
        return Observable<QuerySnapshot>.create { observer in
            self.base.getDocuments { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot {
                    observer.onNext(snapshot)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
  
    public func getDocuments(source: FirestoreSource) -> Observable<QuerySnapshot> {
        return Observable<QuerySnapshot>.create { observer in
            self.base.getDocuments(source: source) { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot {
                    observer.onNext(snapshot)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    public func getFirstDocument() -> Observable<QueryDocumentSnapshot> {
        return self.base.limit(to: 1)
            .rx
            .getDocuments()
            .map { snapshot in
                guard let document = snapshot.documents.first(where: { $0.exists }) else {
                    throw NSError(domain: FirestoreErrorDomain, code: FirestoreErrorCode.notFound.rawValue, userInfo: nil)
                }
                return document
            }
    }
    
    public func listen() -> Observable<QuerySnapshot> {
        return Observable<QuerySnapshot>.create { observer in
            let listener = self.base.addSnapshotListener { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot {
                    observer.onNext(snapshot)
                }
            }
            return Disposables.create {
                listener.remove()
            }
        }
    }
    
    public func listen(includeMetadataChanges: Bool) -> Observable<QuerySnapshot> {
        return Observable<QuerySnapshot>.create { observer in
            let listener = self.base.addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot {
                    observer.onNext(snapshot)
                }
            }
            return Disposables.create {
                listener.remove()
            }
        }
    }
}
