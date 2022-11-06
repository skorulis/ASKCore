# ASKCore

This package contains classes that form the core of most apps. This covers multiple disparate areas but for simplicity are all grouped under one umbrella until such a time that there is sufficient reason to create a standalone package.

## Coordinator

The coordinator folder contains code for managing SwiftUI the navigation stack. 

## Error

Services for handling errors. Usually an app will have a central ErrorService and setup an ErrorPresentationController to present the errors that are raised.

## Injection

Helper functions for Swinject to allow easy integration into apps following preset patterns. 

## Network

Services for making network requests
