/*
 SRError.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/15.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

enum SRError: LocalizedError {
    enum DatabaseError: LocalizedError {
        case failedFetchData
        case failedUpdateDB

        var title: String {
            switch self {
            case .failedFetchData:
                return String(localized: "failedFetchDataErrorTitle")
            case .failedUpdateDB:
                return String(localized: "failedUpdateDBErrorTitle")
            }
        }

        var errorDescription: String? {
            return String(localized: "failedDBErrorMessage")
        }
    }

    enum StampError: LocalizedError {
        case notFoundDataID
        case emojiOverrapping
        case summaryExceeds

        var errorDescription: String? {
            switch self {
            case .notFoundDataID:
                return String(localized: "notFoundDataIDErrorMessage")
            case .emojiOverrapping:
                return String(localized: "emojiOverlappingErrorMessage")
            case .summaryExceeds:
                return String(localized: "summaryExceedsErrorMessage")
            }
        }
    }

    enum StampContext {
        case add
        case edit
        case delete

        var title: String {
            switch self {
            case .add:
                return String(localized: "unableAddStamp")
            case .edit:
                return String(localized: "unableSaveStamp")
            case .delete:
                return String(localized: "unableDeleteStamp")
            }
        }
    }

    enum LogError: LocalizedError {
        case skipToUpdate

        var title: String {
            return String(localized: "skipToUpdate")
        }

        var errorDescription: String? {
            return String(localized: "skipToUpdateErrorMessage")
        }
    }

    case database(_ databaseError: DatabaseError)
    case stamp(_ stampError: StampError, _ context: StampContext)
    case log(_ logError: LogError)

    var title: String {
        switch self {
        case .database(let error):
            return error.title
        case .stamp(_, let context):
            return context.title
        case .log(let error):
            return error.title
        }
    }

    var errorDescription: String? {
        switch self {
        case .database(let error):
            return error.errorDescription
        case .stamp(let error, _):
            return error.errorDescription
        case .log(let error):
            return error.errorDescription
        }
    }
}
