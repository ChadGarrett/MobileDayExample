//
//  PokemonService.swift
//  MobileDayExample
//
//  Created by Chad Garrett on 2023/11/28.
//

import Alamofire
import Foundation

final class PokemonService {
    let serverTrustManager = ServerTrustManager(evaluators: ["localhost": DisabledTrustEvaluator()])
    lazy var session: Session = Session(serverTrustManager: serverTrustManager)
    
    func getPokemon() async throws -> Pokemon {
        let request = session.request("http://localhost:8000").serializingDecodable(Pokemon.self)
        return try await request.value
    }
}
