//
//  AppIconView.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 6/7/23.
//

import SwiftUI

struct AppIcon: View {
    var body: some View {
        Image(nsImage: NSApplication.shared.applicationIconImage)
            .resizable()
            .scaledToFit()
            .frame(width: 70, height: 70)
    }
}


