//
//  CommentViewController.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/1/25.
//

import UIKit

/// 댓글 바텀 시트를 담당하는 댓글창 뷰 컨트롤러
class CommentViewController: UIViewController {
    
    // MARK: - Property
    
    private let commentView = CommentView()
    // 서버 데이터 프로퍼티 선언
    private var comments: [Comment] // ✅ 서버에서 받아온 댓글 데이터
    private var emojis: EmojiResult // ✅ 서버에서 받아온 이모지 데이터
    private let postDetailService = PostDetailService() // ✅ API 호출 서비스
    private let postId: Int // ✅ 해당 게시물 ID
    
    // ✅ 생성자를 통해 API 데이터를 주입받음
    init(postId: Int, comments: [Comment], emojis: EmojiResult) {
        self.postId = postId
        self.comments = comments
        self.emojis = emojis
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSheetPresentation() // 바텀 시트 설정을 먼저 적용
        view = commentView // 이후에 뷰를 설정
        view.backgroundColor = .white
        
        setupActions()
        setupTableView()
        
        updateEmojiUI(emojis)
        // 초기 이모지 설정 테스트
        /*commentView.updateEmojiImages(with: ["blush", "cry", "pray"])*/
    }
    
    // MARK: - Methods
    
    /// ✅ 이모지 UI 업데이트
    func updateEmojiUI(_ newEmojis: EmojiResult) {
        self.emojis = newEmojis // ✅ 최신 이모지 데이터 갱신
        let emojiTypes = emojis.emojiCounts
        // 개수가 1 이상인 이모지만 필터링하여 업데이트
            .filter { $0.count > 0 } // swiftlint:disable:this empty_count
            .map { $0.emojiType.lowercased() } // 서버 데이터가 대문자이므로 소문자로 변환
        commentView.updateEmojiImages(with: emojiTypes)
    }
    
    /// 테이블 뷰 설정
    private func setupTableView() {
        commentView.tableView.dataSource = self
    }
    
    /// 버튼 액션 설정
    private func setupActions() {
        commentView.submitButton.addTarget(
            self, action: #selector(didTapSubmit),
            for: .touchUpInside)
    }
    
    /// 바텀 시트 설정, iPhone15 테스트 결과 UIsheetPresentationContoller 특정기기 비정상 작동 버그(16pro 문제없음)
    private func setupSheetPresentation() {
        if let sheet = self.sheetPresentationController {
            sheet.detents = [
                .medium(), // 중간 크기 (약간만 띄우기)
                .large() // 완전 확장
            ]
            sheet.prefersGrabberVisible = true // 상단 그립
            sheet.preferredCornerRadius = 25 // 모서리 둥글게
        }
    }
    
    /// ✅ 댓글 등록 버튼 클릭 시 댓글 추가 (실제 API 호출)
    @objc private func didTapSubmit() {
        guard let text = commentView.commentTextField.text, !text.isEmpty else { return }
        
        Task {
            do {

                
                // ✅ 댓글 등록 API 호출
                let response = try await postDetailService.postComment(
                    postId: postId, content: text)
                
                // ✅ 서버에서 댓글 등록이 성공했는지 확인
                guard response.isSuccess else {
                    throw APIError.networkError(response.message)
                }
                
                // ✅ 성공적으로 등록된 경우, 새로운 댓글을 가져와 UI 업데이트
                await fetchUpdatedComments()
                
                DispatchQueue.main.async {
                    self.commentView.commentTextField.text = "" // ✅ 입력 필드 초기화
                    self.commentView.tableView.reloadData() // ✅ 테이블 뷰 갱신
                }
                print("✅ 댓글 등록 성공: \(response.result)")
            } catch {
                print("❌ 댓글 등록 실패: \(error)")
            }
        }
    }
    
    /// ✅ 최신 댓글을 다시 불러오는 메서드
    private func fetchUpdatedComments() async {
        do {
            let (updatedComments, _) = try await postDetailService.fetchCommentsAndEmojis(
                postId: postId)
            
            DispatchQueue.main.async {
                self.comments = updatedComments // ✅ 최신 댓글 목록으로 갱신
                self.commentView.tableView.reloadData() // ✅ UI 업데이트
            }
        } catch {
            print("❌ 최신 댓글 불러오기 실패: \(error)")
        }
    }
}

// MARK: - UITableViewDataSource
extension CommentViewController: UITableViewDataSource {
    
    // 테이블 뷰의 섹션당 행 개수를 반환하는 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    // 각 행에 대한 셀을 생성하여 반환하는 메서드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 재사용 가능한 셀을 가져옴 (없으면 기본 UITableViewCell 반환)
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentCell.identifier,
            for: indexPath) as? CommentCell else { return UITableViewCell() }
        // 현재 인덱스의 댓글 데이터를 셀에 설정
        cell.configure(with: comments[indexPath.row])
        return cell
    }
}
