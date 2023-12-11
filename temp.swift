//
//  temp.swift
//  LP Training
//
//  Created by Aiden Favish on 12/10/23.
//
import SwiftUI
import Foundation


func createCSVFile(atPath path: String, initialContent: String) {
    let fileManager = FileManager.default
    let csvFilePath = URL(fileURLWithPath: path)
    
    if !fileManager.fileExists(atPath: path) {
        do {
            try initialContent.write(to: csvFilePath, atomically: true, encoding: .utf8)
            print("CSV file created at path: \(path)")
        } catch {
            print("Error creating CSV file: \(error)")
        }
    } else {
        print("File already exists at path: \(path)")
    }
}

func createFolder(atURL url: URL) -> URL? {
    let fileManager = FileManager.default
    
    do {
        try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        print("Folder created at URL: \(url)")
        return url
    } catch {
        print("Error creating folder: \(error)")
        return nil
    }
}


