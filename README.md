# Flutter Todo App with SQLite Database

This is a simple Todo app built using Flutter framework and SQLite database. The app allows users to create, read, update, and delete tasks. It demonstrates the integration of SQLite for local data storage in a Flutter application.

## Features

- Add new tasks .
- Edit task details.
- Delete tasks from the list.
- View a list of all tasks.


## Installation

1. Clone this repository using `git clone https://github.com/your-username/flutter-todo-sqflite.git`
2. Navigate to the project directory `cd flutter-todo-sqflite`
3. Install the required dependencies using `flutter pub get`
4. Run the app on a connected device or emulator using `flutter run`

## Dependencies

- [sqflite](https://pub.dev/packages/sqflite): A Flutter plugin for SQLite database integration.
- [provider](https://pub.dev/packages/provider): A state management library for Flutter.

## Usage
- Launch the app, and you'll be taken to the main screen.
- To add a new task, tap the "+" button, enter the task title.
- To edit a task, click on the task and change title and click update.
- To delete a task, click on the delete button.

## Database Schema

The app uses a simple SQLite database schema to store tasks:

```sql
CREATE TABLE tasks (
    id INTEGER PRIMARY KEY,
    title TEXT,
);

