# FunTraveler
<p align="center">
  
  <img src="https://i.ibb.co/4JynXzf/71-4x.png" width="150" height="190"/>
<!--   <img src="https://i.ibb.co/FXpy4Dd/1-4x.png" width="130" height="130"/> -->
</p>

<p align="center" style="margin:0px 50px 0px 60px">
FunTraveler is an App that provides a platform for members to share their trips,  sync the information and co-edit their itineraries with group members.
</p>


<p align="center">
    <a href="https://apps.apple.com/tw/app/funtraveler/id1619742562"><img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg"></a>
</p>

## Features

## Hightlights

- With real-time data synchronization to add co-editors, you can invite your friend to edit the itinerary together.
- Integrate the Google Maps into the app, and you can search for attractions fast
- Plan the itinerary automatically, a powerful algorithm that helps you calculate the distance and driving time between the attractions. You don’t need to worry about how to estimate it.
- Find the sharing post easily. We have brought together an active community where you can find useful travel experience sharing and comments.


## Technologies Used
- Used PusherSwift to implement real-time data synchronization and support the co-edit function.
- Implemented the arithmetic logic to rearrange all the time setting in the trip plans.
- Implemented Google Maps SDK to allow users to use maps and search for attractions.
- Encapsulation CoreLocation to calculate distance and traffic times between attractions with coordinates.
- Utilized GMSPolyline to draw custom markers in GoogleMaps to visualize paths.
- Use video cache, enable requests so that data can be served faster, and improve user online experience.
- Utilized AVVideoComposition CoreAnimationTool to combine CALayer and animations in the videos.
- Apply two upload methods to upload video with multipart/form-data.
- Customized UI components to optimize the maintainability and reusability of codes.
- Utilized UIView.animation with gesture recognizer to implement interaction in the whole App.
- Utilized delegate pattern to hand off responsibilities between different classes.
- Implemented Auto Layout programmatically to make the app compatible with all iPhone devices.
- Used MVC pattern to define different objects with different responsibilities, and the way that objects interact with each other.
- Utilized Lottie to display animations.
- Implemented image downloading and caching via Kingfisher.

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

## Requirement
- Xcode 13.0 or later
- iOS 14.0 or later
- Swift 5

## Contact
Sally Lin 林翊婷
sallylin831006@gmail.com

## License
FunTraveler is released under the MIT license. See [LICENSE](https://github.com/sallylin831006/FunTraveler/blob/develop/LICENSE) for details.




