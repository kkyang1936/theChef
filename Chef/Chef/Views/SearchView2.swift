//
//  SearchView2.swift
//  Chef
//
//  Created by Jason Clemens on 2/21/20.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import SwiftUI
import UIKit
import AVFoundation

class CameraView: UIView {
    private var captureSession: AVCaptureSession?
    
    init() {
        super.init(frame: .zero)
        var allowedAccess = false
        let blocker = DispatchGroup()
        blocker.enter()
        AVCaptureDevice.requestAccess(for: .video) { flag in
            allowedAccess = flag
            blocker.leave()
        }
        blocker.wait()
        if (!allowedAccess) {
            print("!!! NO ACCESS TO CAMERA")
            return
        }
        let session = AVCaptureSession()
        session.beginConfiguration()
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified)
        guard videoDevice != nil, let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), session.canAddInput(videoDeviceInput) else {
            print("!!! NO CAMERA DETECTED")
            return
        }
        session.addInput(videoDeviceInput)
        session.commitConfiguration()
        self.captureSession = session
    }
    
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if nil != self.superview {
            self.videoPreviewLayer.session = self.captureSession
            self.videoPreviewLayer.videoGravity = .resizeAspectFill
            self.captureSession?.startRunning()
        } else {
            self.captureSession?.stopRunning()
        }
    }
}

struct CameraViewRepresentable: UIViewRepresentable {
    func updateUIView(_ uiView: CameraView, context: UIViewRepresentableContext<CameraViewRepresentable>) {
    }
    
    func makeUIView(context: UIViewRepresentableContext<CameraViewRepresentable>) -> CameraView {
        CameraView()
    }
    
    typealias UIViewType = CameraView
}

fileprivate enum Constants {
    static let radius: CGFloat = 16
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0.3
}

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content
    @GestureState private var translation: CGFloat = 0
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }
    private var indicator: some View {
        RoundedRectangle(cornerRadius: Constants.radius)
            .fill(Color.secondary)
            .frame(width: Constants.indicatorWidth, height: Constants.indicatorHeight)
            .onTapGesture {
                self.isOpen.toggle()
        }
    }
    
    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        //self.minHeight = maxHeight * Constants.minHeightRatio
        self.minHeight = 175
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator.padding()
                self.content
            }
            .frame(width: geometry.size.width, height: min(self.maxHeight, geometry.size.height), alignment: .top)
            .background(BlurCard())
                //.cornerRadius(Constants.radius)
                .frame(height: geometry.size.height, alignment: .bottom)
                .offset(y: max(self.offset + self.translation, 0))
                .animation(.interactiveSpring())
                .simultaneousGesture(DragGesture(minimumDistance: 30, coordinateSpace: .local).updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                    if !self.isOpen {
                        UIApplication.shared.endEditing(true)
                    }
                })
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                self.isOpen = true
            }
        }
    }
}

struct SearchBar: View{
    @Binding var searchText: String
    @State private var showCancelButton = false
    
    init(_ searchText: Binding<String>) {
        self._searchText = searchText
    }
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Find a recipe", text: $searchText,
                          onEditingChanged: { isEditing in
                            self.showCancelButton = isEditing
                }, onCommit: {
                    self.showCancelButton = false
                    //print("Search: " + self.searchText)
                }).foregroundColor(.primary)
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
            if showCancelButton {
                Button("Cancel") {
                    UIApplication.shared.endEditing(true)
                    self.searchText = ""
                    self.showCancelButton = false
                }
                .foregroundColor(Color(.systemBlue))
            }
        }.padding(.horizontal)
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows.filter{$0.isKeyWindow}.first?.endEditing(force)
    }
}

struct SearchView2: View {
    @State var bottomSheetShown = false
    @State var searchString = ""
    @State var addingIngredient = ""
    @State private var ingredients: [String] = []
    @State private var resultsView: ResultsView? = nil
    @State private var navigate = false
    
    func deleteIngredient(at indexSet: IndexSet) {
        self.ingredients.remove(atOffsets: indexSet)
    }
    
    var body: some View {
        ZStack {
            GeometryReader { g in
                //Only works on physical devices
                CameraViewRepresentable()
                    .edgesIgnoringSafeArea(.top)
            }
            BottomSheetView(isOpen: $bottomSheetShown, maxHeight: 600) {
                GeometryReader { geometry in
                    VStack {
                        SearchBar(self.$searchString)
                        List {
                            HStack {
                                TextField("Add an ingredient to the search...", text: self.$addingIngredient, onCommit: {
                                    print("Ingredient" + self.addingIngredient)
                                    if (!self.addingIngredient.isEmpty) {
                                        self.ingredients.append(self.addingIngredient)
                                        self.addingIngredient = ""
                                    }
                                })
                                Button(action: {
                                    UIApplication.shared.endEditing(true)
                                    self.addingIngredient = ""
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(Color(.systemBlue)) .opacity(self.addingIngredient == "" ? 0 : 1)
                                }
                            }
                            
                            ForEach(self.ingredients, id: \.self) { ingredient in
                                Text(ingredient)
                            }.onDelete(perform: self.deleteIngredient)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        .padding(.horizontal)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                print("Search")
                                print(self.searchString)
                                print(self.ingredients)
                                //TODO: Push the RecipeResultsView onto the NavigationView stack
                                self.resultsView = ResultsView(recipeName: self.searchString, ingredientList: self.ingredients)
                                self.navigate = true;
                            }) {
                                HStack {
                                    Text("Search")
                                    Image(systemName: "chevron.right")
                                }
                                .padding()
                            }.disabled(self.searchString == "" && self.ingredients == [])
                            .padding(.bottom, geometry.safeAreaInsets.bottom)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            NavigationLink(destination: resultsView, isActive: $navigate) {
                EmptyView()
            }.hidden()
            
        }.navigationBarTitle("Recipe search", displayMode: .inline)
    }
}

struct SearchView2_Previews: PreviewProvider {
    static var previews: some View {
        SearchView2()
    }
}
