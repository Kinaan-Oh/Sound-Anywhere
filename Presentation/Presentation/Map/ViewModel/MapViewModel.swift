//
//  MapViewModel.swift
//  Time Capsule
//
//  Created by 오현식 on 2022/03/11.
//

import RxSwift

final class MapViewModel: ViewModelType {
    struct Input {
    }
    
    struct Output {
    }
    
    struct Dependencies {
    }
    
    let dependencies: Dependencies
    var disposeBag: DisposeBag = DisposeBag()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
