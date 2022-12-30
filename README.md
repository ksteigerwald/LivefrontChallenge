# LivefrontChallenge

## Overview
This application pulls news streams from CryptoCompare and analyzes the results with OpenAI. Recommendations chosen from the recommendation menu will take ten recent news articles and summarize all the aggregated content. In addition, selected news articles are analyzed for sentiment or tone or translated into bullet points.

The app utilizes many of the latest features available on iOS 16. Build and run this application using XCode 14.2; there is no guarantee that it will work with any earlier version.

## How to run
API Key's for CryptoCompare and OpenAI must be included in the Environment file under the Token enum. For the intended audience, I will share the API keys with you.

This project makes use of swiftlint, to install it on your system:
```
brew install swiftlint
```
For further instructions go here:[SwiftLint](https://github.com/realm/SwiftLint)

#### Other Dependencies
- Backend Decodable
- OHTTPStubs for testing
- RiveRuntime for animations

## Features

### Networking
- Abstract networking layer that is optimized for use with multiple API's
- Generalized HTTPClient for low overhead and flexibility as needed
- Endpoint Protocol for easy configuration of endpoints without writing a lot of code for each request
- Result type for handling success and failure cases in HTTPClient
- Async/await for granular matching of external API's
- Serviceable protocols to define service classes that execute network requests
- Services that are easily composable into Repository or other layers through dependency injection
- Easy to maintain and allows for quick pivoting as needed

### Frontend Architecture
SwiftUI's declarative UI does not require the use of MVVM in iOS development. Instead, it follows an MV (Model View) setup, with the View containing equivalent functions to the ViewModel. The Environment Object allows for access to repositories that synchronize data flow throughout the app. However, it is important to note that while some state may be preserved in the Environment Object, it could potentially be refactored to have isolated views manage their own state. This approach may provide better scalability and maintenance for the app. 

### SwiftUI Tests
At this time, SwiftUI views do not come with built-in testing capabilities. However, following the principles outlined in John Sundell's "Writing Testable Code when using SwiftUI" article, we can make testing easier. This includes separating views and business logic, using dependency injection, and making sure views are as stateless as possible. Doing this will make it simpler to create unit tests for the business logic and integration tests for the views.

I will be working on SwiftUI testing but may be found on a development branch vs what is currently submitte. 

## Credits and Inspiration
- https://developer.apple.com/forums/thread/699003
- https://betterprogramming.pub/async-await-generic-network-layer-with-swift-5-5-2bdd51224ea9
- https://www.figma.com/community/plugin/1041038879576667317/Swift-Package-Exporter (Love this)

## Screenshots
