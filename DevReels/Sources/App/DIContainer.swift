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
        container.register(ReelsDataSourceProtocol.self) { _ in ReelsDataSource() }
        container.register(KeychainProtocol.self) { _ in Keychain() }
        container.register(KeychainManagerProtocol.self) { resolver in
            var dataSource = KeychainManager()
            dataSource.keychain = resolver.resolve(KeychainProtocol.self)
            return dataSource
        }
    }
    
    private func registerRepositories() {
        container.register(AuthRepositoryProtocol.self) { resolver in
            var repository = AuthRepository()
            repository.authService = resolver.resolve(AuthServiceProtocol.self)
            return repository
        }
        container.register(ReelsRepositoryProtocol.self) { resolver in
            var repository = ReelsRepository()
            repository.reelsDataSource = resolver.resolve(ReelsDataSourceProtocol.self)
            return repository
        }
        
        container.register(TokenRepositoryProtocol.self) { resolver in
            var repository = TokenRepository()
            repository.keychainManager = resolver.resolve(KeychainManagerProtocol.self)
            return repository
        }
    }
    
    private func registerUseCases() {
        container.register(LoginUseCaseProtocol.self) { resolver in
            var useCase = LoginUseCase()
            useCase.authRepository = resolver.resolve(AuthRepositoryProtocol.self)
            useCase.tokenRepository = resolver.resolve(TokenRepositoryProtocol.self)
            return useCase
        }
        container.register(ReelsUseCaseProtocol.self) { resolver in
            var useCase = ReelsUseCase()
            useCase.reelsRepository = resolver.resolve(ReelsRepositoryProtocol.self)
            return useCase
        }
        container.register(UploadReelsUsecaseProtocol.self) { resolver in
            var useCase = UploadReelsUseCase()
            useCase.reelsRepository = resolver.resolve(ReelsRepositoryProtocol.self)
            return useCase
        }
    }
    
    private func registerViewModels() {
        container.register(LoginViewModel.self) { resolver in
            let viewModel = LoginViewModel()
            viewModel.loginUseCase = resolver.resolve(LoginUseCaseProtocol.self)
            return viewModel
        }
        container.register(ReelsViewModel.self) { resolver in
            let viewModel = ReelsViewModel()
            viewModel.reelsUseCase = resolver.resolve(ReelsUseCaseProtocol.self)
            return viewModel
        }
        container.register(VideoTrimmerViewModel.self) { _ in VideoTrimmerViewModel() }
        container.register(VideoDetailsViewModel.self) { resolver in
            let viewModel = VideoDetailsViewModel()
            viewModel.uploadReelsUsecase = resolver.resolve(UploadReelsUsecaseProtocol.self)
            return viewModel
        }
    }
}
