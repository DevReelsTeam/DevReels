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

final class ReelsViewController: ViewController {
    
    private lazy var tableView = UITableView().then {
        $0.backgroundColor = .systemBackground
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
        $0.register(ReelsCell.self, forCellReuseIdentifier: ReelsCell.identifier)
    }
    
    private lazy var topGradientImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
        
    var viewModel: ReelsViewModel?
    
    // MARK: - Inits
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ReelsViewModel(delegate: self)
        layout()
    }
    
    override func viewDidLayoutSubviews() {
        configure()
        DispatchQueue.main.async {
            VideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: self.tableView)
        }
    }
    
    override func bind() {
    }
    
    // MARK: - Layout
    override func layout() {
        view.addSubview(tableView)
        view.addSubview(topGradientImageView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        topGradientImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configure() {
        configureGradients()
        configureTableView()
    }
    
    fileprivate func configureGradients() {
        let topGradient = Utilities.shared.createGradient(color1: .black.withAlphaComponent(0.7), color2: .black.withAlphaComponent(0.0), frame: topGradientImageView.bounds)
        
        topGradientImageView.contentMode = .scaleAspectFill
        topGradientImageView.image = topGradient
    }
    
    fileprivate func configureTableView() {
        tableView.isPagingEnabled = true
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
    }
}

extension ReelsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.videos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReelsCell") as? ReelsCell else {
            return UITableViewCell()
        }
        cell.configureCell(data: viewModel?.videos[indexPath.row] ?? VideoObject(videoURL: "", thumbnailURL: "", title: "", videoDescription: ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? PlayVideoLayerContainer {
            if videoCell.videoURL != nil {
                VideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        VideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            VideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView)
        }
    }
}
extension ReelsViewController: ReelsRepositoryProtocol {
    func refresh() {
    }
}
