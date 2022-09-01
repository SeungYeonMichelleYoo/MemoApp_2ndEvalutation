//
//  FileManager + Extension.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/09/01.
//

import UIKit

extension UIViewController {
    
    
    func documentDirectoryPath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } //Document 경로
        return documentDirectory
    }
    
    
}

