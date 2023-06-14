//
//  chatGPT.swift
//  chatGPT
//
//  Created by 坂本　龍征 on 2023/06/13.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct chatGPTEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack{
            Text("ChatGPTに・・・")
                .font(.title)
                .padding(.bottom,5)
                .padding(.top,5)
            HStack{
                Link(destination: URL(string: "Label://question")!, label:{
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.green)
                        .padding(5)
                        .overlay(
                            Text("質問")
                                .foregroundColor(.white)
                                .font(.title)
                        )
                    
                })
                Link(destination: URL(string: "Label://consult")!, label:{
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.green)
                        .padding(5)
                        .overlay(
                            Text("相談")
                                .foregroundColor(.white)
                                .font(.title)
                            
                        )
                    
                })
                Link(destination: URL(string: "Label://talk")!, label:{
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.green)
                        .padding(5)
                        .overlay(
                            Text("会話")
                                .foregroundColor(.white)
                                .font(.title)
                            
                        )
                    
                })
                
            }
        }
    }
}

struct chatGPT: Widget {
    let kind: String = "chatGPT"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            chatGPTEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

struct chatGPT_Previews: PreviewProvider {
    static var previews: some View {
        chatGPTEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
