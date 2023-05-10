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
        
    }
    
    private func registerRepositories() {
        
    }
    
    private func registerUseCases() {
        
    }
    
    private func registerViewModels() {
        
    }
}
