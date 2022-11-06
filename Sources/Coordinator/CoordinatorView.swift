//  Created by Alexander Skorulis on 27/9/2022.

import Foundation
import SwiftUI

@available(iOS 16, *)
public struct CoordinatorView<T: PCoordinator>: View {
    
    @StateObject var coordinator: T
    @Environment(\.dismiss) private var dismiss
    
    public init(coordinator: T) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.navPath) {
            coordinator.root.render(coordinator: coordinator)
                .navigationDestination(for: PathWrapper.self) { path in
                    path.render(coordinator: coordinator)
                }
        }
        .environment(\.coordinator, coordinator)
        .onChange(of: coordinator.shouldDismiss) { value in
            if value {
                dismiss()
            }
        }
        .fullScreenCover(item: binding(style: .fullScreen)) { presented in
            CoordinatorView(coordinator: presented.coordinator)
        }
        .sheet(item: binding(style: .sheet)) { presented in
            CoordinatorView(coordinator: presented.coordinator)
        }
    }
    
    private func binding(style: PresentationStyle) -> Binding<PresentedCoordinator<T>?> {
        return Binding<PresentedCoordinator<T>?> {
            return coordinator.presented?.only(style: style)
        } set: { newValue in
            if newValue == nil && coordinator.presented != nil {
                coordinator.presented = newValue
            }
        }
    }
    
}

