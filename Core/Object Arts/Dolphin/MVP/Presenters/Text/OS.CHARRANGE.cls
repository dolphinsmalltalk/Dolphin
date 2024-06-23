"Filed out from Dolphin Smalltalk"!

OS.AbstractCHARRANGE
	subclass: #'OS.CHARRANGE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CHARRANGE_Size' -> 16r8. '_OffsetOf_cpMax' -> 16r4. '_OffsetOf_cpMin' -> 16r0 }!

OS.CHARRANGE guid: (Core.GUID fromString: '{3fd4e349-a730-484e-afb1-5f2fd9036259}')!

OS.CHARRANGE comment: '<CHARRANGE> is an <ExternalStructure> class to wrap the struct ''Win.CHARRANGE'' from type information in the ''Windows API (ANSI)'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagCHARRANGE {
	long cpMin;
	long cpMax;
} CHARRANGE;
'!

!OS.CHARRANGE categoriesForClass!Win-Structs! !

!OS.CHARRANGE methodsFor!

cpMax
	"Answer the <Integer> value of the receiver's 'cpMax' field."

	^bytes int32AtOffset: _OffsetOf_cpMax!

cpMax: anInteger
	"Set the receiver's 'cpMax' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cpMax put: anInteger!

cpMin
	"Answer the <Integer> value of the receiver's 'cpMin' field."

	^bytes int32AtOffset: _OffsetOf_cpMin!

cpMin: anInteger
	"Set the receiver's 'cpMin' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cpMin put: anInteger! !

!OS.CHARRANGE categoriesForMethods!
cpMax!**compiled accessors**!public! !
cpMax:!**compiled accessors**!public! !
cpMin!**compiled accessors**!public! !
cpMin:!**compiled accessors**!public! !
!

!OS.CHARRANGE class methodsFor!

byteSize
	^_CHARRANGE_Size!

defineFields
	"Define the fields of the CHARRANGE structure.
		CHARRANGE compileDefinition
	
		typedef 
		struct tagCHARRANGE {
			long cpMin;
			long cpMax;
		} CHARRANGE;
"

	self
		defineField: #cpMin type: Int32Field new;
		defineField: #cpMax type: Int32Field new! !

!OS.CHARRANGE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
!

