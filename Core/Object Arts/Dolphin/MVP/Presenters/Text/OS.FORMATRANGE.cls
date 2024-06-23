"Filed out from Dolphin Smalltalk"!

OS.AbstractFORMATRANGE
	subclass: #'OS.FORMATRANGE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_FORMATRANGE_Size' -> 16r30.
			'_OffsetOf_cpMax' -> 16r2C.
			'_OffsetOf_cpMin' -> 16r28
		}!

OS.FORMATRANGE guid: (Core.GUID fromString: '{9bdca5bb-f238-4744-a903-f02b32617822}')!

OS.FORMATRANGE comment: 'FORMATRANGE is an <ExternalStructure> class to represent the Win32 structure of the same name.

FORMATRANGE is used in conjunction with the Rich Edit control''s EM_FORMATRANGE message. See the Win32 SDK documentation for further information.'!

!OS.FORMATRANGE methodsFor!

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

!OS.FORMATRANGE categoriesForMethods!
cpMax!**compiled accessors**!public! !
cpMax:!**compiled accessors**!public! !
cpMin!**compiled accessors**!public! !
cpMin:!**compiled accessors**!public! !
!

!OS.FORMATRANGE class methodsFor!

byteSize
	^_FORMATRANGE_Size!

defineFields
	"Define the fields of the Win32 FORMATRANGE structure.

		FORMATRANGE compileDefinition
	"

	super defineFields.
	"Expand CHARRANGE inline"
	self
		defineField: #cpMin type: Int32Field new;
		defineField: #cpMax type: Int32Field new!

getFieldNames
	^#(#hdc #hdcTarget #rc #rcPage #cpMin #cpMax)! !

!OS.FORMATRANGE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

