//
//  MasonryView.swift
//  PhotoFinish
//
//  Created by Renata Liu on 2025-03-23.
//

import SwiftUI

struct MasonryView: View {
    let images: [UIImage]
    
    private var leftColumn: [UIImage] = []
    private var rightColumn: [UIImage] = []
    
    init(images: [UIImage]) {
        self.images = images
        
        for (index, image) in images.enumerated() {
            if index % 2 == 0 {
                leftColumn.append(image)
            } else {
                rightColumn.append(image)
            }
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            
            LazyVStack(spacing: 16) {
                ForEach(leftColumn.indices, id: \.self) { idx in
                    Image(uiImage: leftColumn[idx])
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                        .shadow(color: .cyan, radius: 5, x: 0, y: 0)
                }
            }
            
            LazyVStack(spacing: 16) {
                ForEach(rightColumn.indices, id: \.self) { idx in
                    Image(uiImage: rightColumn[idx])
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                        .shadow(color: .cyan, radius: 5, x: 0, y: 0)
                }
            }
        }
    }
}
