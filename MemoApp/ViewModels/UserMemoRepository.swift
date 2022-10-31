//
//  UserMemoRepository.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/08/31.
//

import Foundation
import RealmSwift
import SwiftUI

//realm 관련 여기로 몰아두기(리팩토링)

class UserMemoRepositoryType {
    
    //MARK: - 메모 최신순으로 정렬
    func fetch() -> Results<Memo> {
        return localRealm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false)
    }
    
    func checkData(userMemo: Memo) -> Bool {
        return self.localRealm.objects(Memo.self).contains(userMemo)
    }
    
//    var localRealm = try! Realm()
    
    
    let config = Realm.Configuration(
        schemaVersion: 1,
        
        migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 1) {
                migration.enumerateObjects(ofType: Memo.className()) { oldObject, newObject in
                    newObject!["fixed"] = false
                }
            }
            
//            Realm.Configuration.defaultConfiguration = config
        }
    )
    let localRealm = try! Realm(configuration: Realm.Configuration(
        schemaVersion: 1,
        
        migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 1) {
                migration.enumerateObjects(ofType: Memo.className()) { oldObject, newObject in
                    newObject!["fixed"] = false
                }
            }
            
//            Realm.Configuration.defaultConfiguration = config
        }
    ))

    //MARK: - 메모삭제
    func delete(item: Memo) {
        do {
            try! self.localRealm.write {
                if self.checkData(userMemo: item) {
                    self.localRealm.delete(item)
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    //MARK: - 메모추가
    func addMemo(title: String, content: String) -> Memo {
        let data = Memo(title: title, content: content, date: Date())

        do {
            try localRealm.write {
                localRealm.add(data)
            }
        } catch let error {
            print(error)
        }
        return data
    }
    
    //MARK: - 서치바에서 텍스트 찾을 때, realm 저장된 메모 내용 중 해당 글씨 들어있는 경우
    func fetchFilterinSearch(_ item: String) -> Results<Memo> {
        return self.localRealm.objects(Memo.self).filter("title CONTAINS '\(item)' OR content CONTAINS '\(item)'")
    }
    
    func fetchFilterByFixed(fixed: Bool) -> Results<Memo> {
        return self.localRealm.objects(Memo.self).filter("fixed=\(fixed)")
    }
    
    
    //MARK: - 고정시
    func updateFixed(item: Memo) {
        //realm data update (고정 true/false에 따라). 데이터 변경시에 항상 써야함

        do {
            try self.localRealm.write {
                //하나의 레코드에서 특정 컬럼 하나만 변경
                item.fixed = !item.fixed
            }
        } catch let error {
            print(error)
        }
    }

    
    //MARK: - 수정시
    func modify(item: Memo, title: String, content: String) {
        //realm data update (고정 true/false에 따라). 데이터 변경시에 항상 써야함
        
        do {
            try self.localRealm.write {
                //하나의 레코드에서 특정 컬럼 하나만 변경
                item.title = title
                item.content = content
            }
        } catch let error {
            print(error)
        }
    }
    
}

