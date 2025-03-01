//
//  AddGoalWithSpeechViewModel.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/19/25.
//


import Foundation
import Speech
import AVFoundation

@available(iOS 17, *)
class AddGoalWithSpeechViewModel: ObservableObject {
    @Published var speechText: String = ""
    @Published var isRecording = false
    @Published var goals: [(label: String, mainGoal: String, miniGoals: [(title: String, dueDate: Date?)])] = []
    @Published var error: Error?
    @Published var isLoading = false
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    func startRecording() {
        isLoading = true
        
        //stop any existing recognition session before starting a new one
        resetRecognition()
        
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Speech recognition is not available"])
            isLoading = false
            return
        }
        
        do {
            try startAudioSession()
            try startRecognition()
            isRecording = true
        } catch {
            self.error = error
            isLoading = false
        }
    }
    
    func stopRecording() {
        guard isRecording else { return }
        
        //stop and clean up
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        recognitionRequest?.endAudio()
        isRecording = false
        
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
        
        print("speech text before extraction: \(speechText)")
        
        //Extract multiple goals from the speech text
        do {
            let extractedGoals = try GoalExtractor.extractMultipleGoals(from: speechText)
            goals = extractedGoals
            print("Updated goals: \(self.goals)")
        } catch {
            self.error = error
            print("Error extracting goals: \(error)")
        }
        
        //Deactivate audio session
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    private func resetRecognition() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
    }
    
    private func startAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    }
    
    private func startRecognition() throws {
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            if let result = result {
                self.speechText = result.bestTranscription.formattedString
            }
            
            if error != nil {
                self.stopRecording()
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        isLoading = false
    }
}
