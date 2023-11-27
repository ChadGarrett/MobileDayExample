//
//  UITableViewExtension.swift
//  MobileDayExample
//
//  Created by Chad Garrett on 2023/11/28.
//

import Foundation
import UIKit

extension UITableView {
    func dequeuePokemonCell(at indexPath: IndexPath, pokemon: Pokemon) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = pokemon.name
        config.secondaryText = "Level: \(pokemon.level) - XP: \(pokemon.experience)"
        cell.contentConfiguration = config
        return cell
    }
}
