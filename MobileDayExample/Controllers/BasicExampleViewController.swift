//
//  ViewController.swift
//  MobileDayExample
//
//  Created by Chad Garrett on 2023/11/27.
//

import UIKit
import RealmSwift

class BasicExampleViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var realm: Realm
    private var token: NotificationToken?
    
    init() {
        self.realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MemoryRealm"))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        token?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Basic Example"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        navigationItem.setRightBarButton(btnAddPokemon, animated: true)
        start()
    }
    
    private func start() {
        let results = realm.objects(Pokemon.self)
        token = results.observe { [tableView] changes in
            switch changes {
            case .initial:
                tableView?.reloadData()
                
            case .update(_, let deletions, let insertions, let modifications):
                tableView?.performBatchUpdates({
                    tableView?.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                    tableView?.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    tableView?.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                }, completion: nil)
                
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private lazy var btnAddPokemon: UIBarButtonItem = {
        let button = UIBarButtonItem(systemItem: .add)
        button.target = self
        button.action = #selector(addNewPokemon)
        return button
    }()
    
    @objc
    private func addNewPokemon() {
        let pokemon = Pokemon()
        pokemon.name = "Pokemon \(Int.random(in: 100..<1000))"
        pokemon.level = Int.random(in: 0..<99)
        pokemon.experience = Int.random(in: 1000..<10_000)
        
        try? realm.write {
            realm.add(pokemon)
        }
    }
    
    private func deletePokemon(at indexPath: IndexPath) {
        let pokemon = realm.objects(Pokemon.self)[indexPath.item]
        
        try? realm.write {
            realm.delete(pokemon)
        }
    }
}





















extension BasicExampleViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(Pokemon.self).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon = realm.objects(Pokemon.self)[indexPath.item]
        return tableView.dequeuePokemonCell(at: indexPath, pokemon: pokemon)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, onComplete in
            self.deletePokemon(at: indexPath)
            onComplete(true)
        }
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
}
