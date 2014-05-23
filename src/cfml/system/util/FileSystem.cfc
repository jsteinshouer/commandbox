/**
*********************************************************************************
* Copyright Since 2005 ColdBox Platform by Ortus Solutions, Corp
* www.coldbox.org | www.ortussolutions.com
********************************************************************************
* @author Brad Wood, Luis Majano, Denny Valliant
*
* I contain helpful methods for dealing with file and directory paths
*
*/
component singleton {
	
	// DI
	property name="shell" inject="shell";

	function init() {
		return this;
	}

	/**
	* Resolve the incoming directory from the file system
	* @directory.hint The directory to resolve
	*/
	function resolveDirectory( required string directory ) {
		// Load our path into a Java file object so we can use some of its nice utility methods
		var oDirectory = createObject( 'java', 'java.io.File' ).init( directory );

		// This tells us if it's a relative path
		// Note, at this point we don't actually know if it actually even exists yet
		if( !oDirectory.isAbsolute() ) {
			// If it's relative, we assume it's relative to the current working directory and make it absolute
			oDirectory = createObject( 'java', 'java.io.File' ).init( shell.pwd() & '/' & directory );
		}

		// This will standardize the name and calculate stuff like ../../
		return oDirectory.getCanonicalPath();
	}

	// TODO: Add resolve file

	/**
	* Get the JRE Executable from the File System
	*/
	function getJREExecutable(){
		// get java home
		var jreDirectory = createObject( "java", "java.lang.System" ).getProperty( "java.home" );
		if( isNull( jreDirectory ) OR !len( jreDirectory ) ){
			throw(message="Java.home not found", type="IllegalStateException" );
		}
		// detect OS
		var fileExtension = findNoCase( "windows", server.os.name ) ? ".exe" : "";
		// build path to executable
		var javaPath = jreDirectory & "/" & "bin" & "/java#fileExtension#";
		// build command
		var javaCommand =  createObject( "java", "java.io.File").init( javaPath ).getCanonicalPath();
		// take care of spaces in command
		if( javaCommand contains " " ){
			javaCommand = """#javaCommand#""";
		}
		
		return javaCommand;
	}

}