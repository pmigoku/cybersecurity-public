# GitHub Crash Course
Welcome! This guide will walk you through the basics of using Git and GitHub to collaborate on our course repository. The goal is to allow everyone to contribute labs, demos, and fixes without directly editing the `main` branch.

Think of **Git** as "Track Changes" for code. it's a system that lives on your computer to manage and track the history of your files. Think of **GitHub** as Google Drive—it's a website where we store copies of our Git repositories to collaborate with others.

Full git documentation can be found [Here](https://git-scm.com/doc)

## Getting Setup
Installing Git
* **Windows**: Download and install [Git for Windows](https://git-scm.com/download/win).
* **macOS**: Open your terminal and run `xcode-select --install`. If that doesn't work, you can install it with [Homebrew](https://brew.sh/) by running `brew install git`.
* **Linux**: Open your terminal and use your package manager.
    * For Debian/Ubuntu: `sudo apt-get update && sudo apt-get install git`
    * For Fedora/CentOS: `sudo yum install git`

Next you must configure git
```bash
git config --global user.name "Your Name"
git config --global user.email "youremail@example.com"
```

If you don't already have one, sign up for a free account at [github.com](https://github.com).

## Collobaration workflow
This is the cycle you'll follow every time you want to add or change something in the main repository. This process ensures your changes are reviewed before being merged, which is a standard best practice.

### Step 1: Fork the Repository

A **fork** is your personal copy of the main repository. You can make any changes you want to your fork without affecting the original.

* Navigate to the main course repository on GitHub.
* Click the **Fork** button in the top-right corner. This will create a copy of the repository under your own GitHub account.

### Step 2: Clone Your Fork to Your Computer

A **clone** is a local copy of the repository that lives on your machine. This is where you will actually edit the files.

* Go to *your* forked repository on GitHub (e.g., `github.com/YourUsername/Course-Repo`).
* Click the green **`< > Code`** button.
* Copy the URL (HTTPS is easiest to start with).
* In your terminal, navigate to where you want to store the project and run:

```bash
git clone COPIED_URL_HERE
```

This will create a new folder with the repository's name.

### Step 3: Create a New Branch

A **branch** is like creating a separate draft of your work. It lets you work on a new feature or fix without disturbing the main version of the code. **Never work directly on the `main` branch.**

* Navigate into your new repository folder: `cd Course-Repo`
* Create and switch to a new branch. Give it a descriptive name.

```bash
# Example branch names: add-sql-injection-lab, fix-typo-in-readme
git checkout -b <your-branch-name>
```

### Step 4: Make Your Changes

Now, you can create new files or edit existing ones. Add your new lab, update a demo script, or fix a typo. Do all your work in this new branch.

You can always check the status of your changes by running:
`git status`

### Step 5: Stage and Commit Your Changes

Once you're happy with your changes, you need to save them to Git's history. This is a two-step process.

1.  **Stage Files**: This is you telling Git, "prepare these specific files to be saved." You can add all changed files at once with a period (`.`).
    ```bash
    git add .
    ```
2.  **Commit Files**: This creates a snapshot (a "save point") of your staged files. Always include a clear, concise message describing what you did.
    ```bash
    git commit -m "feat: Add new lab for directory traversal"
    ```

### Step 6: Push Your Branch to Your Fork

Now you need to upload your committed changes from your computer to your fork on GitHub.

```bash
git push origin <your-branch-name>
```

### Step 7: Open a Pull Request (PR)

A **Pull Request** is a formal request to merge the changes from your branch into the `main` branch of the *original* course repository. This is the final step where others can review your work.

* Go to your fork on GitHub.
* You should see a banner that says "Your branch is ahead of 'main' by X commits." Click the **"Contribute"** or **"Open pull request"** button.
* Make sure the base repository is the original course repo and the head repository is your fork.
* Add a clear title and description for your changes.
* Click **"Create pull request"**.

Your work is now submitted for review!

---

## Part 3: Keeping Your Fork Updated

If the original course repository gets updated by other instructors, your fork will become outdated. You should sync it before starting new work.

1.  **Configure an "Upstream" Remote (One-time setup)**: First, tell Git where the original repository is.
    ```bash
    # In your local repo folder
    git remote add upstream [https://github.com/OriginalOwner/Course-Repo.git](https://github.com/OriginalOwner/Course-Repo.git)
    ```
2.  **Sync Your Fork**: Before creating a new branch, pull the latest changes from the original repository into your local `main` branch.
    ```bash
    # Switch to your main branch
    git checkout main

    # Fetch changes from the original repo
    git pull upstream main

    # Push those updates to your fork on GitHub
    git push origin main
    ```

Now your fork's `main` branch is up-to-date, and you can create a new branch to start your next contribution.

# A Simpler Workflow with VS Code

By using VS Code's built-in Git features and the official GitHub extension, you can reduce the number of commands you need to memorize and manage everything from one place.

## Prerequisites

1.  **Install Git**: You still need Git installed on your system, as VS Code uses it in the background.
2.  **Install the GitHub Extension**: In VS Code, go to the **Extensions** view (the icon with the four squares on the sidebar). Search for `GitHub Pull Requests and Issues` and install the official one from Microsoft.
3.  **Log In**: After installing the extension, you'll be prompted to log in to your GitHub account. A notification will pop up—just click to sign in and authorize VS Code.

---

## The Easier Visual Studio Code Workflow

This process replaces most of the command-line steps with simple button clicks.

### Step 1: Fork and Clone the Repository

* **Fork on GitHub**: This is the only step you still need to do in your web browser. Go to the main course repository and click **Fork**.

* **Clone in VS Code**:
    1.  Open the Command Palette (`Ctrl+Shift+P` or `Cmd+Shift+P` on Mac).
    2.  Type `Git: Clone` and press Enter.
    3.  Select **"Clone from GitHub"** and choose your forked repository from the list.
    4.  Pick a folder on your computer to save it to. VS Code will open the repository for you automatically.

### Step 2: Create a New Branch

Instead of using the command line, just look at the bottom-left corner of the VS Code window.

1.  Click on the current branch name (which will likely be `main`).
2.  A menu will appear at the top. Click **`+ Create new branch...`**.
3.  Type your new branch name (e.g., `add-xss-demo`) and press Enter.

You are now on your new branch. It's that simple!

### Step 3: Make, Stage, and Commit Changes

This is where the VS Code integration really shines.

1.  **Make Changes**: Edit your files as you normally would.
2.  **View Changes**: Click on the **Source Control** icon in the sidebar on the left (it looks like a branching path). You'll see a list of all the files you've modified.
3.  **Stage Changes**: Hover over a file in the list and click the **`+`** icon to "stage" it (add it to your commit).
4.  **Commit**: Type a clear commit message in the text box at the top of the Source Control panel and click the **checkmark icon** ✔️ to commit your staged changes.


### Step 4: Push Your Branch

After committing, VS Code will know your new branch exists locally but not on GitHub.

* Look at the bottom-left status bar again. You'll see an icon with a cloud and an up arrow (⤓). Click it. This single action, often labeled **"Publish Branch"**, will push your new branch and all your commits to your fork on GitHub.

### Step 5: Create the Pull Request (Right from VS Code!)

Once you've pushed your branch, the GitHub extension makes this final step incredibly easy.

1.  Go to the **GitHub** icon in the sidebar on the left.
2.  You will see your branch listed under the "Pull Requests" section.
3.  Click the **Create Pull Request** icon (it looks like a small arrow branching off).
4.  A new panel will open where you can review the changes, write a title and description, and create the PR without ever leaving your editor.

That's it! You have successfully submitted your changes for review. The workflow is the same, but VS Code's interface provides a much more intuitive, visual way to get it done.

