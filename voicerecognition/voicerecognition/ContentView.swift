//
//  ContentView.swift
//  voicerecognition
//
//  Created by 坂本　龍征 on 2023/06/11.
//
import SwiftUI
import Speech

struct ContentView: View {
//    @Stateは値が変更されたらViewが再描画される変数を宣言できる。
//            又structの中で値が変更できる。
    @State private var label: String = ""//labelに音声認識で検出した文字が格納される。
    @State private var buttonTitle: String = "話しかける"
    @State private var recording: Bool = false//レコーディングボタンが押されたか押されてないか？
    @State private var content: String = ""//ChatGPTに渡す言葉
    @State private var requesting: Bool = false//ChatGPTへリクエストを出したか出してないか？
    @State private var response: String = "none"//ChatGPTから帰ってきた言葉
    
    
    //音声認識の言語設定設定
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja_JP"))!
    private let audioEngine = AVAudioEngine()
    @State private var recognitionReq = SFSpeechAudioBufferRecognitionRequest()
    @State private var recognitionTask: SFSpeechRecognitionTask?
    
    var body: some View {
        VStack {
            Text(label)
                .padding()
            
            Button(action: {
                if recording {
                    stopSpeechRecognition()
                } else {
                    startSpeechRecognition()
                }
            }) {
                Text(buttonTitle)
            }
            .padding()
            .disabled(!recognizer.isAvailable)
            
            Button(action: {
                requesting = true
                content = label
                
                Task{
                    response = await request()
                    requesting = false
                }
            }){
                Text("ChatGPTへ")
            }
        }
        .onAppear {
//            ユーザーから許諾を取るためにダイアログを表示するためのメソッド
            requestAuthorization()
            setupAudioSession()
        }
    }
    
    private func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized && self.recognizer.isAvailable {
                    self.buttonTitle = "音声認識の開始"
                } else {
                    self.buttonTitle = "音声認識は利用不可"
                }
            }
        }
    }
    
    private func setupAudioSession() {
        do {
            if recognizer.supportsOnDeviceRecognition {
                recognitionReq.requiresOnDeviceRecognition = true
            }
            recognitionReq.shouldReportPartialResults = true
            
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func startSpeechRecognition() {
        do {
            self.label = ""
            if let recognitionTask = recognitionTask {
                recognitionTask.cancel()
                self.recognitionTask = nil
            }
            
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 2048, format: recordingFormat) { buffer, time in
                recognitionReq.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            recognitionTask = recognizer.recognitionTask(with: recognitionReq) { result, error in
                if let error = error {
                    print("\(error)")
                } else {
                    DispatchQueue.main.async {
                        self.label = result?.bestTranscription.formattedString ?? ""
                    }
                }
            }
            
            recording = true
            buttonTitle = "音声認識の停止"
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func stopSpeechRecognition() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionReq.endAudio()
        
        recording = false
        recognitionReq = SFSpeechAudioBufferRecognitionRequest()
        buttonTitle = "音声認識の開始"
    }
    
    private func request() async -> String{
        
        //URL
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            return "URL error"
        }
        
        //URLRequestを作成
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.allHTTPHeaderFields = ["Authorization" : "Bearer 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"
                                   ,"OpenAI-Organization": "org-5y3XaXNcdHS6USR5BggTG29v"
                                   ,"Content-Type" : "application/json"]
        req.httpBody = """
{
"model" : "gpt-3.5-turbo"
,"messages": [{"role": "user", "content": "\(content)"}]
}
""".data(using: .utf8)
        
        //URLSessionでRequest
        guard let (data, urlResponse) = try? await URLSession.shared.data(for: req) else {
            return "URLSession error"
        }
        
        //ResponseをHTTPURLResponseにしてHTTPレスポンスヘッダを得る
        guard let httpStatus = urlResponse as? HTTPURLResponse else {
            return "HTTPURLResponse error"
        }
        
        //BodyをStringに、失敗したらレスポンスコードを返す
        guard let response = String(data: data, encoding: .utf8) else {
            return "\(httpStatus.statusCode)"
        }
        
        print(response)
        if let jsonData = response.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    print(content)
                    // ここでcontentを使用することができます
                }
            } catch {
                print("JSONパースエラー: \(error)")
            }
        }
        
//        let decoder = JSONDecoder()
//        guard let employee = try? decoder.decode(ResponseGpt.self, from: response) else {
//            fatalError("Failed to decode from JSON.")
//        }
        
        return response
        
    }
}

//@main
//struct SpeechRecognitionApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
