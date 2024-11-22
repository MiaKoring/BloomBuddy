//
//  NavigationGroups.swift
//  BloomBuddy
//
//  Created by Mia Koring on 22.11.24.
//

protocol NavigationGroups: CaseIterable, Identifiable, Hashable {
    associatedtype ChildrenType: Navigation
    var children: [ChildrenType] { get }
    var title: String? { get }
}
