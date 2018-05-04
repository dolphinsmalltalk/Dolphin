"Filed out from Dolphin Smalltalk 7"!

IEnumXXXX subclass: #IEnumStruct
	instanceVariableNames: 'elementClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IEnumStruct guid: (IID fromString: '{E153E32C-7CFB-4182-A9CD-E5394DB58168}')!
IEnumStruct comment: 'IEnumStruct is a generic client implemention of IEnum for enumerating over structs. It can be parameterised with the structure type to be enumerated over on a per instance basis, eliminating the need to define a large number of IEnumStructName classes.

Instance Variables:
	elementClass		<externalStructure class>

'!
!IEnumStruct categoriesForClass!COM-Interfaces! !
!IEnumStruct methodsFor!

elementClass
	^elementClass!

elementClass: anExternalStructure 
	elementClass := anExternalStructure! !
!IEnumStruct categoriesFor: #elementClass!accessing!private! !
!IEnumStruct categoriesFor: #elementClass:!accessing!private! !

!IEnumStruct class methodsFor!

elementClass: elementClass 
	"Answer a new instance of the receiver that will be able to enumerate over a collection of
	the specified class of <ExternalStructure> elements."

	^(self newPointer)
		elementClass: elementClass;
		yourself! !
!IEnumStruct class categoriesFor: #elementClass:!instance creation!public! !

