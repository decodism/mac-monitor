//
//  MuteTypeBadgeView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 9/10/25.
//

import SwiftUI
import SutroESFramework

struct MuteTypeBadgeView: View {
    var path: ESMutedPath

    private var humanType: String {
        switch path.type {
        case "ES_MUTE_PATH_TYPE_PREFIX":
            return "Initiating prefix"
        case "ES_MUTE_PATH_TYPE_LITERAL":
            return "Initiating literal"
        case "ES_MUTE_PATH_TYPE_TARGET_PREFIX":
            return "Target prefix"
        case "ES_MUTE_PATH_TYPE_TARGET_LITERAL":
            return "Target literal"
        default:
            return "Unknown"
        }
    }

    private var badgeColor: Color {
        switch path.type {
        case "ES_MUTE_PATH_TYPE_PREFIX":
            return .red
        case "ES_MUTE_PATH_TYPE_LITERAL":
            return .orange
        case "ES_MUTE_PATH_TYPE_TARGET_PREFIX":
            return .green
        case "ES_MUTE_PATH_TYPE_TARGET_LITERAL":
            return .blue
        default:
            return .black
        }
    }

    var body: some View {
        Text(" **\(humanType)** ")
            .background(RoundedRectangle(cornerRadius: 5).fill(badgeColor.opacity(0.3)))
    }
}
