//
//  HomeController.swift
//  RSS Reader
//
//  Created by Josip Marković on 20.12.2021..
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

public final class HomeViewController: UIViewController, UITableViewDelegate {
    private let viewModel: HomeViewModel!
    
    public let disposeBag = DisposeBag()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }

}
