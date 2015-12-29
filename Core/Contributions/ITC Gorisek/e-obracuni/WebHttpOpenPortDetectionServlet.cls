"Filed out from Dolphin Smalltalk X6.1"!

WebHttpServlet subclass: #WebHttpOpenPortDetectionServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebHttpOpenPortDetectionServlet guid: (GUID fromString: '{78C0F981-DA66-4710-A637-2024417C735B}')!
WebHttpOpenPortDetectionServlet comment: ''!
!WebHttpOpenPortDetectionServlet categoriesForClass!Unclassified! !
!WebHttpOpenPortDetectionServlet methodsFor!

process: request on: stream 
	self checkOrSetDefaultClientIdCookieFor: request on: stream.
	application httpLoadBalancer rememberOpenPortFor: request.
	stream nextPutAll: '<html><head><title>OK</title></head><body></body></html>'! !
!WebHttpOpenPortDetectionServlet categoriesFor: #process:on:!public! !

!WebHttpOpenPortDetectionServlet class methodsFor!

servletName
	"Test if Open Port"

	^'T_O_P'! !
!WebHttpOpenPortDetectionServlet class categoriesFor: #servletName!public! !

