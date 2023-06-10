//
//  DetailViewModel.swift
//  CryptoAppSwiftUI
//
//  Created by MacBook Air on 04.06.2023.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    
    @Published var overViewStatistics: [StatisticModel] = []
    @Published var additionaltatistics: [StatisticModel] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    @Published var coin: CoinModel
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] (returnedArrays) in
                self?.overViewStatistics = returnedArrays.overview
                self?.additionaltatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
        
        coinDetailService.$coinDetails
            .sink { [weak self] returnedCoinDetails in
                self?.coinDescription = returnedCoinDetails?.readableDescription
                self?.websiteURL = returnedCoinDetails?.links?.homepage?.first
                self?.redditURL = returnedCoinDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistics(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> ((overview: [StatisticModel], additional: [StatisticModel])) {
       
        let overViewArray = createOverView(coinModel: coinModel)
        let additionalArray = createAdditional(coinDetailModel: coinDetailModel, coinModel: coinModel)
        
        return (overViewArray, additionalArray)
    }
    
   private func createOverView(coinModel: CoinModel) -> [StatisticModel] {
       //overview
       
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChanged = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current price", value: price, percentageChange: pricePercentChanged)
        let marketCap = "$ \((coinModel.marketCap?.formattedWithAbbreviations() ?? ""))"
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Cap", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)

        let overviewArray: [StatisticModel] = [
        priceStat, marketCapStat, rankStat, volumeStat
        ]
        return overviewArray
    }
    
   private func createAdditional(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> [StatisticModel]{
        //additional
        
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange2 = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange2)
        let markerCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let markerCapPercentChange2 = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: markerCapChange, percentageChange: markerCapPercentChange2)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let HashingStat = StatisticModel(title: "Hashing Algoritm", value: hashing)
        
        let additionalArray: [StatisticModel] = [
        highStat,
        lowStat,
        priceChangeStat,
        marketCapChangeStat,
        blockStat,
        HashingStat
        ]
        return additionalArray
    }
}
