"Filed out from Dolphin Smalltalk X6.2"!

WebHttpServer subclass: #WebHttpsServer
	instanceVariableNames: 'sslConfiguration'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebHttpsServer guid: (GUID fromString: '{70C9D09E-68DC-4ED4-AA2E-48C9D07E2267}')!
WebHttpsServer comment: ''!
!WebHttpsServer categoriesForClass!Unclassified! !
!WebHttpsServer methodsFor!

basicStartup
	super basicStartup.
	ItcSystemManager logLine: 'Web server using secure HTTPS protocol'!

processRequestFrom: socket 
"	ne pozabi poslati:

		request setIsHttps"!

serverProtocol
	^'HTTPS'! !
!WebHttpsServer categoriesFor: #basicStartup!public! !
!WebHttpsServer categoriesFor: #processRequestFrom:!public! !
!WebHttpsServer categoriesFor: #serverProtocol!public! !

!WebHttpsServer class methodsFor!

defaultPort
	^defaultPort isNil ifTrue: [443] ifFalse: [defaultPort]! !
!WebHttpsServer class categoriesFor: #defaultPort!public! !

