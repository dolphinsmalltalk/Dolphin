"Filed out from Dolphin Smalltalk"!

HTTP_PROPERTY_FLAGS subclass: #HttpQosSetting
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpQosSetting guid: (GUID fromString: '{9468481b-e27a-44f4-8468-2e5f2fdef275}')!
HttpQosSetting isAbstract: true!
HttpQosSetting comment: ''!
!HttpQosSetting categoriesForClass!Win32-Structs! !
!HttpQosSetting methodsFor!

qosType
	^self class qosType!

value
	^self subclassResponsibility!

value: anInteger
	^self subclassResponsibility! !
!HttpQosSetting categoriesForMethods!
qosType!constants!public! !
value!public! !
value:!public! !
!

!HttpQosSetting class methodsFor!

propertyId
	^HttpServerQosProperty!

qosType
	^self subclassResponsibility! !
!HttpQosSetting class categoriesForMethods!
propertyId!constants!public! !
qosType!constants!public! !
!

