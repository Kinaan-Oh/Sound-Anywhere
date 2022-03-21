//
//  ViewModelType.swift
//  Time Capsule
//
//  Created by 오현식 on 2022/03/07.
//

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
