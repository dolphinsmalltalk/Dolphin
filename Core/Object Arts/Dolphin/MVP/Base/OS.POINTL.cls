"Filed out from Dolphin Smalltalk 7"!

External.POINT subclass: #'OS.POINTL'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_x' -> 16r0.
		'_OffsetOf_y' -> 16r4
	}!
OS.POINTL guid: (Core.GUID fromString: '{dbeaf6a6-d2f7-4153-a02e-a389955a892f}')!
OS.POINTL comment: '`POINTL` is an `ExternalStructure` class to wrap the Win32 POINTL structure. Instances of `POINTL` represent a cartesian coordinate with 32-bit signed integer x and y values.
'!
!OS.POINTL categoriesForClass!Win32-Structs! !
!OS.POINTL methodsFor!

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
!OS.POINTL categoriesFor: #asUIntPtr!converting!public! !
!OS.POINTL categoriesFor: #x!**compiled accessors**!public! !
!OS.POINTL categoriesFor: #x:!**compiled accessors**!public! !
!OS.POINTL categoriesFor: #x:y:!initializing!public! !
!OS.POINTL categoriesFor: #y!**compiled accessors**!public! !
!OS.POINTL categoriesFor: #y:!**compiled accessors**!public! !

!OS.POINTL class methodsFor!

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

x: x y: y
	"Answer a new instance of the receiver representing the Point whose 
	cartesian coordinates are the arguments.
	Implementation Note: For performance reasons avoid going through
	all the <ExternalStructure> framework methods."

	^self basicNew bytes: ((ByteArray newFixed: 8)
				sdwordAtOffset: _OffsetOf_x put: x;
				sdwordAtOffset: _OffsetOf_y put: y;
				yourself)! !
!OS.POINTL class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.POINTL class categoriesFor: #x:y:!instance creation!public! !

