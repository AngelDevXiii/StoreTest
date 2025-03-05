# Flutter Data Source Pattern with Offline-First Approach

## Overview

In this project, I implemented the Data Source pattern in Flutter to manage both remote and local data sources. The goal was to create a seamless offline-first experience where the app continues to function even without an active internet connection.

## Implementation Details

### Remote and Local Data Sources

I structured the data handling using two separate data sources:

1. **Remote Data Source**: Handles interactions with Firebase.
2. **Local Data Source**: Uses ObjectBox as a dependency to store cached data.

### Offline-First Approach

- The app prioritizes data from the local cache, ensuring that users can continue using it without noticing connectivity issues.
- When a sync is triggered, the local data is compared against the remote data.
- If conflicting data exists, the most recent timestamp determines which version is kept.

### Firebase Offline Capabilities

Although Firebase provides built-in offline support, I disabled it for demonstration purposes to showcase the custom offline-first implementation with ObjectBox caching.

## Conclusion

This project serves as a showcase of handling offline-first data synchronization in Flutter using the Data Source pattern. By leveraging ObjectBox for local caching and Firebase as a remote backend, I was able to create an experience where users interact with the app without being disrupted by connectivity changes.
