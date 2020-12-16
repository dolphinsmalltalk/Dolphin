"Filed out from Dolphin Smalltalk 7"!

HTTP_PROPERTY_FLAGS subclass: #HttpQosSetting
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!HttpQosSetting categoriesFor: #qosType!constants!public! !
!HttpQosSetting categoriesFor: #value!public! !
!HttpQosSetting categoriesFor: #value:!public! !

!HttpQosSetting class methodsFor!

propertyId
	^HttpServerQosProperty!

qosType
	^self subclassResponsibility! !
!HttpQosSetting class categoriesFor: #propertyId!constants!public! !
!HttpQosSetting class categoriesFor: #qosType!constants!public! !

