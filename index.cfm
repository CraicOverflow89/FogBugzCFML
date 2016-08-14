<cfscript>

	// Map Component
	tool = new fogBugzTool();

	// Authentication
	auth = {username:"MY USERNAME", password:"MY PASSWORD", domain:"MY DOMAIN"};
	// the domain is where you are on FogBugz - so if it's 'acme.fogbugz.com' when you login, it would be 'acme'
	// for example {username:"john.smith@acme.com", password:"12345", domain:"acme"};

	// Create Session
	session = tool.actionSessionLogin(auth.username, auth.password, auth.domain);
	if(!session.success)
	{
		writeDump(session.error);
		abort;
	}

	// List Cases
	writeDump(tool.actionCaseList(session.token, auth.domain));

	// Specific Case Info
	//writeDump(tool.actionCaseInfo(session.token, auth.domain, 123)); // where 123 is the ID of a case

	// Create a Case
	//writeDump(tool.actionCaseCreate(token = session.token, domain = auth.domain, project = "Test", title = "Test", description = "Just testing the FogBugz API", assignID = 3, priority = 7, category = "INQUIRY"));
	// where assignID is the userID for which to create the case (you can get this from above requests or looking on the website)
	// NOTE: if the project you specify doesn't exist, it will assign it to one that does!

	// Close Session
	tool.actionSessionLogoff(session.token, auth.domain);

</cfscript>