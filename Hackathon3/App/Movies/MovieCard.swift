//
//  MovieCard.swift
//  Hackathon3
//
//  Created by Mia Koring on 18.07.24.
//

import Foundation
import SwiftUI
import SwiftChameleon
import Kingfisher

struct MovieCard: View {
    let movie: TMDBMovie
    @State var liked: Bool = false
    @State var failed: Bool = false
    @State var timer: Timer? = nil
    @State var showDetail: Bool = false
    @Binding var likeDisabled: Bool
    @State var showUserCreation: Bool = false // falls irgendwie in userDefaults die userid verloren geht, fragt nicht, errorhandling für zeug was hoffentlich nie auftritt
    
    var body: some View {
        ZStack {
            ZStack {
                if let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)") {
                    KFImage(url)
                        .placeholder { _ in
                            ProgressView().progressViewStyle(.circular)
                        }
                        .cacheOriginalImage(true)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                } else {
                    LoadFailedView(error: "URL invalid")
                }

                VStack {
                    Spacer()

                    HStack {
                        VStack(alignment: .leading) {
                            Text(movie.title)
                                .font(.Bold.small)
                                .lineLimit(2)

                            movie.voteAverage.stars
                                .font(.Bold.verySmall)
                                .foregroundStyle(.orange)
                        }

                        Spacer()

                        Image(systemName: "heart\(liked ? ".fill" : "")")
                            .foregroundStyle(liked ? Color.red.gradient: Color.black.gradient)
                            .button {
                                toggleLike()
                            }
                            .disabled(likeDisabled)
                    }
                    .padding(.horizontal, 15.0)
                    .frame(maxWidth: .infinity, minHeight: 60.0, maxHeight: 60.0)
                    .background(.white.opacity(0.9))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .clipShape(.rect(cornerRadius: 15.0))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture(perform: tapped)
        .sheet(isPresented: $showDetail) {
            MovieDetail(movie: movie, liked: $liked, likeDisabled: $likeDisabled) {
                toggleLike()
            }
                .presentationCornerRadius(25)
        }
        .task {
            liked = UDKey.favourised(movie.id).value as? Bool ?? false
        }
        .sheet(isPresented: $showUserCreation) {
            CreateUser()
                .interactiveDismissDisabled()
        }
    }
 
    private func tapped() {
        guard let timer else {
            createTimer()
            return
        }
        if !timer.isValid {
            createTimer()
            return
        }
        timer.invalidate()
        liked.toggle()
    }
    
    private func createTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { timer in
            showDetail = true
            timer.invalidate()
        }
    }
    
    private func toggleLike() {
        Task {
            likeDisabled.setTrue()
            liked.toggle()
            UDKey.favourised(movie.id).set(liked)
            let res = await Favourite.changeOne(movieID: movie.id, favourised: liked)
            switch res {
            case .ok(let t):
                break
            case .error(let e):
                switch e {
                case .userID:
                    showUserCreation = true
                default:
                    print(e.localizedDescription)
                }
            }
            likeDisabled.setFalse()
        }
    }
}

struct LoadFailedView: View {
    let error: String
    var body: some View {
        RoundedRectangle(cornerRadius: 25, style: .continuous)
            .fill(.thinMaterial)
            .overlay {
                Image(systemName: "x.circle")
                    .foregroundStyle(.red)
                Text(error)
            }
            .frame(minHeight: 100)
    }
}

