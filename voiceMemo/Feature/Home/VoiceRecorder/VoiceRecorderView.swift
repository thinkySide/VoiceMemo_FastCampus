//
//  VoiceRecorderView.swift
//  voiceMemo
//

import SwiftUI

struct VoiceRecorderView: View {
    
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @StateObject private var voiceRecorderViewModel = VoiceRecorderViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                TitleView()
                
                if voiceRecorderViewModel.recordedFiles.isEmpty {
                    AnnouncementView()
                } else {
                    VoiceRecorderListView(voiceRecorderViewModel: voiceRecorderViewModel)
                        .padding(.top, 15)
                }
                
                Spacer()
            }
            
            RecordButtonView(voiceRecordViewModel: voiceRecorderViewModel)
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .alert(
            "선택된 음성메모를 삭제하시겠습니까?",
            isPresented: $voiceRecorderViewModel.isDisplayRemoveAlert
        ) {
            Button("삭제", role: .destructive) {
                voiceRecorderViewModel.removeSelectedVoiceRecord()
            }
            
            Button("취소", role: .cancel) {}
        }
        .alert(
            voiceRecorderViewModel.alertMessage,
            isPresented: $voiceRecorderViewModel.isDisplayAlert
        ) {
            Button("확인", role: .cancel) {}
        }
        .onChange(of: voiceRecorderViewModel.recordedFiles) { recordedFiles in
            homeViewModel.setVoiceRecordersCount(recordedFiles.count)
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    fileprivate var body: some View {
        HStack {
            Text("음성메모")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color(.customBlack))
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 30)
    }
}

// MARK: - 음성 메모 안내 뷰
private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Rectangle()
                .fill(Color(.customCoolGray))
                .frame(height: 1)
            
            Spacer()
                .frame(height: 180)
            
            Image(.pencil)
                .renderingMode(.template)
            
            Text("현재 등록된 음성메모가 없습니다.")
            
            Text("하단의 녹음 버튼을 눌러 음성메모를 시작해주세요.")
            
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundStyle(Color(.customGray2))
    }
}

// MARK: - 음성 메모 리스트 뷰
private struct VoiceRecorderListView: View {
    
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    
    fileprivate init(voiceRecorderViewModel: VoiceRecorderViewModel) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
    }
    
    fileprivate var body: some View {
        ScrollView(.vertical) {
            VStack {
                Rectangle()
                    .fill(Color(.customGray2))
                    .frame(height: 1)
                
                ForEach(voiceRecorderViewModel.recordedFiles, id: \.self) { recordedFile in
                    VoiceRecorderCellView(
                        voiceRecorderViewModel: voiceRecorderViewModel,
                        recordedFile: recordedFile
                    )
                }
            }
        }
    }
}

// MARK: - 음성 메모 셀 뷰
private struct VoiceRecorderCellView: View {
    
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    private var recordedFile: URL
    private var creationDate: Date?
    private var duration: TimeInterval?
    private var progressBarValue: Float {
        if voiceRecorderViewModel.selectedRecordedFile == recordedFile
            && (voiceRecorderViewModel.isPlaying || voiceRecorderViewModel.isPaused) {
            return Float(voiceRecorderViewModel.playedTime) / Float(duration ?? 1)
        } else {
            return 0
        }
    }
    
    fileprivate init(
        voiceRecorderViewModel: VoiceRecorderViewModel,
        recordedFile: URL
    ) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
        self.recordedFile = recordedFile
        (self.creationDate, self.duration) = voiceRecorderViewModel.getFileInfo(for: recordedFile)
    }
    
    fileprivate var body: some View {
        VStack {
            Button {
                voiceRecorderViewModel.voiceRecordCellTapped(recordedFile)
            } label: {
                VStack {
                    HStack {
                        Text(recordedFile.lastPathComponent)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color(.customBlack))
                        
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        if let creationDate = creationDate {
                            Text(creationDate.formattedVoiceRecorderTime)
                                .font(.system(size: 14))
                                .foregroundStyle(Color(.customIconGray))
                        }
                        
                        Spacer()
                        
                        if voiceRecorderViewModel.selectedRecordedFile != recordedFile,
                           let duration = duration {
                            Text(duration.formattedTimeInterval)
                                .font(.system(size: 14))
                                .foregroundStyle(Color(.customIconGray))
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            
            if voiceRecorderViewModel.selectedRecordedFile == recordedFile {
                VStack {
                    ProgressBar(progress: progressBarValue)
                        .frame(height: 2)
                    
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        Text(voiceRecorderViewModel.playedTime.formattedTimeInterval)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(Color(.customIconGray))
                        
                        Spacer()
                        
                        if let duration = duration {
                            Text(duration.formattedTimeInterval)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(Color(.customIconGray))
                        }
                    }
                    
                    Spacer()
                        .frame(height: 10)
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            if voiceRecorderViewModel.isPaused {
                                voiceRecorderViewModel.resumePlaying()
                            } else {
                                voiceRecorderViewModel.startPlaying(recordingURL: recordedFile)
                            }
                        } label: {
                            Image(.play)
                                .renderingMode(.template)
                                .foregroundStyle(Color(.customBlack))
                        }
                        
                        Spacer()
                            .frame(width: 10)
                        
                        Button {
                            if voiceRecorderViewModel.isPlaying {
                                voiceRecorderViewModel.pausePlaying()
                            }
                        } label: {
                            Image(.pause)
                                .renderingMode(.template)
                                .foregroundStyle(Color(.customBlack))
                        }
                        
                        Spacer()
                        
                        Button {
                            voiceRecorderViewModel.removeButtonTapped()
                        } label: {
                            Image(.trash)
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(Color(.customBlack))
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Rectangle()
                .fill(Color(.customGray2))
                .frame(height: 1)
        }
    }
}

// MARK: - 프로그레스 바
private struct ProgressBar: View {
    
    private var progress: Float
    
    fileprivate init(progress: Float) {
        self.progress = progress
    }
    
    fileprivate var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(.customGray2))
                
                Rectangle()
                    .fill(Color(.customGreen))
                    .frame(width: CGFloat(self.progress) * geometry.size.width)
            }
        }
    }
}

// MARK: - 녹음 버튼 뷰
private struct RecordButtonView: View {
    
    @ObservedObject private var voiceRecordViewModel: VoiceRecorderViewModel
    
    fileprivate init(voiceRecordViewModel: VoiceRecorderViewModel) {
        self.voiceRecordViewModel = voiceRecordViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack{
                Spacer()
                
                Button {
                    voiceRecordViewModel.recordButtonTapped()
                } label: {
                    if voiceRecordViewModel.isRecording {
                        Image(.micRecording)
                    } else {
                        Image(.mic)
                    }
                }
                
            }
        }
    }
}

#Preview {
    VoiceRecorderView()
}
