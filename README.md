# Place Alert

**Place Alert** is an iOS application designed to notify users by phone call or notification when they arrive at a pre-defined location, such as a bus stop or destination. The app allows users to add routes, manage bus stops or destinations via maps, and customize when they want to receive notifications (e.g., on specific days or weekdays).

The app leverages the **Google Maps SDK** for detailed mapping, **Google Places** API for location search, and provides a user-friendly interface for route customization and notifications.

---

## Features

- **Real-time Location Alerts:** Notifies the user via phone call or notification when the destination or stop is reached.
- **Route Management:** Users can add, edit, and delete routes, as well as specify multiple stops along the way.
- **Map Integration:** Fully integrated with Google Maps SDK for detailed maps and location accuracy.
- **Location Search:** Powered by Google Places and its Autocomplete method, users can search for any location quickly.
- **Custom Notification Settings:** Users can set whether they want to be notified on weekdays, weekends, or specific days, and toggle notifications for active/inactive routes.
- **Easy Activation/Deactivation:** Simple controls to activate or deactivate route alerts.

---

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Technologies Used](#technologies-used)
---

## Installation

### Requirements

- iOS 12.0 or later
- Xcode 14.0 or later
- Swift 5.5 or later
- [Cocoapods](https://cocoapods.org) or [Swift Package Manager](https://swift.org/package-manager/) for dependency management
- A valid Google API Key with **Google Maps**, **Google Places**, and **Autocomplete** enabled

### Setup

1. Clone this repository:

    ```bash
    git clone https://github.com/yourusername/place-alert.git
    ```

2. Install dependencies via CocoaPods:

    ```bash
    pod install
    ```

   Or, if using Swift Package Manager, update your `Package.swift` file to include:

    ```swift
    dependencies: [
        .package(url: "https://github.com/googlemaps/google-maps-ios-utils.git", .upToNextMajor(from: "3.10.0"))
    ]
    ```

3. Open the `.xcworkspace` file in Xcode:

    ```bash
    open PlaceAlert.xcworkspace
    ```

4. Add your Google API Key in the `AppDelegate.swift` file:

    ```swift
    import GoogleMaps
    import GooglePlaces

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("YOUR_GOOGLE_API_KEY")
        GMSPlacesClient.provideAPIKey("YOUR_GOOGLE_API_KEY")
        return true
    }
    ```

5. Build and run the application on a simulator or real device.

---

## Usage

1. **Add a Route:**
   - Open the app and go to the "Routes" section.
   - Click on the "Add Route" button.
   - Select the start and destination points on the map.

2. **Add Bus Stops/Destinations:**
   - Within a route, click "Add Stop" and search for specific bus stops or locations using the integrated Google Places Autocomplete.

3. **Activate/Deactivate Routes:**
   - Toggle the switch to enable or disable notifications for each route.

4. **Customize Notifications:**
   - Set custom notifications for weekdays, weekends, or specific days through the route settings.

---

## Configuration

1. **Google Maps SDK Integration:**
   The app uses Google Maps SDK for iOS to display detailed maps and location information. Ensure that you enable the **Google Maps API** in your [Google Cloud Console](https://console.cloud.google.com/).

2. **Google Places & Autocomplete:**
   The search functionality is powered by the Google Places API. Make sure that **Autocomplete** is enabled in your Google Cloud project for location search.

---

## Technologies Used

- **iOS:** Swift 5, Xcode 14
- **Google Maps SDK:** Provides detailed maps and geolocation features.
- **Google Places API:** For location searching and autocomplete functionality.
- **CocoaPods:** Dependency manager for installing the required SDKs.
- **Push Notifications:** For delivering location alerts to users in real time.


---

