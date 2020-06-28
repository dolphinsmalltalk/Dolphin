"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #GpCharacterRange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_First' -> 16r0.
		'_OffsetOf_length' -> 16r4
	}!
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
	"Answer the <Integer> value of the receiver's 'First' field."

	^bytes sdwordAtOffset: _OffsetOf_First!

First: anInteger
	"Set the receiver's 'First' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_First put: anInteger!

length
	"Answer the <Integer> value of the receiver's 'length' field."

	^bytes sdwordAtOffset: _OffsetOf_length!

length: anInteger
	"Set the receiver's 'length' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_length put: anInteger! !
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
	self byteSize: 8!

getFieldNames
	^#(#First #length)! !
!GpCharacterRange class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!GpCharacterRange class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

