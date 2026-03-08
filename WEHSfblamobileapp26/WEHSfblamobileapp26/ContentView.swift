//
//  ContentView.swift
//  WEHSfblamobileapp26
//
//  Created by Hannah You on 2/27/26.
//

import SwiftUI

struct ContentView: View {
    @State private var hasSeenWelcome = false

    var body: some View {
        Group {
            if hasSeenWelcome {
                MainTabView()
            } else {
                WelcomeView {
                    withAnimation(.easeInOut) {
                        hasSeenWelcome = true
                    }
                }
            }
        }
    }
}

// MARK: - Welcome Screen

struct WelcomeView: View {
    var onContinue: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.8, green: 0.1, blue: 0.1), Color.orange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 32, style: .continuous)
                            .fill(Color.white.opacity(0.15))
                            .frame(width: 140, height: 140)

                        VStack(spacing: 8) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 56))
                                .foregroundColor(.white)
                            Text("App Icon")
                                .font(.footnote.weight(.semibold))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }

                    Text("Welcome to FlamesFBLA!")
                        .font(.system(size: 28, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)

                    Text("Williamsville East High School Flames' Official FBLA Member App")
                        .font(.system(size: 16, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 32)
                }

                Spacer()

                VStack(spacing: 12) {
                    Button(action: onContinue) {
                        Text("Enter App")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(14)
                    }

                    Text("Stay connected, informed, and engaged with FlamesFBLA, its events, and our broader community.")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
}

// MARK: - Main Tabs

struct MainTabView: View {
    var body: some View {
        TabView {
            NewsFeedView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            MemberProfileView()
                .tabItem {
                    Label("Members", systemImage: "person.crop.circle")
                }

            EventsCalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }

            NetworkingView()
                .tabItem {
                    Label("Network", systemImage: "bubble.left.and.bubble.right.fill")
                }

            CommunityAndResourcesView()
                .tabItem {
                    Label("Community", systemImage: "globe.americas.fill")
                }
        }
        .accentColor(.red)
    }
}

// MARK: - News Feed (Home)

struct AnnouncementGraphic: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let subtitle: String
}

struct NewsFeedView: View {
    @State private var selectedGraphicIndex = 0

    private let graphics: [AnnouncementGraphic] = [
        .init(imageName: "announcement1", title: "Welcome Flames!", subtitle: "Kick off the year with FBLA."),
        .init(imageName: "announcement2", title: "Commons Cafe", subtitle: "Sign up for this week's shift."),
        .init(imageName: "announcement3", title: "Workshops", subtitle: "Prep for your competitive events."),
        .init(imageName: "announcement4", title: "Conferences", subtitle: "Stay on top of SLC & NLC."),
        .init(imageName: "announcement5", title: "Leadership", subtitle: "Run for office and get involved.")
    ]

    private let weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]

    @State private var previewNotes: [String: String] = [:]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Sliding graphics carousel
                    TabView(selection: $selectedGraphicIndex) {
                        ForEach(Array(graphics.enumerated()), id: \.offset) { index, graphic in
                            ZStack(alignment: .bottomLeading) {
                                Group {
                                    if UIImage(named: graphic.imageName) != nil {
                                        Image(graphic.imageName)
                                            .resizable()
                                            .scaledToFill()
                                    } else {
                                        LinearGradient(
                                            colors: [Color.red.opacity(0.9), Color.orange],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    }
                                }
                                .frame(height: 220)
                                .clipped()
                                .cornerRadius(20)

                                LinearGradient(
                                    colors: [Color.black.opacity(0.7), Color.clear],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                                .cornerRadius(20)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(graphic.title)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text(graphic.subtitle)
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.9))
                                }
                                .padding()
                            }
                            .padding(.horizontal)
                            .tag(index)
                        }
                    }
                    .frame(height: 240)
                    .tabViewStyle(.page(indexDisplayMode: .automatic))

                    // Week in Preview
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Week in Preview")
                            .font(.title3.weight(.semibold))

                        Text("Quickly see what's coming up in FBLA this week. Add notes for general meetings, workshops, conferences, and more.")
                            .font(.footnote)
                            .foregroundColor(.secondary)

                        ForEach(weekDays, id: \.self) { day in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(day)
                                        .font(.headline)
                                    Spacer()
                                }

                                TextField("Add what's happening (\(day.lowercased()) meeting, workshop, cafe shift...)", text: Binding(
                                    get: { previewNotes[day, default: ""] },
                                    set: { previewNotes[day] = $0 }
                                ))
                                .textFieldStyle(.roundedBorder)
                                .font(.subheadline)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(14)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
                .padding(.top)
            }
            .navigationTitle("Flames Feed")
        }
    }
}

// MARK: - Member Profiles

struct MemberProfileView: View {
    @State private var fullName: String = ""
    @State private var instagramHandle: String = ""
    @State private var linkedinHandle: String = ""
    @State private var event1: String = ""
    @State private var event2: String = ""
    @State private var event3: String = ""
    @State private var bio: String = ""

    @State private var pastEvents: String = ""
    @State private var leadershipRoles: String = ""
    @State private var commonsCafes: String = ""
    @State private var programsOfWork: String = ""
    @State private var fblaGoals: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Basic info
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color(.systemGray5))
                                    .frame(width: 80, height: 80)
                                Image(systemName: "person.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(.gray)
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                TextField("Full Name", text: $fullName)
                                    .textFieldStyle(.roundedBorder)

                                Text("Add a profile picture using the Assets catalog or extend this view later to use the Photos picker.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Social Links")
                                .font(.headline)

                            TextField("@instagram", text: $instagramHandle)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.never)

                            TextField("LinkedIn URL or handle", text: $linkedinHandle)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.never)
                        }
                    }

                    // Events
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Competitive Events (up to 3)")
                            .font(.headline)

                        Group {
                            TextField("Event 1", text: $event1)
                            TextField("Event 2", text: $event2)
                            TextField("Event 3", text: $event3)
                        }
                        .textFieldStyle(.roundedBorder)
                    }

                    // Bio
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Short Bio")
                            .font(.headline)

                        TextEditor(text: $bio)
                            .frame(minHeight: 80)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }

                    // FBLA History
                    VStack(alignment: .leading, spacing: 16) {
                        Text("FBLA History")
                            .font(.title3.weight(.semibold))

                        HistorySection(title: "Past Events", text: $pastEvents, placeholder: "List previous competitive events or conferences.")
                        HistorySection(title: "Leadership Roles", text: $leadershipRoles, placeholder: "Chapter officer, committee chair, etc.")
                        HistorySection(title: "Commons Cafes Worked", text: $commonsCafes, placeholder: "List dates, shifts, or responsibilities.")
                        HistorySection(title: "Programs of Work", text: $programsOfWork, placeholder: "Projects, initiatives, or special programs.")
                    }

                    // Goals
                    VStack(alignment: .leading, spacing: 8) {
                        Text("FBLA Goals")
                            .font(.title3.weight(.semibold))

                        TextEditor(text: $fblaGoals)
                            .frame(minHeight: 100)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)

                        Text("Think about what you want to learn, conferences you want to attend, awards you're aiming for, and leadership roles you want to pursue.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("Member Profile")
        }
    }
}

struct HistorySection: View {
    let title: String
    @Binding var text: String
    let placeholder: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
            TextEditor(text: $text)
                .frame(minHeight: 70)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            Text(placeholder)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Calendar & Study Schedule

enum FBLAEventType: String, CaseIterable, Identifiable {
    case workshop = "Workshop"
    case slc = "State Leadership Conference"
    case nlc = "National Leadership Conference"
    case springDistrict = "Spring District Meeting"
    case fallDistrict = "Fall District Meeting"
    case slcPayment = "SLC Payment Installment"
    case commonsCafe = "Commons Cafe Week"
    case generalMeeting = "General Meeting"
    case other = "Other"

    var id: String { rawValue }
}

struct FBLAEvent: Identifiable {
    let id = UUID()
    var date: Date
    var type: FBLAEventType
    var title: String
    var notes: String
}

struct StudyTask: Identifiable {
    let id = UUID()
    var eventName: String
    var dueDate: Date
    var notes: String
    var isCompleted: Bool = false
}

struct EventsCalendarView: View {
    @State private var selectedDate: Date = .now
    @State private var eventType: FBLAEventType = .workshop
    @State private var eventTitle: String = ""
    @State private var eventNotes: String = ""
    @State private var events: [FBLAEvent] = []

    @State private var studyEventName: String = ""
    @State private var studyDueDate: Date = .now
    @State private var studyNotes: String = ""
    @State private var studyTasks: [StudyTask] = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Calendar for key FBLA events
                    VStack(alignment: .leading, spacing: 16) {
                        Text("FBLA Event Calendar")
                            .font(.title3.weight(.semibold))

                        DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.graphical)

                        VStack(alignment: .leading, spacing: 12) {
                            Picker("Event Type", selection: $eventType) {
                                ForEach(FBLAEventType.allCases) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(.menu)

                            TextField("Event title (optional)", text: $eventTitle)
                                .textFieldStyle(.roundedBorder)

                            TextField("Notes (e.g. location, time, reminders)", text: $eventNotes)
                                .textFieldStyle(.roundedBorder)

                            Button {
                                let newEvent = FBLAEvent(
                                    date: selectedDate,
                                    type: eventType,
                                    title: eventTitle.isEmpty ? eventType.rawValue : eventTitle,
                                    notes: eventNotes
                                )
                                events.append(newEvent)
                                eventTitle = ""
                                eventNotes = ""
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add to Calendar")
                                }
                                .font(.system(size: 15, weight: .semibold))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color.red.opacity(0.12))
                                .foregroundColor(.red)
                                .cornerRadius(10)
                            }
                        }
                    }

                    // Upcoming events list
                    if !events.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Upcoming Events & Deadlines")
                                .font(.headline)

                            ForEach(events.sorted { $0.date < $1.date }) { event in
                                HStack(alignment: .top, spacing: 12) {
                                    VStack {
                                        Text(event.date, format: .dateTime.day())
                                            .font(.headline)
                                        Text(event.date, format: .dateTime.month(.abbreviated))
                                            .font(.caption)
                                    }
                                    .padding(8)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(event.title)
                                            .font(.subheadline.weight(.semibold))
                                        Text(event.type.rawValue)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        if !event.notes.isEmpty {
                                            Text(event.notes)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(8)
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
                            }
                        }
                    }

                    // Study schedule / todo list
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Study Schedule")
                            .font(.title3.weight(.semibold))

                        Text("Create a focused study plan for your competitive events. Break down prep into smaller tasks with clear due dates.")
                            .font(.footnote)
                            .foregroundColor(.secondary)

                        VStack(alignment: .leading, spacing: 10) {
                            TextField("Event name (e.g. Intro to Business)", text: $studyEventName)
                                .textFieldStyle(.roundedBorder)

                            DatePicker("Target Date", selection: $studyDueDate, displayedComponents: .date)

                            TextField("Task details (e.g. practice test, case study, slides)", text: $studyNotes)
                                .textFieldStyle(.roundedBorder)

                            Button {
                                let task = StudyTask(
                                    eventName: studyEventName,
                                    dueDate: studyDueDate,
                                    notes: studyNotes,
                                    isCompleted: false
                                )
                                studyTasks.append(task)
                                studyEventName = ""
                                studyNotes = ""
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add Study Task")
                                }
                                .font(.system(size: 15, weight: .semibold))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color.blue.opacity(0.12))
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                            }
                        }

                        if !studyTasks.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Your Study To-Do List")
                                    .font(.headline)

                                ForEach($studyTasks) { $task in
                                    HStack(alignment: .top, spacing: 10) {
                                        Button {
                                            task.isCompleted.toggle()
                                        } label: {
                                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(task.isCompleted ? .green : .gray)
                                                .font(.system(size: 20))
                                        }

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(task.eventName.isEmpty ? "General FBLA Prep" : task.eventName)
                                                .font(.subheadline.weight(.semibold))
                                                .strikethrough(task.isCompleted, color: .secondary)

                                            Text(task.dueDate, style: .date)
                                                .font(.caption)
                                                .foregroundColor(.secondary)

                                            if !task.notes.isEmpty {
                                                Text(task.notes)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .padding(10)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Events & Study")
        }
    }
}

// MARK: - Networking & Messaging

struct MemberConnection: Identifiable {
    let id = UUID()
    let name: String
    let events: String
    let instagram: String
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let isFromUser: Bool
    let text: String
}

struct NetworkingView: View {
    enum Segment {
        case connections
        case messages
    }

    @State private var selectedSegment: Segment = .connections
    @State private var searchText: String = ""

    private let sampleConnections: [MemberConnection] = [
        .init(name: "Alex Kim", events: "Intro to Business, Marketing", instagram: "@alexk"),
        .init(name: "Taylor Singh", events: "Accounting I, Business Law", instagram: "@taylor.s"),
        .init(name: "Jordan Lee", events: "Graphic Design, Social Media Strategies", instagram: "@jordanl")
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("", selection: $selectedSegment) {
                    Text("Connect").tag(Segment.connections)
                    Text("Messages").tag(Segment.messages)
                }
                .pickerStyle(.segmented)
                .padding()

                if selectedSegment == .connections {
                    connectionsList
                } else {
                    messagesList
                }
            }
            .navigationTitle("Networking")
        }
    }

    private var connectionsList: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Find Members")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)

            TextField("Search by name or event", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .padding(.bottom, 8)

            List {
                ForEach(filteredConnections) { member in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(member.name)
                            .font(.headline)
                        Text(member.events)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        if !member.instagram.isEmpty {
                            HStack(spacing: 6) {
                                Image(systemName: "camera.fill")
                                Text(member.instagram)
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(.plain)
        }
    }

    private var filteredConnections: [MemberConnection] {
        guard !searchText.isEmpty else { return sampleConnections }
        return sampleConnections.filter { member in
            member.name.localizedCaseInsensitiveContains(searchText) ||
            member.events.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var messagesList: some View {
        NavigationStack {
            List {
                NavigationLink {
                    FlamesBotChatView()
                } label: {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [.red, .orange], startPoint: .top, endPoint: .bottom))
                                .frame(width: 44, height: 44)
                            Image(systemName: "flame.fill")
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text("FlamesFBLA Bot")
                                .font(.headline)
                            Text("Ask quick questions about how to get involved.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section("Recent Chats") {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Alex Kim")
                                .font(.subheadline.weight(.semibold))
                            Text("Thanks for sharing your study guide!")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 4)

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Chapter Leadership")
                                .font(.subheadline.weight(.semibold))
                            Text("Don't forget about this week's general meeting.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Messages")
        }
    }
}

struct FlamesBotChatView: View {
    @State private var messages: [ChatMessage] = [
        ChatMessage(isFromUser: false, text: "Hi! I'm the FlamesFBLA Bot. Ask me how to get involved, what conferences are, or who to contact for help.")
    ]
    @State private var currentInput: String = ""

    private let officerContactInfo = """
If your question isn't in the FAQs, please reach out to:
- Chapter Officers: use GroupMe/Remind or talk to any officer in person.
- Advisor: Email your chapter advisor or stop by their classroom.
"""

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(messages) { message in
                            HStack {
                                if message.isFromUser {
                                    Spacer()
                                    Text(message.text)
                                        .padding(10)
                                        .background(Color.blue.opacity(0.9))
                                        .foregroundColor(.white)
                                        .cornerRadius(16)
                                        .frame(maxWidth: 260, alignment: .trailing)
                                } else {
                                    Text(message.text)
                                        .padding(10)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(16)
                                        .frame(maxWidth: 260, alignment: .leading)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                }
                .onChange(of: messages.count) { _ in
                    if let last = messages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()

            HStack(spacing: 8) {
                TextField("Ask the FlamesFBLA Bot...", text: $currentInput)
                    .textFieldStyle(.roundedBorder)

                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(currentInput.isEmpty ? .gray : .blue)
                }
                .disabled(currentInput.isEmpty)
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .navigationTitle("FlamesFBLA Bot")
    }

    private func sendMessage() {
        let trimmed = currentInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        messages.append(ChatMessage(isFromUser: true, text: trimmed))
        currentInput = ""

        let lower = trimmed.lowercased()
        var reply: String

        if lower.contains("get involved") || lower.contains("involved") {
            reply = "Great question! Some of the best ways to get involved are:\n- Run for a chapter leadership role.\n- Volunteer for Commons Cafe shifts.\n- Attend general meetings and workshops.\n- Sign up for a competitive event and build a study plan."
        } else if lower.contains("commons cafe") {
            reply = "Commons Cafe is a student-run cafe that helps fund FBLA. Watch for sign-up links in announcements, talk to officers, or check the calendar tab for Commons Cafe weeks."
        } else if lower.contains("slc") || lower.contains("state leadership") {
            reply = "The State Leadership Conference (SLC) is an overnight conference where you compete, attend workshops, and network. Check the calendar for SLC dates and payment installment deadlines, and make sure your event prep is on track in the study schedule."
        } else if lower.contains("nlc") || lower.contains("national leadership") {
            reply = "The National Leadership Conference (NLC) is where top performers from each state compete and attend national-level sessions. Ask your advisor or officers about qualifying, travel details, and costs."
        } else if lower.contains("meeting") {
            reply = "General meetings keep you up to date on deadlines, volunteer opportunities, and announcements. Check the calendar tab for upcoming meetings and the home feed for the \"Week in Preview.\""
        } else {
            reply = "I'm not totally sure about that one, but I still want to help.\n\n\(officerContactInfo)"
        }

        messages.append(ChatMessage(isFromUser: false, text: reply))
    }
}

// MARK: - Community, Resources & Feedback

struct MemberDocument: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

struct CommunityAndResourcesView: View {
    @State private var myDocuments: [MemberDocument] = []
    @State private var newDocTitle: String = ""
    @State private var newDocDescription: String = ""

    @State private var feedbackText: String = ""
    @State private var feedbackSubmitted: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Chapter Resources
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Key FBLA Resources")
                            .font(.title3.weight(.semibold))

                        ResourceRow(title: "Competitive Events Guide", detail: "Overview of events, rubrics, and sample topics.")
                        ResourceRow(title: "Dress Code & Conference Checklist", detail: "What to wear and pack for SLC and NLC.")
                        ResourceRow(title: "Commons Cafe Guidelines", detail: "Expectations, roles, and best practices for shifts.")
                        ResourceRow(title: "Chapter Bylaws & Leadership Roles", detail: "How the chapter runs and ways to serve.")
                    }

                    // My Documents
                    VStack(alignment: .leading, spacing: 12) {
                        Text("My Documents")
                            .font(.title3.weight(.semibold))

                        Text("Save links or notes for your study guides, slide decks, practice tests, and more.")
                            .font(.footnote)
                            .foregroundColor(.secondary)

                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Document title (e.g. Marketing Roleplay Slides)", text: $newDocTitle)
                                .textFieldStyle(.roundedBorder)

                            TextField("Description or link", text: $newDocDescription)
                                .textFieldStyle(.roundedBorder)

                            Button {
                                let doc = MemberDocument(title: newDocTitle, description: newDocDescription)
                                myDocuments.append(doc)
                                newDocTitle = ""
                                newDocDescription = ""
                            } label: {
                                HStack {
                                    Image(systemName: "tray.and.arrow.down.fill")
                                    Text("Save to My Documents")
                                }
                                .font(.system(size: 15, weight: .semibold))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color.green.opacity(0.12))
                                .foregroundColor(.green)
                                .cornerRadius(10)
                            }
                            .disabled(newDocTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                        }

                        if !myDocuments.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(myDocuments) { doc in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(doc.title)
                                            .font(.subheadline.weight(.semibold))
                                        if !doc.description.isEmpty {
                                            Text(doc.description)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(10)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }

                    // Broader FBLA Community
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Broader FBLA Community")
                            .font(.title3.weight(.semibold))

                        CommunityRow(
                            title: "National FBLA",
                            description: "Explore national programs, scholarships, national officers, and resources.",
                            tag: "National"
                        )
                        CommunityRow(
                            title: "New York State FBLA",
                            description: "State-level conferences, deadlines, and leadership opportunities.",
                            tag: "State"
                        )
                        CommunityRow(
                            title: "Local & Regional Chapters",
                            description: "Connect with nearby schools for collaboration and friendly competition.",
                            tag: "Regional"
                        )
                        CommunityRow(
                            title: "Business & Community Partners",
                            description: "Find mentors, judges, and community service projects.",
                            tag: "Partners"
                        )
                    }

                    // Feedback
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Feedback")
                            .font(.title3.weight(.semibold))

                        Text("Help us improve the FlamesFBLA app and your chapter experience. Share what's working well and what we should add or change.")
                            .font(.footnote)
                            .foregroundColor(.secondary)

                        TextEditor(text: $feedbackText)
                            .frame(minHeight: 100)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)

                        Button {
                            feedbackSubmitted = true
                            feedbackText = ""
                        } label: {
                            HStack {
                                Image(systemName: "paperplane.fill")
                                Text("Submit Feedback")
                            }
                            .font(.system(size: 15, weight: .semibold))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.red.opacity(0.12))
                            .foregroundColor(.red)
                            .cornerRadius(10)
                        }

                        if feedbackSubmitted {
                            Text("Thank you for your feedback! Officers and the advisor can review this to keep improving the app and chapter.")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Community & Resources")
        }
    }
}

struct ResourceRow: View {
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "doc.text.fill")
                .foregroundColor(.blue)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(detail)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct CommunityRow: View {
    let title: String
    let description: String
    let tag: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(tag.uppercased())
                .font(.caption2.weight(.bold))
                .padding(.vertical, 4)
                .padding(.horizontal, 6)
                .background(Color.red.opacity(0.1))
                .foregroundColor(.red)
                .cornerRadius(6)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    ContentView()
}
