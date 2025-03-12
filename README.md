![iScreen Shoter - Google Chrome - 250312133346](https://github.com/user-attachments/assets/5fac2114-e762-4bf8-906f-a0f15d0301cd)

# Task description

Please use Rails to build a simple survey tool, with the following requirements:

- A user should be able to create any number of surveys
- A survey consists of one question represented as a single string. The answer to the question is always Yes or No.
- The home screen of your app should show a list of surveys and a button to create a new one
- A user can respond to a survey by clicking into it from the list mentioned above
- A survey can be answered multiple times with a yes/no response
- You should keep track of when each of the survey responses are saved
- You should display the results of the survey on the home screen with the percentage of yes and no responses.

NB:

- You should make sure that your app can be run by other developers on the team.
- Make sure all of your dependencies are listed in your Gemfile and instructions are provided for setup if needed.
- You don't need to worry about user authentication but you may stub this out if you wish

Tech stack:

- You should use SQLite to persist your data.
- You should use ruby 3.2
- You should use Rails 7.1.2
- You should return back to us a single compressed file that contains the source for this Rails app.

## Setup

1. Install dependencies:

   ```bash
   bundle install
   ```

2. Setup the database:

   ```bash
   rails db:create
   rails db:migrate
   ```

3. Start the server:
   ```bash
   rails server
   ```

App will be available at `http://localhost:3000`
