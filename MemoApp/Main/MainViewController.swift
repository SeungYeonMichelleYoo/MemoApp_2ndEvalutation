
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
    
    //MARK: - searchController
    var searchController: UISearchController!
    
    //필터링 되어서 나온 대상
    var text: String = ""
    
    //MARK: - UI 요소 배치
    lazy var mainTableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = .darkGray
        return tableview
    }()
    
    let addMemoBtn: addMemoButton = {
        let btn = addMemoButton()
        return btn
    }()
    
    //MARK: - 여러군데에서 테이블뷰 갱신코드 쓰지 않아도 되게끔 하는 코드
    var tasks: Results<UserMemo>! {
        didSet {
            mainTableView.reloadData()
            print("Tasks Changed")
            
            self.navigationItem.title = "\(repository.fetch().count)개의 메모"
            //memoCount : 3개 숫자마다 , 넣는거 필요 (numberformatter)
        }
    }
    
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        fetchRealm()
        
        //만약 task = nil -> firstvc 띄우기 아닐경우 해당화면에서 시작.
        if tasks.count == 0 {
            //firstview 팝업 띄우기
            let vc = FirstViewController(nibName: "FirstViewController", bundle: nil)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
            
            //밑 배경 투명 처리
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
            view.isOpaque = true
        }
        
        setupTableView()
        
        view.addSubview(mainTableView)
        view.addSubview(addMemoBtn)
        print(documentDirectoryPath()?.path) //realm 경로 확인
        
        mainTableView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        
        addMemoBtn.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
            
        }
        
        //MARK: - navigation title 설정 (평소 large title, 메모 작성시 중앙 작게)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .red
        setupSearchController()
        
        //navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: .white]
        
        addMemoBtn.addTarget(self, action: #selector(addMemoBtnClicked), for: .touchUpInside)
        
        print("fixedCount: \(repository.fetchFilterByFixed(fixed: true).count)")
        print("non-fixedCount: \(repository.fetchFilterByFixed(fixed: false).count)")
        
    }
    
    @objc func addMemoBtnClicked() {
        //화면전환 코드 (메모 작성으로 넘어감)
        self.navigationController?.pushViewController(WriteViewController(), animated: true)
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil) //결과VC
        searchController.searchBar.placeholder = "검색"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.hidesNavigationBarDuringPresentation = true
        
        //searchBar에 text가 업데이트될 때마다 불리는 메소드
        searchController.searchResultsUpdater = self
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    //MARK: - 검색화면 스크롤시 키보드 내리기
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.navigationItem.searchController?.searchBar.resignFirstResponder()
    }
    
    func setupTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        
        //section 뒤 배경 없애기
        mainTableView.backgroundView = nil
        mainTableView.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("text: \(text)")
        fetchRealm()
    }
    
    func fetchRealm() {
        if self.navigationItem.searchController?.isActive == true {
            self.tasks = self.repository.fetchFilterinSearch(text)
        } else {
            tasks = repository.fetch()
            print(tasks.count)
        }
    }
    
}
//MARK: - SearchBarDelegate
extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.text = searchController.searchBar.text!
        //        if (text == "") {
        //            self.tasks = self.repository.fetch()
        //        } else {
        //tasks 안에 검색된 결과가 들어감
        self.tasks = self.repository.fetchFilterinSearch(text)
        //        }
        mainTableView.reloadData()
    }
}

//MARK: - tableview 관련
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.navigationItem.searchController?.isActive == true {
            return 1
        } else {
            if repository.fetchFilterByFixed(fixed: true).count > 0 {
                return 2
            } else { return 1 }
        }
    }
    
    //MARK: - 섹션 타이틀
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if self.navigationItem.searchController?.isActive == true {
                return "\(tasks.count)개 찾음"
            } else if repository.fetchFilterByFixed(fixed: true).count > 0 {
                return "고정된 메모"
            } else {
                return "메모"
            }
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
            if self.navigationItem.searchController?.isActive == true {
                return tasks.count
            } else {
                let fixedCount = repository.fetchFilterByFixed(fixed: true).count
                return fixedCount > 0 ? fixedCount > 5 ? 5 : fixedCount : repository.fetch().count
            }
        } else {
            return repository.fetchFilterByFixed(fixed: false).count
        }
    }
    
    
    //MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        
        var memo: UserMemo!
        if indexPath.section == 0 { //section = 0 일 때 고정된 메모 or 메모.
            if self.navigationItem.searchController?.isActive == true { //search중에는 무조건 section이 하나
                memo = tasks[indexPath.row]
            } else {
                let fixedCount = repository.fetchFilterByFixed(fixed: true).count
                memo = fixedCount > 0 ? repository.fetchFilterByFixed(fixed: true)[indexPath.row] : repository.fetch()[indexPath.row]
            }
        } else { //section = 1일 때 무조건 고정된 메모 존재. 나머지 고정되지 않은 메모 표시
            memo = repository.fetchFilterByFixed(fixed: false)[indexPath.row]
        }
        
        cell.titleLabel.text = memo.memoTitle
        print("content: \(memo.memoContent)")
        cell.contentLabel.text = memo.memoContent
        cell.dateLabel.text = getDateFormat(memodate: memo.memoDate)
        
        return cell
    }
    
    //MARK: - 행 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    //MARK: - didSelectoRowAt
    // 섹션이 0 일 경우
    // case3 1)검색결과 2)고정된 메모 3)메모
    // 섹션이 1 일 경우
    // case1 메모 (고정되지 않은 메모임)
    
    //각 섹션에 대한 데이터들 , 그리고 indexpath.row(행 번호) 를 writeVC에 전달.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //화면전환 코드 (해당 메모 수정으로 넘어감)
        let vc = WriteViewController()
        if indexPath.section == 0 { //section = 0 일 때 고정된 메모 or 메모.
            if self.navigationItem.searchController?.isActive == true { //search중에는 무조건 section이 하나
                vc.tasks = tasks
                vc.navTitle = "검색"
            } else {
                let fixedCount = repository.fetchFilterByFixed(fixed: true).count
                vc.tasks = fixedCount > 0 ? repository.fetchFilterByFixed(fixed: true) : repository.fetch()
            }
        } else { //section = 1일 때 무조건 고정된 메모 존재. 나머지 고정되지 않은 메모 표시
            vc.tasks = repository.fetchFilterByFixed(fixed: false)
        }
        vc.index = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
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
        var memo: UserMemo!
        
        let alert = UIContextualAction(style: .normal, title: "") { [self] action, view, completionHander in
            showAlertMessage(title: "최대 5개의 메모까지 고정할 수 있습니다.")
        }
        
        if indexPath.section == 0 { //section = 0 일 때 고정된 메모 or 메모.
            if self.navigationItem.searchController?.isActive == true {
                memo = tasks[indexPath.row]
            } else {
                let fixedCount = repository.fetchFilterByFixed(fixed: true).count
                memo = fixedCount > 0 ? repository.fetchFilterByFixed(fixed: true)[indexPath.row] : repository.fetch()[indexPath.row]
            }
        } else { //section = 1일 때 무조건 고정된 메모 존재. 나머지 고정되지 않은 메모 표시
            if repository.fetchFilterByFixed(fixed: true).count > 4 {
                return UISwipeActionsConfiguration(actions: [alert])
            }
            memo = repository.fetchFilterByFixed(fixed: false)[indexPath.row]
        }
        
        let fix = UIContextualAction(style: .normal, title: "고정")  { [self] action, view, completionHandler in
            repository.updateFixed(item: memo)
            self.fetchRealm()
        }
        
        fix.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [fix])
    }
    
    //MARK: - 오른쪽 swipe시 삭제
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var memo: UserMemo!
        
        if indexPath.section == 0 { //section = 0 일 때 고정된 메모 or 메모.
            if self.navigationItem.searchController?.isActive == true {
                memo = tasks[indexPath.row] } else {
                    let fixedCount = repository.fetchFilterByFixed(fixed: true).count
                    memo = fixedCount > 0 ? repository.fetchFilterByFixed(fixed: true)[indexPath.row] : repository.fetch()[indexPath.row]
                } } else { //section = 1일 때 무조건 고정된 메모 존재. 나머지 고정되지 않은 메모 표시
                    memo = repository.fetchFilterByFixed(fixed: false)[indexPath.row]
                }
        
        
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        let showAlert = UIContextualAction(style: .normal, title: "삭제")  { [self] action, view, completionHandler in
            present(alert, animated: true)
        }
        let delete = UIAlertAction(title: "OK", style: .default) { (action) in
            self.repository.delete(item: memo)
            self.fetchRealm()
        }
        alert.addAction(delete)
        
        
        showAlert.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [showAlert])
    }
    
}

extension UISearchBar
{
    func setPlaceholderTextColorTo(color: UIColor)
    {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = color
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = color
    }
}
