## Get Started

### Steps to setup the application
- Clone the repo
- ``` bundle install ```
- ``` rake db:create db:migrate db:seed ```
- Start server ``` rails s ```
- Go to this URL - [http://localhost:3000](http://localhost:3000)
- This will redirect to the Login page.
- Login with the seeded admin creds
  - ``` email : admin@example.com ```
  - ``` password : password ```
- For student registration go to [http://localhost:3000/users/sign_up](http://localhost:3000/users/sign_up)

### Feature
- Admin can manage (create, edit, delete and list) Schools
- Admin can manage(create, edit, delete and list) School admins
- School admins can manage (create, edit, delete and list) courses and batches
- School admin can see all the enrollments under a batch and can approve / reject
- SchoolAdmins can adds students to batches
- Admin can impersonate as a School admin and can manage everything under the school
- Students can register to the app, and they can raise a request to enrol in a batch.
- Students from the same batch can see their classmates

### Specs

Run the specs using the command ```rspec spec```

### API
- API Documentation URL - https://documenter.getpostman.com/view/2206416/2s9YC7UCGC
