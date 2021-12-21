//
//  NewsListViewModel.swift
//  RSS Reader
//
//  Created by Josip Marković on 21.12.2021..
//

import Foundation
import RxSwift
import RxCocoa

class NewsListViewModelImpl: NewsListViewModel {
    var loaderPublisher = PublishSubject<Bool>()
    var input: ReplaySubject<NewsListInput> = ReplaySubject.create(bufferSize: 1)
    var output: BehaviorRelay<NewsListOutput> = BehaviorRelay.init(value: NewsListOutput(items: [], event: nil))
    
    public struct Dependencies {
        let news: News
    }
    
    var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    
}

extension NewsListViewModelImpl {
    
    func bindViewModel() -> [Disposable] {
        var disposables = [Disposable]()
        disposables.append(self.input
                            .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                            .flatMap{ [unowned self] (input) -> Observable<NewsListOutput> in
                                switch input{
                                case .loadData:
                                    return handleDataLoad()
                                case .newsClicked(indexPath: let indexPath):
                                    return handleNewsClick(at: indexPath)
                                }
                            }.bind(to: output))
        return disposables
    }
    
    func handleNewsClick(at indexPath: IndexPath) -> Observable<NewsListOutput> {
        if let item = output.value.items[indexPath.section].items[indexPath.row] as? NewsListItem{
            guard let url = URL(string: item.item.link ?? "") else {
                return .just(.init(items: output.value.items, event: nil))
            }
            return .just(.init(items: output.value.items, event: .openNews(url: url)))
        }
        return .just(.init(items: output.value.items, event: nil))
    }
    
    func handleDataLoad() -> Observable<NewsListOutput> {
        self.loaderPublisher.onNext(true)
        let newsItems = createScreenData(from: self.dependencies.news)
        self.loaderPublisher.onNext(false)
        return .just(.init(items: newsItems, event: .reloadData(title: dependencies.news.title ?? "")))
    }
    
    func createScreenData(from news: News) -> [NewsListSectionItem]{
        var screenData = [NewsListSectionItem]()
        screenData.append(NewsListSectionItem(identity: "newsItem", items: news.items.map({ newsItem -> NewsListItem in
            return NewsListItem(identity: newsItem.title ?? "", item: newsItem)
        })))
        return screenData
    }
}

protocol NewsListViewModel {
    func bindViewModel() -> [Disposable]
    var loaderPublisher: PublishSubject<Bool> {get}
    var input: ReplaySubject<NewsListInput> {get}
    var output: BehaviorRelay<NewsListOutput> {get}
}
