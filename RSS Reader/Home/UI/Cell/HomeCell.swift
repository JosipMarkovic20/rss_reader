//
//  HomeCell.swift
//  RSS Reader
//
//  Created by Josip Marković on 21.12.2021..
//

import Foundation
import UIKit
import Kingfisher

class HomeCell: UITableViewCell{
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let typeImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
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
        addSubviews(views: [nameLabel, typeImage])
        selectionStyle = .none
        setupConstraints()
    }
    
    func setupConstraints(){
        typeImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60).priority(.required)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(typeImage)
            make.top.equalTo(typeImage.snp.bottom).offset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configure(item: News){
        self.nameLabel.text = item.title
        guard let url = URL(string: item.imageLink ?? "") else { return }
        self.typeImage.kf.setImage(with: url)
    }
}
