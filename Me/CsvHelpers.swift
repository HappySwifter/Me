//
//  CsvHelpers.swift
//  Me
//
//  Created by Artem on 23.02.2024.
//

import Foundation
import TabularData
import OSLog
import SwiftData
import SwiftUI

struct CsvHelpers {
    
    enum CsvError: Error {
        case badUrl
        case countMismatch
        case noFile
        case fileAlreadyExits
        case unsupportedType
    }
    
    private let fileManager: FileManager
    private let modelContext: ModelContext
    
    private let logger = Logger(subsystem: "Me", category: "CsvHelpers")
    
    init(fileManager: FileManager, modelContext: ModelContext) {
        self.fileManager = fileManager
        self.modelContext = modelContext
    }
    
    func getCsvUrl() throws -> URL {
        return try fileManager
            .url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            .appendingPathComponent("CSVRec.csv")
    }
    
    func getDataFrame() throws -> DataFrame {
        let url = try getCsvUrl()
        if let df = try? DataFrame(contentsOfCSVFile: url) {
            return df
        } else {
            try DataFrame().writeCSV(to: url)
            return try DataFrame(contentsOfCSVFile: url)
        }
    }
    
    func save(dataFrame: DataFrame) throws {
        let url = try getCsvUrl()
        try dataFrame.writeCSV(to: url)
    }
    
    func getFeatures() throws -> [Feature] {
        let dataFrame = try getDataFrame()
        let desc = FetchDescriptor<Feature>()
        let features = try modelContext.fetch(desc)
        
        guard dataFrame.columns.count == features.count else {
            throw CsvError.countMismatch
        }
        return features
    }
    
    func add<T>(feature: Feature, value: Item<T>) throws {
        logger.info("Adding new feature. Name: \(feature.name)")
        var dataFrame = try getDataFrame()
        logger.info("Saving to DF:\n \(dataFrame)")
        let rowsCount = dataFrame.rows.count
        let contents = Array(repeating: value.value, count: rowsCount == 0 ? 1 : rowsCount)
        let column = Column(name: feature.name, contents: contents)
        if !dataFrame.containsColumn(feature.name) {
            dataFrame.append(column: column)
        }
        logger.info("Updated DF:\n\(dataFrame)")
        try save(dataFrame: dataFrame)
    }
        
    func add<T>(row: [Item<T>]) throws {
        var dataFrame = try getDataFrame()
        var dict = [String: Any]()
        for item in row {
            dict[item.featureName] = item.value
        }
        dataFrame.append(valuesByColumn: dict)
        logger.info("Added new row:\n\(dataFrame)")
        try save(dataFrame: dataFrame)
    }
}
