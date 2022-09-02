//
//  MainViewController.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/08/31.
//

import UIKit
import SnapKit
import RealmSwift

class MainViewController: BaseViewController {
    var model = UserMemo()
    
    let repository = UserMemoRepositoryType()
    
    lazy var mainTableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = .darkGray
        return tableview
    }()
    
    let addMemoButton: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    //여러군데에서 테이블뷰 갱신코드 쓰지 않아도 되게끔 하는 코드
    var tasks: Results<UserMemo>! {
        didSet {
            mainTableView.reloadData()
            print("Tasks Changed")
            
            navigationItem.title = "\(tasks.count)개의 메모"
            //memoCount : 3개 숫자마다 , 넣는거 필요 (numberformatter)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        view.addSubview(mainTableView)
        view.addSubview(addMemoButton)
        print(documentDirectoryPath()?.path)
        
        mainTableView.snp.remakeConstraints { make in
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
        }

        addMemoButton.snp.makeConstraints { make in
            make.top.equalTo(mainTableView.snp.bottom).offset(8)
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
        
        //navigation title 설정 (평소 large title, 메모 작성시 중앙 작게)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.navigationBar.barTintColor = .red
        if tasks == nil {
            navigationItem.title = "0개의 메모"
        } else {
            navigationItem.title = "개의 메모"
        }
        navigationItem.title = "QkdQkefk"
    }
    
    func setupTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        
        //section 뒤 배경 없애기
        mainTableView.backgroundView = nil
        mainTableView.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchRealm()
    }
    
    func fetchRealm() {
        tasks = repository.fetch()
        print(tasks.count)
    }
    
}
//MARK: - SearchBarDelegate
extension MainViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        dump(searchController.searchBar.text)
    }
}

//MARK: - tableview 관련
extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    //MARK: - 섹션 타이틀
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "고정된 메모"
        case 1:
            return "메모"
        default:
            print("out of index")
            return ""
        }
    }

    //MARK: - 섹션에 해당하는 행 개수 표현
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //memoCount(전체개수)가 1~5개일 때 고정된 메모 개수로 반영. 6개 이상일 때는 고정된 메모 5개.
        if section == 0 {
            return tasks.count > 5 ? 5 : tasks.count
        } else {
            return tasks.count > 5 ? tasks.count - 5 : tasks.count
        }
    }


    //MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        cell.titleLabel.text = tasks[indexPath.row].memoTitle
        print("content: \(tasks[indexPath.row].memoContent)")
        cell.contentLabel.text = tasks[indexPath.row].memoContent
        cell.dateLabel.text = getDateFormat(memodate: tasks[indexPath.row].memoDate)
        return cell
    }
    
    //MARK: - 행 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    //MARK: - section header color change
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }

        header.textLabel?.frame = CGRect(x: 0, y: 0, width: 200, height: header.frame.size.height)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        header.textLabel?.textAlignment = .left
    }


    //MARK: - 왼쪽 swipe시 고정
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let fix = UIContextualAction(style: .normal, title: "고정")  { [self] action, view, completionHandler in
            //            repository.delete(item: self.tasks[indexPath.row])
            //            self.fetchRealm()
        }

        fix.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [fix])
    }

    //MARK: - 오른쪽 swipe시 삭제
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "삭제")  { [self] action, view, completionHandler in
            repository.delete(item: self.tasks[indexPath.row])
            //            self.fetchRealm()
        }

        delete.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [delete])
    }

}
