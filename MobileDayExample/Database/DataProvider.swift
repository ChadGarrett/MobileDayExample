//
//  DataProvider.swift
//  MobileDayExample
//
//  Created by Chad Garrett on 2023/11/28.
//

import Foundation
import RealmSwift

enum DataProviderState {
    case started
    case stopped
}

protocol DataProviderStateDelegate: AnyObject {
    func dataProviderStateDidUpdate(to state: DataProviderState)
}

protocol DataProviderDataDelegate: AnyObject {
    func dataProviderDataDidUpdate<T>(_ provider: DataProvider<T>)
}

class DataProvider<T: Object> {
    typealias QueryOptions = DataProviderQueryOptions
    
    // MARK: - Delegates
    
    weak var stateDelegate: DataProviderStateDelegate?
    weak var updateDelegate: DataProviderDataDelegate?
    
    // MARK: - Properties
    
    private var bindTarget: DataProviderBindTarget
    private var limit: Int?
    private var token: NotificationToken?
    
    private var state: DataProviderState = .stopped {
        didSet { stateDidUpdate() }
    }
    
    var basePredicate: NSPredicate = NSPredicate(value: true) {
        didSet {
            if self.basePredicate != oldValue,
               self.token != nil {
                restart()
            }
        }
    }
    
    var filter: NSPredicate = NSPredicate(value: true) {
        didSet {
            if self.filter != oldValue,
               self.token != nil {
                restart()
            }
        }
    }
    
    var sort: [RealmSwift.SortDescriptor] = [] {
        didSet {
            if self.sort != oldValue,
               self.token != nil {
                restart()
            }
        }
    }
    
    // MARK: - Setup
    
    init(bindTo target: DataProviderBindTarget, basePredicate: NSPredicate, filter: NSPredicate, sort: [RealmSwift.SortDescriptor]) {
        self.bindTarget = target
        self.basePredicate = basePredicate
        self.filter = filter
        self.sort = sort
    }
    
    private typealias QueryAndRealm = (query: Results<T>, realm: Realm)
    
    private func queryAndRealm(options: QueryOptions = .default) -> QueryAndRealm {
        let realm = try! Realm()
        realm.refresh()
        let query = realm
            .objects(T.self)
            .filter(basePredicate)
            .filter(options.isFiltered ? filter : NSPredicate(value: true))
            .sorted(by: options.isSorted ? sort : [])
        return (query: query, realm: realm)
    }
    
    func query(_ options: QueryOptions = .default) -> Results<T> {
        return queryAndRealm(options: options).query
    }
    
    func object(at index: Int, refresh: Bool = false) -> T? {
        return item(at: index, refresh: refresh)
    }
    
    private func item(at index: Int, refresh: Bool = false) -> T? {
        let (results, _) = queryAndRealm()
        
        guard index < results.count
        else { return nil }
        
        return results[index]
    }
    
    func start() {
        self.token?.invalidate()
        self.token = self.query().observe { [weak self] (changes: RealmCollectionChange) in
            DispatchQueue.main.async { [weak self] in
                switch changes {
                case .initial:
                    self?.bindTarget.handleInitialUpdate()
                    if let self {
                        self.updateDelegate?.dataProviderDataDidUpdate(self)
                    }
                    
                case .update(_, let deletions, let insertions, let modifications):
                    self?.bindTarget.handleUpdates(deletions: deletions, insertions: insertions, modifications: modifications)
                    if let self {
                        self.updateDelegate?.dataProviderDataDidUpdate(self)
                    }
                    
                case .error(let error):
                    print(error.localizedDescription)
                }
            }
        }
        self.state = .started
    }
    
    func stop() {
        token?.invalidate()
        state = .stopped
    }
    
    func restart() {
        self.token?.invalidate()
        self.start()
    }
    
    // MARK: - Notifiers
    
    private func stateDidUpdate() {
        stateDelegate?.dataProviderStateDidUpdate(to: state)
    }
}


