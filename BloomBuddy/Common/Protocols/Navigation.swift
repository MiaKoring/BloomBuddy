//
//  ViewEnum.swift
//  BloomBuddy
//
//  Created by Mia Koring on 22.11.24.
//
import SwiftUI

protocol Navigation: Identifiable, Hashable {
    var view: AnyView { get }
    var button: AnyView { get }
    var searchMatches: [String] { get }
    var fullDivider: Bool { get }
    var destinationTitle: String { get }
}
