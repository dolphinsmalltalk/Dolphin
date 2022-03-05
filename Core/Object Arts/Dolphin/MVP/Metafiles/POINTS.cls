"Filed out from Dolphin Smalltalk"!

ExternalPoint subclass: #POINTS
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_x _OffsetOf_y'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
POINTS guid: (GUID fromString: '{3278b910-3376-47e3-be99-02afe78a6230}')!
POINTS addClassConstant: '_OffsetOf_x' value: 16r0!
POINTS addClassConstant: '_OffsetOf_y' value: 16r2!
POINTS comment: '<POINTS> is an <ExternalStructure> class to wrap the struct ''Win32.POINTS'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(3278B910-3376-47E3-BE99-02AFE78A6230)]
struct tagPOINTS {
	short x;
	short y;
} POINTS;
'!
!POINTS categoriesForClass!Win32-Structs! !
!POINTS methodsFor!

asDword
	"Answer the receiver in a form suitable for passing or returning 
	as a 32-bit value (i.e. a 32-bit integer)."

	^bytes dwordAtOffset: 0!

asUIntPtr
	"Answer the receiver in a form suitable for passing or returning 
	as a  machine-word sized (32 or 64-bit) value."

	"Implementation Note: The compiler will optimise out the condition because it is constant."

	^VMConstants.IsWin64 ifTrue: [self asPoint asUIntPtr] ifFalse: [bytes dwordAtOffset: 0]!

x
	"Answer the <Integer> value of the receiver's 'x' field."

	^bytes swordAtOffset: _OffsetOf_x!

x: anInteger
	"Set the receiver's 'x' field to the value of the argument, anInteger"

	bytes swordAtOffset: _OffsetOf_x put: anInteger!

y
	"Answer the <Integer> value of the receiver's 'y' field."

	^bytes swordAtOffset: _OffsetOf_y!

y: anInteger
	"Set the receiver's 'y' field to the value of the argument, anInteger"

	bytes swordAtOffset: _OffsetOf_y put: anInteger! !
!POINTS categoriesForMethods!
asDword!converting!public! !
asUIntPtr!converting!public! !
x!**compiled accessors**!public! !
x:!**compiled accessors**!public! !
y!**compiled accessors**!public! !
y:!**compiled accessors**!public! !
!

!POINTS class methodsFor!

defineFields
	"Define the fields of the POINTS structure.

	POINTS  compileDefinition

		typedef [uuid(3278B910-3376-47E3-BE99-02AFE78A6230)]
		struct tagPOINTS {
			short x;
			short y;
		} POINTS;
"

	self
		defineField: #x type: SWORDField new beOverride;
		defineField: #y type: SWORDField new beOverride!

x: x y: y 
	^self basicNew bytes: ((ByteArray newFixed: 4)
				swordAtOffset: _OffsetOf_x put: x;
				swordAtOffset: _OffsetOf_y put: y;
				yourself)! !
!POINTS class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
x:y:!instance creation!public! !
!

