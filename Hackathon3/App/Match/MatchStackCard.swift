//
//  MatchStackCard.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

import SwiftUI
import Kingfisher

struct MatchStackCard: View {

    @Environment(MatchMovieModel.self) var matchModel
    let movie: TMDBMovie

    @State var offset: CGFloat = 0
    @GestureState var isDragging: Bool = false
    @State var endSwipe: Bool = false

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let index = CGFloat(matchModel.getIndex(movie))
            let topOffset = (index <= 2 ? index: 2) * 15

            ZStack {
                ZStack {
                    if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(movie.posterPath)") {
                        KFImage.url(url)
                            .loadDiskFileSynchronously()
                            .cacheMemoryOnly()
                            .fade(duration: 0.25)
                            .resizable()
                            .scaledToFill()
                    }

                    VStack {
                        Text(movie.title)
                            .font(.Bold.title)
                            .lineLimit(2)

                        movie.voteAverage.stars
                            .font(.Bold.small)
                            .foregroundStyle(.orange)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80.0, maxHeight: 80.0)
                    .background(.white.opacity(0.85))
                    .offset(y: (size.height / 2) - 40.0)
                }
                .frame(width: size.width - topOffset, height: size.height)
                .clipShape(.rect(cornerRadius: 15.0))
                .offset(y: -topOffset)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .offset(x: offset)
        .rotationEffect(.degrees(getRotation(angle: 8)))
        .contentShape(Rectangle().trim(from: 0, to: endSwipe ? 0: 1))
        .gesture(
            DragGesture()
                .updating($isDragging, body: { value, out, _ in
                    out.setTrue()
                })
                .onChanged({ value in
                    let translation = value.translation.width
                    offset = (isDragging ? translation: .zero)
                })
                .onEnded({ value in
                    let width = getRect().width - 50
                    let translation = value.translation.width

                    let checkingStatus = (translation > 0 ? translation: -translation)

                    withAnimation {
                        if checkingStatus > (width/2) {
                            offset = (translation > 0 ? width: -width) * 2
                            endSwipeAction(translation > 0 ? .right : .left)
                        } else {
                            offset = .zero
                        }
                    }
                })
        )
    }

    func endSwipeAction(_ direction: Direction) {
        withAnimation(.none) {
            endSwipe.setTrue()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let _ = withAnimation {
                switch direction {
                case .left:
                    matchModel.doSwipe()
                case .right:
                    matchModel.doSwipe(right: true)
                }
            }
        }
    }

    func getRotation(angle: Double) -> Double {
        (offset / (getRect().width - 50)) * angle
    }

}

extension View {
    func getRect() -> CGRect {
        UIScreen.main.bounds
    }
}
