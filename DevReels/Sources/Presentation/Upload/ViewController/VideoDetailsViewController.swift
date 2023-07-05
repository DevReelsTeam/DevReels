//
//  VideoDetailsViewController.swift
//  DevReels
//
//  Created by HoJun on 2023/05/25.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxKeyboard
import Then

final class VideoDetailsViewController: ViewController {
    
    // MARK: - Properties
    
    private let scrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = true
    }
    
    private let contentView = UIView()
    
    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .black
    }
    
    private let titleTextField = TextField().then {
        $0.placeholder = "제목을 입력하세요"
        $0.title = "제목"
    }
    
    private let descriptionTextView = CountTextView().then {
        $0.placeholder = "내용을 입력하세요"
        $0.title = "내용"
        $0.maxCount = 100
    }
    
    private let linkTextField = TextField(inputType: .url).then {
        $0.placeholder = "영상 관련 링크를 입력해주세요"
        $0.title = "링크"
    }
    
    private let uploadButton = ValidationButton().then {
        $0.isEnabled = false
        $0.setTitle("< Upload >", for: .normal)
    }
    
    private var viewModel: VideoDetailsViewModel
    
    init(viewModel: VideoDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private let githubToggleBar = ToggleBar().then {
        $0.image = UIImage(systemName: "square.and.arrow.up")
        $0.title = "Github 링크 추가하기"
    }
    
    private lazy var stackView = UIStackView().then {
        $0.addArrangedSubview(githubToggleBar)
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    private func addTextField() {
        guard let toggleBar = stackView.arrangedSubviews.last else { return }
        let nextEntryIndex = stackView.arrangedSubviews.count
                
        let offset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y + toggleBar.bounds.size.height)
        
        let newEntryView = linkTextField
        newEntryView.isHidden = true
        
        stackView.insertArrangedSubview(newEntryView, at: nextEntryIndex)
        
        UIView.animate(withDuration: 0.25) {
            newEntryView.isHidden = false
            self.scrollView.contentOffset = offset
        }
    }
    
    private func removeTextField() {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.linkTextField.isHidden = true
        }, completion: { _ in
            self.linkTextField.removeFromSuperview()
        })
    }
    
    // MARK: - binds
    
    override func bind() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                self?.scrollView.contentInset.bottom = keyboardVisibleHeight
            })
            .disposed(by: disposeBag)
        
        githubToggleBar.rx.isOn
            .subscribe(onNext: { [weak self] in
                $0 ? self?.addTextField() : self?.removeTextField()
            })
            .disposed(by: disposeBag)
        
        let input = VideoDetailsViewModel.Input(
            backButtonTapped: backButton.rx.tap.throttle(.seconds(1), scheduler: MainScheduler.instance),
            title: titleTextField.rx.text.orEmpty.asObservable(),
            description: descriptionTextView.rx.text.orEmpty.asObservable(),
            linkString: linkTextField.rx.text.orEmpty.asObservable(),
            linkValidation: linkTextField.rx.isValidURL.asObservable(),
            uploadButtonTapped: uploadButton.rx.tap.asObservable()
            )
            
        let output = viewModel.transform(input: input)
        
        output.uploadButtonEnabled
            .drive(uploadButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        thumbnailImageView.image = output.thumbnailImage
    }
    
    
    // MARK: - Methods
    
    private func configureNavigationBar() {
        navigationItem.title = "세부정보 입력하기"
    }
    
    override func layout() {
        
        view.addSubview(uploadButton)
        uploadButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(49)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(uploadButton.snp.top)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints {
            $0.size.equalTo(200)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(18)
        }
        
        contentView.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.top.equalTo(titleTextField.snp.bottom).offset(18)
            $0.height.equalTo(150)
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.top.equalTo(descriptionTextView.snp.bottom).offset(18)
        }
    
        let marginView = UIView()
        contentView.addSubview(marginView)
        marginView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(stackView.snp.bottom)
        }
    }
}
