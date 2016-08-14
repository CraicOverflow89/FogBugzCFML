FogBugzCFML
===========
API Wrapper for the FogBugz website written in CFML.

#### Setup
To get this working you need to call ```actionSessionLogin``` with your FogBugz username, password and domain.
You will get back a session token, which you use for subsequent calls.
You should call ```actionSessionLogoff``` when finished.

#### Further Reading
There aren't functions here for everything you can do with the API, so feel free to add some!
See the [official API documentation](http://help.fogcreek.com/the-fogbugz-api) for more information.

#### Error Handling
The fogBugzTool component does a little error handling but some issues will be thrown.
Obviously, adapt everything to how you best see fit, for your own needs.

#### Feedback
Feel free to share questions/comments.