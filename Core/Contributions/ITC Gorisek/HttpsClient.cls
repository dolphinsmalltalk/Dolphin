"Filed out from Dolphin Smalltalk 7"!

HttpClient subclass: #HttpsClient
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpsClient guid: (GUID fromString: '{ba0fb7f4-f9d2-41fc-be2e-544de795897b}')!
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

