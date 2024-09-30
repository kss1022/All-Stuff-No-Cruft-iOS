//
//  JoinedConference.swift
//
//
//  Created by 한현규 on 9/2/24.
//

import SwiftUI
import AppUtil

struct JoinedConference: View {
    
    private let conference: Conference
    
    @Binding
    private var path: NavigationPath
    
    @State
    private var talks: [Talk]
    
    init(conference: Conference, path: Binding<NavigationPath>) {
        self.conference = conference
        self._path = path
        self.talks = []
    }
    
    var body: some View {
        List{
            ConferenceCard(conference: conference)
                .aspectRatio(3/2, contentMode: .fit)
                .listRowSeparator(.hidden)
                .listRowInsets(.init())
            
            Section(
                content:{
                    ForEach(talks){ talk in
                        ScheduleRow(talk: talk).onTapGesture {
                            path.append(talk)
                        }
                    }
                },
                header: {
                    Text("Shedule")
                        .font(.headline)
                        .fontWeight(.bold)
            })
            .foregroundStyle(.primary)
        }
        .listStyle(.plain)
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Talk.self){ talk in
            JoinedTalk(talk: talk, path: $path)
        }
        .task {
            self.talks = (try? await conference.talks) ?? []
        }
            
    }
    
    private func randomTalk() -> Talk?{
        return talks.randomElement()
    }
}


#Preview {
    let conference = Conference(
        id: 1,
        name: "Spring camp",
        information: Information(
            content: """
스프링캠프 2024는 애플리케이션 서버 개발자들과 함께 가치있는 기술에 관한 정보과 경험을 '공유'하고, 참가한 사람들과 함께 '인연'을 만들고, 시끌벅적하게 즐길 수 있는 개발자들을 위한 '축제'를 목표로 하는 비영리 컨퍼런스입니다.
""",
            contentType: "Plan"
        ),
        address: Address(
            city: "서울시",
            street: "강남구 남부순환로 3104",
            zipCode: "2352",
            coordinate: Coordinate(
                latitude: 37.49699460099485,
                longitude: 127.07202388832731
            )
        ),
        schedule: Schedule(
            meetingStartAt: Date(),
            meetingEndAt: Date(),
            registerStartAt: Date(),
            registerEndAt: Date()
        ),
        capacity: Capacity(
            maxCapacity: 100,
            availableCapacity: 70,
            currentCapacity: 30
        ),
        price: Price(amount: 300000, currency: "won"),
        posterURL: "https://images.unsplash.com/photo-1560439514-4e9645039924?q=80&w=3870&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    )
        
    
    return JoinedConference(conference: conference, path: .constant(.init()))
}
