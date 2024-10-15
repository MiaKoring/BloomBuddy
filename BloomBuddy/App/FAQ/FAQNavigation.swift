//
//  FAQNavigation.swift
//  BloomBuddy
//
//  Created by Mia Koring on 27.08.24.
//

import SwiftUI

struct FAQNavigation: View {
    @State var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            Button {
                path.append(FAQ.sensorProblems)
            } label: {
                Text("Nav1")
            }
            Button {
                path.append(FAQ.sensorSetup)
            } label: {
                Text("Nav2")
            }
            .navigationDestination(for: FAQ.self) { val in
                switch val {
                case .sensorProblems:
                    FAQDestination(type: .sensorProblems)
                case .sensorSetup:
                    Text("SensorSetup")
                }
            }
        }
    }
}
