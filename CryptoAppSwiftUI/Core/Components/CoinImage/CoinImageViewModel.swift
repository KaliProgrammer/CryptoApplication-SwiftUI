//
//  CoinImageViewModel.swift
//  CryptoAppSwiftUI
//
//  Created by MacBook Air on 24.05.2023.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = true
    private var cancellables = Set<AnyCancellable>()
    
    private let coin: CoinModel
    private let coinImageService: CoinImageService
    
    init(coin: CoinModel) {
        self.coinImageService = CoinImageService(coin: coin)
        self.coin = coin
        loadImage()
    }
    
    private func loadImage() {
        coinImageService.$image
            .sink { _ in
                self.isLoading = false
            } receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
            }
            .store(in: &cancellables)
    }
}
