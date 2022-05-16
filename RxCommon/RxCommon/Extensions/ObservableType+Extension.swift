//
//  ObservableType+Extension.swift
//  Common
//
//  Created by 오현식 on 2022/04/19.
//

import RxCocoa
import RxSwift

extension ObservableType {
    public func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            return Driver.empty()
        }
    }
    
    public func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
