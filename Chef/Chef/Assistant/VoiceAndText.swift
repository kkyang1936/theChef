import Foundation
import AVFoundation
import Speech

class SpeechToText {
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    var recognitionRequest : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    var transcriptionOutput = ""
    var returnOutput = ""
    //var changed = false
    //public var finishState = false
    
    private func requestAuthorization(){
        // Asynchronously make the authorization request.
        SFSpeechRecognizer.requestAuthorization { authStatus in

            // Divert to the app's main thread so that the UI
            // can be updated.
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.transcriptionOutput = ""
                    
                case .denied:
                    self.transcriptionOutput = "access denied"
                    
                case .restricted:
                    self.transcriptionOutput = "access restricted"
                    
                case .notDetermined:
                    self.transcriptionOutput = "access not Determined"
                    
                default:
                    self.transcriptionOutput = "access error"
                }
            }
        }
    }
    
    public func recognize(callback: @escaping (String) -> ()) {
        self.requestAuthorization()
        
        // Cancel the previous task if it's running.
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        do{
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
        }catch{
            print(error)
        }
        do{
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        }catch{
            print(error)
        }
        let inputNode = audioEngine.inputNode
        
        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        // Keep speech recognition data on device
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = false
        }
        
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                
                // Update the text view with the results.
                self.transcriptionOutput = result.bestTranscription.formattedString
                print("transcripting:" + self.transcriptionOutput)
                isFinal = result.isFinal
                if isFinal {
                    //self.finishState = isFinal
                    self.returnOutput = result.bestTranscription.formattedString
                    //print("return:" + self.returnOutput)
                }
                
                
            }
            if isFinal{
                self.stopRecording()
                print("result:" + self.returnOutput)
                callback(self.returnOutput)
                
                
            }else if error == nil{
                self.restartSpeechTimer()
                
            }
            if error != nil {
                self.stopRecording()
                print(error)
                //call back
                self.returnOutput = "error occur, script transcription failed"
                callback(self.returnOutput)
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do{
            try audioEngine.start()
        }catch{
            print(error)
        }
        
        
        // Let the user know to start talking.
        //textView.text = "(Go ahead, I'm listening)"
        
        
        //return self.returnOutput
        //call back
        //callback(self.returnOutput)
    }
    
    private func stopRecording(){
        self.audioEngine.stop()
        
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        self.recognitionRequest = nil
        self.recognitionTask = nil
    }
    
    private func restartSpeechTimer() {
        let timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: {(timer) in
            timer.invalidate()
            self.stopRecording()
            
        })
    }
    
    
    /*func recognize(callback: @escaping (String) -> ()) {
        DispatchQueue.main.async {
            callback(self.recognize())
        }
    }*/

}

class TextToSpeech{
    // this method turns text to speech
    public func speak(words:String){
        let utterance = AVSpeechUtterance(string: words)
        utterance.voice = AVSpeechSynthesisVoice(language:"en-US")
        utterance.rate = 0.55
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
}




