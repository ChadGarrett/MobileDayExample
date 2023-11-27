//
//  SyncService.swift
//  MobileDayExample
//
//  Created by Chad Garrett on 2023/11/28.
//

import Foundation
import RealmSwift

final class SyncService {
    static let instance = SyncService()
    
    private var pokemonService = PokemonService()
    private var timer: Timer?
    
    private init() {}
    
    deinit {
        timer?.invalidate()
    }
    
    private func fetchAndStorePokemon() {
        Task {
            do {
                let pokemon = try await pokemonService.getPokemon()
                handleSuccessfulSync(pokemon)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func handleSuccessfulSync(_ pokemon: Pokemon) {
        DispatchQueue.global(qos: .default).async {
            let realm = try! Realm()
            try! realm.write {
                realm.add(pokemon)
            }
        }
    }
    
    func startSyncingPokemon() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            withTimeInterval: 3.0,
            repeats: true,
            block: { [weak self] _ in
                self?.fetchAndStorePokemon()
            })
    }
    
    func stopSyncingPokemon() {
        timer?.invalidate()
    }
}
