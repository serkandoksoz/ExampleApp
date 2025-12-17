//
//  LocalizationManager.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 2.12.2024.
//

import Foundation

typealias Localization = [LocalizationElement]

struct LocalizationElement: Codable {
    let key: String?
    let value: String?
}

final class LocalizationManager {
    static let shared = LocalizationManager()

    private let fileName = "localizations.json"
    private var localizations: [String: [String: String]] = [:] // [Language: [Key: Value]]
    private let logger = AppLogger(category: "LocalizationManager")
    private let currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"

    private init() {
        Task {
            await loadLocalizations()
        }
    }

    // MARK: - Public Methods
    func localizedString(for key: String) -> String {
        /// Fallback to the key if not found
        localizations[currentLanguage]?[key] ?? key
    }

    func saveLocalizations(_ data: Localization) async {
        do {
            // Convert the array of LocalizationElement into a [String: String] dictionary
            let dictionary = data.reduce(into: [String: String]()) { result, element in
                if let key = element.key, let value = element.value {
                    result[key] = value
                }
            }
            
            // Encode the dictionary as JSON
            let jsonData = try JSONEncoder().encode([currentLanguage: dictionary])
            let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
            
            // Write JSON to file
            try await withCheckedThrowingContinuation { continuation in
                DispatchQueue.global().async {
                    do {
                        try jsonData.write(to: fileURL, options: .atomic)
                        continuation.resume()
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
            
            localizations[currentLanguage] = dictionary
            logger.debug("Localization data successfully saved for language: \(currentLanguage)")
        } catch {
            logger.error("Failed to save localization data: \(error)")
        }
    }
    
    func loadLocalizations() async {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            let jsonData = try await withCheckedThrowingContinuation { continuation in
                DispatchQueue.global().async {
                    do {
                        let data = try Data(contentsOf: fileURL)
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
            localizations = try JSONDecoder().decode([String: [String: String]].self, from: jsonData)
        } catch {
            logger.info("No localization data found: \(error)")
        }
    }

    func loadLocalizations() {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            let jsonData = try Data(contentsOf: fileURL)
            localizations = try JSONDecoder().decode([String: [String: String]].self, from: jsonData)
        } catch {
            logger.info("No localization data found: \(error)")
        }
    }
    
    func hasLocalization() -> Bool {
        /// Check if localization data exists for the current language
        localizations.keys.contains(currentLanguage)
    }

    // MARK: - Private Helpers
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
