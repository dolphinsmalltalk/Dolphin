﻿"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArray
	subclass: #'OS.COM.CADWORD'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CADWORD_Size' -> 16r8 }!

OS.COM.CADWORD guid: (Core.GUID fromString: '{60f684dc-b3e2-4700-8e9c-d1a18764ed84}')!

OS.COM.CADWORD comment: '<CADWORD> is an <ExternalStructure> class to wrap the struct ''OCIDL.CADWORD'' from type information in the ''OCIDL Library'' library.

CADWORD is a counted array of 32-bit unsigned integers. For an example usage see IPerPropertyBrowsing.'!

!OS.COM.CADWORD categoriesForClass!OCIDL-Structs! !

!OS.COM.CADWORD methodsFor!

getElements
	^UInt32Array fromAddress: self pElems length: self cElems! !

!OS.COM.CADWORD categoriesForMethods!
getElements!accessing!private! !
!

!OS.COM.CADWORD class methodsFor!

byteSize
	^_CADWORD_Size!

defineFields
	"Define the fields of the CADWORD structure.
		CADWORD compileDefinition
	
		typedef 		struct tagCADWORD {
			unsigned long cElems;
			unsigned long* pElems;
		} CADWORD;

	"

	"Nothing more to add to superclass template"
	super defineFields.

!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^UInt32
! !

!OS.COM.CADWORD class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
elementClass!constants!public! !
!

