//
//  TodoListViewModel.swift
//  voiceMemo
//

import Foundation

class TodoListViewModel: ObservableObject {
    @Published var todos: [Todo]
    @Published var isEditMode: Bool
    @Published var removeTodos: [Todo]
    @Published var isDisplayRemoveTodoAlert: Bool
    
    var removeTodosCount: Int {
        return removeTodos.count
    }
    
    var navigationBarRightButtonMode: NavigationBtnType {
        isEditMode ? .complete : .edit
    }
    
    init(
        todos: [Todo] = [],
        isEditMode: Bool = false,
        removeTodos: [Todo] = [],
        isDisplayRemoveTodoAlert: Bool = false
    ) {
        self.todos = todos
        self.isEditMode = isEditMode
        self.removeTodos = removeTodos
        self.isDisplayRemoveTodoAlert = isDisplayRemoveTodoAlert
    }
}

extension TodoListViewModel {
    
    /// 탭했을 때
    func selectedBoxTapped(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0 == todo }) {
            todos[index].selected.toggle()
        }
    }
    
    /// 추가했을 때
    func addTodo(_ todo: Todo) {
        todos.append(todo)
    }
    
    /// 네비게이션 바 오른쪽 버튼 탭
    func navigationRightButtonTapped() {
        if isEditMode {
            if removeTodos.isEmpty {
                isEditMode = false
            } else {
                setIsDisplayRemoveTodoAlert(true)
            }
        } else {
            isEditMode = true
        }
    }
    
    /// Alert 불러주기
    func setIsDisplayRemoveTodoAlert(_ isDisplay: Bool) {
        isDisplayRemoveTodoAlert = isDisplay
    }
    
    /// 삭제 목록에 넣어주기
    func todoRemoveSelectedBoxTapped(_ todo: Todo) {
        if let index = removeTodos.firstIndex(where: { $0 == todo }) {
            removeTodos.remove(at: index)
        } else {
            removeTodos.append(todo)
        }
    }
    
    /// 삭제 버튼 눌렀을 때
    func removeButtonTapped() {
        todos.removeAll { todo in
            removeTodos.contains(todo)
        }
        
        removeTodos.removeAll()
        isEditMode = false
    }
}
