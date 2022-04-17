//
//  FIRFirestore+Rx.swift
//  Data
//
//  Created by 오현식 on 2022/04/17.
//

// Reference: https://github.com/RxSwiftCommunity/RxFirebase/blob/develop/Sources/Firestore/FIRFirestore%2BRx.swift

import FirebaseFirestore
import RxCocoa
import RxSwift

extension Reactive where Base: Firestore {
    public func disableNetwork() -> Observable<Void> {
        return Observable.create { observer in
            self.base.disableNetwork(completion: { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            })
            return Disposables.create()
        }
    }
    
    public func enableNetwork() -> Observable<Void> {
        return Observable.create { observer in
            self.base.enableNetwork(completion: { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            })
            return Disposables.create()
        }
    }
    
    public func runTransaction(_ updateBlock: @escaping (Transaction) throws -> Any?) -> Observable<Any?> {
        return self.runTransaction(type: Any.self, updateBlock)
    }
    
    public func runTransaction<T>(type: T.Type, _ updateBlock: @escaping (Transaction) throws -> T?) -> Observable<T?> {
        return Observable.create { observer in
            self.base.runTransaction({ transaction, errorPointer in
                do {
                    return try updateBlock(transaction)
                } catch {
                    errorPointer?.pointee = error as NSError
                    return nil
                }
            }, completion: { value, error in
                guard let error = error else {
                    observer.onNext(value as? T)
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            })
            return Disposables.create()
        }
    }
}
