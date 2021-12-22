//
//  NewsListViewController.swift
//  RSS Reader
//
//  Created by Josip Marković on 21.12.2021..
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

public final class NewsListViewController: UIViewController, UITableViewDelegate, LoaderProtocol {
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<NewsListSectionItem>!
    private let viewModel: NewsListViewModel!
    public let disposeBag = DisposeBag()
    weak var coordinatorDelegate: CoordinatorDelegate?
    
    public let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    var spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        return view
    }()
    
    init(viewModel: NewsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("Deinit: \(self)")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindDataSource()
        viewModel.input.onNext(.loadData)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent{
            coordinatorDelegate?.viewControllerHasFinished()
        }
    }
}

extension NewsListViewController {
    
    private func setupUI() {
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white
        view.addSubview(tableView)
        setupConstraints()
        setupTableView()
    }
    
    func setupTableView(){
        registerCells()
    }
    
    func setupConstraints(){
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func registerCells() {
        self.tableView.register(NewsListCell.self, forCellReuseIdentifier: "NewsListCell")
    }
    
    func bindDataSource(){
        disposeBag.insert(viewModel.bindViewModel())
        
        dataSource = RxTableViewSectionedAnimatedDataSource<NewsListSectionItem>{ (dataSource, tableView, indexPath, rowItem) -> UITableViewCell in
            let item = dataSource[indexPath.section].items[indexPath.row]
            let cell: NewsListCell = tableView.dequeueCell(identifier: "NewsListCell")
            if let safeItem = item as? NewsListItem{
                cell.configure(item: safeItem.item)
            }
            return cell
        }
        self.dataSource.animationConfiguration = .init(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .automatic)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.output
            .map({ $0.items })
            .bind(to: tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        viewModel.output
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (output) in
                guard let safeEvent = output.event else { return }
                switch safeEvent{
                case .error(let message):
                    showAlertWith(title: R.string.localizable.error(), message: message)
                case .reloadData(let title):
                    self.title = title
                    tableView.reloadData()
                case .openNews(let url):
                    UIApplication.shared.open(url)
                }
            }).disposed(by: disposeBag)
        
        viewModel.loaderPublisher
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (shouldShowLoader) in
                if shouldShowLoader{
                    showLoader()
                }else{
                    hideLoader()
                }
            }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map({ NewsListInput.newsClicked(indexPath: $0)})
            .bind(to: viewModel.input)
            .disposed(by: disposeBag)
    }
}
