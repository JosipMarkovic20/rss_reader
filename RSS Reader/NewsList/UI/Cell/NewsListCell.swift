//
//  NewsListCell.swift
//  RSS Reader
//
//  Created by Josip Marković on 21.12.2021..
//

import Foundation
import UIKit

class NewsListCell: UITableViewCell{
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let newsImage: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        addSubviews(views: [titleLabel, newsImage])
        selectionStyle = .none
        setupConstraints()
    }
    
    func setupConstraints(){
        newsImage.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.height.equalTo(120).priority(.required)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(newsImage.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(newsImage)
        }
    }
    
    func configure(item: News){
        self.titleLabel.text = item.title
        guard let url = URL(string: item.imageLink ?? "") else { return }
        newsImage.kf.setImage(with: url, placeholder: R.image.placeholder())
    }
}
