# YamatomichiApp

This README is still a work in progress...

# Code Coverage Report

[![codecov](https://codecov.io/gh/LVOL98/YamatomichiApp/branch/main/graph/badge.svg?token=0Q9VOW921Z)](https://codecov.io/gh/LVOL98/YamatomichiApp)

[![codecov](https://codecov.io/gh/{LVOL98}/{YamatomichiApp}/branch/master/graph/badge.svg)](https://codecov.io/gh/{LVOL98}/{YamatomichiApp})

Link to coverage report:

[https://app.codecov.io/gh/LVOL98/YamatomichiApp](https://app.codecov.io/gh/LVOL98/YamatomichiApp)

---

1. [Branching strategy.](#branch-strat)
   1. [Feature branch convention.](#branch-conv)
   2. [Hotfixes branching.](#branch-hotfixes)
2. [Basic git commands.](#basic-git-commands)
3. [Commit messages](#commit-messages)
4. [Project file/folder structure](#project-structure)
5. [Testing strategy](#testing-strategy)
6. [Points to be discussed](d#iscussion-points)

<a name="branch-strat"></a>

## Branching strategy

Our branching strategy will utilize the
[Gitflow Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)
and can be read in further details in the link. Basically we will have 2 main
branches and a number of feature branches:

1. `main` branch - This is the main branch and contains the "production code".
2. `develop` branch - This is the development branch containing the development
code. This code is merged and pushed into `main` at the end of each
sprint/increment.
3. `feature` branches is used to develop specific product features relating to a
specific user story and is merged and pushed into the development branch when it
 adheres to the definition of done (DoD).

![Git Flow Workflow - Release Branches](<https://wac-cdn.atlassian.com/dam/jcr:b5259cce-6245-49f2-b89b-9871f9ee3fa4/03%20(2).svg?cdnVersion=1472>)

<a name="branch-conv"></a>

### Feature branch convention

- Branches should be branched from `develop`
- Remember always to pull the newest development branch before creating a feature
branch
- Name branches with user story ID's from [ClickUp](https://app.clickup.com/4656448/v/b/s/8730607)
and a small descriptive tag such as `#epzeny_profileCreation`
- Experimenting with things is fine but preferably this is best in branches. In
some cases working on a specific user stories more than one it might make sense
to further branch out from the feature branch eg. `#epzeny_profileCreation_juwu`

<a name="branch-hotfixes"></a>

### Hotfixes branching

This branching strategy might not be necessary in the beginning but might be
usefull in later sprints if bugs are discovered that are easily fixable.

![Git flow workflow - Hotfix Branches](<https://wac-cdn.atlassian.com/dam/jcr:61ccc620-5249-4338-be66-94d563f2843c/05%20(2).svg?cdnVersion=1472>)

<a name="basic-git-commands"></a>

## Basic git commands

Change branch

```bash
git checkout branch_name
```

Create a new branch

```bash
git checkout -b branch_name
```

<a name="commit-messages"></a>

## Commit messages

Any convention such as tags? Point to be discussed.

<a name="project-structure"></a>

## Project file/folder structure

Initial Draft:

![Code Structure Package Diagram V.1](https://i.imgur.com/RkA391c.png)

See also [this medium post](https://medium.com/flutter-community/flutter-scalable-folder-files-structure-8f860faafebd)

<a name="testing-strategy"></a>

## Testing Strategy

We have 3 categories of tests

- Unit Tests
- Widget Tests
- Integration Tests

The following strategy is used to maximize fault discovery without slowing development. The implementation of the various tests are as follows

### Unit Tests

Test of a unit of code usually with a specific function i.e. a calculator or a email validator

These test should be written with the associated feature of the program

### Widget Tests

Test of a UI elemnt and its functionality

Should be written when components are made (widgets that are used in several places and are imported from a tamplate that we (the developers) have made) and not to ensure the functionality of an entire view, for that see integration tests (i.e. TextFormFieldComponent)

### Integration Tests

Test the program on an emulated device and can perform longer flows such as signing in with at test user, and signing out with that given user

These test should be written together with development of larger features to ensure compatability on several devices

NOTE: that this doesn't use any mocks and will test the program as if it was live

Commands for integration tests:

```bash
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/support_test.dart
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/sign_in_test.dart
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/email_not_verified_alert_test.dart
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/banned_user_test.dart
```

<a name="discussion-points"></a>

## Point to be discussed

- [ ] Should we make code reviews and only merge with pull requests?
- [ ] Should we make any commit message conventions?
- [ ] Consider the file structure of the project

<!-- ## Setting up your local developer environment on Mac

1. Download the Flutter SDK (Software development kit):
[flutter_macos_1.22.6-stable.zip](https://storage.googleapis.com/flutter_infra/releases/stable/macos/flutter_macos_1.22.6-stable.zip)
2. Extract the file in the desired location - can be anywhere on your system doesn't matter. Can be done manually or with the following command:

```bash
cd ~/PATH-TO-DESIED-LOCATIOM
unzip ~/Downloads/flutter_macos_1.22.6-stable.zip
```

3. Add the `flutter` tool to your path. This is done by opening your .bash_profile file found in your root user folder. Can be opened/created either with `code ~/.bash_profile` if VS code is already in your path. Otherwise goto your hme folder in finder (usually has the name of you computer user) and press `CMD + SHIFT + .` for showing hidden files. If no such file exist you can create one with `touch .bash_profile`. -->
