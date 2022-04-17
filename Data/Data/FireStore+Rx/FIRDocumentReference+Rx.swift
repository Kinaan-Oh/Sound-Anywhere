//
//  FIRDocumentReference+Rx.swift
//  Data
//
//  Created by 오현식 on 2022/04/17.
//

// Reference: https://github.com/RxSwiftCommunity/RxFirebase/blob/develop/Sources/Firestore/FIRDocumentReference%2BRx.swift

import FirebaseFirestore
import RxCocoa
import RxSwift

extension Reactive where Base: DocumentReference {
    public func setData(_ documentData: [String: Any]) -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.base.setData(documentData) { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    public func setData(_ documentData: [String: Any], merge: Bool) -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.base.setData(documentData, merge: merge) { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    public func updateData(_ fields: [AnyHashable: Any]) -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.base.updateData(fields) { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    public func delete() -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.base.delete { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    public func getDocument() -> Observable<DocumentSnapshot> {
        return Observable.create { observer in
            self.base.getDocument { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot, snapshot.exists {
                    observer.onNext(snapshot)
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: FirestoreErrorDomain, code: FirestoreErrorCode.notFound.rawValue, userInfo: nil))
                }
            }
            return Disposables.create()
        }
    }
    
    public func getDocument(source: FirestoreSource) -> Observable<DocumentSnapshot> {
        return Observable.create { observer in
            self.base.getDocument(source: source) { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot, snapshot.exists {
                    observer.onNext(snapshot)
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: FirestoreErrorDomain, code: FirestoreErrorCode.notFound.rawValue, userInfo: nil))
                }
            }
            return Disposables.create()
        }
    }
    
    public func listen(includeMetadataChanges: Bool) -> Observable<DocumentSnapshot> {
        return Observable<DocumentSnapshot>.create { observer in
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
    
    public func listen() -> Observable<DocumentSnapshot> {
        return Observable<DocumentSnapshot>.create { observer in
            let listener = self.base.addSnapshotListener() { snapshot, error in
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
