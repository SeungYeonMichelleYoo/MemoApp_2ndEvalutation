//
//  MainTableViewCell.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/08/31.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    //MARK: - 제목 라벨
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    //MARK: - 날짜 라벨
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    //MARK: - 내용 라벨
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    //코드로 tableview짤 때(스토리보드 없이), 초기화 해야하는 이유: 인터페이스 빌더에서는 자동으로 초기화를 해주지만, 코드에서는 인터페이스 빌더를 사용하는게 아니기 때문
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        self.contentView.backgroundColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - subview 추가 및 제약조건
    private func layout() {
        
        [titleLabel, dateLabel, contentLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leadingMargin.equalTo(self.contentView).inset(8)
            make.top.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.rightMargin.equalTo(self.contentView).inset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leadingMargin.equalTo(self.contentView).inset(8)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
//          priority 찾아보기!!
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leadingMargin.equalTo(dateLabel.snp.trailing).offset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
//            make.rightMargin.equalTo(self.contentView).inset(8)
        }
        
    }
    
}
