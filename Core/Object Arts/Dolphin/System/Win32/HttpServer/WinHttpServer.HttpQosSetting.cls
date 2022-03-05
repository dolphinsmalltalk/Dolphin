"Filed out from Dolphin Smalltalk"!

WinHttpServer.HTTP_PROPERTY_FLAGS subclass: #'WinHttpServer.HttpQosSetting'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_HttpQosSetting_Size' -> 16r4
	}!
WinHttpServer.HttpQosSetting guid: (Core.GUID fromString: '{9468481b-e27a-44f4-8468-2e5f2fdef275}')!
WinHttpServer.HttpQosSetting isNonInstantiable: true!
WinHttpServer.HttpQosSetting comment: ''!
!WinHttpServer.HttpQosSetting categoriesForClass!Win32-Structs! !
!WinHttpServer.HttpQosSetting methodsFor!

qosType
	^self class qosType! !
!WinHttpServer.HttpQosSetting categoriesForMethods!
qosType!constants!public! !
!

!WinHttpServer.HttpQosSetting class methodsFor!

propertyId
	^HttpServerQosProperty!

qosType
	^self subclassResponsibility! !
!WinHttpServer.HttpQosSetting class categoriesForMethods!
propertyId!constants!public! !
qosType!constants!public! !
!

