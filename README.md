# FunTraveler
<p align="center">
  <img src="https://i.ibb.co/4JynXzf/71-4x.png" width="150"/>
<!--   <img src="https://i.ibb.co/FXpy4Dd/1-4x.png" width="130" height="130"/> -->
</p>

<p align="center" style="margin:0px 50px 0px 60px">
FunTraveler is an App that provides a platform for members to share their trips, <br>sync the information and co-edit their itineraries with group members.
</p>


<p align="center">
    <a href="https://apps.apple.com/tw/app/funtraveler/id1619742562"><img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg"></a>
</p>

## Features

## Hightlights

- With real-time data synchronization to add co-editors, you can invite your friends to edit the itinerary together.
- Integrate the Google Maps into the app, and you can search for attractions fast
- Plan the itinerary automatically, a powerful algorithm that helps you calculate the distance and driving time between the attractions. You don’t need to worry about how to estimate it.
- Find the sharing post easily. We have brought together an active community where you can find useful travel experience sharing and comments.


## Technologies Used
- Used `PusherSwift` to implement real-time data synchronization and support the co-edit function.
- Implemented the arithmetic logic to rearrange all the time setting in the trip plans.
- Implemented `Google Maps SDK` to allow users to use maps and search for attractions.
- `Encapsulation CoreLocation` to calculate distance and traffic times between attractions with coordinates.
- Utilized `GMSPolyline` to draw custom markers in GoogleMaps to visualize paths.
- Use `video cache`, enable requests so that data can be served faster, and improve user online experience.
- Utilized `AVVideoComposition CoreAnimationTool` to combine CALayer and animations in the videos.
- Apply two upload methods to upload video with `multipart/form-data`.
- Customized UI components to optimize the maintainability and reusability of codes.
- Utilized `UIView.animation` with gesture recognizer to implement interaction in the whole App.
- Utilized `delegate pattern` to hand off responsibilities between different classes.
- Implemented `Auto Layout programmatically` to make the app compatible with all iPhone devices.
- Used `MVC pattern` to define different objects with different responsibilities, and the way that objects interact with each other.
- Utilized Lottie to display animations.
- Implemented image downloading and caching via Kingfisher.

## Screen Shots 
![3](https://user-images.githubusercontent.com/86958230/170877232-2cc5f9ca-5147-41d9-bf31-6e8999a89bc3.png)
![4](https://user-images.githubusercontent.com/86958230/170877239-61e54e45-b76c-470d-b2fd-bb98ef89fe01.png)
![5](https://user-images.githubusercontent.com/86958230/170877242-22c90bce-6546-4c86-a68c-ad610b937b7a.png)
![6](https://user-images.githubusercontent.com/86958230/170877243-12a70f26-7c62-4f5e-8a4e-c92c2f2b679d.png)
![7](https://user-images.githubusercontent.com/86958230/170877246-2030e31b-af27-4529-a750-fe87f3c2a766.png)
![8](https://user-images.githubusercontent.com/86958230/170877247-874c28fd-28e8-475f-a2e9-09cf09dbb1ba.png)
![9](https://user-images.githubusercontent.com/86958230/170877248-e365ccd5-4dc3-4868-94f2-d888f018f046.png)

## Libraries
  * [PusherSwift](https://github.com/pusher/pusher-websocket-swift)
  * [lottie-ios](https://github.com/airbnb/lottie-ios)
  * [GoogleMaps](https://developers.google.com/maps/documentation/ios-sdk/)
  * [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess)
  * [JGProgressHUD](https://github.com/JonasGessner/JGProgressHUD)
  * [IQKeyboardManagerSwift](https://github.com/hackiftekhar/IQKeyboardManager)
  * [SwiftLint](https://github.com/realm/SwiftLint)
  * [Crashlytics](https://firebase.google.com/products/crashlytics?hl=en)

## Version
1.0.1

## Release Notes
| Version | Notes |
| :---: | ----- |
| 1.0.1 | Fix bugs|
| 1.0.0 | Submitted to the App Store |

## Requirement
- Xcode 13.0 or later
- iOS 14.0 or later
- Swift 5

## Contact
Sally Lin 林翊婷
sallylin831006@gmail.com

## License
FunTraveler is released under the MIT license. See [LICENSE](https://github.com/sallylin831006/FunTraveler/blob/develop/LICENSE) for details.




