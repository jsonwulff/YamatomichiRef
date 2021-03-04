# Routing

## Adding a new route

In order to add a new route to the app first add a route name in `/routes/routes.dart`.
Afterwards add the new route to the switch case in `/routes/route_generator.dart`.

When pushing a named route it is possible to pass arguments to the routed view.
This is done as shown in the example below

```dart
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      ...
      // Example of passing data
      case someRoute:
        // Validation of passed data - in this case a string
        if(args is String) {
          return MaterialPageRoute(builder: (_) => someView(data: args));
        }
        // If args is not of the correct type, return an error page.
        // Possibly throw an exceptoion while in development
        return MaterialPageRoute(builder: (_) => UnknownPage());
      ...
    }
  }
}
```
