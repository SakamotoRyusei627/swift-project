//
//  FirstView.swift
//  voicerecognition
//
//  Created by 坂本　龍征 on 2023/06/12.
//aa

import SwiftUI

struct FirstView: View {
    @State var startPointStr: String = "home icon"
    @State var requestQuestion = "あなたに質問したいです。"
    @State var requestConsult = "あなたに相談したいです。"
    @State var requestTalk = "あなたと会話したいです。"
    @State private var password = ""                    // 入力された合言葉
    @State private var showingSecondViewQ = false        // 画面遷移フラグ
    @State private var showingSecondViewC = false        // 画面遷移フラグ
    @State private var showingSecondViewT = false        // 画面遷移フラグ
    var body: some View {
        /// ナビゲーションの定義
        NavigationStack {
            VStack{
                Button(action: {
                    if(showingSecondViewQ == false){
                        self.showingSecondViewQ = true
                    }
                }) {
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(.green)
                        .padding(10)
                        .overlay(
                            Text("質問する")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .padding(10)
                            
                        )
                }
                .navigationDestination(isPresented: $showingSecondViewQ) {
                    ContentView(request: $requestQuestion)
                }
                Button(action: {
                    if(showingSecondViewC == false){
                        self.showingSecondViewC = true
                    }
                }) {
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(.green)
                        .padding(10)
                        .overlay(
                            Text("相談する")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .padding(10)
                            
                        )
                }
                .navigationDestination(isPresented: $showingSecondViewC) {
                    ContentView(request: $requestConsult)
                }
                Button(action: {
                    if(showingSecondViewT == false){
                        self.showingSecondViewT = true
                    }
                }) {
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(.green)
                        .padding(10)
                        .overlay(
                            Text("会話する")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .padding(10)
                            
                        )
                }
                .navigationDestination(isPresented: $showingSecondViewT) {
                    ContentView(request: $requestTalk)
                }
            }
            .navigationTitle("chatGPTに・・・")
            .onOpenURL(perform: { url in
                startPointStr = url.host ?? "unknown"
                if(startPointStr == "question"){
                    self.showingSecondViewQ = true
                }else if(startPointStr == "consult"){
                    self.showingSecondViewC = true
                }else if (startPointStr == "talk"){
                    self.showingSecondViewT = true
                }
                
            })
        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
