//
//  RESTManager.swift
//  RSS Reader
//
//  Created by Josip Marković on 20.12.2021..
//

import Foundation
import RxSwift
import SwiftyXMLParser
import Alamofire

class RESTManager{
    
    let session = URLSession.shared
    
    func getNewsData(url: URL) -> Observable<News>{
        return Observable.create{ observer in
            let request = AF.request(url).responseData { response in
                switch response.result {
                case .success(let data):
                    let xml = XML.parse(data)
                    let xmlChannel = xml.rss.channel
                    let xmlItems = xmlChannel.item
                    var items = [NewsItem]()
                    for item in xmlItems {
                        let imageLink = item["media:content"].attributes["url"]
                        items.append(NewsItem(title: item.title.text,
                                              link: item.link.text,
                                              imageLink: imageLink))
                    }
                    let news = News(title: xmlChannel.image.title.text,
                                    imageLink: xmlChannel.image["url"].text,
                                    items: items)
                    observer.onNext(news)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
