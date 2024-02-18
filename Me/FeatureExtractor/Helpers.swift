//
//  Helpers.swift
//  Me
//
//  Created by Artem on 17.02.2024.
//

import Foundation

struct Helpers {
    static func printError(from results: [EvalResult]) {
        print("Изменение этих параметров искажают значение таргета на кол-во процентов")
        let rmse = results.sorted(by: { $0.rmse < $1.rmse })
        print("RMSE")
        rmse.forEach {
            print("\($0.feature): \(String(format: "%.2f", ($0.rmse * 100)))%")
        }
        print("")
        let maxError = results.sorted(by: { $0.maxError < $1.maxError })
        print("MAX")
        maxError.forEach {
            print("\($0.feature): \(String(format: "%.2f", ($0.maxError * 100)))%")
        }
        
    }

    static func printError(from result: EvalResult) {
        print("Error ", (String(format: "%.2f", result.rmse * 100)), "%\n" )
    }
}
