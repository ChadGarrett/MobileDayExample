//
//  BindTargetController.swift
//  MobileDayExample
//
//  Created by Chad Garrett on 2023/11/28.
//

import Foundation
import RealmSwift
import UIKit

final class AdvancedExampleViewController: SearchController {
    
    // MARK: - Properties
    
    override var searchText: String {
        didSet {
            guard searchText != oldValue else { return }
            searchTextDidUpdate()
        }
    }
    
    private var isNetworkSyncing: Bool = false
    
    // MARK: - Setup
    
    deinit {
        SyncService.instance.stopSyncingPokemon()
        dataProvider.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Advanced Example"
        navigationItem.setRightBarButton(UIBarButtonItem(customView: btnSync), animated: true)
        tableView.sectionHeaderTopPadding = 0.0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.register(PokemonHeaderView.self, forHeaderFooterViewReuseIdentifier: "PokemonHeaderView")
        setupData()
    }
    
    private func setupData() {
        dataProvider.start()
    }
    
    private func searchTextDidUpdate() {
        dataProvider.filter = searchFilter
    }
    
    // MARK: - Data
    
    private lazy var dataProvider: DataProvider<Pokemon> = {
        let provider = DataProvider<Pokemon>(
            bindTo: .tableView(self.tableView),
            basePredicate: NSPredicate(value: true),
            filter: searchFilter,
            sort: sortDescriptor)
        provider.updateDelegate = self
        provider.stateDelegate = self
        return provider
    }()
    
    private var searchFilter: NSPredicate {
        if searchText == "" {
            return NSPredicate(value: true)
        } else {
            return NSPredicate(format: "name LIKE[c] %@", "*\(searchText)*")
        }
    }
    
    private var sortDescriptor: [RealmSwift.SortDescriptor] {
        return [
            SortDescriptor(keyPath: "name"),
            SortDescriptor(keyPath: "level", ascending: true)
        ]
    }
    
    // MARK: - Subviews
    
    private lazy var btnSync: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onToggleSync), for: .touchUpInside)
        button.setImage(UIImage(systemName: "play"), for: .normal)
        return button
    }()
    
    @objc
    private func onToggleSync() {
        isNetworkSyncing ? SyncService.instance.stopSyncingPokemon() : SyncService.instance.startSyncingPokemon()
        
        isNetworkSyncing.toggle()
        
        btnSync.setImage(isNetworkSyncing ? UIImage(systemName: "stop") : UIImage(systemName: "play"), for: .normal)
        navigationItem.setRightBarButton(UIBarButtonItem(customView: btnSync), animated: true)
    }
}

extension AdvancedExampleViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupHeaderView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.query().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon = dataProvider.object(at: indexPath.row)!
        return tableView.dequeuePokemonCell(at: indexPath, pokemon: pokemon)
    }
    
    @discardableResult
    private func setupHeaderView() -> UIView {
        let highestLevel = dataProvider.query().max(of: \.level) ?? 0
        let totalXp = dataProvider.query().sum(of: \.experience)
        
        let headerView = tableView?.headerView(forSection: 0) as? PokemonHeaderView ?? PokemonHeaderView(frame: .zero)
        headerView.configure(maxLevel: highestLevel, totalExperience: totalXp)
        return headerView
    }
}

extension AdvancedExampleViewController: DataProviderDataDelegate {
    func dataProviderDataDidUpdate<T>(_ provider: DataProvider<T>) where T : Object {
        print("Data provider data updated")
        setupHeaderView()
    }
}

extension AdvancedExampleViewController: DataProviderStateDelegate {
    func dataProviderStateDidUpdate(to state: DataProviderState) {
        print("Data provider state: \(state)")
    }
}
