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
    
    lazy var tableView = UITableView().then {
        $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        $0.rowHeight = UITableView.automaticDimension
    }
    
    let commentInputView = CommentInputView(frame: .zero)
    
    var dommyData = [Comment(commentID: "123", reelsID: "1233", writerID: "124", content: "안녕하세요", date: 123, likes: 12),
        Comment(commentID: "123", reelsID: "1233", writerID: "124", content: "반갑습니다", date: 123, likes: 12),
        Comment(commentID: "123", reelsID: "1233", writerID: "124", content: "빼애애액", date: 123, likes: 12),
        Comment(commentID: "123", reelsID: "1233", writerID: "124", content: "빼애애액빼애애액빼애애액빼애애액빼애애액빼애애액빼애애액빼애애액빼애애액빼애애액빼애애액", date: 123, likes: 12),
        Comment(commentID: "123", reelsID: "1233", writerID: "124", content: "배고파배고파배고파배고파배고파배고파배고파 배고파배고파배고파배고파", date: 123, likes: 12),
        Comment(commentID: "123", reelsID: "1233", writerID: "124", content: "개굴 개굴 개구리개굴 개굴 개구리개굴 개굴 개구리개굴 개굴 개구리개굴 개굴 개구리개굴 개굴 개구리개굴 개굴 개구리", date: 123, likes: 12)]
    
    lazy var dommy = BehaviorSubject(value: dommyData).asDriver(onErrorJustReturn: [Comment(commentID: "", reelsID: "", writerID: "", content: "", date: 1, likes: 12)])

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
    }
    
    // MARK: - Methods
    
    override func bind() {
        dommy
            .drive(tableView.rx.items) { tableView, index, item in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: CommentCell.identifier,
                    for: IndexPath(row: index, section: 0)) as? CommentCell else {
                    return UITableViewCell() }
                
                cell.selectionStyle = .none
                cell.textView.text = item.content
                
                return cell
            }
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardHeight in
                self?.commentInputView.snp.updateConstraints {
                    $0.bottom.equalTo(self?.view ?? UIView()).offset(-keyboardHeight)
                }
                self?.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        commentInputView.textField.rx
            .controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [unowned self] in
            self.resignFirstResponder()
        })
        
        commentInputView.inputButton.rx
            .tap
            .subscribe(onNext: {
                
//                let request = CommentRequestDTO(reelsID: "wBlUVJotbpl8LwDiLJvy", writerID: "현준", content: "재밌어요", date: 1234)
//                CommentDataSource().upload(reelsID: "wBlUVJotbpl8LwDiLJvy", request: request)
                
                CommentDataSource().read(reelsID: "wBlUVJotbpl8LwDiLJvy")
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
            $0.height.equalTo(60)
        }
    }
    
    func attribute() {
        title = "댓글"
    }
}
