//
//  ReelsViewModel.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

final class ReelsViewModel: ViewModel {
    
    struct Input {
        let refresh: Observable<Void>
    }
    
    struct Output {
        private let studyList = PublishSubject<[Reels]>()
    }
    
    var reelsUseCase: ReelsUseCaseProtocol?
    var disposeBag = DisposeBag()
    private let reelsList = PublishSubject<[Reels]>()
    private let refresh = PublishSubject<Int>()
    
    func transform(input: Input) -> Output {
        Output.init()
    }
    
    func bindRefresh(input: Input) {
//        refresh
//            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
//            .withUnretained(self)
//            .flatMap { delay, arguments -> Observable<Result<[Reels], Error>> in
//                return Observable.combineLatest(
//                    Observable.just(()).delay(
//                        .seconds(delay),
//                        scheduler: MainScheduler.instance
//                    ),
//                    self.reelsUseCase.list()
//                )
//            }
    }
}
