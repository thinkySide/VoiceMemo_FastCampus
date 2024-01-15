//
//  ToodoListView.swift
//  voiceMemo
//

import SwiftUI

struct TodoListView: View {
    
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            // 투두 셀 리스트
            VStack {
                if !todoListViewModel.todos.isEmpty {
                    CustomNavigationBar(
                        isDisplayLeftButton: false,
                        rightButtonAction: {
                            todoListViewModel.navigationRightButtonTapped()
                        },
                        rightButtonType: todoListViewModel.navigationBarRightButtonMode
                    )
                } else {
                    Spacer()
                        .frame(height: 30)
                }
                
                TitleView()
                    .padding(.top, 20)
                
                if todoListViewModel.todos.isEmpty {
                    AnnouncementView()
                } else {
                    TodoListContentView()
                        .padding(.top, 20)
                }
            }
            
            WriteTodoButtonView()
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .alert(
            "TO DO List \(todoListViewModel.removeTodosCount)개 삭제하시겠습니까?",
            isPresented: $todoListViewModel.isDisplayRemoveTodoAlert
        ) {
            Button("삭제", role: .destructive) {
                todoListViewModel.removeButtonTapped()
            }
            Button("취소", role: .cancel) {}
        }
        
        /// 실시간으로 todo가 생성, 삭제될 때마다
        /// homeViewModel의 메서드 호출(데이터 업데이트)
        .onChange(of: todoListViewModel.todos) { todos in
            homeViewModel.setTodosCount(todos.count)
        }
    }
}

// MARK: - TODO List 타이틀 뷰
private struct TitleView: View {
    
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        HStack {
            if todoListViewModel.todos.isEmpty {
                Text("TO DO LIST를\n추가해 보세요.")
            } else {
                Text("TO DO LIST \(todoListViewModel.todos.count)개가\n있습니다.")
            }
            
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - TODO List 안내뷰
private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            Image(.pencil)
                .renderingMode(.template)
            
            Text("\"매일 아침 5시 운동가라고 알려줘\"")
            Text("\"내일 8시 수강 신청하라고 알려줘\"")
            Text("\"1시 반 점심 약속 리마인드 해줘\"")
            
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundStyle(Color(.customGray2))
    }
}

// MARK: - TODO List 컨텐츠 뷰
private struct TodoListContentView: View {
    
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Text("할일 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)
                
                Spacer()
            }
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color(.customGray0))
                        .frame(height: 1)
                    
                    ForEach(todoListViewModel.todos, id: \.self) { todo in
                        // TODO: - 셀 뷰 호출하고 todo 넣어주기
                        TodoCellView(todo: todo)
                    }
                }
            }
        }
    }
}

// MARK: - TODO 셀 뷰
private struct TodoCellView: View {
    
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @State private var isRemoveSelected: Bool
    private var todo: Todo
    
    fileprivate init(
        isRemoveSelected: Bool = false,
        todo: Todo
    ) {
        _isRemoveSelected = State(initialValue: isRemoveSelected)
        self.todo = todo
    }
    
    fileprivate var body: some View {
        VStack(spacing: 20) {
            HStack {
                if !todoListViewModel.isEditMode {
                    Button {
                        todoListViewModel.selectedBoxTapped(todo)
                    } label: {
                        todo.selected ? Image(.selectedBox) : Image(.unSelectedBox)
                    }
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(todo.title)
                        .font(.system(size: 16))
                        .foregroundStyle(todo.selected ? Color(.customIconGray) : Color(.customBlack))
                        .strikethrough(todo.selected)
                    
                    Text(todo.convertedDayAndTime)
                        .font(.system(size: 16))
                        .foregroundStyle(Color(.customIconGray))
                }
                
                Spacer()
                
                if todoListViewModel.isEditMode {
                    Button {
                        isRemoveSelected.toggle()
                        todoListViewModel.todoRemoveSelectedBoxTapped(todo)
                    } label: {
                        isRemoveSelected ? Image(.selectedBox) : Image(.unSelectedBox)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            Rectangle()
                .fill(Color(.customGray0))
                .frame(height: 1)
        }
    }
}

// MARK: - 작성 버튼
private struct WriteTodoButtonView: View {
    
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                Button {
                    pathModel.paths.append(.todoView)
                } label: {
                    Image(.writeBtn)
                }
            }
        }
    }
}

#Preview {
    TodoListView()
        .environmentObject(PathModel())
        .environmentObject(TodoListViewModel())
}
