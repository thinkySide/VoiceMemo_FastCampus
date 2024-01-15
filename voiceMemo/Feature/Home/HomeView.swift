//
//  HomeView.swift
//  voiceMemo
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var pathModel: PathModel
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            TabView(selection: $homeViewModel.selectedTab) {
                TodoListView()
                    .tabItem {
                        Image(
                            homeViewModel.selectedTab == .todoList
                            ? .todoIconSelected
                            : .todoIcon
                        )
                    }
                    .tag(Tab.todoList)
                
                MemoListView()
                    .tabItem {
                        Image(
                            homeViewModel.selectedTab == .memo
                            ? .memoIconSelected
                            : .memoIcon
                        )
                    }
                    .tag(Tab.memo)
                
                VoiceRecorderView()
                    .tabItem {
                        Image(
                            homeViewModel.selectedTab == .voiceRecorder
                            ? .recordIconSelected
                            : .recordIcon
                        )
                    }
                    .tag(Tab.voiceRecorder)
                
                TimerView()
                    .tabItem {
                        Image(
                            homeViewModel.selectedTab == .timer
                            ? .timerIconSelected
                            : .timerIcon
                        )
                    }
                    .tag(Tab.timer)
                
                SettingView()
                    .tabItem {
                        Image(
                            homeViewModel.selectedTab == .setting
                            ? .settingIconSelected
                            : .settingIcon
                        )
                    }
                    .tag(Tab.setting)
            }
            .environmentObject(homeViewModel)
            
            SeparatorLineView()
        }
    }
}

// MARK: - 구분선
private struct SeparatorLineView: View {
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.white, .gray.opacity(0.1)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 10)
                .padding(.bottom, 60)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(PathModel())
        .environmentObject(TodoListViewModel())
        .environmentObject(MemoListViewModel())
}
