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
            //print(error)
        }
        do{
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        }catch{
            //print(error)
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
                isFinal = result.isFinal
                if isFinal {
                    //self.finishState = isFinal
                    self.returnOutput = result.bestTranscription.formattedString
                    //print("return:" + self.returnOutput)
                }
                
                
            }
            if isFinal{
                self.stopRecording()
                print("transcription: " + self.returnOutput)
                callback(self.returnOutput)
                
                
            }else if error == nil{
                self.restartSpeechTimer()
                
            }
            if error != nil {
                self.stopRecording()
				//print(error!)
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
            //print(error)
        }
        

    }
    
    private func stopRecording(){
        self.audioEngine.stop()
        
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        self.recognitionRequest = nil
        self.recognitionTask = nil
    }
    
    private func restartSpeechTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: {(timer) in
            timer.invalidate()
            self.stopRecording()
            
        })
    }
    
}

class TextToSpeech{
    // this method turns text to speech
    public func speak(words:String){
		
		//listVoices()
		var voiceToUse: AVSpeechSynthesisVoice?
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            
            if voice.name == "Alex"{
                voiceToUse = voice
            }else if voice.name == "Aaron"{
                voiceToUse = voice
			}else if voice.name == "Karen"{
				voiceToUse = voice
			}else if voice.name == "Samantha"{
                voiceToUse = voice
            }
        }
		
        let utterance = AVSpeechUtterance(string: words)
		utterance.voice = voiceToUse
        //print("voice using is")
		if utterance.voice != nil {
			//print(utterance.voice!)
		}
        //utterance.voice = AVSpeechSynthesisVoice(language:"en-US")
        utterance.rate = 0.45
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
	
	public func listVoices() {

        let voicesAvailable = AVSpeechSynthesisVoice.speechVoices()
        for voice in voicesAvailable {
            print (voice.identifier + " " + voice.language + " " + voice.name)
        }
    }
    
}






