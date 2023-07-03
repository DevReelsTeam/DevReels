//
//  CommentViewController.swift
//  DevReels
//
//  Created by 강현준 on 2023/06/28.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import RxKeyboard
import FirebaseFirestore

final class CommentViewController: ViewController {
    
    // MARK: - Properties
    
    private lazy var tableView = UITableView().then {
        $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        $0.rowHeight = UITableView.automaticDimension
    }
    private let commentInputView = CommentInputView(frame: .zero)
    private let tmpBackButton = UIButton(type: .system).then {
        $0.setTitle("Back", for: .normal)
    }

    private let viewModel: CommentViewModel
    
    // MARK: - Inits
    
    init(viewModel: CommentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
    }
    
    // MARK: - Methods
    
    override func bind() {
        
        let input = CommentViewModel.Input(
            viewWillAppear: rx.viewWillAppear.map { _ in ()}.asObservable(),
            backButtonTapped: tmpBackButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
        )
        
        let output = viewModel.transform(input: input)
        
        
        commentInputView.inputButton.rx
            .tap
            .subscribe(onNext: {
                let repository = DIContainer.shared.container.resolve(CommentRepositoryProtocol.self)
                

            })
            .disposed(by: disposeBag)
        
        bindInputView()
        bindTableView(output: output)
    }
    
    func bindTableView(output: CommentViewModel.Output) {
        
        output.commentList
            .drive(tableView.rx.items(
                cellIdentifier: CommentCell.identifier,
                cellType: CommentCell.self)) { _, comment, cell in
                    cell.prepareForReuse()
                    cell.configureCell(data: comment)
                    cell.selectionStyle = .none }
                .disposed(by: disposeBag)
    }
    
    func bindInputView() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardHeight in
                self?.commentInputView.snp.updateConstraints {
                    $0.bottom.equalTo(self?.view ?? UIView()).offset(-keyboardHeight)
                }
                self?.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        view.addSubview(commentInputView)
        
        commentInputView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        view.addSubview(tmpBackButton)
        
        tmpBackButton.snp.makeConstraints {
            $0.bottom.equalTo(commentInputView.snp.top)
            $0.leading.equalToSuperview()
        }
    }
    
    // TODO: - navigation Item 표시 안됨
    func attribute() {
        self.navigationController?.navigationItem.title = "댓글"
        self.navigationItem.title = "댓글"
        self.title = "댓글"
        self.navigationController?.tabBarController?.navigationController?.title = title
        self.navigationController?.tabBarController?.navigationController?.navigationItem.title = title
        print("@@@@@@@@@@@@@")
        print(navigationItem.leftBarButtonItem?.title)
        print(navigationItem.title)
        print("@@@@@@@@@@@@@")
    }
}
