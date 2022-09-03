//
//  MainViewController.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/08/31.
//

import UIKit
import SnapKit
import RealmSwift

class MainViewController: BaseViewController, UISearchControllerDelegate, UISearchBarDelegate {
    var model = UserMemo()
    
    let repository = UserMemoRepositoryType()
    
    var searchController: UISearchController!
    
    lazy var mainTableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = .darkGray
        return tableview
    }()
    
    let addMemoBtn: addMemoButton = {
        let btn = addMemoButton()
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
    
    var _resultsTableController: ResultsTableViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
        
        setupSearchController()
        setupTableView()
        
        view.addSubview(mainTableView)
        view.addSubview(addMemoBtn)
        print(documentDirectoryPath()?.path) //realm 경로 확인
        
        mainTableView.snp.remakeConstraints { make in
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
        
        //        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: .white]
        
        addMemoBtn.addTarget(self, action: #selector(addMemoBtnClicked), for: .touchUpInside)
    }
    @objc func addMemoBtnClicked() {
        //화면전환 코드 (메모 작성으로 넘어감)
        self.navigationController?.pushViewController(WriteViewController(), animated: true)
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil) //nil인 이유: 결과VC를 따로 하지 X
        searchController.searchBar.placeholder = "검색"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
//        searchController.hidesNavigationBarDuringPresentation = false
        
        
        //searchBar에 text가 업데이트될 때마다 불리는 메소드
        searchController.searchResultsUpdater = self
        
        self.navigationItem.searchController = searchController
//        self.navigationItem.hidesSearchBarWhenScrolling = false
        
//        let searchingModel: UserMemo = tasks
//
//        let text: String = "\(searchingModel.beerNameKr)(\(searchingModel.beerNameEn))" // ex) 제주 위트 에일(JEJU Wit ale)
//        let attributeString = NSMutableAttributedString(string: text) // 텍스트 일부분 색상, 폰트 변경 - https://icksw.tistory.com/152
//        // 문자열에서 원하는 문자의 인덱스 찾는 방법 - t.ly/ci4z
//        var textFirstIndex: Int = 0 // 검색중인 키워드가 가장 처음으로 나온 인덱스를 저장할 변수 선언.
//        if let textFirstRange = text.range(of: "\(searchingKeyword)", options: .caseInsensitive) { // 검색중인 키워드가 있을 때에만 색상 변경 - 검색중인 키워드가 가장 처음으로 일치하는 문자열의 범위를 알아낼 수 있음. (caseInsensitive:대소문자 구분X)
//            textFirstIndex = text.distance(from: text.startIndex, to: textFirstRange.lowerBound) // 거리(인덱스) 구해서 저장.
//
//            attributeString.addAttribute(.foregroundColor, value: UIColor.subYellow, range: NSRange(location: textFirstIndex, length: searchingKeyword.count)) // 텍스트 색상(yellow) 변경.
//            attributeString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: cell.beerName.font.pointSize), range: NSRange(location: textFirstIndex, length: searchingKeyword.count)) // 기존 사이즈 변경 없이 bold처리 : https://stackoverflow.com/questions/39999093/swift-programmatically-make-uilabel-bold-without-changing-its-size
//            cell.beerName.attributedText = attributeString // ex) "제주" 위트 에일(JEJU Wit ale)
//            cell.selectionStyle = .none // 테이블뷰 cell 선택시 배경색상 없애기 : https://gonslab.tistory.com/41 |
//
//        }
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
        return 50.0
    }
    
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //화면전환 코드 (해당 메모 수정으로 넘어감)
        let vc = WriteViewController()
        vc.tasks = tasks
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

//MARK: - Searchbar 검색시 나타나는 테이블
class ResultsTableViewController: UITableViewController {
    var items = [String] ()
    let CELLID = "CELLID"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.CELLID)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELLID, for: indexPath)
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
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
