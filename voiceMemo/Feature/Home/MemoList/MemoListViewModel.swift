//
//  MemoListViewModel.swift
//  voiceMemo
//

import Foundation

class MemoListViewModel: ObservableObject {
    @Published var memos: [Memo]
    @Published var isEditMode: Bool
    @Published var removeMemos: [Memo]
    @Published var isDisplayRemoveAlert: Bool
    
    var removeMemoCount: Int {
        removeMemos.count
    }
    
    var navigationBarRightButtonMode: NavigationBtnType {
        isEditMode ? .complete : .edit
    }
    
    init(
        memos: [Memo] = [],
        isEditMode: Bool = false,
        removeMemos: [Memo] = [],
        isDisplayRemoveAlert: Bool = false
    ) {
        self.memos = memos
        self.isEditMode = isEditMode
        self.removeMemos = removeMemos
        self.isDisplayRemoveAlert = isDisplayRemoveAlert
    }
}

extension MemoListViewModel {
    func addMemo(_ memo: Memo) {
        memos.append(memo)
    }
    
    func updateMemo(_ memo: Memo) {
        if let index = memos.firstIndex(where: { $0 == memo }) {
            memos[index] = memo
        }
    }
    
    func removeMemo(_ memo: Memo) {
        if let index = memos.firstIndex(where: { $0 == memo }) {
            memos.remove(at: index)
        }
    }
    
    func navigationRightButtonTapped() {
        if isEditMode {
            if removeMemos.isEmpty {
                isEditMode = false
            } else {
                setIsDisplayRemoveMemoAlert(true)
            }
        } else {
            isEditMode = true
        }
    }
    
    func setIsDisplayRemoveMemoAlert(_ isDisplay: Bool) {
        isDisplayRemoveAlert = isDisplay
    }
    
    func memoRemoveSelectedBoxTapped(_ memo: Memo) {
        if let index = removeMemos.firstIndex(where: { $0 == memo }) {
            removeMemos.remove(at: index)
        } else {
            removeMemos.append(memo)
        }
    }
    
    func removeButtonTapped() {
        memos.removeAll { memo in
            removeMemos.contains(memo)
        }
        removeMemos.removeAll()
        isEditMode = false
    }
}
