//
//  MemoModel.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/10/29.
//

import Foundation

struct MemoList {
    let memos: [MemoModel]
}

struct MemoModel {
    let memoTitle: String //제목(필수)
    let memoContent: String //내용(필수)
    let memoDate = Date() //등록 날짜(필수)
    let fixed: Bool //고정(옵션)
}
