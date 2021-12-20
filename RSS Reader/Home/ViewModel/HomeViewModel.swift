//
//  HomeViewModel.swift
//  RSS Reader
//
//  Created by Josip Marković on 20.12.2021..
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModel {
    func bindViewModel() -> [Disposable]
    var loaderPublisher: PublishSubject<Bool> {get}

}

class HomeViewModelImpl: HomeViewModel {
    var loaderPublisher = PublishSubject<Bool>()

    
    public struct Dependencies {
    }
    
    var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    
}

extension HomeViewModelImpl {
    
    func bindViewModel() -> [Disposable] {
        var disposables = [Disposable]()

        return disposables
    }

}
