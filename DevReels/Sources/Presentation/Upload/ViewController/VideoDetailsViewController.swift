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

class VideoDetailsViewController: ViewController {
    
    // MARK: - Properties
    
    private let scrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = true
    }
    
    private let contentView = UIView()
    
    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .darkGray
    }
    
    private let titleTextField = CountTextField().then {
        $0.placeholder = "영상의 제목을 입력해주세요"
        $0.title = "제목"
    }
    
    private let descriptionTextView = CountTextView().then {
        $0.placeholder = "상세 설명을 추가해주세요"
        $0.title = "설명"
    }
    
    private let linkTextField = UrlTextField().then {
        $0.placeholder = "영상 관련 링크를 입력해주세요"
        $0.title = "링크"
    }
    
    private let uploadButton = ValidationButton().then {
        $0.isEnabled = false
        $0.layer.cornerRadius = 8.0
        $0.layer.masksToBounds = true
        $0.setTitle("업로드", for: .normal)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    // MARK: - binds
    
    override func bind() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                self?.scrollView.contentInset.bottom = keyboardVisibleHeight
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
            .bind(to: uploadButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - Methods
    
    private func configureNavigationBar() {
        navigationItem.title = "비디오 상세 정보"
    }
    
    override func layout() {
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
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
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(20)
        }
        
        contentView.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.top.equalTo(titleTextField.snp.bottom).offset(20)
            $0.height.equalTo(150)
        }
        
        contentView.addSubview(linkTextField)
        linkTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.top.equalTo(descriptionTextView.snp.bottom).offset(20)
        }

        contentView.addSubview(uploadButton)
        uploadButton.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.4)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(linkTextField.snp.bottom).offset(20)
            $0.height.equalTo(34)
        }
        
        let marginView = UIView()
        contentView.addSubview(marginView)
        marginView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(uploadButton.snp.bottom)
        }
    }
}
