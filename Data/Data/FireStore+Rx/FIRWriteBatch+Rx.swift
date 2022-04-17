//
//  FIRWriteBatch+Rx.swift
//  Data
//
//  Created by 오현식 on 2022/04/17.
//

// Reference: https://github.com/RxSwiftCommunity/RxFirebase/blob/develop/Sources/Firestore/FIRWriteBatch%2BRx.swift

import FirebaseFirestore
import RxCocoa
import RxSwift

extension Reactive where Base: WriteBatch {
    public func commit() -> Observable<Void> {
        return Observable.create { observer in
            self.base.commit { error in
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
}
