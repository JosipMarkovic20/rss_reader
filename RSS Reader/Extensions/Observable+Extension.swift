//
//  Observable+Extension.swift
//  RSS Reader
//
//  Created by Josip Marković on 21.12.2021..
//

import Foundation
import RxSwift

public extension Observable {
    func handleError() -> Observable<Result<Element, Error>> {
        return self.map { (element) -> Result<Element, Error> in
            return .success(element)
        }.catch { error -> Observable<Result<Element, Error>> in
            return .just(.failure(error))
        }
    }
}
