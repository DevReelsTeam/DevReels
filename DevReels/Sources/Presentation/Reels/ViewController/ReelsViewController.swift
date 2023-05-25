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
        
    private let viewModel: ReelsViewModel
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
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
        )
        let ouput = viewModel.transform(input: input)
        
        ouput.reelsList
            .drive(tableView.rx.items) { tableView, index, reels in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ReelsCell.identifier,
                    for: IndexPath(row: index, section: 0)
                ) as? ReelsCell else {
                    return UITableViewCell()
                }
                cell.selectionStyle = .none
                cell.prepareForReuse()
                cell.configureCell(data: reels)
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.didEndDisplayingCell
            .subscribe(onNext: { [weak self] cell, _ in
                guard self != nil else { return }
                
                if let videoCell = cell as? PlayVideoLayerContainer {
                    if videoCell.videoURL != nil {
                        VideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx.didEndDecelerating
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                VideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.didEndDragging
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                VideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView)
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
