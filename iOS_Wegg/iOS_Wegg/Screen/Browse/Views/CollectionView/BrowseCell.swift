//
//  BrowseCell.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/17/25.
//

import UIKit
import SnapKit
import Then

/// 둘러보기 탭 커스텀셀 클래스
class BrowseCell: UICollectionViewCell {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    /// 셀 프로필 이미지
    public lazy var userProfile = UIImageView().then {
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    /// 셀 닉네임 라벨
    public lazy var nickNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .black
    }
    
    /// 셀 게시물 이미지
    public lazy var postImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 15
    }
    
    // MARK: - Methods
    
    /// UI 컴포넌트를 셀에 추가하기
    private func addComponents() {
        [nickNameLabel, userProfile, postImage].forEach {
            self.addSubview($0)
        }
    }
    
    /// 사용자 프로필, 닉네임, 게시물 제약 조건 설정
    private func setupConstraints() {
        userProfile.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(1)
            $0.trailing.equalTo(nickNameLabel.snp.leading).offset(-10)
            $0.width.height.equalTo(30)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(userProfile)
            $0.leading.equalTo(userProfile.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        postImage.snp.makeConstraints {
            $0.top.equalTo(userProfile.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    /// 셀에 데이터를 설정하는 메서드
    func configure(with item: BrowseItem) {
        // 닉네임 설정
        nickNameLabel.text = item.nickName
        
        // 프로필 이미지 설정
        userProfile.image = UIImage(named: item.profileImage)
        
        // 게시물 이미지 설정
        postImage.image = UIImage(named: item.postImage.first ?? "placeholder")
    }
}
