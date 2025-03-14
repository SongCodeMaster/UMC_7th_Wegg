//
//  PlaceDetailCollectionHandler.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/7/25.
//

import UIKit

class PlaceDetailCollectionHandler:
    NSObject,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource {
    
    // MARK: - Properties
    
    private let sectionModel: HotPlaceSectionModel
    
    // 초기화 메서드로 필요한 데이터 주입
    init(sectionModel: HotPlaceSectionModel) {
        self.sectionModel = sectionModel
    }
    
    // MARK: - UICollectionViewDataSource
    
    /// 컬렉션 뷰에서 하나의 섹션만 표시
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /// 섹션의 아이템 개수를 반환
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return sectionModel.items.count
    }
    
    /// 섹션에서 셀을 생성하고 데이터를 설정
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PlaceDetailImageCell.identifier,
            for: indexPath
        ) as? PlaceDetailImageCell else {
            fatalError("Could not dequeue PlaceDetailImageCell")
        }
        
        // safe를 `indexPath.row`가 안전한 범위 내에 있는 경우만 실행
        if let imageModel = sectionModel.items[safe: indexPath.row] {
            cell.configure(model: imageModel)
        }
        
        return cell
    }
    
    // 컬렉션 뷰에서 행(줄) 간 간격 설정
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 14
    }
    
    // 같은 행(라인) 내에서 아이템 간 최소 간격 설정
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    // 컬렉션 뷰의 특정 아이템이 선택되었을 때 실행되는 이벤트 처리
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if indexPath.section == 0 && indexPath.item == 0 {
            print("이미지 컬렉션뷰 탭")
        }
    }
}
