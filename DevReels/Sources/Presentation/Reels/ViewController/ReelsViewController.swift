//
//  ReelsViewController.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import DRVideoController
import AVFoundation

final class ReelsViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var tableView = UITableView().then {
        $0.register(ReelsCell.self, forCellReuseIdentifier: ReelsCell.identifier)
        $0.rowHeight = UIScreen.main.bounds.height
        $0.backgroundColor = .systemBackground
        $0.showsVerticalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.bounces = false
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
    }
    
    private lazy var topGradientImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    var videoLayer = AVPlayerLayer()
    
    var commentButtonTapped = PublishSubject<Reels>()
    
    private let viewModel: ReelsViewModel
    private var videoController: VideoPlayerController {
        viewModel.videoController
    }
    private let disposeBag = DisposeBag()
    private var currentReels: Reels?
    
    // MARK: - Inits
    init(viewModel: ReelsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
    }
    
    func bind() {
        let input = ReelsViewModel.Input(
            viewWillAppear: rx.viewWillAppear.map { _ in () }
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            viewWillDisAppear: rx.viewWillDisappear.map { _ in () }
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            reelsTapped: tableView.rx.itemSelected.map { _ in () }
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            reelsChanged: tableView.rx.didEndDisplayingCell.map { $0.indexPath },
            reelsWillBeginDragging: tableView.rx.willBeginDragging.map { _ in },
            reelsDidEndDragging: tableView.rx.didEndDragging.map { _ in },
            commentButtonTap: commentButtonTapped
        )
        let output = viewModel.transform(input: input)
        
        output.reelsList
            .drive(tableView.rx.items(
                cellIdentifier: ReelsCell.identifier,
                cellType: ReelsCell.self
            )) { [weak self] _, reels, cell in
                guard let self = self else { return }
                
                cell.commentButtonTap
                    .subscribe(onNext: {
                        self.commentButtonTapped.onNext($0)
                    })
                    .disposed(by: cell.disposeBag)
                
                self.currentReels = reels
                
                cell.prepareForReuse()
                cell.configureCell(data: reels)
                
                guard let url = reels.videoURL else { return }
                
                videoController.setupVideoFor(url: url)
                videoController.playVideo(withLayer: cell.videoLayer, url: url)
            }
            .disposed(by: disposeBag)
        
        /// 구현해야하는 것
        /// Cell이 didEndDisplayingCell 일때 videoLayer와 videoURL을 받아서 playVideo 메서드를 호출
        /// Cell이 willBeginDragging 일때 videoLayer와 videoURL을 받아서 pauseVideo 메서드 호출
        
        Observable.combineLatest(viewModel.reelsList, tableView.rx.didEndDisplayingCell)
            .subscribe(onNext: { [weak self] reelsList, didEndDisplayingCell in
                guard let self = self else { return }
                
                if let videoCell = didEndDisplayingCell.cell as? PlayVideoLayerContainer {
                    if videoCell.videoURL != nil {
                        videoController.removeLayerFor(cell: videoCell)
                        videoController.setupVideoFor(url: reelsList[didEndDisplayingCell.indexPath.row].videoURL ?? "")
                    }
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx.didEndDecelerating
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                videoController.pausePlayeVideosFor(tableView: tableView)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.didEndDragging
            .subscribe(onNext: { [weak self] decelerate in
                guard let self = self else { return }
                if !decelerate {
                    videoController.pausePlayeVideosFor(tableView: tableView)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Layout
    func layout() {
        view.addSubview(tableView)
        view.addSubview(topGradientImageView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        topGradientImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
