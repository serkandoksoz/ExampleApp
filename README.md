# iOS Guidelines - Full Version

iOS Guidelines
Guidelines for Developing an iOS Project
This document provides a comprehensive guideline for structuring, developing, and documenting iOS projects. It is designed to be generic 
and applicable to most iOS applications, ensuring consistency, scalability, and maintainability.
1. Project Overview
Start by defining the purpose of your iOS application, the technologies used, and the intended audience.
Key Components:
Programming Language: Swift is preferred due to its modern syntax and integration with iOS frameworks.
UI Framework: Use SwiftUI for new projects or UIKit for maintaining legacy projects.
Architecture: Favor scalable architectures such as MVVM, MVC, or Clean Architecture, depending on project complexity.
Version Control: Use Git with a branching strategy like Gitflow or Trunk-Based Development.
2. Recommended Project Structure
Organize the project to ensure clarity and ease of navigation. Below is a suggested structure:
3. Versioning
Versioning your app is essential for proper maintenance and deployment. Use the following guidelines:
1iOSProject/
2 ├── Models/           # Data models and business logic
3 │   ├──  DataModel.swift
4 │   ├──  SchemaType.swift
5 ├── ViewModels/       # State management and logic for UI
6 │   ├──  HomeViewModel.swift
7 │   ├──  AuthViewModel.swift
8 ├── Views/            # SwiftUI or UIKit Views
9 │   ├──  HomeView.swift
10 │   ├──  CustomPageControl.swift
11 │   ├──  BannerView.swift
12 ├── Networking/       # API clients and request handlers
13 │   ├──  RequestBuilder.swift
14 │   ├──  APIClient.swift
15 ├── Resources/        # Assets, strings, and localization files
16 │   ├──  Assets.xcassets
17 │   ├──  Localizable.strings
18 ├── Utils/            # Utility classes and extensions
19 │   ├──  Extensions/
20 │   ├──  AppLogger.swift
21 ├── Tests/            # Unit and UI tests
22 │   ├──  UnitTests/
23 │   ├──  UITests/

3.1 Semantic Versioning
Follow the Semantic Versioning convention:
Major: Increment for breaking changes or major feature releases.
Minor: Increment for backward-compatible new features.
Patch: Increment for bug fixes or minor updates.
3.2 Versioning Example
For example:
1.0.0: Initial release.
1.1.0: Added a new feature (e.g., offline caching).
1.1.1: Fixed a bug in offline caching.
3.3 Automating Versioning
Automate versioning using Fastlane:
Add a lane in Fastfile:
Run the lane:
4. Git Branching Strategy
A well-defined branching strategy ensures smooth collaboration and deployment.
4.1 Gitflow
The Gitflow branching strategy is ideal for structured release management.
Branches:
main: Always contains the production-ready code.
develop: Integration branch for features.
feature/branch-name: Branch for developing individual features.
release/branch-name: Branch for preparing a release.
hotfix/branch-name: Branch for fixing production issues.
Workflow:
Create a feature branch from develop:
Merge the feature branch back into develop after completion:
1lane :bump_version do
2  increment_version_number(
3    bump_type: "patch" # Can be major, minor, or patch
4  )
5  increment_build_number
6end
1fastlane bump_version
1git checkout -b feature/your-feature-name develop
1git checkout develop
2git merge feature/your-feature-name

Create a release branch from develop:
Merge the release branch into main and tag it:
4.2 Trunk-Based Development
For simpler projects, Trunk-Based Development is an alternative to Gitflow:
Main branch: Contains the latest production-ready code.
Developers commit directly to the main branch after completing small changes or pull requests.
5. Development Guidelines
5.1 Coding Standards
Follow SwiftLint for maintaining code style and standards.
Naming Conventions:
Classes and structs: PascalCase
Variables and methods: camelCase
Constants: UPPER_CASE
Code Comments:
Use inline comments only when necessary.
Document public functions and classes using Swift's doc comments (///).
5.2 UI Development
SwiftUI:
Use declarative syntax to build composable views.
Break large views into smaller, reusable components.
Example:
UIKit:
Follow Auto Layout and use Storyboard or programmatic UI based on team preferences.
1git checkout -b release/v1.1.0 develop
1git checkout main
2git merge release/v1.1.0
3git tag -a v1.1.0 -m "Release version 1.1.0"
1struct CustomButton: View {
2    var title: String
3    var action: () -> Void
4
5    var body: some View {
6        Button(action: action) {
7            Text(title)
8                .padding()
9                .background(Color.blue)
10                .foregroundColor(.white)
11                .cornerRadius(8)
12        }
13    }
14}

Adhere to Apple's Human Interface Guidelines.
5.3 Networking
The networking layer abstracts request handling for both REST APIs and GraphQL APIs. We use async/await for REST APIs and Apollo for 
GraphQL integration.
5.3.1 REST Networking with Async/Await
The REST networking layer is designed to handle asynchronous requests using the async/await mechanism introduced in Swift 5.5.
Base Networking Layer
Use the following perform(request:) function as the core for handling REST API requests:
Example Usage
Best Practices for REST APIs
Avoid Hardcoding: Store base URLs and API keys in a secure configuration file.
Error Handling: Throw custom error types (NetworkingError) to handle and display user-friendly messages.
Validation: Use a urlResponseValidator to validate server responses before decoding.
5.3.2 GraphQL Networking with Apollo
We use Apollo for integrating GraphQL APIs into the project, leveraging its strongly typed query and mutation generation.
Setting Up Apollo
Add Apollo to the Project: Use Swift Package Manager:
Generate GraphQL Models: Install the Apollo CLI to generate type-safe models for your queries:
Use the CLI to generate models:
1// MARK: Perform REST Request with Async/Await
2public func perform(request: URLRequest) async throws {
3    do {
4        let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
5        _ = try urlResponseValidator.validate(data: data, urlResponse: response, error: nil)
6    } catch let error as NetworkingError {
7        throw error
8    } catch {
9        throw NetworkingError.unknown
10    }
11}
1struct APIClient {
2    func fetchData<T: Decodable>(from url: URL) async throws -> T {
3        var request = URLRequest(url: url)
4        request.httpMethod = "GET"
5
6        let data = try await perform(request: request)
7        return try JSONDecoder().decode(T.self, from: data)
8    }
9}
1<https://github.com/apollographql/apollo-ios.git>
1npm install -g apollo

Initialize Apollo Client: Create a reusable GraphQLNetwork layer:
Fetching Data with Apollo
Define and execute queries using Apollo’s strongly typed API:
5.3.3 Best Practices for Networking
Code Organization:
Keep REST and GraphQL logic separate by defining separate layers (e.g., APIClient for REST and GraphQLNetwork for 
GraphQL).
Error Handling:
Use custom error types for REST and GraphQL to provide user-friendly messages.
Example:
Caching:
Use Apollo's built-in caching for GraphQL responses to improve performance.
Implement custom caching mechanisms for REST APIs if needed.
Testing:
1apollo codegen:generate --target=swift --schema=schema.graphql --output-directory=Generated/
1import Apollo
2
3class GraphQLNetwork {
4    static let shared = GraphQLNetwork()
5
6    private(set) lazy var apollo: ApolloClient = {
7        let url = URL(string: "<https://api.example.com/graphql>")!
8        return ApolloClient(url: url)
9    }()
10}
1import Apollo
2
3class ItemsViewModel: ObservableObject {
4    @Published var items: [Item] = []
5    @Published var errorMessage: String?
6
7    func fetchItems() {
8        GraphQLNetwork.shared.apollo.fetch(query: GetItemsQuery()) { [weak self] result in
9            switch result {
10            case .success(let graphQLResult):
11                self?.items = graphQLResult.data?.items.compactMap { $0 } ?? []
12            case .failure(let error):
13                self?.errorMessage = error.localizedDescription
14            }
15        }
16    }
17}
1enum NetworkingError: Error {
2    case invalidResponse
3    case decodingFailed
4    case unknown
5}

Mock both REST and GraphQL APIs for unit testing.
Example:
Security:
Avoid hardcoding API keys or sensitive information. Use environment variables or secure storage.
5.4 State Management
Use MVVM for better separation of concerns.
ViewModel: Manages state and handles business logic.
View: Observes the ViewModel and reacts to changes.
Example:
5.5 Testing
Unit Tests:
Test key components like ViewModel logic and network layers.
Example:
UI Tests:
Test user flows and interactions.
Use XCTest to simulate user actions.
6. Documentation
6.1 Commenting Code
Document classes, functions, and protocols using Swift's documentation format.
1class MockApolloClient: ApolloClientProtocol {
2    func fetch<Query: GraphQLQuery>(
3        query: Query,
4        resultHandler: GraphQLResultHandler<Query.Data>?
5    ) {
6        // Return mock data
7    }
8}
1class HomeViewModel: ObservableObject {
2    @Published var banners: [String] = []
3
4    func fetchBanners() {
5        // Fetch data and update state
6    }
7}
1func testFetchBanners() {
2    let viewModel = HomeViewModel()
3    viewModel.fetchBanners()
4    XCTAssertEqual(viewModel.banners.count, 3)
5}

Example:
6.2 README File
Include a README.md file at the root of the project with:
Project Overview
Installation Steps
Usage Instructions
API Endpoints
Contact Information
6.3 API Documentation
Document all API endpoints used in the project:
Base URL: <https://api.example.com>
Endpoint: /banners
Method: GET
Response: JSON Array of banners.
7. Deployment Guidelines
7.1 App Store Deployment
1. Ensure the app builds without warnings or errors.
2. Archive the app in Xcode:
Product > Archive
3. Validate the build:
Use Xcode Organizer to ensure the app meets App Store requirements.
4. Submit for review.
7.2 Continuous Integration/Continuous Deployment (CI/CD)
Use tools like Bitrise, GitHub Actions, or Jenkins for automated builds and deployments.
Example Workflow:
Trigger on main branch commits.
Run unit tests and UI tests.
Deploy beta builds to TestFlight.
8. Best Practices
1. Scalability:
Use protocols and generics to make components reusable.
Example:
1/// Represents a reusable button for the app.
2struct CustomButton: View {
3    var title: String
4    var action: () -> Void
5}

2. Performance:
Profile the app regularly using Xcode's Instruments.
Avoid unnecessary computations in the main thread.
3. Security:
Use Keychain to store sensitive information like user tokens.
Avoid embedding API keys directly in the source code.
9. Future Enhancements
Modularize the app into Swift packages for better reusability.
Add support for offline caching using CoreData or Realm.
Improve accessibility compliance with Apple's Accessibility APIs.
1protocol APIRequest {
2    associatedtype Response: Decodable
3    var url: URL { get }
4}

