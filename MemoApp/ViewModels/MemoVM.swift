//
//  MemoVM.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/10/29.
//
import Foundation
import RealmSwift

class MemoVM {
    var memos: [Memo] = []
    
    var tasks: Results<Memo>!
    
    init() {
        fetchAll()
    }
    
    let repository = UserMemoRepositoryType()

    func saveOrDelete(memo: Memo, text: String) -> Memo {
        if text.count > 0 {
            let strList = text.components(separatedBy: .newlines) // \n을 바탕으로 배열로 만듬
            var title = ""
            var content = ""
            if (strList.count > 0) {
                title = strList[0]
                
                if (strList.count > 1) {
                    for i in 1...strList.count-1 {
                        content += strList[i] + "\n"
                    }
                    content = content.trimmingCharacters(in: .whitespacesAndNewlines) //마지막 \n 없애기
                }
            }
            if (memo.title == "") { // new memo
                return repository.addMemo(title: title, content: content)
            } else { // modify memo
                repository.modify(item: memo, title: title, content: content)
            }
        } else {
            deleteByItem(item: memo)
            self.tasks = repository.fetch()
            return Memo()
        }
        return memo
    }
    
    //특정 행에 대한 메모 가져오기
    func fetchMemo(index: Int) -> Memo {
        fetchAll()
        return tasks[index]
    }
    
    func fetchAll() -> [Memo] {
        tasks = repository.fetch()
        return returnMemos()
    }
    
    func fetchByKeyword(word: String) -> [Memo] {
        tasks = repository.fetchFilterinSearch(word)
        return returnMemos()
    }
    
    func fetchByFixed(fixed: Bool) -> [Memo] {
        tasks = repository.fetchFilterByFixed(fixed: fixed)
        return returnMemos()
    }
    
    func deleteByItem(item: Memo) {
        repository.delete(item: item)
    }
    
    func updateByItem(item: Memo) {
        repository.updateFixed(item: item)
    }
    
    func returnMemos() -> [Memo] {
        memos = []
        for task in tasks {
            memos.append(task)
        }
        return memos
    }
}
