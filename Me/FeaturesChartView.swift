//
//  FeaturesChartView.swift
//  Me
//
//  Created by Artem on 18.02.2024.
//

import Foundation
import Charts
import SwiftUI
import FeatureExtractor

struct FeaturesChartView: View {
    let data: [Mse]
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Text("Train MSE %")
                    Chart {
                        ForEach(data) { datum in
                            BarMark(x: .value("Type", datum.feature),
                                    y: .value("Value", datum.train))
                            .foregroundStyle(by: .value("Type", datum.feature))
                            .opacity(0.5)
                            .annotation() {
                                Text(datum.feature.prefix(5))
                                    .foregroundColor(.gray)
                                    
                            }
                        }
                    }
                    .aspectRatio(1, contentMode: .fit)
                }
                
                VStack {
                    Text("Validate MSE %")
                    Chart {
                        ForEach(data) { datum in
                            BarMark(x: .value("Type", datum.feature),
                                    y: .value("Value", datum.validate))
                            .foregroundStyle(by: .value("Type", datum.feature))
                            .opacity(0.5)
                            .annotation() {
                                Text(datum.feature.prefix(5))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .aspectRatio(1, contentMode: .fit)
                }
            }
            .padding()
        }
    }
}

#Preview {
    FeaturesChartView(data: [])
}
