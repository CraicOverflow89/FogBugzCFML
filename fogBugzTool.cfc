component name = "fogBugzTool" output = "false"
{
	// Map Request UDF
	udf_request = new plugins.request().request;

	// Column Lookup
	column_lookup = "ixBug,ixBugParent,ixBugChildren,tags,fOpen,sTitle,sOriginalTitle,sLatestTextSummary,ixBugEventLatestText,ixProject,sProject,ixArea,ixGroup,ixPersonAssignedTo,sPersonAssignedTo,sEmailAssignedTo,ixPersonOpenedBy,ixPersonClosedBy,isPersonResolvedBy,ixPersonLastEditedBy,ixStatus,ixPriority,ixFixFor,dtLastUpdated,ixCategory,sCategory";

	/**
	* @hint creates a new case
	* @token the api token for the session
	* @domain your company domain
	* @project the name of the project
	* @title the title of the case
	* @description the description of the case
	* @assignID the ID of the user to assign the case to
	* @priority the priority of the case (1 - 7)
	* @category the name of the category (BUG|FEATURE|INQUIRY|SCHEDULE)
	*/
	public struct function actionCaseCreate(required string token, required string domain, required string project, required string title, required string description, required numeric assignID, required numeric priority, string category = "bug")
	{
		try
		{
			// Priority
			if(arguments.priority < 1 || arguments.priority > 7) {throw(message = "Invalid priority: " & arguments.priority & ". Must be between 1 (highest) and 7 (lowest).", type = "Invalid priority");}

			// Category
			var categoryID = 0;
			if(arguments.category == "BUG") {categoryID = 1;}
			if(arguments.category == "FEATURE") {categoryID = 2;}
			if(arguments.category == "INQUIRY") {categoryID = 3;}
			if(arguments.category == "SCHEDULE") {categoryID = 4;}
			if(categoryID == 0) {throw(message = "Invalid category: " & arguments.category & ". Valid categories are: BUG, FEATURE, INQUIRY or SCHEDULE.", type = "Invalid category");}

			// Request
			var result = udf_request(url = "https://" & arguments.domain & ".fogbugz.com/api.asp?cmd=new&token=" & arguments.token & "&sProject=" & arguments.project & "&sTitle=" & arguments.title & "&sEvent=" & arguments.description & "&ixPriority=" & arguments.priority & "&ixPersonAssignedTo=" & arguments.assignID, prefix = true);
			if(result.statusCode == "200 OK") {return {success:true, response:xmlParse(result.fileContent)};}
			return {success:false, error:result.errorDetail};
		}
		catch(any ex) {return {success:false, error:ex};}
	}

    /**
	* @hint get info for a specific case
	* @token the api token for the session
	* @domain your company domain
	* @caseID the id of the case to lookup
	*/
	public struct function actionCaseInfo(required string token, required string domain, required numeric caseID)
    {
        try
        {
            var result = udf_request(url = "https://" & arguments.domain & ".fogbugz.com/api.asp?cmd=search&token=" & arguments.token & "&cols=" & column_lookup & "&q=ixBug:" & arguments.caseID, prefix = true);
            if(result.statusCode == "200 OK") {return {success:true, info:xmlParse(result.fileContent)};}
            return {success:false, error:result.errorDetail};
        }
        catch(any ex) {return {success:false, error:ex};}
    }

	/**
	* @hint list cases
	* @token the api token for the session
	* @domain your company domain
	*/
	public struct function actionCaseList(required string token, required string domain)
	{
		try
		{
			var column_lookup = "ixBug,ixBugParent,ixBugChildren,tags,fOpen,sTitle,sOriginalTitle,sLatestTextSummary,ixBugEventLatestText,ixProject,sProject,ixArea,ixGroup,ixPersonAssignedTo,sPersonAssignedTo,sEmailAssignedTo,ixPersonOpenedBy,ixPersonClosedBy,isPersonResolvedBy,ixPersonLastEditedBy,ixStatus,ixPriority,ixFixFor,dtLastUpdated,ixCategory,sCategory";
			var result = udf_request(url = "https://" & arguments.domain & ".fogbugz.com/api.asp?cmd=listCases&token=" & arguments.token & "&cols=" & column_lookup, prefix = true);
			if(result.statusCode == "200 OK") {return {success:true, list:xmlParse(result.fileContent)};}
			return {success:false, error:result.errorDetail};
		}
		catch(any ex) {return {success:false, error:ex};}
	}

	/**
	* @hint login to the service and get the session token for further requests
	* @username the account username
	* @password the account password
	* @domain your company domain
	*/
	public struct function actionSessionLogin(required string username, required string password, required string domain)
	{
		try
		{
			var result = udf_request(url = "https://" & arguments.domain & ".fogbugz.com/api.asp?cmd=logon&email=" & arguments.username & "&password=" & arguments.password, prefix = true);
			if(result.statusCode == "200 OK" && findNoCase("<token>", result.fileContent)) {return {success:true, token:xmlParse(result.fileContent).response.token.XmlText, result:result};}
			if(findNoCase("Connection Failure", result.fileContent)) {return {success:false, error:"Connection Failure... check your authentication details."};}
			return {success:false, error:xmlParse(result.fileContent).response.error.XmlText};
		}
		catch(any ex) {return {success:false, error:ex};}
	}

	/**
	* @hint close a session
	* @token the api token for the session
	* @domain your company domain
	*/
	public void function actionSessionLogoff(required string token, required string domain)
	{
		try {udf_request("https://" & arguments.domain & ".fogbugz.com/api.asp?cmd=logoff&token=" & arguments.token);}
		catch(any ex) {return;}
	}

}