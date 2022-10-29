//
//  UserMemoRepository.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/08/31.
//

import Foundation
import RealmSwift

//realm 관련 여기로 몰아두기(리팩토링)

class UserMemoRepositoryType {
    
    //MARK: - 메모 최신순으로 정렬
    func fetch() -> Results<UserMemo> {
        return localRealm.objects(UserMemo.self).sorted(byKeyPath: "memoDate", ascending: false)
    }
    
//    var localRealm = try! Realm()
    
    
    let config = Realm.Configuration(
        schemaVersion: 1,
        
        migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 1) {
                migration.enumerateObjects(ofType: UserMemo.className()) { oldObject, newObject in
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
                migration.enumerateObjects(ofType: UserMemo.className()) { oldObject, newObject in
                    newObject!["fixed"] = false
                }
            }
            
//            Realm.Configuration.defaultConfiguration = config
        }
    ))

    //MARK: - 메모삭제
    func delete(item: UserMemo) {
        do {
            try self.localRealm.write {
                self.localRealm.delete(item)
            }
        } catch let error {
            print(error)
        }
    }
    
    //MARK: - 메모추가
    func addMemo(title: String, content: String) {
        let data = UserMemo(memoTitle: title, memoContent: content, memoDate: Date())

        do {
            try localRealm.write {
                localRealm.add(data)
            }
        } catch let error {
            print(error)
        }
    }
    
    //MARK: - 서치바에서 텍스트 찾을 때, realm 저장된 메모 내용 중 해당 글씨 들어있는 경우
    func fetchFilterinSearch(_ item: String) -> Results<UserMemo> {
        return self.localRealm.objects(UserMemo.self).filter("memoTitle CONTAINS '\(item)' OR memoContent CONTAINS '\(item)'")
    }
    
    func fetchFilterByFixed(fixed: Bool) -> Results<UserMemo> {
        return self.localRealm.objects(UserMemo.self).filter("fixed=\(fixed)")
    }
    
    
    //MARK: - 고정시
    func updateFixed(item: UserMemo) {
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
    func modify(item: UserMemo, title: String, content: String) {
        //realm data update (고정 true/false에 따라). 데이터 변경시에 항상 써야함
        
        do {
            try self.localRealm.write {
                //하나의 레코드에서 특정 컬럼 하나만 변경
                item.memoTitle = title
                item.memoContent = content
            }
        } catch let error {
            print(error)
        }
    }
    
}

