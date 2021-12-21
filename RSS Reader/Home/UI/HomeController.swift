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

public final class HomeViewController: UIViewController, UITableViewDelegate, LoaderProtocol {
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<HomeSectionItem>!
    private let viewModel: HomeViewModel!
    public let disposeBag = DisposeBag()
    weak var delegate: HomeNavigationDelegate?
    
    public let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    var spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        return view
    }()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindDataSource()
        viewModel.input.onNext(.loadData)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension HomeViewController {
    
    private func setupUI() {
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
        self.tableView.register(HomeCell.self, forCellReuseIdentifier: "HomeCell")
    }
    
    func bindDataSource(){
        disposeBag.insert(viewModel.bindViewModel())
        
        dataSource = RxTableViewSectionedAnimatedDataSource<HomeSectionItem>{ (dataSource, tableView, indexPath, rowItem) -> UITableViewCell in
            let item = dataSource[indexPath.section].items[indexPath.row]
            let cell: HomeCell = tableView.dequeueCell(identifier: "HomeCell")
            if let safeItem = item as? HomeItem{
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
                case .openNewsList(let news):
                    delegate?.navigateToNewsList(news: news)
                case .error(let message):
                    showAlertWith(title: R.string.localizable.error(), message: message)
                case .reloadData:
                    tableView.reloadData()
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
            .map({ HomeInput.newsClicked(indexPath: $0)})
            .bind(to: viewModel.input)
            .disposed(by: disposeBag)
    }
}
