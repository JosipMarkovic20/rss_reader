//
//  NewsRepository.swift
//  RSS Reader
//
//  Created by Josip Marković on 21.12.2021..
//

import Foundation
import RxSwift

class NewsRepositoryImpl: NewsRepository {
    let restManager: RESTManager
    let nyTimesUrl = URL(string: "https://rss.nytimes.com/services/xml/rss/nyt/World.xml")
    let nyTimesTechnologyUrl = URL(string: "https://rss.nytimes.com/services/xml/rss/nyt/Technology.xml")
    let nyTimesSportUrl = URL(string: "https://rss.nytimes.com/services/xml/rss/nyt/Sports.xml")
    
    init(restManager: RESTManager) {
        self.restManager = restManager
    }
    func getNewsFeeds() -> Observable<Result<[News], Error>> {
        var feeds = [News]()
        let observable = getFeed(from: nyTimesUrl)
        
        return observable.flatMap {[unowned self] result -> Observable<Result<News, Error>> in
            switch result {
            case .success(let news):
                feeds.append(news)
                return getFeed(from: nyTimesTechnologyUrl)
            case .failure(let error):
                return .just(.failure(error))
            }
        }.flatMap {[unowned self] result -> Observable<Result<News, Error>> in
            switch result {
            case .success(let news):
                feeds.append(news)
                return getFeed(from: nyTimesSportUrl)
            case .failure(let error):
                return .just(.failure(error))
            }
        }.flatMap { result -> Observable<Result<[News], Error>> in
            switch result {
            case .success(let news):
                feeds.append(news)
                return .just(.success(feeds))
            case .failure(let error):
                return .just(.failure(error))
            }
        }
    }
    
    private func getFeed(from url: URL?) -> Observable<Result<News, Error>> {
        guard let url = url else {
            return .just(.failure(NewsError.general))
        }

        let observable: Observable<Result<News, Error>> = restManager.getNewsData(url: url).handleError()
        return observable
    }
}
protocol NewsRepository {
    func getNewsFeeds() -> Observable<Result<[News], Error>>
}
