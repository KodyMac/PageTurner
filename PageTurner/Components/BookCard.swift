//
//  BookCard.swift
//  PageTurner
//
//  Created by Kody McNamara on 5/1/26.
//

import SwiftUI

struct BookCard: View {
    let book: Book
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            //cover image
            AsyncImage(url: book.coverURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure, .empty:
                    Rectangle()
                        .foregroundStyle(.secondary.opacity(0.2))
                        .overlay {
                            Image(systemName: "book.closed")
                                .foregroundStyle(.secondary)
                        }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 60, height: 85)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .shadow(color: .black.opacity(0.15),radius:4,x:0,y:2)
            
            //tedt info
            VStack(alignment: .leading, spacing:4) {
                Text(book.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(book.authorNames)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                
                Spacer()
                
                Text("\(book.downloadCount.formatted()) downloads")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
    }
}
