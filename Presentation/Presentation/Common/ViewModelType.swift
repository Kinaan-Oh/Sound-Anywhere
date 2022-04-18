//
//  ViewModelType.swift
//  Time Capsule
//
//  Created by 오현식 on 2022/03/07.
//

import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    associatedtype Dependencies
    
    var dependencies: Dependencies { get }
    var disposeBag: DisposeBag { get set }
    
    init(dependencies: Dependencies)
    
    func transform(input: Input) -> Output
}
