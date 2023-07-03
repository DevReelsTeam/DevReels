//
//  CommentViewModel.swift
//  DevReels
//
//  Created by 강현준 on 2023/06/30.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum CommentNavigation {
    case back
}

final class CommentViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let backButtonTapped: Observable<Void>
    }
    
    struct Output {
        let commentList: Driver<[Comment]>
    }
    
    var commentListUseCase = DIContainer.shared.container.resolve(CommentListUseCaseProtocol.self)
    let navigation = PublishSubject<CommentNavigation>()
    private let commentList = PublishSubject<[Comment]>()
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { viewModel, _ in
                viewModel.commentListUseCase?.commentList(reelsID: "wBlUVJotbpl8LwDiLJvy").asResult() ?? .empty()
            }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success(let data):
                    viewModel.commentList.onNext(data)
                case .failure:
                    viewModel.commentList.onNext([])
                }
            })
            .disposed(by: disposeBag)
        
        input.backButtonTapped
            .map { CommentNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
            
        return Output(commentList: commentList.asDriver(onErrorJustReturn: []))
    }
}
