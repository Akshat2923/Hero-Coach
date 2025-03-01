//
//  PhotoUploadView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/23/25.
//
import SwiftUI
import PhotosUI

@available(iOS 17, *)
struct PhotoUploadView: View {
    @Binding var imagesData: [Data]
    @State private var selectedItems: [PhotosPickerItem] = []
    let onImagesUpdated: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if imagesData.isEmpty {
                PhotosPicker(
                    selection: $selectedItems,
                    maxSelectionCount: 5,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    VStack(spacing: 8) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 40))
                            .foregroundStyle(.gray)
                        Text("Personalize it!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(30)
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(imagesData, id: \.self) { data in
                            if let uiImage = UIImage(data: data) {
                                VStack(spacing: 8) {
                                    ZStack {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .cornerRadius(32)
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 400, height: 200)
                                            .clipped()
                                            .scrollTransition(
                                                axis: .horizontal
                                            ) { content, phase in
                                                content
                                                    .offset(x: phase.value * -250)
                                            }
                                    }
                                    .containerRelativeFrame(.horizontal)
                                    .clipShape(RoundedRectangle(cornerRadius: 32))
                                }
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                
                .contentMargins(.horizontal, 32)
                
                PhotosPicker(
                    selection: $selectedItems,
                    maxSelectionCount: 5,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20))
                        
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .onChange(of: selectedItems) { newItems in
            Task {
                var newImages: [Data] = []
                for item in newItems {
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        newImages.append(data)
                    }
                }
                if !newImages.isEmpty {
                    imagesData.append(contentsOf: newImages)
                    onImagesUpdated()
                    selectedItems.removeAll()
                }
            }
        }
    }
}
