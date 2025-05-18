# 🍜 Umm – Nearby Restaurant Explorer

**Umm** is a SwiftUI-based iOS application that helps users explore nearby restaurants and drink shops through a fun and intuitive spin wheel experience – powered by Google Places and Apple MapKit.

[🔗 GitHub Repository](https://github.com/nman7/IOS_TASK_3)

---

## ✨ Features

- 🎰 **Spin Wheel Recommendation**: Users spin a roulette wheel to receive a random recommendation (e.g. “ramen”, “boba”, “sushi”). The result is automatically used to query nearby places via the Google Places API.
- 🔍 **API-based Search from Spin Result**: Instead of typing, the app searches based on the selected keyword from the spin result, providing a surprise element to the user experience.
- 🗺️ **Interactive Map View**:
  - Tappable restaurant pins with circular image previews
  - Zoom in/out and re-center on user location
  - Tap a pin to view an info card with photo gallery, name, address, and rating
- 📄 **List View**: View the same results in a scrollable list layout with thumbnails and descriptions.
- ❤️ **Favourites**:
  - Tap to save your favourite restaurants
  - View saved favourites and remove them when needed
- 📍 **Location Services**:
  - Uses your current location to search nearby
  - Displays your location as a blue dot on the map
- 💾 **Smart Search Caching**:
  - Caches results for the same keyword and location to reduce unnecessary API calls
  - Loads faster when revisiting previously searched terms

---

## 🛠 Technologies Used

- **SwiftUI**
- **MapKit**
- **CoreLocation**
- **Google Places API**
  - Text Search
  - Place Details
  - Place Photos

---

## 🧪 Setup Instructions

1. Clone this repository:
   ```bash
   git clone https://github.com/nman7/IOS_TASK_3.git
   ```

2. Open `Umm.xcodeproj` in Xcode.

3. Add your **Google Maps API Key**:
   - Open `RecommendationView.swift`, `FavouritesView.swift`
   - Replace the `apiKey` string with your own Google API key that has:
     - Places API
     - Place Details
     - Place Photos enabled

4. Run on a real iOS device or iOS simulator (iPhone 16 Pro 18.2 recommended) (location services recommended).

---


## 💡 Credits

Developed by **Cheng-En Tsai**,	**Kai-Hsuan Lin**, and	**Nauman mansuri** for iOS Development Project.  
Built with Google Maps APIs and designed for decision-fatigued food lovers 😋

---

## 📄 License

MIT License – use freely, attribution appreciated.
