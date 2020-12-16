"Filed out from Dolphin Smalltalk 7"!

WinHttpServer.HTTP_PROPERTY_FLAGS subclass: #'WinHttpServer.HttpQosSetting'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WinHttpServer.HttpQosSetting guid: (Core.GUID fromString: '{9468481b-e27a-44f4-8468-2e5f2fdef275}')!
WinHttpServer.HttpQosSetting isNonInstantiable: true!
WinHttpServer.HttpQosSetting comment: ''!
!WinHttpServer.HttpQosSetting categoriesForClass!Win32-Structs! !
!WinHttpServer.HttpQosSetting methodsFor!

qosType
	^self class qosType!

value
	^self subclassResponsibility!

value: anInteger
	^self subclassResponsibility! !
!WinHttpServer.HttpQosSetting categoriesFor: #qosType!constants!public! !
!WinHttpServer.HttpQosSetting categoriesFor: #value!public! !
!WinHttpServer.HttpQosSetting categoriesFor: #value:!public! !

!WinHttpServer.HttpQosSetting class methodsFor!

propertyId
	^HttpServerQosProperty!

qosType
	^self subclassResponsibility! !
!WinHttpServer.HttpQosSetting class categoriesFor: #propertyId!constants!public! !
!WinHttpServer.HttpQosSetting class categoriesFor: #qosType!constants!public! !

