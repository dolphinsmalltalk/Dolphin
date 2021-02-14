"Filed out from Dolphin Smalltalk 7"!

OS.COM.CountedArray subclass: #'OS.COM.CADWORD'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.CADWORD guid: (Core.GUID fromString: '{60f684dc-b3e2-4700-8e9c-d1a18764ed84}')!
OS.COM.CADWORD comment: '<CADWORD> is an <ExternalStructure> class to wrap the struct ''OCIDL.CADWORD'' from type information in the ''OCIDL Library'' library.

CADWORD is a counted array of 32-bit unsigned integers. For an example usage see IPerPropertyBrowsing.'!
!OS.COM.CADWORD categoriesForClass!OCIDL-Structs! !
!OS.COM.CADWORD methodsFor!

getElements
	^DWORDArray fromAddress: self pElems length: self cElems! !
!OS.COM.CADWORD categoriesFor: #getElements!accessing!private! !

!OS.COM.CADWORD class methodsFor!

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

	^DWORD
! !
!OS.COM.CADWORD class categoriesFor: #defineFields!public!template definition! !
!OS.COM.CADWORD class categoriesFor: #elementClass!constants!public! !

