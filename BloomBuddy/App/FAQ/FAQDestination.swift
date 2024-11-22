//
//  FAQDestination.swift
//  BloomBuddy
//
//  Created by Mia Koring on 27.08.24.
//

import SwiftUI
import Kingfisher
import MarkdownUI

struct FAQDestination: View {
    let type: FAQ
    @State var detailImage: Data?
    @State var url: URL? = nil
    @Environment(\.openURL) var openUrl
    @State var components: [FAQComponent] = [FAQComponent(md: """
# Title test

bla bla bla

[![test](https://images.touchthegrass.de/BloomBuddyMarketing.png)](https://bloombuddy.touchthegrass.de/faq/images/aHR0cHM6Ly9pbWFnZXMudG91Y2h0aGVncmFzcy5kZS9CbG9vbUJ1ZGR5TWFya2V0aW5nLnBuZwo=)
""")]
    var body: some View {
        ScrollView {
            VStack {
                ForEach(components, id: \.self) { comp in
                    VStack {
                        Markdown(MarkdownContent(comp.md ?? ""))
                            .environment(\.openURL, OpenURLAction(handler: { url in
                                handleUrl(url) ? .handled: .systemAction
                            }))
                    }
                }
            }
        }
        .onOpenURL { url in
            _ = handleUrl(url)
        }
        .sheet(item: $detailImage) { data in
            VStack {
                Text("Detailansicht")
                    .font(.Bold.title2)
                if let uiImage = UIImage(data: data) {
                    SwiftUIImageViewer(image: Image(uiImage: uiImage))
                    if let url {
                        ShareLink(item: url, label: {Image(systemName: "square.and.arrow.up")})
                            .padding(.horizontal, 10)
                            .padding(.top, 7)
                            .padding(.bottom, 10)
                            .background {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(.plantGreen.opacity(0.4))
                            }
                    }
                } else {
                    ContentUnavailableView("Bild konnte nicht geladen werden", systemImage: "exclamationmark.triangle")
                }
            }
            .presentationDragIndicator(.visible)
            .padding()
        }
        
    }
    
    func handleUrl(_ url: URL) -> Bool {
        if url.path().hasPrefix("/faq/images/"), let imageBase64UrlStr = url.pathComponents.last, let imageBase64UrlStrData = Data(base64Encoded: imageBase64UrlStr), let imageUrlStr = String(data: imageBase64UrlStrData, encoding: .ascii)?.replacingOccurrences(of: "\n", with: ""), let imageUrl = URL(string: imageUrlStr) {
            Task {
                do {
                    let request = URLRequest(url: imageUrl)
                    let (data, response) = try await URLSession.shared.data(for: request)
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        detailImage = data
                        self.url = imageUrl
                    } else {
                        detailImage = Data()
                        self.url = nil
                    }
                } catch {
                    print(error.localizedDescription)
                    detailImage = Data()
                    self.url = nil
                }
            }
            return true
        } else {
            return false
        }
    }
}

