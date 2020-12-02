"Filed out from Dolphin Smalltalk 7"!

ExternalPoint subclass: #POINTL
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_x' -> 16r0.
		'_OffsetOf_y' -> 16r4
	}!
POINTL guid: (GUID fromString: '{dbeaf6a6-d2f7-4153-a02e-a389955a892f}')!
POINTL comment: '`POINTL` is an `ExternalStructure` class to wrap the Win32 POINTL structure. Instances of `POINTL` represent a cartesian coordinate with 32-bit signed integer x and y values.
'!
!POINTL categoriesForClass!Win32-Structs! !
!POINTL methodsFor!

asUIntPtr
	"Answer the receiver in a form suitable for passing or returning 
	as a  machine-word sized (32 or 64-bit) value."

	"Implementation Note: The compiler will optimise out the condition because it is constant."

	^VMConstants.IsWin64 ifTrue: [bytes uintPtrAtOffset: 0] ifFalse: [self asPoint asUIntPtr]!

x
	"Answer the <Integer> value of the receiver's 'x' field."

	^bytes sdwordAtOffset: _OffsetOf_x!

x: anInteger
	"Set the receiver's 'x' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_x put: anInteger!

x: xInteger y: yInteger

	bytes
		sdwordAtOffset: _OffsetOf_x put: xInteger;
		sdwordAtOffset: _OffsetOf_y put: yInteger!

y
	"Answer the <Integer> value of the receiver's 'y' field."

	^bytes sdwordAtOffset: _OffsetOf_y!

y: anInteger
	"Set the receiver's 'y' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_y put: anInteger! !
!POINTL categoriesFor: #asUIntPtr!converting!public! !
!POINTL categoriesFor: #x!**compiled accessors**!public! !
!POINTL categoriesFor: #x:!**compiled accessors**!public! !
!POINTL categoriesFor: #x:y:!initializing!public! !
!POINTL categoriesFor: #y!**compiled accessors**!public! !
!POINTL categoriesFor: #y:!**compiled accessors**!public! !

!POINTL class methodsFor!

defineFields
	"Define the fields of the POINTL structure.
		POINTL compileDefinition
	
		typedef 		struct tagPOINTL {
			long x;
			long y;
		} POINTL;
"

	self
		defineField: #x type: SDWORDField new;
		defineField: #y type: SDWORDField new!

uninitialize
	"Private - Unitialize the receiver as it is about to be removed from the system.
	Make sure our alias disappears with us."

	self environment removeKey: #POINT ifAbsent: []!

x: x y: y
	"Answer a new instance of the receiver representing the Point whose 
	cartesian coordinates are the arguments.
	Implementation Note: For performance reasons avoid going through
	all the <ExternalStructure> framework methods."

	^self basicNew 
		bytes: ((ByteArray newFixed: 8)
				sdwordAtOffset: _OffsetOf_x put: x;
				sdwordAtOffset: _OffsetOf_y put: y;
				yourself)
! !
!POINTL class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!POINTL class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!POINTL class categoriesFor: #x:y:!instance creation!public! !

