# 03-week-3-navigation-state-management 

When is setState still enough, and when should state be lifted into Riverpod?
setState is sufficient for ephemeral, localized UI state that no other widget cares about (e.g., a simple animation toggle or a text field input). State must be lifted into Riverpod when it needs to be shared across multiple pages, involves asynchronous operations (like network requests), or contains complex business logic that should be separated from the UI tree.

What is the difference between context.go and context.push, and when should each be used?
context.go alters the underlying route stack to jump to a specific destination, often replacing the current view. It is used for top-level navigation (like a NavigationBar switching between Home and Stats). context.push stacks a new page strictly on top of the current one, preserving the previous page's state and automatically providing a Back button. It is used for navigating into deeper detail views.

How does AsyncValue prevent bugs compared with three separate booleans?
Relying on separate booleans (isLoading, hasError, hasData) allows for impossible overlapping states, such as isLoading and hasError both being true simultaneously. AsyncValue operates as a sealed union type, forcing the application to exist in exactly one mutually exclusive state at a time. It physically prevents unhandled UI states.

Which part of the AI output did you fix, and why?
I fixed three critical flaws:

A dependency name collision in pubspec.yaml where the project name matched the package name, breaking all imports.

Misplaced UI code (ListView.builder) floating outside of any class structure.

The toggle and remove methods in the TodoListNotifier. The initial AI logic relied on list indexes, which would cause the wrong tasks to be modified or deleted when operating on a filtered list. I refactored them to target the exact Todo object instead.

AI is used to make my words more a lil bit comfortable to understand 

setState is enough for localized, temporary UI state that no other screen cares about, while Riverpod should be used when state needs to be shared globally

context.go replaces the route stack (ideal for top-level navigation bars where you jump between main views), whereas context.push stacks a new screen on top

AsyncValue acts as a sealed union that ensures only one mutually exclusive state—loading, error, or data—can exist at a time

I fixed a dependency collision in pubspec.yaml, removed misplaced floating UI code, and refactored index-based list manipulation to target exact Todo objects so that filtering wouldn't break data mutations. (I use AI to explain this one because what I know is... "the code is error so I see all files and there is a problem there I change is and voila it works!!!)

