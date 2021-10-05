# Code test

The task is to build an iOS application that will make a network request and display a credit score to the user. A request can be made to the following endpoint. It will respond with a JSON payload providing credit score information for the user: https://5lfoiyb0b3.execute-api.us-west-2.amazonaws.com/prod/mockcredit/values

## Criteria and Tips
We do not expect a perfect solution, but we do expect your solution to be **production-grade**. Here are some criteria and tips:
* The project should contain only what is needed.
* The code should be well structured and easy to follow.
* The solution should be well tested with automation tests.
* You should consider error cases.
* You should consider other form factors.
* You can make any technical decisions that you think are appropriate provided you’re willing to explain them.
* Your user interfaces should be built using **UIKit**.  Although we are adopting SwiftUI, most of our app is still written using UIKit.
* Your solution should be written entirely in **Swift** – we do not use Objective C.

## Bonus Points
For bonus points, consider some of the following extras:
* Add a circular progress indicator inside of the circle that animates as it appears, rather like the donut in the ClearScore app.
* Add a detail page that opens when the donut is tapped by the user, displaying additional information from the endpoint.
