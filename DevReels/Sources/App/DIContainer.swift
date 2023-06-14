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
        container.register(ReelsDataSourceProtocol.self) { _ in ReelsDataSource() }
    }
    
    private func registerRepositories() {
        container.register(ReelsRepositoryProtocol.self) { resolver in
            var repository = ReelsRepository()
            repository.reelsDataSource = resolver.resolve(ReelsDataSourceProtocol.self)
            return repository
        }
    }
    
    private func registerUseCases() {
        container.register(ReelsUseCaseProtocol.self) { resolver in
            var useCase = ReelsUseCase()
            useCase.reelsRepository = resolver.resolve(ReelsRepositoryProtocol.self)
            return useCase
        }
    }
    
    private func registerViewModels() {
        container.register(LoginViewModel.self) { resolver in
            let viewModel = LoginViewModel()
            
            return viewModel
        }
        container.register(ReelsViewModel.self) { resolver in
            let viewModel = ReelsViewModel()
            viewModel.reelsUseCase = resolver.resolve(ReelsUseCaseProtocol.self)
            return viewModel
        }
        container.register(ProfileViewModel.self) { reslover in
            let viewModel = ProfileViewModel()
            return viewModel
        }
    }
}
