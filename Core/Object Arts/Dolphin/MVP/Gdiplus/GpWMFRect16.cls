"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #GpWMFRect16
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GpWMFRect16 guid: (GUID fromString: '{1713ca90-9e3e-465b-9c3d-3c7b201f00ee}')!
GpWMFRect16 comment: '<GpWMFRect16> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpWMFRect16'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(1713CA90-9E3E-465B-9C3D-3C7B201F00EE)]
struct tagGpWMFRect16 {
	short left;
	short top;
	short right;
	short bottom;
} GpWMFRect16;
'!
!GpWMFRect16 categoriesForClass!Unclassified! !
!GpWMFRect16 methodsFor!

bottom
	"Answer the receiver's bottom field as a Smalltalk object."

	^(bytes swordAtOffset: 6)!

bottom: anObject
	"Set the receiver's bottom field to the value of anObject."

	bytes swordAtOffset: 6 put: anObject!

left
	"Answer the receiver's left field as a Smalltalk object."

	^(bytes swordAtOffset: 0)!

left: anObject
	"Set the receiver's left field to the value of anObject."

	bytes swordAtOffset: 0 put: anObject!

right
	"Answer the receiver's right field as a Smalltalk object."

	^(bytes swordAtOffset: 4)!

right: anObject
	"Set the receiver's right field to the value of anObject."

	bytes swordAtOffset: 4 put: anObject!

top
	"Answer the receiver's top field as a Smalltalk object."

	^(bytes swordAtOffset: 2)!

top: anObject
	"Set the receiver's top field to the value of anObject."

	bytes swordAtOffset: 2 put: anObject! !
!GpWMFRect16 categoriesFor: #bottom!**compiled accessors**!public! !
!GpWMFRect16 categoriesFor: #bottom:!**compiled accessors**!public! !
!GpWMFRect16 categoriesFor: #left!**compiled accessors**!public! !
!GpWMFRect16 categoriesFor: #left:!**compiled accessors**!public! !
!GpWMFRect16 categoriesFor: #right!**compiled accessors**!public! !
!GpWMFRect16 categoriesFor: #right:!**compiled accessors**!public! !
!GpWMFRect16 categoriesFor: #top!**compiled accessors**!public! !
!GpWMFRect16 categoriesFor: #top:!**compiled accessors**!public! !

!GpWMFRect16 class methodsFor!

defineFields
	"Define the fields of the GpWMFRect16 structure.
		GpWMFRect16 compileDefinition
	
		typedef [uuid(1713CA90-9E3E-465B-9C3D-3C7B201F00EE)]
		struct tagGpWMFRect16 {
			short left;
			short top;
			short right;
			short bottom;
		} GpWMFRect16;
"

	self
		defineField: #left type: SWORDField new offset: 0;
		defineField: #top type: SWORDField new offset: 2;
		defineField: #right type: SWORDField new offset: 4;
		defineField: #bottom type: SWORDField new offset: 6.
	self byteSize: 8! !
!GpWMFRect16 class categoriesFor: #defineFields!**auto generated**!initializing!public! !

