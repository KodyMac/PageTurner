//
//  SettingsSheet.swift
//  PageTurner
//
//  Created by Kody McNamara on 5/4/26.
//

import SwiftUI

struct SettingsSheet: View {
    @EnvironmentObject var libraryStore: LibraryStore
    @Environment(\.dismiss) var dismiss
    
    //make a local copy, then save when the user is done
    @State private var draft: ReaderSettings
    
    init(current: ReaderSettings) {
        _draft = State(initialValue: current)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                //font size //maybe make a slider?
                Section("Text Size") {
                    VStack(spacing: 8) {
                        HStack {
                            Text("A").font(.system(size:12))
                            Slider(value: $draft.fontSize, in: 12...28, step: 1)
                            Text("A").font(.system(size: 22))
                        }
                        Text("Size \(Int(draft.fontSize))pt")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                
                
                //spacing slider
                Section("Line Spacing") {
                    VStack(spacing: 8) {
                        Slider(value: $draft.lineSpacing, in: 0...20, step: 2)
                        Text("\(Int(draft.lineSpacing))pt spacing")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                
                
                //font picker
                Section("Font") {
                    Picker("Font", selection: $draft.fontChoice) {
                        ForEach(FontChoice.allCases, id: \.self) { font in
                            Text(font.rawValue).tag(font)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                //theme picker
                Section("Theme") {
                    ForEach(ReaderTheme.allCases, id: \.self) { theme in
                        Button {
                            draft.theme = theme
                        } label: {
                            HStack {
                                Circle() //design i got from online with the overlay
                                    .fill(theme.backgroundColor)
                                    .frame(width: 24, height: 24)
                                    .overlay(Circle().stroke(.secondary.opacity(0.3), lineWidth: 1))
                                Text(theme.rawValue)
                                    .foregroundStyle(.primary)
                                Spacer()
                                if draft.theme == theme {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.blue)
                                }
                            }
                        }
                    }
                }
                
                //show preview of what settings would look like
                Section("Preview") {
                    ZStack {
                        draft.theme.backgroundColor
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Text("The story so far: In the beginning the Universe was created. This has made a lot of people very angry and been widely regarded as a bad move.") //idk if i need a quote thing here but -Douglas Adams, "The Restaurant At the End of the Universe" (1980)
                            .font(previewFont)
                            .foregroundStyle(draft.theme.textColor)
                            .lineSpacing(CGFloat(draft.lineSpacing))
                            .padding()
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Reader Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        libraryStore.saveSettings(draft)
                        dismiss()
                    }
                    .bold()
                }
            }
        }
    }
    private var previewFont: Font {
        let size = draft.fontSize
        switch draft.fontChoice {
        case .system:
            return .system(size:size)
        case .serif:
            return .custom("Georgia", size:size)
        case .mono:
            return .custom("Courier New", size:size)
        case .comicSans:
            return .custom("Comic Sans MS", size:size)
        default: return .custom(draft.fontChoice.fontName, size: size)
        }
    }
}
