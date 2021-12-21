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
    var input: ReplaySubject<HomeInput> {get}
    var output: BehaviorRelay<HomeOutput> {get}
}

class HomeViewModelImpl: HomeViewModel {
    
    var loaderPublisher = PublishSubject<Bool>()
    var input: ReplaySubject<HomeInput> = ReplaySubject.create(bufferSize: 1)
    var output: BehaviorRelay<HomeOutput> = BehaviorRelay.init(value: HomeOutput(items: [], event: nil))
    var dependencies: Dependencies
    
    public struct Dependencies {
        let newsRepository: NewsRepository
    }
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
}

extension HomeViewModelImpl {
    
    func bindViewModel() -> [Disposable] {
        var disposables = [Disposable]()
        disposables.append(self.input
                            .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                            .flatMap{ [unowned self] (input) -> Observable<HomeOutput> in
                                switch input{
                                case .loadData:
                                    return handleDataLoad()
                                case .newsClicked(indexPath: let indexPath):
                                    return handleNewsClick(at: indexPath)
                                }
                            }.bind(to: output))
        return disposables
    }

    func handleNewsClick(at indexPath: IndexPath) -> Observable<HomeOutput> {
        if let item = output.value.items[indexPath.section].items[indexPath.row] as? HomeItem{
            return .just(.init(items: output.value.items, event: .openNewsList(news: item.item)))
        }
        return .just(.init(items: output.value.items, event: nil))
    }
    
    func handleDataLoad() -> Observable<HomeOutput> {
        self.loaderPublisher.onNext(true)
        return dependencies.newsRepository
            .getNewsFeeds()
            .flatMap {[unowned self] result  -> Observable<HomeOutput> in
                self.loaderPublisher.onNext(false)
                switch result {
                case .success(let news):
                    return .just(.init(items: createScreenData(from: news), event: .reloadData))
                case .failure(let error):
                    return .just(.init(items: output.value.items,
                                       event: .error(error.localizedDescription)))
                }
            }
    }
    
    func createScreenData(from news: [News]) -> [HomeSectionItem]{
        var screenData = [HomeSectionItem]()
        screenData.append(HomeSectionItem(identity: "news", items: news.map({ news -> HomeItem in
            return HomeItem(identity: news.title ?? "", item: news)
        })))
        return screenData
    }
}
