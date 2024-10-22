//
//  Untitled.swift
//  BloomBuddy
//
//  Created by Mia Koring on 19.10.24.
//

import SwiftUI

struct DetailView<Content: View>: View {
    let title: Text
    let content: Content
    @State var isExpanded: Bool = false
    
    init(title: Text, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    title
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding()
                .hidden()
                if isExpanded {
                    content
                        .transition(.scale)
                }
            }
            VStack {
                HStack {
                    title
                    Spacer()
                    Image(systemName: "chevron.right")
                        .rotationEffect(isExpanded ? .degrees(90): .degrees(0))
                }
                .padding()
                .background() {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.plantGreen.secondary.opacity(1))
                }
                .onTapGesture {
                    withAnimation(.linear(duration: 0.15)) {
                        isExpanded.toggle()
                    }
                }
                if isExpanded {
                    content
                        .hidden()
                }
            }
        }
        
    }
}

#Preview {
    DetailView(title: Text("Mehr erfahren")) {
        Text("loloollolololokllololololllolololololoollolololokllololololllolololololoollolololokllololololllolololololoollolololokllololololllolololololoollolololokllololololllolololololoollolololokllololololllolololololoollolololokllololololllolololololoollolololokllololololllolololololoollolololokllololololllolololololoollolololokllololololllolololololoollolololokllololololllolololololoollolololokllololololllolololo")
    }
    .padding()
}
