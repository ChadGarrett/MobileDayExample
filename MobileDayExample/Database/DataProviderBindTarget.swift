//
//  DataProviderBindTarget.swift
//  MobileDayExample
//
//  Created by Chad Garrett on 2023/11/28.
//

import Foundation
import UIKit

enum DataProviderBindTarget {
    case none
    case tableView(UITableView)
    case collectionView(UICollectionView)
}

extension DataProviderBindTarget {
    func handleInitialUpdate() {
        switch self {
        case .none:
            break
            
        case .tableView(let tableView):
            self.handleInitialUpdate(tableView)
            
        case .collectionView(let collectionView):
            self.handleInitialUpdate(collectionView)
        }
    }
    
    func handleUpdates(deletions: [Int], insertions: [Int], modifications: [Int]) {
        switch self {
        case .none:
            break
            
        case .tableView(let tableView):
            self.handleUpdates(tableView, 
                               deletions: deletions, insertions: insertions, modifications: modifications)
            
        case .collectionView(let collectionView):
            self.handleUpdates(collectionView,
                               deletions: deletions, insertions: insertions, modifications: modifications)
        }
    }
}

// MARK: - UITableView

extension DataProviderBindTarget {
    private func handleInitialUpdate(_ tableView: UITableView) {
        tableView.reloadData()
    }
    
    private func handleUpdates(_ tableView: UITableView, deletions: [Int], insertions: [Int], modifications: [Int]) {
        tableView.beginUpdates()
        
        tableView.insertRows(
            at: insertions.map({ IndexPath(row: $0, section: 0) }),
            with: .automatic)
        
        tableView.deleteRows(
            at: deletions.map({ IndexPath(row: $0, section: 0) }),
            with: .automatic)
        
        tableView.reloadRows(
            at: modifications.map({ IndexPath(row: $0, section: 0) }),
            with: .automatic)
        
        tableView.endUpdates()
    }
}

// MARK: - UICollectionView

extension DataProviderBindTarget {
    private func handleInitialUpdate(_ collectionView: UICollectionView) {
        collectionView.reloadData()
    }
    
    private func handleUpdates(_ collectionView: UICollectionView, deletions: [Int], insertions: [Int], modifications: [Int]) {
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
            collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
            collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
        }, completion: nil)
    }
}
