//
//  MainViewController.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/08/31.
//

import UIKit

class MainViewController: BaseViewController {
    
    var memoCount: Int = 0
    
    //memoCount : 3개 숫자마다 , 넣는거 필요 (numberformatter)
    
    var mainView = MainView()
    
    override func loadView() { //super.loadView 호출 금지
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupTableView()

        //navigation title 설정 (평소 large title, 메모 작성시 중앙 작게)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "\(memoCount)개의 메모"
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil) //nil인 이유: 결과VC를 따로 하지 X
        searchController.searchBar.placeholder = "검색"
        searchController.hidesNavigationBarDuringPresentation = false
        
        //searchBar에 text가 업데이트될 때마다 불리는 메소드
        searchController.searchResultsUpdater = self
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Search"
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setupTableView() {
        mainView.mainTableView.delegate = self
        mainView.mainTableView.dataSource = self
    }

}
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //섹션 타이틀
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "고정된 메모"
        } else if section == 1 {
            return "메모"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            //memoCount(전체개수)가 1~5개일 때 고정된 메모 개수로 반영. 6개 이상일 때는 고정된 메모 5개.
            if memoCount > 0 && memoCount < 6 {
                return memoCount
            } else if memoCount > 5 {
                return 5
            }
        } else { //section 1에는 5개를 뺀 나머지 메모의 개수만큼 나온다.
            return (memoCount - 5)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainView.mainTableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let fix = UIContextualAction(style: .normal, title: "고정")  { [self] action, view, completionHandler in
//            repository.delete(item: self.tasks[indexPath.row])
//            self.fetchRealm()
        }
        return UISwipeActionsConfiguration(actions: [fix])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "삭제")  { [self] action, view, completionHandler in
//            repository.delete(item: self.tasks[indexPath.row])
//            self.fetchRealm()
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}
