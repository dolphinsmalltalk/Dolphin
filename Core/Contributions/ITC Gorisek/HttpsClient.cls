"Filed out from Dolphin Smalltalk X6.2"!

HttpClient subclass: #HttpsClient
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpsClient guid: (GUID fromString: '{BA0FB7F4-F9D2-41FC-BE2E-544DE795897B}')!
HttpsClient comment: ''!
!HttpsClient categoriesForClass!Unclassified! !
!HttpsClient methodsFor!

connection
	^lastSocket := ItcSystemManager newSSLclientSocketToHost: serverHostname port: serverPort!

defaultServerPort
	^443! !
!HttpsClient categoriesFor: #connection!public! !
!HttpsClient categoriesFor: #defaultServerPort!public! !

!HttpsClient class methodsFor!

defaultPort
	^443! !
!HttpsClient class categoriesFor: #defaultPort!public! !

