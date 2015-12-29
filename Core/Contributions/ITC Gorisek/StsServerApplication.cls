"Filed out from Dolphin Smalltalk X6.2"!

WikiDocApplication subclass: #StsServerApplication
	instanceVariableNames: 'oldExceptionHandlerMethodSource'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsServerApplication guid: (GUID fromString: '{FDA989FB-CD39-45FD-B631-C4F5C37DA141}')!
StsServerApplication comment: ''!
!StsServerApplication categoriesForClass!Unclassified! !
!StsServerApplication methodsFor!

allowPublicReadOnlyAccess
	"Answer <true> if this is a public STS repository that everyone can access."

	^(self configurationSettingsAt: 'Application.allowPublicReadOnlyAccess' ifAbsent: []) = 'true'!

applicationPath
	^'STSServer'!

defaultAdminPassword
	^'stsadmin'!

defaultAdminUser
	^'STSADMIN'!

defaultUrlPrefix
	"Private - Answer default url prefix if it is not defined in the configuration file."

	^'sts'!

disableDebuggerInServerMode
	"Disables debugger in the development image when STS is running as a server.
	This way debugger window will not open on exceptions and the server will run without blocking.

	Store old method source to restore exception handling method upon STS server shutdown.
	"

	oldExceptionHandlerMethodSource isNil 
		ifTrue: 
			[oldExceptionHandlerMethodSource := (DevelopmentSessionManager methodFor: #unhandledException:) 
						getSource.
			DevelopmentSessionManager 
				compile: 'unhandledException: anException 

	self logError: anException.
	ItcSystemManager logLineWithTS: ''ERROR: '', anException itcDescription.
	^Processor activeProcess terminate']!

initialWikiWelcomePage
	^'==Welcome to STS Server==

You have now successfully installed the STS Server. The server is now running on your computer.

To add new server users or wiki pages please click on the [[button:Login]] above.

The default administrator username and password is:

* Username: ''''''stsadmin''''''
* Password: ''''''stsadmin''''''



[[hint:{{
To learn more about the wiki used by this server please visit the WikiDoc homepage at:

[http://wiki.gorisek.com]
}}]]'!

loadServlets
	super loadServlets.
	self servletManager addServlet: StsServerManagerServlet new for: self!

omniBasePath
	"Path to STS repository."

	^StsManager current getRepositoryPath!

shutdown
	super shutdown.
	oldExceptionHandlerMethodSource isNil 
		ifFalse: 
			[DevelopmentSessionManager compile: oldExceptionHandlerMethodSource.
			oldExceptionHandlerMethodSource := nil]! !
!StsServerApplication categoriesFor: #allowPublicReadOnlyAccess!public!startup and shutdown! !
!StsServerApplication categoriesFor: #applicationPath!public! !
!StsServerApplication categoriesFor: #defaultAdminPassword!public! !
!StsServerApplication categoriesFor: #defaultAdminUser!public! !
!StsServerApplication categoriesFor: #defaultUrlPrefix!private!startup and shutdown! !
!StsServerApplication categoriesFor: #disableDebuggerInServerMode!public!startup and shutdown! !
!StsServerApplication categoriesFor: #initialWikiWelcomePage!public! !
!StsServerApplication categoriesFor: #loadServlets!public!startup and shutdown! !
!StsServerApplication categoriesFor: #omniBasePath!public!startup and shutdown! !
!StsServerApplication categoriesFor: #shutdown!public!startup and shutdown! !

