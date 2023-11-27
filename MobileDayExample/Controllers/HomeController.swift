//
//  HomeController.swift
//  MobileDayExample
//
//  Created by Chad Garrett on 2023/11/28.
//

import Foundation
import UIKit
import RealmSwift

final class HomeController: UITableViewController {
    
    enum MenuItem: Int, CaseIterable {
        case basicExample
        case advancedExample
        case reset
        
        var title: String {
            switch self {
            case .basicExample: return "Basic example"
            case .advancedExample: return "Advanced example"
            case .reset: return "Reset"
            }
        }
        
        var hasChevron: Bool {
            switch self {
            case .basicExample, .advancedExample: return true
            case .reset: return false
            }
        }
        
        var image: UIImage? {
            switch self {
            case .basicExample: return UIImage(systemName: "1.circle")
            case .advancedExample: return UIImage(systemName: "2.circle")
            case .reset: return UIImage(systemName: "trash")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mobile Day"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
}

extension HomeController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuItem.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let controller = MenuItem.allCases[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.selectionStyle = .blue
        var config = cell.defaultContentConfiguration()
        config.image = controller.image
        config.text = controller.title
        cell.accessoryType = controller.hasChevron ? .disclosureIndicator : .none
        cell.contentConfiguration = config
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = MenuItem.allCases[indexPath.item]
        switch controller {
        case .basicExample:
            let controller = BasicExampleViewController()
            navigationController?.pushViewController(controller, animated: true)
        case .advancedExample:
            let controller = AdvancedExampleViewController()
            navigationController?.pushViewController(controller, animated: true)
        case .reset:
            resetApp()
        }
    }
    
    private func resetApp() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
