//
//  HomeStatesView.swift
//  CryptoAppSwiftUI
//
//  Created by MacBook Air on 26.05.2023.
//

import SwiftUI

struct HomeStatesView: View {
   
    @EnvironmentObject private var vm: HomeViewModel
    
    @Binding var showPortfolio: Bool
    
    
    var body: some View {
        HStack {
            ForEach(vm.statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width/3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading
        )
    }
}

struct HomeStatesView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatesView(showPortfolio: .constant(false))
            .environmentObject(dev.homeVM)
    }
}
