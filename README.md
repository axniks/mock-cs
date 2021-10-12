# Code test

This iOS application makes a network request and displays a mock credit score to the user, including a circular progress indicator

## Considerations
* The project is built on Xcode 13 and written in Swift using Foundation and UIKit, and Interface Builder
* File structure and content is mostly left as in the project template, e.g. re AppDelegate
* The main journey (minus the progress indicator) is covered by UI automation
* The JSON parsing is reasonably covered by unit tests

Additional time would have been spent on:
* Considering other form factors, scaling labels and views with the UI
* Increased test coverage, had I added the additional details screen
* Exploring using Combine over completionhandlers for the async requests
* Persisting the score between launches
