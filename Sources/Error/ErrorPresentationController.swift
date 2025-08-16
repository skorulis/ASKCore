//  Created by Alexander Skorulis on 29/10/2022.

#if canImport(UIKit)

import Combine
import Foundation
import UIKit

private final class ErrorPresentationController: UIAlertController {
    
    private var presentationWindow: UIWindow?
    
    func present() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        if let currentScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            window.windowScene = currentScene
        }
        
        window.rootViewController = UIViewController()
        window.windowLevel = UIWindow.Level.alert + 1
        window.backgroundColor = .clear
        window.makeKeyAndVisible()
        window.rootViewController?.present(self, animated: true, completion: nil)
        presentationWindow = window
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presentationWindow?.isHidden = true
        presentationWindow = nil
    }
    
}

@MainActor
public final class ErrorPresentationManager {
    
    private let errorService: PErrorService
    private var currentError: IdentifiedError?
    private var errorDisplay: ErrorPresentationController?
    
    private var subscribers: Set<AnyCancellable> = []
    
    public init(errorService: PErrorService) {
        self.errorService = errorService
        errorService.errorPublisher.sink { [unowned self] errors in
            if let currentError = self.currentError {
                let ids = errors.map { $0.id }
                if !ids.contains(currentError.id) {
                    self.dismiss()
                }
            }
            
            if let error = errors.first, self.currentError == nil {
                Task { @MainActor in
                    self.show(error: error)
                }
            }
        }
        .store(in: &subscribers)
    }
    
    private func show(error: IdentifiedError) {
        self.currentError = error
        let message = error.errorDescription ?? "Unknown error"
        errorDisplay = ErrorPresentationController(title: "Error",
                                                   message: message,
                                                   preferredStyle: .alert)
        
        errorDisplay?.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [unowned self] _ in
            self.dismiss()
        }))
        
        errorDisplay?.present()
    }
    
    private func dismiss() {
        if let error = currentError {
            self.currentError = nil
            errorDisplay?.dismiss(animated: true)
            errorDisplay = nil
            self.errorService.finish(error: error)
        }   
    }
}

#endif
