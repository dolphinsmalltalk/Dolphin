"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #POINTL
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
POINTL guid: (GUID fromString: '{dbeaf6a6-d2f7-4153-a02e-a389955a892f}')!
POINTL comment: '<POINTL> is an <ExternalStructure> class to wrap the struct ''Win.POINTL'' from type information in the ''Windows API (ANSI)'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef struct tagPOINTL {
	long x;
	long y;
} POINTL;
'!
!POINTL categoriesForClass!Win32-Structs! !
!POINTL methodsFor!

asDword
	"Answer the receiver in a form suitable for passing or returning 
	as a 32-bit value (i.e. a 32-bit integer)."

	^(DWORD fromPoint: self) value!

asObject
	"Answer a suitable Smalltalk object to represent the receiver's value, in this case
	a <Point>."

	^self asPoint!

asPoint
	"Answer a Point created that matches the receiver"

	^self x @ self y!

asUIntPtr
	"Answer the receiver in a form suitable for passing or returning 
	as a  machine-word sized (32 or 64-bit) value."

	"Implementation Note: The compiler will optimise out the condition because it is constant."

	^VMConstants.IsWin64 ifTrue: [bytes uintPtrAtOffset: 0] ifFalse: [self asPoint asUIntPtr]!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(; print: self asPoint; nextPut: $)!

value
	"Answer the receiver's value field as an equivalent Smalltalk object."

	^self asPoint!

value: anObject 
	"Set the value buffered by the receiver to anObject."

	self
		x: anObject x;
		y: anObject y!

x
	"Answer the receiver's x field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

x: anObject 
	"Set the receiver's x field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

y
	"Answer the receiver's y field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #y)!

y: anObject 
	"Set the receiver's y field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #y) put: anObject! !
!POINTL categoriesFor: #asDword!converting!public! !
!POINTL categoriesFor: #asObject!converting!public! !
!POINTL categoriesFor: #asPoint!converting!public! !
!POINTL categoriesFor: #asUIntPtr!converting!public! !
!POINTL categoriesFor: #printOn:!printing!public! !
!POINTL categoriesFor: #value!accessing!public! !
!POINTL categoriesFor: #value:!accessing!public! !
!POINTL categoriesFor: #x!**compiled accessors**!public! !
!POINTL categoriesFor: #x:!**compiled accessors**!public! !
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

fromPoint: aPoint
	"Answer a new instance of the receiver representing aPoint."
	
	^self x: aPoint x y: aPoint y!

icon
	"Answer a suitable iconic representation for the receiver."

	^Point icon!

x: x y: y
	"Answer a new instance of the receiver representing the Point whose 
	cartesian coordinates are the arguments.
	Implementation Note: For performance reasons avoid going through
	all the <ExternalStructure> framework methods."

	^self basicNew 
		bytes: ((ByteArray newFixed: 8)
				sdwordAtOffset: 0 put: x;
				sdwordAtOffset: 4 put: y;
				yourself)
! !
!POINTL class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!POINTL class categoriesFor: #fromPoint:!instance creation!public! !
!POINTL class categoriesFor: #icon!constants!development!public! !
!POINTL class categoriesFor: #x:y:!instance creation!public! !

