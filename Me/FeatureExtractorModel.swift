////
////  FeatureExtractorModel.swift
////  Me
////
////  Created by Artem on 23.02.2024.
////
//
//import Foundation
//import CreateML
//import FeatureImportance
//import TabularData
//import SwiftUI
//import Charts
//
//struct FeaturesChartView: View {
//    @State var viewModel: FeatureExtractorModel
//    //    @EnvironmentObject var healthStore: HKHealthStore
//    @State var newPrice = ""
//    @State var solar = ""
//    @State var green = ""
//    @State var size = ""
//    @State var mood = ""
//    
//    var body: some View {
//        ScrollView {
//            HStack {
//                VStack(alignment: .leading) {
//                    Text("Rows count: \(viewModel.dataFrame?.rows.count ?? 0)")
//                    TextField(text: $newPrice) {
//                        Text("Price")
//                    }
//                    TextField("Solar", text: $solar)
//                    TextField("Green", text: $green)
//                    TextField("Size", text: $size)
//                    TextField("Mood", text: $mood)
//                    
//                    Button("Save") {
//                        guard let price = Int(newPrice),
//                              let solarPanels = Double(solar),
//                              let green = Double(green),
//                              let size = Int(size),
//                              let mood = Double(mood) else {
//                            return
//                        }
//                        let house = House(price: price,
//                                          solarPanels: solarPanels,
//                                          greenhouses: green,
//                                          size: size,
//                                          mood: mood)
//                        viewModel.addNew(row: house)
//                        viewModel.getData()
//                    }
//                    .disabled(newPrice.isEmpty || solar.isEmpty || green.isEmpty || size.isEmpty || mood.isEmpty)
//                    .buttonStyle(BorderedButtonStyle())
//                    
//                    
//                    Button("Retrain") {
//                        viewModel.getData()
//                    }
//                    .buttonStyle(BorderedButtonStyle())
//                }
//                
//                VStack {
//                    Text("Train MSE %")
//                    Chart {
//                        ForEach(viewModel.data) { datum in
//                            BarMark(x: .value("Type", datum.feature),
//                                    y: .value("Value", datum.train))
//                            .foregroundStyle(by: .value("Type", datum.feature))
//                            .opacity(0.5)
//                            .annotation() {
//                                Text(datum.feature.prefix(5))
//                                    .foregroundColor(.gray)
//                                
//                            }
//                        }
//                    }
//                    .aspectRatio(1, contentMode: .fit)
//                }
//                
//                VStack {
//                    Text("Validate MSE %")
//                    Chart {
//                        ForEach(viewModel.data) { datum in
//                            BarMark(x: .value("Type", datum.feature),
//                                    y: .value("Value", datum.validate))
//                            .foregroundStyle(by: .value("Type", datum.feature))
//                            .opacity(0.5)
//                            .annotation() {
//                                Text(datum.feature.prefix(5))
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                    }
//                    .aspectRatio(1, contentMode: .fit)
//                }
//            }
//            .padding()
//            
//            
//        }
//        .onAppear {
//            //            viewModel.getData()
//        }
//    }
//}
//
//
//@Observable
//class FeatureExtractorModel {
//    var data = [Mse]()
//    let fileName = "PlanetsData"
//    var dataFrame: DataFrame?
//    
//    private func printRegrMetrics(title: String, metr: MLRegressorMetrics) {
//        func x2(_ val: Double) -> String { String(format: "%.2f", val) }
//        print(title, " RMSE:", x2(metr.rootMeanSquaredError * 100), "MAX:", x2(metr.maximumError * 100))
//    }
//    
//    
//    func getData() {
//        do {
//            let columns = ["price", "solarPanels", "greenhouses", "size", "mood"]
//            try Helpers.writeJsonToDocumentsIfEmpty(fileName: fileName)
//            let jsonUrl = try Helpers.getJsonUrl(fileName: fileName)
//            let dataFrame = try DataFrame(contentsOfJSONFile: jsonUrl, columns: columns)
//            self.dataFrame = dataFrame
//            print(dataFrame)
//            
//            let regressor = try Regressors.trainLinearRegressor(dataFrame: dataFrame,
//                                                                targetColumn: "mood",
//                                                                l1Penalty: 1)
//            
//            
//            printRegrMetrics(title: "Train LinearRegressor", metr: regressor.trainingMetrics)
//            printRegrMetrics(title: "Validate LinearRegressor", metr: regressor.validationMetrics)
//            
//            let params = EvaluationParameters(maxRowsCount: dataFrame.rows.count,
//                                              normalized: true,
//                                              percentValue: true)
//            data.removeAll()
//            try House.FeatureEnum.allCases.forEach {
//                let result = try FeatureImportance.evaluate(
//                    on: dataFrame,
//                    featureName: $0.description,
//                    regressor: regressor,
//                    parameters: params)
//                
//                data.append(result)
//            }
//        } catch {
//            print(error)
//        }
//    }
//    
//    func addNew(row: House) {
//        do {
//            let jsonUrl = try Helpers.getJsonUrl(fileName: fileName)
//            try Helpers.appendNew(row: row, path: jsonUrl.path())
//        } catch {
//            print(error.localizedDescription)
//            
//        }
//    }
//}
