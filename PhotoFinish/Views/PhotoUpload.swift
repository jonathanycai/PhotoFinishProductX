//
//  PhotoUpload.swift
//  PhotoFinish
//
//  Created by Jasper Mao on 2025-03-22.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct PhotoUpload: View {
    // Use a constant for testing with a specific local image
    let testImage = UIImage(named: "exampleUpload")

    @State var retrievedImages = [UIImage]()
    @State private var imagePaths = [String]()
    @State private var showingSheet = false
    
    // Add state for fullscreen image
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingFullscreen = false
    
    // Date formatter for parsing filenames
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        return formatter
    }()
    
    @StateObject var viewModel: ToDoListViewViewModel
    @FirestoreQuery var items: [ToDoListItem]
    
    // Computed property to calculate completion percentage
    private var completionPercentage: Double {
        guard !items.isEmpty else { return 0 }
        
        let completedCount = items.filter { $0.isDone }.count
        return Double(completedCount) / Double(items.count) * 100
    }
    
    init(userId: String) {
        self._items = FirestoreQuery(
            collectionPath: "users/\(userId)/todos"
        )
        self._viewModel = StateObject(wrappedValue: ToDoListViewViewModel(userId: userId)
        )
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text("TODO For Today")
                    .font(.headline)
                    .padding(.top)
                List(items) { item in
                    ToDoListItemView(item: item)
                }
                
                // Task completion statistics
                HStack {
                    VStack(alignment: .leading) {
                        Text("Task Completion")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 4) {
                            Text("\(Int(completionPercentage))%")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(completionColor)
                            
                            Text("completed")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    // Progress circle
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                            .frame(width: 50, height: 50)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(min(completionPercentage / 100, 1.0)))
                            .stroke(completionColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .frame(width: 50, height: 50)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear, value: completionPercentage)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                /// Display retrieved images
                Text("Retrieved Images (\(retrievedImages.count))")
                    .font(.headline)
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // Group photos by day
                        ForEach(groupPhotosByDay().keys.sorted(by: >), id: \.self) { day in
                            if let photosIndicesForDay = groupPhotosByDay()[day] {
                                Section {
                                    LazyVGrid(columns: [
                                        GridItem(.flexible(), spacing: 12),
                                        GridItem(.flexible(), spacing: 12),
                                        GridItem(.flexible(), spacing: 12)
                                    ], spacing: 12) {
                                        ForEach(photosIndicesForDay, id: \.self) { index in
                                            Image(uiImage: retrievedImages[index])
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                                .padding(4)
                                                .onTapGesture {
                                                    selectedImage = retrievedImages[index]
                                                    isShowingFullscreen = true
                                                }
                                        }
                                    }
                                } header: {
                                    HStack {
                                        Text(formatSectionHeader(for: day))
                                            .font(.headline)
                                            .foregroundColor(Color(red:0.71, green:0.85, blue:0.97))
                                            .padding(.leading, 8)
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    .padding() // Added padding around the entire grid
                }
            }
            .background(Color.black)
            .onAppear {
                retrievePhotos()
            }
            
            // Fullscreen overlay when an image is selected
            if isShowingFullscreen, let image = selectedImage {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        ZStack {
                            // Image
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .edgesIgnoringSafeArea(.all)
                            
                            // Close button
                            VStack {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        isShowingFullscreen = false
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 30))
                                            .foregroundColor(.white)
                                            .padding()
                                            .shadow(radius: 2)
                                    }
                                }
                                Spacer()
                            }
                        }
                    )
                    .transition(.opacity)
                    .zIndex(1) // Ensure it's above everything else
                    .onTapGesture {
                        isShowingFullscreen = false
                    }
            }
        }
        .animation(.easeInOut, value: isShowingFullscreen)
    }

    func uploadPhoto() {
        guard let selectedImage = testImage else {
            print("No test image available")
            return
        }

        // Create storage reference
        let storageRef = Storage.storage().reference()

        // Turn image into data
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to data")
            return
        }

        // Get current date and time
        let currentDate = Date()

        // Format the date as a string
        let dateString = dateFormatter.string(from: currentDate)

        // Use the formatted date string in your file path
        let path = "images/\(dateString).jpg"
        
        let fileRef = storageRef.child(path)

        // Upload data
        _ = fileRef.putData(imageData, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
                print("Successfully uploaded image")

                let db = Firestore.firestore()
                db.collection("images").document().setData(["url": path]) { error in
                    // If no error, display new image
                    if error == nil {
                        DispatchQueue.main.async {
                            // Add uploaded image to list of images
                            self.retrievedImages.append(selectedImage)
                            self.imagePaths.append(path)
                        }
                    }
                }
            } else {
                print("Error uploading: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }

    // Computed property to determine color based on completion percentage
    private var completionColor: Color {
        if completionPercentage < 30 {
            return .red
        } else if completionPercentage < 70 {
            return .orange
        } else {
            return .green
        }
    }

    func retrievePhotos() {
        // Get data from db
        let db = Firestore.firestore()

        db.collection("images").getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                var paths = [String]()

                // Loop through all returned docs
                for doc in snapshot!.documents {
                    // Extract filepath
                    paths.append(doc["url"] as! String)
                }

                // Clear previous data
                self.retrievedImages = []
                self.imagePaths = []
                
                // Loop through filepaths
                for path in paths {
                    // Get reference to storage
                    let storageRef = Storage.storage().reference()

                    // Specify path
                    let fileRef = storageRef.child(path)

                    // Retrieve the data
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        // Check for errors
                        if error == nil && data != nil {
                            // Create UI image and put into array for display
                            if let image = UIImage(data: data!) {
                                DispatchQueue.main.async {
                                    self.retrievedImages.append(image)
                                    self.imagePaths.append(path)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Group image indices by day
    private func groupPhotosByDay() -> [Date: [Int]] {
        let calendar = Calendar.current
        var result: [Date: [Int]] = [:]
        
        for i in 0..<imagePaths.count {
            // Extract the date from the path
            // The path format is "images/yyyy-MM-dd_HH-mm-ss.jpg"
            let path = imagePaths[i]
            let filename = path.components(separatedBy: "/").last?.replacingOccurrences(of: ".jpg", with: "") ?? ""
            
            if let date = dateFormatter.date(from: filename) {
                // Get start of day for grouping
                if let dayStart = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: date)) {
                    if result[dayStart] == nil {
                        result[dayStart] = []
                    }
                    result[dayStart]?.append(i)
                }
            }
        }
        
        // Limit to the last 3 days that have photos
        let sortedDays = result.keys.sorted(by: >)
        let lastThreeDays = Array(sortedDays.prefix(3))
        return result.filter { lastThreeDays.contains($0.key) }
    }
    
    // Format section headers (Today, Yesterday, or date)
    private func formatSectionHeader(for date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "EEEE, MMMM d"
            return displayFormatter.string(from: date)
        }
    }
}
