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
    
    var commentButtonTapped = PublishSubject<Reels>()
        
    private let viewModel: ReelsViewModel
    private let videoController = VideoPlayerController.sharedVideoPlayer
    private let disposeBag = DisposeBag()
    
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
            commentButtonTap: commentButtonTapped
        )
        let output = viewModel.transform(input: input)
        
        output.reelsList
            .drive(tableView.rx.items(
                cellIdentifier: ReelsCell.identifier,
                cellType: ReelsCell.self
            )) { _, reels, cell in
                cell.commentButtonTap
                    .subscribe(onNext: { [weak self] in
                        self?.commentButtonTapped.onNext($0)
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.prepareForReuse()
                cell.configureCell(data: reels)
            }
            .disposed(by: disposeBag)
        

        
        tableView.rx.didEndDisplayingCell
            .subscribe(onNext: { [weak self] cell, _ in
                guard let self = self else { return }
                
                if let videoCell = cell as? PlayVideoLayerContainer {
                    if videoCell.videoURL != nil {
                        videoController.removeLayerFor(cell: videoCell)
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
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                videoController.pausePlayeVideosFor(tableView: tableView)
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
