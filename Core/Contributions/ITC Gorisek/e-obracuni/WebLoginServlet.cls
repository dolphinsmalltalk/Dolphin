"Filed out from Dolphin Smalltalk X6.1"!

WebHttpServlet subclass: #WebLoginServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebLoginServlet guid: (GUID fromString: '{0D272FF6-A9E5-4286-9613-E2846CAFE63A}')!
WebLoginServlet comment: ''!
!WebLoginServlet categoriesForClass!Unclassified! !
!WebLoginServlet methodsFor!

process: request on: stream 
	self checkOrSetDefaultClientIdCookieFor: request on: stream.
	Processor activeProcess language: application defaultLanguage.
	application 
		sendLoginPageFor: request
		withMessage: nil
		on: stream! !
!WebLoginServlet categoriesFor: #process:on:!public! !

!WebLoginServlet class methodsFor!

servletName

	^'login.html'! !
!WebLoginServlet class categoriesFor: #servletName!public! !

