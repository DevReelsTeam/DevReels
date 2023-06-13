//
//  DIContainer.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/09.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

import Swinject

final class DIContainer {
    static let shared = DIContainer()
    let container = Container()
    private init() {}
    
    func inject() {
        registerDataSources()
        registerRepositories()
        registerUseCases()
        registerViewModels()
    }
    
    private func registerDataSources() {
        container.register(AuthServiceProtocol.self) { _ in FBAuthService() }
    }
    
    private func registerRepositories() {
        container.register(AuthRepositoryProtocol.self) { resolver in
            var repository = AuthRepository()
//            repository.authService = resolver.resolve(AuthServiceProtocol.self)
            
            return repository
        }
    }
    
    private func registerUseCases() {
        container.register(LoginUseCaseProtocol.self) { resolver in
            var useCase = LoginUseCase()
            useCase.authRepository = resolver.resolve(AuthRepositoryProtocol.self)

            return useCase
        }
    }
    
    private func registerViewModels() {
        container.register(LoginViewModel.self) { resolver in
            let viewModel = LoginViewModel()
            viewModel.loginUseCase = resolver.resolve(LoginUseCaseProtocol.self)
            return viewModel
        }
    }
}
