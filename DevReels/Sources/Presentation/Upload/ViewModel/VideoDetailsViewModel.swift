//
//  VideoDetailsViewModel.swift
//  DevReels
//
//  Created by HoJun on 2023/05/25.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum VideoDetailsNavigation {
    case finish
    case back
}

final class VideoDetailsViewModel: ViewModel {

    struct Input {
        let backButtonTapped: Observable<Void>
        let title: Observable<String>
        let description: Observable<String>
        let linkString: Observable<String>
        let linkValidation: Observable<Bool>
        let uploadButtonTapped: Observable<Void>
    }
    
    struct Output {
        let uploadButtonEnabled: Observable<Bool>
    }
    
    var uploadReelsUsecase: UploadReelsUsecaseProtocol?
    var disposeBag = DisposeBag()
    let navigation = PublishSubject<VideoDetailsNavigation>()
    
    var seletedVideoURL: URL? {
        didSet {
            
        }
    }
    
    private var videoData: Data?
    
    func transform(input: Input) -> Output {
        
        input.backButtonTapped
            .map { VideoDetailsNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)

//        input
//            .uploadButtonTapped
//            .withLatestFrom( Observable.combineLatest(input.title, input.description, input.linkString) )
//            .map { title, description, linkString in
//                uploadReelsUsecase?.upload(title: title, description: description, videoData: )
//            }
            
        
        let uploadButtonEnabled = Observable.combineLatest(
            input.title.map{ !$0.isEmpty },
            input.description.map { !$0.isEmpty },
            input.linkValidation
        ) {
            $0 && $1 && $2
        }
        
        return Output(uploadButtonEnabled: uploadButtonEnabled)
    }
}
