"Filed out from Dolphin Smalltalk"!

ExternalPoint subclass: #POINTL
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_x _OffsetOf_y'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

POINTL guid: (GUID fromString: '{dbeaf6a6-d2f7-4153-a02e-a389955a892f}')!

POINTL addClassConstant: '_OffsetOf_x' value: 16r0!
POINTL addClassConstant: '_OffsetOf_y' value: 16r4!

POINTL comment: '`POINTL` is an `ExternalStructure` class to wrap the Win32 POINTL structure. Instances of `POINTL` represent a cartesian coordinate with 32-bit signed integer x and y values.
'!

!POINTL categoriesForClass!Win32-Structs! !

!POINTL methodsFor!

asDword
	"Answer the receiver in a form suitable for passing or returning as a 32-bit value (i.e. a 32-bit integer)."

	^((bytes sdwordAtOffset: _OffsetOf_x) bitAnd: 16rFFFF)
		bitOr: (((bytes sdwordAtOffset: _OffsetOf_y) bitAnd: 16rFFFF) bitShift: 16)!

asPoint
	"Answer a <Point> that matches the receiver."

	^Point x: (bytes sdwordAtOffset: _OffsetOf_x) y: (bytes sdwordAtOffset: _OffsetOf_y)!

asUIntPtr
	"Answer the receiver in a form suitable for passing or returning 
	as a  machine-word sized (32 or 64-bit) value."

	"Implementation Note: The compiler will optimise out the condition because it is constant."

	^VMConstants.IsWin64
		ifTrue: [bytes uintPtrAtOffset: 0]
		ifFalse: 
			[((bytes sdwordAtOffset: _OffsetOf_x) bitAnd: VMConstants.HalfPtrMask)
				bitOr: (((bytes sdwordAtOffset: _OffsetOf_y) bitAnd: VMConstants.HalfPtrMask)
						bitShift: VMConstants.HalfPtrBits)]!

isZero
	"Answer whether the receiver is equal to Point zero."

	^(bytes sqwordAtOffset: 0) == 0!

x
	"Answer the <Integer> value of the receiver's 'x' field."

	^bytes sdwordAtOffset: _OffsetOf_x!

x: anInteger
	"Set the receiver's 'x' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_x put: anInteger!

x: xNumber y: yNumber
	bytes
		sdwordAtOffset: _OffsetOf_x put: xNumber asInteger;
		sdwordAtOffset: _OffsetOf_y put: yNumber asInteger.
	^self!

y
	"Answer the <Integer> value of the receiver's 'y' field."

	^bytes sdwordAtOffset: _OffsetOf_y!

y: anInteger
	"Set the receiver's 'y' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_y put: anInteger! !

!POINTL categoriesForMethods!
asDword!converting!public! !
asPoint!converting!public! !
asUIntPtr!converting!public! !
isZero!public! !
x!**compiled accessors**!public! !
x:!**compiled accessors**!public! !
x:y:!initializing!public! !
y!**compiled accessors**!public! !
y:!**compiled accessors**!public! !
!

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
				sdwordAtOffset: _OffsetOf_x put: x asInteger;
				sdwordAtOffset: _OffsetOf_y put: y asInteger;
				yourself)
! !

!POINTL class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
uninitialize!class hierarchy-removing!private! !
x:y:!instance creation!public! !
!

