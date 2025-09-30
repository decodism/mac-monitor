//
//  EventCriticality.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 8/22/25.
//

import SwiftUI

public enum EventCriticality: String, Codable {
    case low
    case medium
    case high
}


struct CriticalityTint: ViewModifier {
    let criticality: EventCriticality?
    func body(content: Content) -> some View {
        switch criticality {
        case .high?:   content.foregroundStyle(.red)
        case .medium?: content.foregroundStyle(.orange)
        case .low?:    content
        case nil:      content
        }
    }
}
extension View {
    func criticalityTint(_ criticality: EventCriticality?) -> some View {
        modifier(CriticalityTint(criticality: criticality))
    }
}
