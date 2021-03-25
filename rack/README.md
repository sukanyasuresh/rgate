# Rgate

CLI Application

# About

rgate is a cli application is used to start a rack server which acts as an api gateway between various backends which run as docker containers.

# Set up 

 `cd rack`
 
 `bundle install`

# Configuring container labels

The label values are to be hardcoded in the backends dockerfiles (rgate/containers/backends)

# Configuring config.yml

The backend and the api routes are configured from the `rack/config/config.yml` file.

# Listing the rgate commands

`cd rack`

`./rgate help`


# Running the APP

`cd rack`

`rspec`

# Running the APP

`cd rack`

`./rgate start`

 The params that can be passed now are:
 
 --port,   -p  : The port on which the gateway should run
 
 --config, -c  : The path of the config file  
 
 
 # Design over view
 
 rgate is a stand alone ruby script which when run to start, triggers the command to start a simple rack application.
 
 This rack application before start, makes sures to set up everything is set up like: (app.rb)
 
   1. Docker images are built.
   
   2. The config file is parsed and the routes and backend labels are figured.
   
   3. The corresponding backends for the routes are created.
   
   4. All routes are set.
   
   5. All the routes and mapped to the right handler.
   
And when the server start, the route is just mapped to the right backend and the response is get passed on from the backend.

# Known flaws

1. Not able to pass the label values dynamically which building the image. It has to be modified in the dockerfile and hence is hardcoded
2. Not able to shut down the application gracefully or run it in demon mode. (May be the rack application should have also been dockerized?)
3. Running a system command to start the app.

#References

1. https://levelup.gitconnected.com/writing-a-small-web-service-with-ruby-rack-and-functional-programming-a16f802a19c0  
2. https://stackoverflow.com/questions/701310/launching-ruby-without-the-prefix-ruby
3. https://medium.com/@jesseadametz/test-driven-development-for-your-dockerfiles-350d4d415df7
