"Filed out from Dolphin Smalltalk"!

External.POINT
	subclass: #'OS.POINTL'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_OffsetOf_x' -> 16r0. '_OffsetOf_y' -> 16r4. '_POINTL_Size' -> 16r8 }!
OS.POINTL guid: (Core.GUID fromString: '{dbeaf6a6-d2f7-4153-a02e-a389955a892f}')!
OS.POINTL comment: '`POINTL` is an `External.Structure` class to wrap the Win32 POINTL structure. Instances of `POINTL` represent a cartesian coordinate with 32-bit signed integer x and y values.
'!
!OS.POINTL categoriesForClass!Win32-Structs! !
!OS.POINTL methodsFor!

asUIntPtr
	"Answer the receiver in a form suitable for passing or returning 
	as a  machine-word sized (32 or 64-bit) value."

	"Implementation Note: The compiler will optimise out the condition because it is constant."

	^VMConstants.IsWin64 ifTrue: [bytes uintPtrAtOffset: 0] ifFalse: [self asPoint asUIntPtr]!

isZero
	"Answer whether the receiver is equal to Point zero."

	^(bytes uint64AtOffset: 0) == 0!

x
	"Answer the <Integer> value of the receiver's 'x' field."

	^bytes int32AtOffset: _OffsetOf_x!

x: anInteger
	"Set the receiver's 'x' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_x put: anInteger!

x: xInteger y: yInteger

	bytes
		int32AtOffset: _OffsetOf_x put: xInteger;
		int32AtOffset: _OffsetOf_y put: yInteger!

y
	"Answer the <Integer> value of the receiver's 'y' field."

	^bytes int32AtOffset: _OffsetOf_y!

y: anInteger
	"Set the receiver's 'y' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_y put: anInteger! !
!OS.POINTL categoriesForMethods!
asUIntPtr!converting!public! !
isZero!public!testing! !
x!**compiled accessors**!public! !
x:!**compiled accessors**!public! !
x:y:!initializing!public! !
y!**compiled accessors**!public! !
y:!**compiled accessors**!public! !
!

!OS.POINTL class methodsFor!

byteSize
	^_POINTL_Size!

defineFields
	"Define the fields of the POINTL structure.
		POINTL compileDefinition
	
		typedef 		struct tagPOINTL {
			long x;
			long y;
		} POINTL;
"

	self
		defineField: #x type: Int32Field new;
		defineField: #y type: Int32Field new!

x: x y: y
	"Answer a new instance of the receiver representing the Point whose 
	cartesian coordinates are the arguments.
	Implementation Note: For performance reasons avoid going through
	all the <ExternalStructure> framework methods."

	^self basicNew bytes: ((ByteArray newFixed: _POINTL_Size)
				int32AtOffset: _OffsetOf_x put: x;
				int32AtOffset: _OffsetOf_y put: y;
				yourself)! !
!OS.POINTL class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
x:y:!instance creation!public! !
!

