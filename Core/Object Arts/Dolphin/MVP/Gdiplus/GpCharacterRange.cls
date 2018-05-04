"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #GpCharacterRange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GpCharacterRange guid: (GUID fromString: '{01079d38-5861-45b6-8de5-d2165b5de26b}')!
GpCharacterRange comment: '<GpCharacterRange> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpCharacterRange'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(01079D38-5861-45B6-8DE5-D2165B5DE26B)]
struct tagGpCharacterRange {
	int First;
	int length;
} GpCharacterRange;
'!
!GpCharacterRange categoriesForClass!Unclassified! !
!GpCharacterRange methodsFor!

First
	"Answer the receiver's First field as a Smalltalk object."

	^(bytes sdwordAtOffset: 0)!

First: anObject
	"Set the receiver's First field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

length
	"Answer the receiver's length field as a Smalltalk object."

	^(bytes sdwordAtOffset: 4)!

length: anObject
	"Set the receiver's length field to the value of anObject."

	bytes sdwordAtOffset: 4 put: anObject! !
!GpCharacterRange categoriesFor: #First!**compiled accessors**!public! !
!GpCharacterRange categoriesFor: #First:!**compiled accessors**!public! !
!GpCharacterRange categoriesFor: #length!**compiled accessors**!public! !
!GpCharacterRange categoriesFor: #length:!**compiled accessors**!public! !

!GpCharacterRange class methodsFor!

defineFields
	"Define the fields of the GpCharacterRange structure.
		GpCharacterRange compileDefinition
	
		typedef [uuid(01079D38-5861-45B6-8DE5-D2165B5DE26B)]
		struct tagGpCharacterRange {
			int First;
			int length;
		} GpCharacterRange;
"

	self
		defineField: #First type: SDWORDField new offset: 0;
		defineField: #length type: SDWORDField new offset: 4.
	self byteSize: 8! !
!GpCharacterRange class categoriesFor: #defineFields!**auto generated**!initializing!public! !

