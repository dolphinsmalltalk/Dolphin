"Filed out from Dolphin Smalltalk"!

OS.COM.IEnumXXXX
	subclass: #'OS.COM.IEnumStruct'
	instanceVariableNames: 'elementClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IEnumStruct guid: (OS.COM.IID fromString: '{e153e32c-7cfb-4182-a9cd-e5394db58168}')!
OS.COM.IEnumStruct comment: '`OS.COM.IEnumStruct` is a generic client implemention of IEnum for enumerating over structs. It can be parameterised with the structure type to be enumerated over on a per instance basis, eliminating the need to define a large number of IEnumStructName classes.

Instance Variables:
	elementClass		<externalStructure class>

'!
!OS.COM.IEnumStruct categoriesForClass!COM-Interfaces! !
!OS.COM.IEnumStruct methodsFor!

elementClass
	^elementClass!

elementClass: anExternalStructure 
	elementClass := anExternalStructure! !
!OS.COM.IEnumStruct categoriesForMethods!
elementClass!accessing!private! !
elementClass:!accessing!private! !
!

!OS.COM.IEnumStruct class methodsFor!

elementClass
	"Private - Answer the class of element enumerated by the receiver."

	"Only known by instances"

	^self shouldNotImplement
!

elementClass: elementClass 
	"Answer a new instance of the receiver that will be able to enumerate over a collection of
	the specified class of <ExternalStructure> elements."

	^(self newPointer)
		elementClass: elementClass;
		yourself! !
!OS.COM.IEnumStruct class categoriesForMethods!
elementClass!constants!private! !
elementClass:!instance creation!public! !
!

