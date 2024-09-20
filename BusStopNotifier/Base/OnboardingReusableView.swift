//
//  OnboardingReusableView.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 04.08.2024.
//

import SwiftUI
import Lottie

struct OnboardingReusableView: View {
    @AppStorage("currentPage") var currentPage = 1
    @State private var animate = false
    @Environment(\.colorScheme) var colorscheme
    
    var image: String = "animation1"
    var title: String = "Add bus stops"
    var subHeading: String = "You can select any bus stop in your city with the help of the map view to get notified"
    var namespace: Namespace.ID
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 12) {
                LottieView(animation: .named(image))
                    .playbackMode(.playing(.toProgress(1, loopMode: .repeat(3))))
                    .configure { animationView in
                        animationView.mainThreadRenderingEngineShouldForceDisplayUpdateOnEachFrame.toggle()
                    }
                    .frame(width: geo.size.width, height: geo.size.height * 0.5)
                    .scaleEffect(0.8)
                    .offset(x: animate ? 0 : currentPage > 1 ? -500 : 500)
                    .animation(.smooth.delay(0.2), value: animate)
                
                Group {
                    Text(title)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.customApp)
                        .animation(.smooth.delay(0.4), value: animate)
                        .padding(.horizontal, 3)
                    
                    Text(subHeading)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color(.label))
                        .animation(.snappy.delay(0.5), value: animate)
                        .frame(width: geo.size.width * 0.95, height: geo.size.height * 0.15)
                }
                .offset(x: animate ? 0 : 500)
                .scaleEffect(animate ? 1 : 0.97)
                
                onboardingIndicator(height: geo.size.height)
                onboardingButton

            }
            .background(colorscheme == .dark ? .black.opacity(0.98) : Color(.systemBackground))
            .matchedGeometryEffect(id: "onboarding", in: namespace)
            .onAppear {
                withAnimation {
                    animate = true
                }
            }
            .overlay(alignment: .topLeading) {
                if currentPage > 1 {
                    backButton
                }
            }
            .overlay(alignment: .topTrailing) {
                skipButton
            }
        }
    }
    
    @ViewBuilder private func onboardingIndicator(height: CGFloat) -> some View {
        HStack {
            ForEach(1 ... totalPages, id: \.self) { index in
                Capsule()
                    .frame(width: currentPage == index ? 24 : 12, height: 12)
                    .foregroundStyle(currentPage == index ? .customApp : Color(.systemGray2))
                    .offset(x: animate ? 0 : 500)
                    .scaleEffect(animate ? 1 : 0.97)
                    .animation(.snappy.delay(Double(index) * 0.2 + 0.3), value: animate)
            }
        }
        .frame(maxHeight: height, alignment: .bottom)
    }
    
    private var onboardingButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
            
            Button {
                withAnimation(.smooth) {
                    if currentPage <= 2 {
                        currentPage += 1
                    }
                }
            } label: {
                Text(currentPage == 1 ? "Continue" : "Get started")
                    .foregroundStyle(.white)
            }
            .scaleEffect(animate ? 1 : 0.97)
            .offset(x: animate ? 0 : 500)
            .animation(.snappy, value: animate)
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: 60)
        .foregroundStyle(.customApp).opacity(0.9)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, 20)
    }
    
    private var backButton: some View {
        Button { 
            withAnimation(.smooth) {
                if currentPage > 1 {
                    currentPage -= 1
                }
            }
        } label: {
            Text("Back")
                .foregroundStyle(.customApp)
        }
        .padding()
    }
    
    private var skipButton: some View {
        Button {
            withAnimation(.smooth) {
                    currentPage = 3
            }
        } label: {
            Text("Skip")
                .foregroundStyle(.customApp)
        }
        .padding()
    }
}

#Preview {
    OnboardingReusableView(namespace: Namespace().wrappedValue)
}
