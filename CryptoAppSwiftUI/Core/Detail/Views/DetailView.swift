//
//  DetailView.swift
//  CryptoAppSwiftUI
//
//  Created by MacBook Air on 04.06.2023.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    @State private var showFullDescription: Bool = false
    @StateObject private var vm: DetailViewModel
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    private let spacing: CGFloat = 30
    
    
    init(coin: CoinModel) {
        self._vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    var body: some View {
        ZStack {
            ScrollView {
                
                VStack {
                    ChartView(coin: vm.coin)
                        .padding(.vertical)
                    VStack(spacing: 20) {
                          
                        overview
                        Divider()
                        
                        descriptionSection
                        
                        overViewGrid
                        
                        additionalTitle
                        Divider()
                        
                        additionalGrid
                        
                        VStack(alignment: .leading, spacing: 20) {
                            if let websiteString = vm.websiteURL,
                               let url = URL(string: websiteString) {
                                Link("Website", destination: url)
                            }
                            if let redditString = vm.redditURL,
                               let url = URL(string: redditString) {
                                Link("Reddit", destination: url)
                            }
                                
                        }
                        .tint(.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.headline)
                    }
                    .padding()
                }
            }
            .background(Color.theme.background.ignoresSafeArea())
            .navigationTitle(vm.coin.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    navigationBarTrailingItems
                }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}

extension DetailView {
    private var overview: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth:.infinity, alignment: .leading)
        
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth:.infinity, alignment: .leading)
    }
    
    private var descriptionSection: some View {
        ZStack {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Button {
                        withAnimation(.easeOut) {
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Less" :  "Read more...")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.vertical, 4)
                    }
                    .tint(.blue)

                }
                .frame(width: .infinity, alignment: .leading)
                
            }
        }
    }
    
    private var overViewGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: []) {
            
            ForEach(vm.overViewStatistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    private var additionalGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: []) {
            ForEach(vm.additionaltatistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    private var navigationBarTrailingItems: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
}
