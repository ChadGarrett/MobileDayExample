# Mobile Day Example

A basic example application showing how Realm mobile database can be used as a temporary in-memory storage solution, or as a persistent store for data.

The example also shows how Realms notifications can work to listen for changes on the data, and update the UI accordingly

## Setup

1. Clone the repository
2. Install the pods using `pod install`
3. Open the MobileDayExample.xcworkspace
4. Run the project

### Server script

The advanced example shows how the UIViewController can be totally oblivious to the data and how it is synced, and only pay attention to the database.

To run the mini HTTP server that is included to sync data from, in the project route directory run `python3 server.py` to run the server.