//
//  OnboardingContent.swift
//  voiceMemo
//

import Foundation

/// 탭뷰로 사용되기 때문에 Hashable 프로토콜 채택
struct OnboardingContent: Hashable {
    var imageFileName: String
    var title: String
    var subTitle: String
    
    init(
        imageFileName: String,
        title: String,
        subTitle: String
    ) {
        self.imageFileName = imageFileName
        self.title = title
        self.subTitle = subTitle
    }
}
