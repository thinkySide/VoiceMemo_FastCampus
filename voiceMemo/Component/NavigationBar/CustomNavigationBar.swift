//
//  CustomNavigationBar.swift
//  voiceMemo
//

import SwiftUI

struct CustomNavigationBar: View {
    
    let isDisplayLeftButton: Bool
    let isDisplayRightButton: Bool
    let leftButtonAction: () -> Void
    let rightButtonAction: () -> Void
    let rightButtonType: NavigationBtnType
    
    init(
        isDisplayLeftButton: Bool = true,
        isDisplayRightButton: Bool = true,
        leftButtonAction: @escaping () -> Void = {},
        rightButtonAction: @escaping () -> Void = {},
        rightButtonType: NavigationBtnType = .edit
    ) {
        self.isDisplayLeftButton = isDisplayLeftButton
        self.isDisplayRightButton = isDisplayRightButton
        self.leftButtonAction = leftButtonAction
        self.rightButtonAction = rightButtonAction
        self.rightButtonType = rightButtonType
    }
    
    var body: some View {
        HStack {
            if isDisplayLeftButton {
                Button(
                    action: leftButtonAction,
                    label: { Image(.leftArrow) }
                )
            }
            
            Spacer()
            
            if isDisplayRightButton {
                Button(
                    action: rightButtonAction,
                    label: {
                        if rightButtonType == .close {
                            Image(.close)
                        } else {
                            Text(rightButtonType.rawValue)
                                .foregroundStyle(Color(.customBlack))
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 20)
    }
}

#Preview {
    CustomNavigationBar()
}
