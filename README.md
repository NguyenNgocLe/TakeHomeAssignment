
# Mobile Take Home

  

## Preview

  

<img  src="https://github.com/user-attachments/assets/26b65862-fcc6-4b35-afc7-2cfaa6bdaf6f"  width="300"  height="600"  />

<img  src="https://github.com/user-attachments/assets/4c8a3ad3-453d-44f5-8340-b481a3bb1817"  width="300"  height="600"  />

  
## 1. System
 - iOS >= 15.0
 - Xcode 16 or 15
 - Swift 6.0.3
 - **NOTICE:**

 If you’re using Xcode 16 or later, please download and run the **main** branch. However, if you’re using Xcode 15, kindly run the **test/support_xcode15** branch instead. I initially created the project using Xcode 16 on my personal machine, but I forgot that other developers might be using an older version, which could prevent the project from running properly. That’s why I created the **test/support_xcode15** branch to **support** **Xcode** **15**.

Sorry for the inconvenience.

## 2. Libraries Used
- **SD_WebImage**: Asynchronous image loading & caching with animation support.
- **Alamofire**: Robust async API networking.
- **SVProgressHUD**: Displays progress indicators (HUDs) during network operations.
- **Mocker:** Used for simulating and mocking network responses in unit tests.

## 3. App Features
- **User Information List**: Displays a list of users fetched from a remote API or local database.

- **Image Caching**: Uses SD_WebImage to download and cache user profile images.

- **Loading Indicator**: Uses SVProgressHUD to show and hide progress indicators during network requests.

- **Local Database**: When there are no users, the app will fetch data from the API to display. On subsequent loads, it will load the data from Core Data.

## 4. What I have done?
- Used MVVM architecture.
- Respected SOLID principle strictly.
- Users’ information shown immediately when the administrator
launches the application for the second time.
- Handled network connection error.
- Handled calling API error.
- UnitTest.

## 5. Technology

- **Async Let**: To fetch multiple users concurrently using async let

- **Async await**: modern concurrency

- **XCTestCase**

- **UIKit**

- **Core Data**

## 6. MVVM Flow in Project

1. **User interaction** (e.g., tap in `ListUserViewController`) triggers a call to the **ViewModel** method (`fetchUsers()`).

2. The **ViewModel** uses the **Repository** to load data:

- Checks Core Data for local entries; if missing, fetches users from the GitHub API.

- Converts data into model objects.

- Notifies the **View** of changes through handlers or bindings.

3. **View** reacts to changes (reloads table, shows errors, etc.).

4. **Detail navigation:** When a user taps an entry, the controller initializes a new **ViewModel** for `DetailsUserViewController` and navigates forward.

  

---

  
  
  

## 7. Setup and Installation

  

### Requirements

- **macOS:** Sequoia (recommended) or compatible

- **Xcode:** Version 16.0 (recommended) or compatible (any modern version works) or you can run Xcode 15 with branch **test/support_xcode15**

- **Swift Package Manager:** for dependency management

### Steps

1. **Clone the Repository**

```bash

git clone <YOUR_REPO_URL>

cd <PROJECT_FOLDER>

```

2. **Open the Project**

```bash
open TakeHome.xcodeproj
```

2. **Install Swift Package Manager Dependencies**

```bash
If you haven’t downloaded the Swift Package Manager dependencies yet, please go to File in Xcode -> Packages -> Reset Package Caches. Then, go to Xcode -> File -> Packages -> Update to Latest Package Versions.

After that, select a simulator and choose the appropriate environment scheme. Then press Command + R to run the project.

```

  



  

---

  

## Running the App

  

1. In Xcode, select the desired scheme (`Development`, `Staging`, or `Production`).

2. Build and run the app (`Cmd + R` or use the Run button).

3. Browse users, scroll list. Tap to see user detail.

4. Relaunch to verify instant data load from local cache.

  

---

  

## Unit Testing

  

- ViewModel and networking logic is covered with `XCTest` and mocking.

- To run tests:

Click Product > Test or use shortcut `Cmd + U` in Xcode.

  

---

  

## Troubleshooting

  

- Open `TakeHome.xcodeproj`

- If dependencies are missing, Resetpackage caches in as mentioned in item 2 above.

- Build errors? Check your Xcode version and update Xcode

- API returns empty or errors? GitHub may be rate-limiting your IP
- Those are some of the potential issues you may encounter when running the project. Other situations may also occur.
If you run into any errors, feel free to reach out to me for support in getting the project up and running.
Don’t hesitate to ask!

  

---

  


  


  

**For any questions or feedback, please contact me via email or open an issue. lengoc24899@gmail.com or phone number: 0368058446. Thanks for reading**
