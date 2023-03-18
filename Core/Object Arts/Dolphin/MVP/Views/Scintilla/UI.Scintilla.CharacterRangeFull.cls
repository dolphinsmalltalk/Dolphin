"Filed out from Dolphin Smalltalk"!

OS.AbstractCHARRANGE
	subclass: #'UI.Scintilla.CharacterRangeFull'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_CharacterRangeFull_Size' -> 16r8.
			'_OffsetOf_cpMax' -> 16r4.
			'_OffsetOf_cpMin' -> 16r0
		}!
UI.Scintilla.CharacterRangeFull guid: (Core.GUID fromString: '{70f3e4b8-de34-4813-8084-760a0998595d}')!
UI.Scintilla.CharacterRangeFull comment: ''!
!UI.Scintilla.CharacterRangeFull methodsFor!

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
!UI.Scintilla.CharacterRangeFull categoriesForMethods!
cpMax!**compiled accessors**!public! !
cpMax:!**compiled accessors**!public! !
cpMin!**compiled accessors**!public! !
cpMin:!**compiled accessors**!public! !
!

!UI.Scintilla.CharacterRangeFull class methodsFor!

byteSize
	^_CharacterRangeFull_Size!

defineFields
	"Define the fields of the Scintilla CharacterRangeFull structure.
		CharacterRangeFull compileDefinition
	
	struct Sci_CharacterRangeFull {
		Sci_Position cpMin;
		Sci_Position cpMax;
	};

	Sci_Position is an alias for ptrdiff_t, so a pointer-sized signed integer"

	self
		defineField: #cpMin type: IntPtrField new;
		defineField: #cpMax type: IntPtrField new! !
!UI.Scintilla.CharacterRangeFull class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
!

