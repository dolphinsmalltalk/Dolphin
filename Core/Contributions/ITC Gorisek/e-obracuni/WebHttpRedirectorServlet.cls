"Filed out from Dolphin Smalltalk X6.1"!

WebHttpServlet subclass: #WebHttpRedirectorServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebHttpRedirectorServlet guid: (GUID fromString: '{EF00B823-BEED-4F9F-A8F1-CC7CC5C6CC18}')!
WebHttpRedirectorServlet comment: ''!
!WebHttpRedirectorServlet categoriesForClass!Unclassified! !
!WebHttpRedirectorServlet methodsFor!

process: request on: stream 
	"This is a simple redirector servlet to hide URL parameters from Referer field when redirecting to foreign sites.
	This is done for security reasons.
	Poslje HTML redirect, ker sicer samo HTTP redirect ne spremeni address bar-a in referer-ja."

	| url |
	url := request stringAt: 'url'.
	url isEmpty 
		ifTrue: [stream fileNotFoundResponse]
		ifFalse: 
			[(url beginsWithUppercase: 'HTTP') ifFalse: [url := 'http://' , url].
			stream 
				nextPutAll: '<html><head><meta http-equiv="refresh"  content="0;URL=' , url webHtmlEncodedForForm 
						, '"></head><body></body></html>']! !
!WebHttpRedirectorServlet categoriesFor: #process:on:!public! !

!WebHttpRedirectorServlet class methodsFor!

servletName
	^'redirect'! !
!WebHttpRedirectorServlet class categoriesFor: #servletName!public! !

