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
import TabularData

struct FeaturesChartView: View {
    @State var viewModel: FeatureChartViewModel
    @State var newPrice = ""
    @State var solar = ""
    @State var green = ""
    @State var size = ""
    @State var mood = ""
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    TextField(text: $newPrice) {
                        Text("Price")
                    }
                    TextField("Solar", text: $solar)
                    TextField("Green", text: $green)
                    TextField("Size", text: $size)
                    TextField("Mood", text: $mood)
                    
                    Button("Save") {
                        guard let price = Int(newPrice),
                              let solarPanels = Double(solar),
                              let green = Double(green),
                              let size = Int(size),
                              let mood = Double(mood) else {
                            return
                        }
                        let house = House(price: price,
                                          solarPanels: solarPanels,
                                          greenhouses: green,
                                          size: size,
                                          mood: mood)
                        viewModel.addNew(row: house)
                        viewModel.getData()
                    }
                    .disabled(newPrice.isEmpty || solar.isEmpty || green.isEmpty || size.isEmpty || mood.isEmpty)
                    .buttonStyle(BorderedButtonStyle())
                    

                    
                    Button("Retrain") {
                        viewModel.getData()
                    }
                    .buttonStyle(BorderedButtonStyle())
                }

                VStack {
                    Text("Train MSE %")
                    Chart {
                        ForEach(viewModel.data) { datum in
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
                        ForEach(viewModel.data) { datum in
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
        .onAppear {
            viewModel.getData()
        }
    }
}

@Observable
class FeatureChartViewModel {
    var data = [Mse]()
    let fileName = "PlanetsData"
    
    func addNew(row: House) {
        do {
            let jsonUrl = try Helpers.getJsonUrl(fileName: fileName)
            try Helpers.appendNew(row: row, path: jsonUrl.path())
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func getData() {
        do {
            
            let columns = ["price", "solarPanels", "greenhouses", "size", "mood"]
            try Helpers.writeJsonToDocumentsIfEmpty(fileName: fileName)
            let jsonUrl = try Helpers.getJsonUrl(fileName: fileName)
            let dataFrame = try DataFrame(contentsOfJSONFile: jsonUrl, columns: columns)
            print(dataFrame)
            
            let regressor = try Regressors.trainLinearRegressor(dataFrame: dataFrame,
                                                                targetColumn: "mood",
                                                                l1Penalty: 1)
            
//            let sum = dataFrame.summary(of: "price")
//            print(sum["median"].first!.unsafelyUnwrapped as Int)
            
            let params = EvalParameters(maxRowsCount: dataFrame.rows.count,
                                        normalized: true,
                                        percentValue: true)
            data.removeAll()
            try House.FeatureEnum.allCases.forEach {
                let result = try Predictor.getFeatureImportance(
                    dataFrame: dataFrame,
                    featureName: $0.description,
                    regressor: regressor,
                    parameters: params)
                
                data.append(result)
            }
        } catch {
            print(error)
        }
    }
}

#Preview {
    FeaturesChartView(viewModel: FeatureChartViewModel())
}

// TODO
// Если для новой строки не хватает значения столбца, можно взять медиану от всех строк для данного столбца
// использовать значения вчерашнего дня, позавчера, позапоза, среднее за неделю для некоторых полей. Шаги, зарядка, сладкое, порно

// At least 50 times as many rows as the number of columns for Accurate inferense
// Если мало строк, то evaluate нужно будет делать несколько раз и взять среднюю ошибку

// засунуть в интерфейс результат сегодняшнего дня при помощи regressor.predictions(from: DataFrame)
