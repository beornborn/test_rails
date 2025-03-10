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

1. Clone the repository:

   ```bash
   git clone <repository-url>
   cd test_rails
   ```

   or unpack archive with app if you have one

2. Install dependencies:

   ```bash
   bundle install
   ```

3. Setup the database:

   ```bash
   bin/rails db:create
   bin/rails db:migrate
   ```

4. Run the test suite to verify everything is working:

   ```bash
   bundle exec rspec
   ```

5. Start the server:
   ```bash
   bin/rails server
   ```

The API will be available at `http://localhost:3000`.
