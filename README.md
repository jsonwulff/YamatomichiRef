# YamatomichiApp

This README is still a work in progress...

## Branching strategy

Out branching strategy will utilize the [Gitflow Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) and can be read in further details in the link. Basically we will have 2 main branches and a number of feature branches:

1. `master` branch - This is the main branch and contains the "production code".
2. `develop` branch - This is the development branch containing the development code. This code is merged and pushed into `master` at the end of each sprint/increment.
3. `feature` branches is used to develop specific product features relating to a specific user story and is merged and pushed into the development branch when it adheres to the definition of done (DoD).

![Git Flow Workflow - Release Branches](https://wac-cdn.atlassian.com/dam/jcr:b5259cce-6245-49f2-b89b-9871f9ee3fa4/03%20(2).svg?cdnVersion=1472)

### Feature branch convention

- Branches should be branched from `develop`
- Remember always to pull the newest development branch before creating a feature branch
- Name branches with user story ID's from [ClickUp](https://app.clickup.com/4656448/v/b/s/8730607) and a small descriptive tag such as `#epzeny_profileCreation`
- Experimenting with things is fine but preferably this is best in branches. In some  cases working on a specific user stories more than one it might make sense to further branch out from the feature branch eg. `#epzeny_profileCreation_juwu`

### Basic git commands

Change branch

```bash
git checkout branch_name
```

Create a new branch

```bash
git checkout -b branch_name
```

### Commit messages

Any convention such as tags? Point to be discussed.

### Point to be discussed

- [ ] Should we make code reviews and only merge with pull requests?
- [ ] Should we make any commit message conventions?

<!-- ## Setting up your local developer environment on Mac

1. Download the Flutter SDK (Software development kit):
[flutter_macos_1.22.6-stable.zip](https://storage.googleapis.com/flutter_infra/releases/stable/macos/flutter_macos_1.22.6-stable.zip)
2. Extract the file in the desired location - can be anywhere on your system doesn't matter. Can be done manually or with the following command:

```bash
cd ~/PATH-TO-DESIED-LOCATIOM
unzip ~/Downloads/flutter_macos_1.22.6-stable.zip
```

3. Add the `flutter` tool to your path. This is done by opening your .bash_profile file found in your root user folder. Can be opened/created either with `code ~/.bash_profile` if VS code is already in your path. Otherwise goto your hme folder in finder (usually has the name of you computer user) and press `CMD + SHIFT + .` for showing hidden files. If no such file exist you can create one with `touch .bash_profile`. -->