# User Data

Consider user data as being partitioned into two types:

- User preferences:
  - e.g. theme ( e.g. darkmode )
- User profile
  - email address

How should each type be stored ? Does it even make sense to partition user data at all ?

To answer this, lets consider two data read and write patterns.

## Async read, async write

Most services fall into this pattern ( e.g. a remote api call ).
Any widget access data using this pattern will need to be async aware.
For example, handle loading and error states.

Note that the `SharedPreferences` component for platorm storage of simple data uses this pattern.

## Sync read, sync or fire-and-forget write

Most services ( due to being IO bound in nature ) will not use this data access pattern.

However, in certain cases a service can be forced to behave this way.

The `SharedPreferences` component pulls all data from local storage using a single async call. This can be performed at application bootstrap, so that all subsequence reads are sync.

Writes remain async, however by adopting fire-and-forget we can discard the future and reduce the call to being sync.

This is obviously only a useful approach for non-essential data that does not require writes to be acknowledged.

## User data partitioning

We can therefore divide user data into two groups:

User preferences:

- data that should not force the UI to adopt async patterns
- non-essential data that can be written using fire-and-forget
- notifies all watchers when data changed
- uses `SharedPreferences` component to persist locally

User profile:

- data that should force the UI to adopt async patterns
- essential data that requires writes to be acknowleged
- notifies all watchers when data changed
- uses remote service for centralized storage
