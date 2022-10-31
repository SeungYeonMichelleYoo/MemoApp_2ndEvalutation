
//  MemoListViewController.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/08/31.
//
import Foundation
import UIKit
import SnapKit
import RealmSwift

class MemoListViewController: BaseViewController {
    
    //MARK: - 여러군데에서 테이블뷰 갱신코드 쓰지 않아도 되게끔 하는 코드
    var memos: [Memo] = [] {
        didSet {
            mainTableView.reloadData()
            print("Tasks Changed")
            
            //MARK: - NumberFormtter (3개 숫자마다 , 넣기)
            let numberFormatter = NumberFormatter() //NumberFormatter 객체 생성
            numberFormatter.numberStyle = .decimal
            let memoCount = numberFormatter.string(for: writeViewModel.fetchAll().count) ?? "0"
            
            self.navigationItem.title = "\(memoCount)개의 메모"
            
        }
    }

    private var writeViewModel: MemoVM!
    
    var searchController: UISearchController!
    
    //필터링 되어서 나온 대상
    var text: String = ""
    
    //MARK: - UI 요소 배치
    lazy var mainTableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = .darkGray
        return tableview
    }()
    
    lazy var addMemoBtn: addMemoButton = {
        let btn = addMemoButton()
        return btn
    }()
    
    func getMemoList() {
        if self.navigationItem.searchController?.isActive == true {
            memos = writeViewModel.fetchByKeyword(word: text)
        } else {
            memos = writeViewModel.fetchAll()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.writeViewModel = MemoVM()
        
        //MARK: - 다크모드 대응
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
        } else {
            view.backgroundColor = .white
        }
        
        getMemoList()
        
        //만약 task = nil -> firstvc 띄우기 아닐경우 해당화면에서 시작.
        if memos.count == 0 {
            //firstview 팝업 띄우기
            let vc = FirstViewController(nibName: "FirstViewController", bundle: nil)
            vc.modalPresentationStyle = .overFullScreen
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
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        addMemoBtn.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
            
        }
        
        //MARK: - navigation title 설정
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupSearchController()
        
        addMemoBtn.addTarget(self, action: #selector(addMemoBtnClicked), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //MARK: - 다크모드 대응
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
        } else {
            view.backgroundColor = .white
        }
        
        //MARK: - navigation title 설정
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
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
        getMemoList()
    }

    
}
//MARK: - SearchBarDelegate
extension MemoListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.text = searchController.searchBar.text!
        //tasks 안에 검색된 결과가 들어감
        memos = writeViewModel.fetchByKeyword(word: text)
        mainTableView.reloadData()
    }
}

//MARK: - tableview 관련
extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.navigationItem.searchController?.isActive == true {
            return 1
        } else {
            if writeViewModel.fetchByFixed(fixed: true).count > 0 {
                return 2
            } else {
                return writeViewModel.fetchAll().count == 0 ? 0 : 1
            }
        }
    }
    
    //MARK: - 섹션 타이틀
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if self.navigationItem.searchController?.isActive == true {
                return "\(memos.count)개 찾음"
            } else if writeViewModel.fetchByFixed(fixed: true).count > 0 {
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
                return memos.count
            } else {
                let fixedCount = writeViewModel.fetchByFixed(fixed: true).count
                return fixedCount > 0 ? fixedCount > 5 ? 5 : fixedCount : writeViewModel.fetchAll().count
            }
        } else {
            return writeViewModel.fetchByFixed(fixed: false).count
        }
    }
    
    
    //MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        
        var memo: Memo!
        if indexPath.section == 0 { //section = 0 일 때 고정된 메모 or 메모.
            if self.navigationItem.searchController?.isActive == true { //search중에는 무조건 section이 하나
                memo = memos[indexPath.row]
                let attributeString4Title = NSMutableAttributedString(string: memo.title) // 텍스트 일부분 색상, 폰트 변경
                let attributeString4Content = NSMutableAttributedString(string: memo.content)
                
                var textFirstIndex4Title: Int = 0 // 검색중인 키워드가 가장 처음으로 나온 인덱스를 저장할 변수 선언.
                var textFirstIndex4Content: Int = 0
                if let textFirstRange4Title = memo.title.range(of: "\(self.text)", options: .caseInsensitive) { // 검색중인 키워드가 있을 때에만 색상 변경 - 검색중인 키워드가 가장 처음으로 일치하는 문자열의 범위를 알아낼 수 있음. (caseInsensitive:대소문자 구분X)
                    textFirstIndex4Title = memo.title.distance(from: text.startIndex, to: textFirstRange4Title.lowerBound) // 거리(인덱스) 구해서 저장.
                    
                    attributeString4Title.addAttribute(.foregroundColor, value: UIColor.orange, range: NSRange(location: textFirstIndex4Title, length: self.text.count)) // 텍스트 색상 변경
                    attributeString4Title.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: cell.titleLabel.font.pointSize), range: NSRange(location: textFirstIndex4Title, length: self.text.count)) // 기존 사이즈 변경 없이 bold처리
                    cell.titleLabel.attributedText = attributeString4Title
                    cell.selectionStyle = .none // 테이블뷰 cell 선택시 배경색상 없애기
                }
                if let textFirstRange4Content = memo.content.range(of: "\(self.text)", options: .caseInsensitive) { // 검색중인 키워드가 있을 때에만 색상 변경 - 검색중인 키워드가 가장 처음으로 일치하는 문자열의 범위를 알아낼 수 있음. (caseInsensitive:대소문자 구분X)
                    textFirstIndex4Content = memo.content.distance(from: text.startIndex, to: textFirstRange4Content.lowerBound) // 거리(인덱스) 구해서 저장.
                    
                    attributeString4Content.addAttribute(.foregroundColor, value: UIColor.orange, range: NSRange(location: textFirstIndex4Content, length: self.text.count)) // 텍스트 색상 변경
                    attributeString4Content.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: cell.contentLabel.font.pointSize), range: NSRange(location: textFirstIndex4Content, length: self.text.count)) // 기존 사이즈 변경 없이 bold처리
                    cell.contentLabel.attributedText = attributeString4Content
                    cell.selectionStyle = .none // 테이블뷰 cell 선택시 배경색상 없애기
                }
            } else {
                let fixedCount = writeViewModel.fetchByFixed(fixed: true).count
                memo = fixedCount > 0 ? writeViewModel.fetchByFixed(fixed: true)[indexPath.row] : writeViewModel.fetchAll()[indexPath.row]
            }
        } else { //section = 1일 때 무조건 고정된 메모 존재. 나머지 고정되지 않은 메모 표시
            memo = writeViewModel.fetchByFixed(fixed: false)[indexPath.row]
        }
        
        //검색하다가 메인으로 돌아와도 색깔 바뀌지 않게 세팅
        if self.navigationItem.searchController?.isActive == false {
            cell.titleLabel.text = memo.title
            cell.contentLabel.text = memo.content
            cell.titleLabel.textColor = .white
            cell.contentLabel.textColor = .lightGray
        }
        
        cell.dateLabel.text = getDateFormat(memodate: memo.date)
        
        return cell
    }
    
    //MARK: - 행 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    //MARK: - didSelectoRowAt
    // 섹션이 0 일 경우
    // case 3개: 1)검색결과 2)고정된 메모 3)메모
    // 섹션이 1 일 경우
    // case 1갸: 메모 (고정되지 않은 메모임)
    
    //각 섹션에 대한 데이터들 , 그리고 indexpath.row(행 번호) 를 writeVC에 전달.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //화면전환 코드 (해당 메모 수정으로 넘어감)
        let vc = WriteViewController()
        if indexPath.section == 0 { //section = 0 일 때 고정된 메모 or 메모.
            if self.navigationItem.searchController?.isActive == true { //search중에는 무조건 section이 하나
//                vc.tasks = tasks
                vc.memo = memos[indexPath.row]
                vc.navTitle = "검색"
            } else {
                let fixedCount = writeViewModel.fetchByFixed(fixed: true).count
//                vc.tasks = fixedCount > 0 ? repository.fetchFilterByFixed(fixed: true) : repository.fetch()
                vc.memo = fixedCount > 0 ? writeViewModel.fetchByFixed(fixed: true)[indexPath.row] : writeViewModel.fetchAll()[indexPath.row]
            }
        } else { //section = 1일 때 무조건 고정된 메모 존재. 나머지 고정되지 않은 메모 표시
//            vc.tasks = repository.fetchFilterByFixed(fixed: false)
            vc.memo = writeViewModel.fetchByFixed(fixed: false)[indexPath.row]
        }
//        vc.index = indexPath.row
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - section header color change
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        header.textLabel?.frame = CGRect(x: 0, y: 0, width: 200, height: header.frame.size.height)
        header.textLabel?.textColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        header.textLabel?.textAlignment = .left
    }
    
    
    //MARK: - 왼쪽 swipe시 고정
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var memo: Memo!
        
        let alert = UIContextualAction(style: .normal, title: "") { [self] action, view, completionHander in
            showAlertMessage(title: "최대 5개의 메모까지 고정할 수 있습니다.")
        }
        
        if indexPath.section == 0 { //section = 0 일 때 고정된 메모 or 메모.
            if self.navigationItem.searchController?.isActive == true {
                memo = memos[indexPath.row]
            } else {
                let fixedCount = writeViewModel.fetchByFixed(fixed: true).count
                memo = fixedCount > 0 ? writeViewModel.fetchByFixed(fixed: true)[indexPath.row] : writeViewModel.fetchAll()[indexPath.row]
            }
        } else { //section = 1일 때 무조건 고정된 메모 존재. 나머지 고정되지 않은 메모 표시
            if writeViewModel.fetchByFixed(fixed: true).count > 4 {
                return UISwipeActionsConfiguration(actions: [alert])
            }
            memo = writeViewModel.fetchByFixed(fixed: false)[indexPath.row]
        }
        
        let fix = UIContextualAction(style: .normal, title: "고정")  { [self] action, view, completionHandler in
            writeViewModel.updateByItem(item: memo)
            getMemoList()
        }
        
        fix.backgroundColor = .orange
        fix.image = UIImage(systemName: memo.fixed ? "pin.slash.fill" : "pin.fill")
        return UISwipeActionsConfiguration(actions: [fix])
    }
    
    //MARK: - 오른쪽 swipe시 삭제
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var memo: Memo!
        
        if indexPath.section == 0 { //section = 0 일 때 고정된 메모 or 메모.
            if self.navigationItem.searchController?.isActive == true {
                memo = memos[indexPath.row] } else {
                    let fixedCount = writeViewModel.fetchByFixed(fixed: true).count
                    memo = fixedCount > 0 ? writeViewModel.fetchByFixed(fixed: true)[indexPath.row] : writeViewModel.fetchAll()[indexPath.row]
                }
        } else { //section = 1일 때 무조건 고정된 메모 존재. 나머지 고정되지 않은 메모 표시
            memo = writeViewModel.fetchByFixed(fixed: false)[indexPath.row]
        }
        
        
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        let showAlert = UIContextualAction(style: .normal, title: "삭제")  { [self] action, view, completionHandler in
            present(alert, animated: true)
        }
        let delete = UIAlertAction(title: "OK", style: .default) { (action) in
            self.writeViewModel.deleteByItem(item: memo)
            self.getMemoList()
        }
        alert.addAction(delete)
        
        showAlert.backgroundColor = .systemRed
        showAlert.image = UIImage(systemName: "trash")
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
