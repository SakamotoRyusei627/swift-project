//
//  FirstView.swift
//  voicerecognition
//
//  Created by 坂本　龍征 on 2023/06/12.
//

import SwiftUI

struct FirstView: View {
    @State var showingIndicator = false
    @State var requestQuestion = "あなたに質問したいです。"
    @State var requestConsult = "あなたに相談したいです。"
    @State var requestTalk = "あなたと会話したいです。"
    var body: some View {
        NavigationView{
            VStack {
                NavigationLink(destination: ContentView(request: $requestQuestion)){
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
                NavigationLink(destination: ContentView(request: $requestConsult)){
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
                NavigationLink(destination: ContentView(request: $requestTalk)){
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
            }
            .navigationTitle("chatGPTに・・・")
        }
        
    }
    
    
}




struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
