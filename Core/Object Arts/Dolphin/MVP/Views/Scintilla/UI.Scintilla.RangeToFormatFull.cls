"Filed out from Dolphin Smalltalk"!

OS.AbstractFORMATRANGE
	subclass: #'UI.Scintilla.RangeToFormatFull'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_cpMax' -> 16r2C.
			'_OffsetOf_cpMin' -> 16r28.
			'_RangeToFormatFull_Size' -> 16r30
		}!
UI.Scintilla.RangeToFormatFull guid: (Core.GUID fromString: '{a15c1878-0be0-46bf-9a95-1432da170cdc}')!
UI.Scintilla.RangeToFormatFull comment: ''!
!UI.Scintilla.RangeToFormatFull methodsFor!

cpMax
	"Answer the <Integer> value of the receiver's 'cpMax' field."

	^bytes intPtrAtOffset: _OffsetOf_cpMax!

cpMax: anInteger
	"Set the receiver's 'cpMax' field to the value of the argument, anInteger"

	bytes intPtrAtOffset: _OffsetOf_cpMax put: anInteger!

cpMin
	"Answer the <Integer> value of the receiver's 'cpMin' field."

	^bytes intPtrAtOffset: _OffsetOf_cpMin!

cpMin: anInteger
	"Set the receiver's 'cpMin' field to the value of the argument, anInteger"

	bytes intPtrAtOffset: _OffsetOf_cpMin put: anInteger! !
!UI.Scintilla.RangeToFormatFull categoriesForMethods!
cpMax!**compiled accessors**!public! !
cpMax:!**compiled accessors**!public! !
cpMin!**compiled accessors**!public! !
cpMin:!**compiled accessors**!public! !
!

!UI.Scintilla.RangeToFormatFull class methodsFor!

byteSize
	^_RangeToFormatFull_Size!

defineFields
	"Define the fields of the Scintilla RangeToFormatFull structure.

		RangeToFormatFull compileDefinition
	"

	super defineFields.
	"Expand CharacterRangeFull inline"
	self
		defineField: #cpMin type: IntPtrField new;
		defineField: #cpMax type: IntPtrField new!

getFieldNames
	^#(#hdc #hdcTarget #rc #rcPage #cpMin #cpMax)! !
!UI.Scintilla.RangeToFormatFull class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

