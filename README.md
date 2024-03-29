# iOS Interview Project

This is the base project for the iOS interview with improved architecture. 

I completed the refactors discussed in the interview with Cesar! 😊

#Branching
Uses [Git Flow](https://nvie.com/posts/a-successful-git-branching-model), most changes should be made on `dev`

# Architecture
I chose to refactor the app into an MVVM-C based architecture using protocol oriented programming and Swift generics. This gives us a good level of testability and allow allows us to build simple Views that do not contain business logic.

## Root
Required dependencies are created in the `init()` of `SceneDelegate` from where, we navigate to the initial `Screen.characterList`

## Dependency Injection
Dependency Injection container that provides all necessary ViewModels and Services. It's easy to use, just call `resolve<T>()` will throw an error if the requested type is not supported

## Navigation
- `enum Screen` contains the screens we want to display. For now it's just `characterList`
- `Navigator` has a method `navigate(to screen: Screen)` which pushes the view onto a `UINavigationController`. It also has `showAlert()` for showing alerts to the user

## ViewModel
Provides a bindable interface for Views to hook into. Methods such as `getPokemonList()` ensure that all business logic is abstracted away from the view to reduce coupling.

## Bindings
`Bindable` is an observable object that consumers can listen to via `addObserver()`. Also called `LiveData`. Views should set this up via `Bind()` function

## Services and Networking
- `PokemonService` responsible for fetching the list of Pokemon when needed
- `NetworkService` has a generic method `fetch <Response: Codable>(endpoint: String, completion: @escaping (Response?, Error?) -> ()` this allows us to fetch from any API endpoint we'd like as long as we provide the expected response. Uses `URLSession`


# Next Steps
- If I were to spend more time on this, I'd probably convert the UI to SwiftUI. That way, we can drop the need for our `Bindable` class and just use the native [`@Published`](https://developer.apple.com/documentation/combine/published) and [`@Binding<T>`](https://developer.apple.com/documentation/swiftui/binding).
- I'd also add unit tests using XCTest and verification based testing using a framework like [Quick](https://github.com/Quick/Quick). Can use something like [Mockingbird](https://github.com/birdrides/mockingbird) for mocks. This lets us test that our ViewModel calls our PokemonSevice with the correct arguments, for example. Oh, and I would make the UI more enjoyable of course! 

All in all this was a very fun exercise! 😁