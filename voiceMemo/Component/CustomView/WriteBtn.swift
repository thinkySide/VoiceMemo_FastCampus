//
//  WriteBtn.swift
//  voiceMemo
//
//

import SwiftUI

// MARK: - 1. ViewModifier로 만들기

/// Public = 모듈간에 분리가 되었을 때도 호출 가능.
public struct WriteButtonViewModifier: ViewModifier {
    let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    /// body -> 필수 구현
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        action()
                    } label: {
                        Image(.writeBtn)
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 50)
            }
        }
    }
}


// MARK: - 2. View를 확장해서 사용하는 방법
extension View {
    public func writeButton(perform action: @escaping () -> Void) -> some View {
        ZStack {
            self
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        action()
                    } label: {
                        Image(.writeBtn)
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 50)
            }
        }
    }
}


// MARK: - 3 새로운 View를 만들어 사용하는 방법
public struct WriteButtonView<Content: View>: View {
    let content: Content
    let action: () -> Void
    
    public init(
        @ViewBuilder content: () -> Content,
        action: @escaping () -> Void
    ) {
        self.content = content()
        self.action = action
    }
    
    public var body: some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        action()
                    } label: {
                        Image(.writeBtn)
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 50)
            }
        }
    }
}
