//
//  MarketDataService.swift
//  CryptoAppSwiftUI
//
//  Created by MacBook Air on 01.06.2023.
//

import Foundation
import Combine

class MarketDataService {
    @Published var marketData: MarketDataModel?  = nil
    //var cancellables = Set<AnyCancellable>()
    
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getData()
    }
    
     func getData() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: {[weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
            

        
        
    }
}
