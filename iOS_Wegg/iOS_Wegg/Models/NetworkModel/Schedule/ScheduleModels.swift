//
//  ScheduleModels.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/19/25.
//

import Foundation

struct CookieStorage {
    static let cookie: String = "6F77FD41916947AB15E622DE5254C8B5"
}

/// 일정 상태를 나타내는 Enum
enum ScheduleStatus: String, Codable {
    case yet = "YET"           // 계획 시작 전
    case started = "STARTED"   // 계획 시작(장소 인증한 후)
    case succeeded = "SUCCEEDED" // 계획 성공
    case failed = "FAILED"     // 계획 실패

    /// 상태에 따른 설명 반환
    var description: String {
        switch self {
        case .yet:
            return "계획 시작 전"
        case .started:
            return "계획 시작(장소인증한 후)"
        case .succeeded:
            return "계획 성공"
        case .failed:
            return "계획 실패"
        }
    }
}

// 지각 상태 Enum
enum LateStatus: String, Codable {
    case onTime = "ZERO"      // 정시 도착
    case late3Min = "THREE"    // 3분 지각
    case late5Min = "FIVE"     // 5분 지각
    case late7Min = "SEVEN"    // 7분 지각
    case late10Min = "TEN"     // 10분 지각
}

enum ScheduleOnOffSyntax: String, Codable {
    case on = "TRUE"
    case off = "FALSE"
}
