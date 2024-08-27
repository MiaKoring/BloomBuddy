//
//  SensorDetailAdd.swift
//  BloomBuddy
//
//  Created by Mia Koring on 24.08.24.
//

import Foundation
import SwiftUI
import SwiftChameleon

struct SensorDetailAdd: View {
    @Environment(\.dismiss) var dismiss
    @State var name: String = ""
    @State var setup: Bool = true
    @State var showLogin: Bool = false
    @State var unexpectedError: BloomBuddyApiError? = nil
    @State var showNameUsed: Bool = false
    
    var body: some View {
        VStack(alignment: .trailing) {
            BBTextField("Benenne den Sensor", text: $name)
            Text("\(32 - name.count)/32")
                .font(.Regular.regularSmall)
                .foregroundStyle(name.count <= 32 ? .gray : .red)
                .padding(.horizontal)
            Toggle(isOn: $setup) {
                VStack(alignment: .leading) {
                    Text("Anweisungen & begleitete Einrichtung, kann jederzeit nachgeholt werden")
                        .font(.Regular.regularSmall)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal)
            if showNameUsed {
                Text("Du hast bereits einen Sensor mit diesem Namen")
                    .font(.Regular.regularSmall)
                    .foregroundStyle(.red)
                    .padding(.horizontal)
            }
            Text("Erstellen")
                .bigButton(valid: !name.isEmpty && name.count <= 32) {
                    Task {
                        let jwtRes = await BBAuthManager.jwt()
                        switch jwtRes {
                        case .success(let token):
                            let res = await BBController.request(.createSensor(name, token), expected: String.self)
                            switch res {
                            case .success(_):
                                showNameUsed = false
                                dismiss()
                                //TODO: add sensor setup
                            case .failure(let failure):
                                if failure == .nameUsed {
                                    showNameUsed = true
                                    return
                                }
                                BBController.handleUnauthorized(failure, showLogin: $showLogin, unexpectedError: $unexpectedError)
                            }
                        case .failure(let failure):
                            BBController.handleUnauthorized(failure, showLogin: $showLogin, unexpectedError: $unexpectedError)
                        }
                    }
                }
        }
    }
}

#Preview {
    VStack {
        
    }
    .sheet(isPresented: .constant(true)) {
        VStack {
            SensorDetailAdd()
        }
        .padding(20)
        .presentationDetents([.medium])
    }
}
