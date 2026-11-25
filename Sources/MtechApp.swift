import SwiftUI

// MARK: - App

@main
struct MtechApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.dark)
                .tint(.green)
        }
    }
}

// MARK: - Данные (правь здесь)

struct Tutorial: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let icon: String
    let steps: [String]
}

let tutorials: [Tutorial] = [
    Tutorial(
        title: "Установка IPA через Sideloadly",
        category: "Установка",
        icon: "square.and.arrow.down",
        steps: [
            "Скачай и установи Sideloadly на ПК или Mac.",
            "Подключи iPhone кабелем и разреши доверие компьютеру.",
            "Перетащи IPA в окно Sideloadly и введи Apple ID.",
            "Нажми Start и дождись установки.",
            "Открой Настройки → Основные → VPN и управление устройством и доверься профилю."
        ]
    ),
    Tutorial(
        title: "Подпись IPA сертификатом",
        category: "Сертификаты",
        icon: "checkmark.seal",
        steps: [
            "Подготовь .p12 и .mobileprovision и пароль от сертификата.",
            "Открой ESign (или другой подписчик) и импортируй сертификат.",
            "Выбери IPA и нажми «Подписать».",
            "Установи подписанное приложение и доверься профилю."
        ]
    ),
    Tutorial(
        title: "Что делать, если сертификат отозван",
        category: "Сертификаты",
        icon: "exclamationmark.triangle",
        steps: [
            "Проверь, что сертификат не в блокировке (статус в подписчике).",
            "Удали приложение и профиль в Настройках.",
            "Установи новый сертификат и подпиши IPA заново."
        ]
    )
]

let aboutName = "Mtech"
let aboutText = "Разработчик. Делаю приложения, твики и туторы для iOS."

let links: [(title: String, icon: String, url: String)] = [
    ("GitHub", "chevron.left.forwardslash.chevron.right", "https://github.com/iosfreeM"),
    ("TikTok", "play.rectangle", "https://www.tiktok.com/"),      // вставь свою ссылку
    ("Telegram-канал", "paperplane", "https://t.me/")              // вставь свою ссылку
]

// MARK: - Root

struct RootView: View {
    var body: some View {
        TabView {
            AboutView()
                .tabItem { Label("Обо мне", systemImage: "person.crop.circle") }
            TutorialsView()
                .tabItem { Label("Туторы", systemImage: "book") }
        }
    }
}

// MARK: - Обо мне

struct AboutView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ZStack {
                        Circle().fill(Color.green.opacity(0.2))
                        Text("M")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.green)
                    }
                    .frame(width: 110, height: 110)
                    .padding(.top, 24)

                    Text(aboutName)
                        .font(.largeTitle.bold())
                    Text(aboutText)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)

                    VStack(spacing: 10) {
                        ForEach(links, id: \.title) { item in
                            if let url = URL(string: item.url) {
                                Link(destination: url) {
                                    HStack {
                                        Image(systemName: item.icon)
                                            .frame(width: 28)
                                        Text(item.title)
                                        Spacer()
                                        Image(systemName: "arrow.up.right")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
            }
            .navigationTitle("Обо мне")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Туторы

struct TutorialsView: View {
    @State private var query = ""

    private var filtered: [Tutorial] {
        query.isEmpty
            ? tutorials
            : tutorials.filter {
                $0.title.localizedCaseInsensitiveContains(query)
                || $0.category.localizedCaseInsensitiveContains(query)
            }
    }

    private var categories: [String] {
        Array(Set(filtered.map { $0.category })).sorted()
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(categories, id: \.self) { category in
                    Section(category) {
                        ForEach(filtered.filter { $0.category == category }) { tutorial in
                            NavigationLink {
                                TutorialDetail(tutorial: tutorial)
                            } label: {
                                Label(tutorial.title, systemImage: tutorial.icon)
                            }
                        }
                    }
                }
            }
            .searchable(text: $query, prompt: "Поиск по туторам")
            .navigationTitle("Туторы")
        }
    }
}

struct TutorialDetail: View {
    let tutorial: Tutorial

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(Array(tutorial.steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1)")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(width: 28, height: 28)
                            .background(Color.green)
                            .clipShape(Circle())
                        Text(step)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(tutorial.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
