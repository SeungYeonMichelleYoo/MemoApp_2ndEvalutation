////
////  MainView.swift
////  MemoApp
////
////  Created by SeungYeon Yoo on 2022/08/31.
////
//import UIKit
//import SnapKit
//
//class MainView: BaseView {
//
//    let mainTableView: UITableView = {
//        let tableview = UITableView()
//        return tableview
//    }()
//
//
//    let addMemoButton: UIButton = {
//        let btn = UIButton()
//        return btn
//    }()
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func configureUI() {
//
//        [mainTableView, addMemoButton].forEach {
//            self.addSubview($0)
//        }
//
//    }
//
//    override func setConstraints() {
//
//        mainTableView.snp.remakeConstraints { make in
//            make.top.leadingMargin.trailingMargin.bottom.equalTo(self.safeAreaLayoutGuide).inset(8)
//        }
//
//        addMemoButton.snp.makeConstraints { make in
//            make.trailingMargin.equalTo(self.safeAreaLayoutGuide).inset(8)
//            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
//        }
//    }
//}
