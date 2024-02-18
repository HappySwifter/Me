//
//  Helpers.swift
//  Me
//
//  Created by Artem on 18.02.2024.
//

import Foundation

struct Helpers {
    enum FileError: Error {
        case noFile
        case fileSaveError
    }
    
    static let fileManager = FileManager.default

    static func getJsonUrl(fileName: String) throws -> URL {
        let docDir = try fileManager.url(for: .documentDirectory,
                                                 in: .userDomainMask,
                                                 appropriateFor: nil,
                                                 create: false)
        return docDir.appending(path: fileName).appendingPathExtension("json")
    }

    static func appendNew(row: House, path: String) throws {
        if let data = fileManager.contents(atPath: path) {
            var houses = try JSONDecoder().decode([House].self, from: data)
            houses.append(row)
            let newData = try JSONEncoder().encode(houses)
            if !fileManager.createFile(atPath: path, contents: newData) {
                throw FileError.fileSaveError
            }
        } else {
            throw FileError.noFile
        }
    }

    static func writeJsonToDocumentsIfEmpty(fileName: String) throws {
        let jsonUrl = try getJsonUrl(fileName: fileName)
        if !fileManager.fileExists(atPath: jsonUrl.path()) {
            let mockFileURL = Bundle.main.url(forResource: fileName, withExtension: "json")!
            let data = try Data(contentsOf: mockFileURL)
            if !fileManager.createFile(atPath: jsonUrl.path(), contents: data) {
                throw FileError.fileSaveError
            }
        }
    }
}

