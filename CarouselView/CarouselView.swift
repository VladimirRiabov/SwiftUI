//
//  CarouselView.swift
//  Apps
//
//  Created by Владимир on 28.03.2023.
//

import SwiftUI

struct CarouselView: View {
    var courses = coursesData
    @State private var selectedCourse: Course?
    @State var show = false
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            VStack{
                MenuView()
                ScrollView {
                    VStack {
                        header
                        coursesScrollView
                        Tips()
                    }
                }
                Spacer()
            }
        }
    }
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Courses")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                
                Text("\(courses.count) Courses")
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.leading, 60.0)
    }
    
    private var coursesScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30.0) {
                ForEach(courses) { item in
                    CourseCard(course: item, selectedCourse: $selectedCourse)
                        .frame(width: 246, height: 360)
                }
            }
            .padding(.horizontal, 50)
            .padding(.bottom, 50)
            .padding(.top, 20)
            Spacer()
        }
    }
    
    
}

struct Tips: View {
    let tips = [
        ("1", "Speak with Native Speakers", "Practice speaking with native speakers."),
        ("2", "Contextual Vocabulary", "Learn vocabulary in context."),
        ("3", "Spaced Repetition", "Use spaced repetition for memorization."),
        ("4", "Active Listening", "Listen to the language as much as possible."),
        ("5", "Multimodal Practice", "Practice reading, writing, listening, and speaking.")
    ]
    
    @State private var currentIndex = 0
    
    var body: some View {
        VStack {
            HStack {
                Text("Today's Learning Tips")
                    .padding(.leading, 40)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            HStack(spacing: 20) {
                ForEach(tips.indices, id: \.self) { index in
                    
                    Text(tips[index].0)
                        .font(.headline)
                        .foregroundColor(index == currentIndex ? .white : .gray)
                        .padding(20)
                        .background(index == currentIndex ? Color.blue : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onTapGesture {
                            withAnimation {
                                currentIndex = index
                            }
                        }
                }
                
            }
            .padding(.horizontal)
            .animation(.easeInOut(duration: 0.3))
            
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text(tips[currentIndex].1)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(tips[currentIndex].2)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct CourseCard: View {
    let course: Course
    @Binding var selectedCourse: Course?
    
    var body: some View {
        Button(action: { self.selectedCourse = course }) {
            GeometryReader { geometry in
                CourseView(course: course)
                    .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 20) / -20), axis: (x: 0, y: 50.0, z: 0))
                    .sheet(item: self.$selectedCourse) { selectedCourse in
                        SheetLanguageView(course: selectedCourse)
                    }
            }
        }
    }
}

struct CourseView: View {
    var course: Course
    
    var body: some View {
        VStack(alignment: .leading) {
            CourseTitle(title: course.title)
            Spacer()
            CourseImage(image: course.image)
        }
        .background(course.color)
        .cornerRadius(30)
        .frame(width: 246, height: 360)
        .shadow(color: course.shadowColor.opacity(0.3), radius: 20, x: 0, y: 20)
    }
}

struct CourseTitle: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(30)
            .lineLimit(4)
    }
}

struct CourseDescription: View {
    var description: String
    
    var body: some View {
        Text(description)
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(30)
    }
}

struct CourseImage: View {
    var image: String
    
    var body: some View {
        Image(image)
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fit)
            .frame(width: 246, height: 150)
            .padding(.bottom, 30)
    }
}

struct SheetLanguageView: View {
    var course: Course
    
    var body: some View {
        ZStack {
            course.color
            ScrollView {
                VStack {
                    CourseTitle(title: course.title)
                    CourseImage(image: course.image)
                    CourseDescription(description: course.description)
                    Spacer()
                    StartButtonView()
                    
                    
                }.frame(minHeight: UIScreen.main.bounds.height - 100)
            }
        }
        .ignoresSafeArea()
    }
}

struct StartButtonView: View {
    var body: some View {
        Button(action: {
        }) {
            HStack(spacing: 8) {
                Text("Start")
                
                Image(systemName: "arrow.right.circle")
                    .imageScale(.large)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule().strokeBorder(Color.white, lineWidth: 1.25)
            )
        }
        .accentColor(Color.white)
    }
}

//MARK: Menu
struct MenuView: View {
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack {
                Button(action: {}) {
                    CircleButton(icon: "list.bullet")
                }
                Spacer()
                Button(action: {}) {
                    CircleButton(icon: "person.crop.circle")
                }
                Button(action: {}) {
                    CircleButton(icon: "bell")
                }
            }
            .padding()
            Spacer()
        }
    }
}

struct CircleButton: View {
    var icon: String
    var backgroundColor: Color = Color(.white)
    var iconColor: Color = .primary
    
    var body: some View {
        Image(systemName: icon)
            .foregroundColor(iconColor)
            .frame(width: 44, height: 44)
            .background(backgroundColor)
            .cornerRadius(22)
            .shadow(color: Color(.black).opacity(0.1), radius: 20, x: 0, y: 20)
    }
}

struct Course: Identifiable {
    var id = UUID()
    var title: String
    var image: String
    var color: Color
    var shadowColor: Color
    var description: String
}

let coursesData = [
    Course(title: "Learn Spanish for Beginners",
           image: "spanish",
           color: Color("spanish"),
           shadowColor: Color("french"),
           description: "Get started with Spanish for beginners! Learn essential vocabulary, grammar, and pronunciation skills to start speaking Spanish confidently."),
    Course(title: "Master French Conversation",
           image: "french",
           color: Color("french"),
           shadowColor: Color("french"),
           description: "Improve your French conversational skills and expand your vocabulary. Become fluent in French and engage in meaningful conversations with native speakers."),
    Course(title: "Speak German with Confidence",
           image: "german",
           color: Color("german"),
           shadowColor: Color("french"),
           description: "Develop your German speaking abilities and build confidence in your communication skills. Learn grammar, vocabulary, and pronunciation for effective conversations."),
    Course(title: "Essential Chinese for Travel",
           image: "chinese",
           color: Color("chinese"),
           shadowColor: Color("french"),
           description: "Prepare for your travels in China with essential Chinese language skills. Learn practical phrases, cultural etiquette, and tips for navigating various situations."),
    Course(title: "Discover Japanese Culture",
           image: "japanese",
           color: Color("japanese"),
           shadowColor: Color("french"),
           description: "Explore Japanese culture through language learning. Discover traditions, customs, and etiquette while enhancing your reading, writing, and speaking abilities."),
]

