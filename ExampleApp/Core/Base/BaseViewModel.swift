//
//  BaseViewModel.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 12.05.2025.
//

import Foundation
import Combine


open class BaseViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    
    // Common logger for all viewmodels
    var logger = AppLogger(category: "BaseViewModel")
    
    // Store cancellables for memory management
    public var cancellables = Set<AnyCancellable>()
    
    public init() {
        // Base initialization
        self.setupBindings()
    }
    
    // MARK: - Setup and Lifecycle
    
    /// Setup any bindings needed for the viewmodel
    open func setupBindings() {
        // Override in subclasses to add specific bindings
    }
    
    // MARK: - Error Handling
    
    /// Handle completion from Combine publishers
    open func handleCompletion<T>(_ completion: Subscribers.Completion<T>) where T: Error {
        switch completion {
        case .finished:
            logger.debug("Request completed successfully")
        case .failure(let error):
            handleError(error)
        }
    }
    
    /// Process errors and update error message
    open func handleError(_ error: Error) {
        isLoading = false
        errorMessage = error.localizedDescription
        logger.error("Error occurred: \(error.localizedDescription)")
    }
    
    // MARK: - REST API Helpers
    
    /// Execute a REST API request with Combine
    open func executeRestRequest<T: Decodable>(
        _ publisher: AnyPublisher<T, Error>,
        completion: ((T) -> Void)? = nil
    ) {
        isLoading = true
        errorMessage = nil
        
        publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completionStatus in
                self?.isLoading = false
                switch completionStatus {
                case .finished:
                    self?.logger.debug("REST request completed successfully")
                case .failure(let error):
                    self?.handleError(error)
                }
            }, receiveValue: { [weak self] result in
                self?.logger.debug("REST result received: \(String(describing: result))")
                completion?(result)
            })
            .store(in: &cancellables)
    }
    
    // MARK: - GraphQL API Helpers
    
    /// Execute a GraphQL query with Combine
    open func executeGraphQLQuery<T: Decodable>(
        _ publisher: AnyPublisher<T, Error>,
        completion: ((T) -> Void)? = nil
    ) {
        isLoading = true
        errorMessage = nil
        
        publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completionStatus in
                self?.isLoading = false
                switch completionStatus {
                case .finished:
                    self?.logger.debug("GraphQL query completed successfully")
                case .failure(let error):
                    self?.handleError(error)
                }
            }, receiveValue: { [weak self] result in
                self?.logger.debug("GraphQL result received: \(String(describing: result))")
                completion?(result)
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Cleanup
    
    /// Cancel all outstanding requests
    open func cancelAllRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    deinit {
        cancelAllRequests()
        logger.debug("\(String(describing: type(of: self))) deinitializing")
    }
}
