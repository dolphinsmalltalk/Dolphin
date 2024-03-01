"Filed out from Dolphin Smalltalk"!

ExternalRectangle subclass: #RECT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_bottom _OffsetOf_left _OffsetOf_right _OffsetOf_top'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RECT guid: (GUID fromString: '{0a6e055d-001b-4817-b07d-fe982ca46330}')!

RECT addClassConstant: '_OffsetOf_bottom' value: 16rC!
RECT addClassConstant: '_OffsetOf_left' value: 16r0!
RECT addClassConstant: '_OffsetOf_right' value: 16r8!
RECT addClassConstant: '_OffsetOf_top' value: 16r4!

RECT comment: '`RECT` is an `ExternalStructure` class to wrap the standard Win32 structure of the same name.

The `RECT` structure is used in many places in the Windows API to represent a rectangle consisting of 32-bit co-ordinates for top-left and bottom-right corners. `RECTL` is an alias for the same class/structure. `RECT` supports conversions to and from the Smalltalk `Rectangle` class.'!

!RECT categoriesForClass!Win32-Structs! !

!RECT methodsFor!

asRectangle
	"Answer a new Rectangle that matches the receiver."

	"Implementation Note: This is used so much during layout, that it is worth providing an inlined implementation as an optimization."

	^Rectangle
		origin: (Point x: (bytes sdwordAtOffset: _OffsetOf_left) y: (bytes sdwordAtOffset: _OffsetOf_top))
		corner: (Point x: (bytes sdwordAtOffset: _OffsetOf_right) y: (bytes sdwordAtOffset: _OffsetOf_bottom))!

bottom
	"Answer the <Integer> value of the receiver's 'bottom' field."

	^bytes sdwordAtOffset: _OffsetOf_bottom!

bottom: aNumber
	"Set the receiver's 'bottom' field to the integer value of the argument."

	bytes sdwordAtOffset: _OffsetOf_bottom put: aNumber asInteger!

bottomRight
	"Answer a <Point> representing the bottom right position of the receiver."

	^Point x: (bytes sdwordAtOffset: _OffsetOf_right) y: (bytes sdwordAtOffset: _OffsetOf_bottom)!

bottomRight: aPoint
	"Set the <Point> representing the bottom right corner of the receiver."

	bytes
		sdwordAtOffset: _OffsetOf_right put: aPoint x asInteger;
		sdwordAtOffset: _OffsetOf_bottom put: aPoint y asInteger!

extent
	"Answer a Point representing the extent of the receiver. The x coordinate is the width and the y coordinate is the height."

	"Override as an optimisation"

	^Point x: (bytes sdwordAtOffset: _OffsetOf_right) - (bytes sdwordAtOffset: _OffsetOf_left)
		y: (bytes sdwordAtOffset: _OffsetOf_bottom) - (bytes sdwordAtOffset: _OffsetOf_top)!

extent: aPoint
	"Set the extent of the receiver to the <Point> argument. The origin remains the same and the corner stays in the same quadrant it was in relative to the origin point. If aPoint contains any negative value, the result is undefined."

	bytes
		sdwordAtOffset: _OffsetOf_right put: ((bytes sdwordAtOffset: _OffsetOf_left) + aPoint x) asInteger;
		sdwordAtOffset: _OffsetOf_bottom put: ((bytes sdwordAtOffset: _OffsetOf_top) + aPoint y) asInteger!

height
	"Answer the height of the receiver."

	^(bytes sdwordAtOffset: _OffsetOf_bottom) - (bytes sdwordAtOffset: _OffsetOf_top)!

left
	"Answer the <Integer> value of the receiver's 'left' field."

	^bytes sdwordAtOffset: _OffsetOf_left!

left: aNumber
	"Set the receiver's 'left' field to the integer value of the argument."

	bytes sdwordAtOffset: _OffsetOf_left put: aNumber asInteger!

right
	"Answer the <Integer> value of the receiver's 'right' field."

	^bytes sdwordAtOffset: _OffsetOf_right!

right: aNumber
	"Set the receiver's 'right' field to the integer value of the argument."

	bytes sdwordAtOffset: _OffsetOf_right put: aNumber asInteger!

rightCenter
	"Answer a <Point> specifying the position of the centre of the receiver's right edge."

	^self right @ self centerY!

scaleBy: aMagnitude
	"Scale the receiver in-place by the specified <Point> or <Number> multiplier."

	self
		topLeft: self topLeft * aMagnitude;
		bottomRight: self bottomRight * aMagnitude!

top
	"Answer the <Integer> value of the receiver's 'top' field."

	^bytes sdwordAtOffset: _OffsetOf_top!

top: aNumber
	"Set the receiver's 'top' field to the integer value of the argument."

	bytes sdwordAtOffset: _OffsetOf_top put: aNumber asInteger!

topLeft
	"Answer a <Point> representing the top left position of the receiver."

	^Point x: (bytes sdwordAtOffset: _OffsetOf_left) y: (bytes sdwordAtOffset: _OffsetOf_top)!

topLeft: aPoint
	"Set the <Point> representing the top left position of the receiver."

	bytes
		sdwordAtOffset: _OffsetOf_left put: aPoint x asInteger;
		sdwordAtOffset: _OffsetOf_top put: aPoint y asInteger!

width
	"Answer the width of the receiver."

	^(bytes sdwordAtOffset: _OffsetOf_right) - (bytes sdwordAtOffset: _OffsetOf_left)! !

!RECT categoriesForMethods!
asRectangle!converting!public! !
bottom!**compiled accessors**!public! !
bottom:!**compiled accessors**!public! !
bottomRight!accessing!public! !
bottomRight:!accessing!public! !
extent!accessing!public! !
extent:!accessing!public! !
height!public! !
left!**compiled accessors**!public! !
left:!**compiled accessors**!public! !
right!**compiled accessors**!public! !
right:!**compiled accessors**!public! !
rightCenter!accessing!public! !
scaleBy:!public!transforming! !
top!**compiled accessors**!public! !
top:!**compiled accessors**!public! !
topLeft!accessing!public! !
topLeft:!accessing!public! !
width!accessing!public! !
!

!RECT class methodsFor!

defineFields
	"Define the fields of the RECT structure.
		RECT compileDefinition
	
		typedef 		struct tagRECT {
			long left;
			long top;
			long right;
			long bottom;
		} RECT;

	"

	self
		defineField: #left type: SDWORDField new;
		defineField: #top type: SDWORDField new;
		defineField: #right type: SDWORDField new;
		defineField: #bottom type: SDWORDField new!

extent: newExtent
	"Answer a new instance of the receiver with zero origin and the specified extent."

	^self basicNew bytes: ((ByteArray newFixed: 16)
				sdwordAtOffset: 8 put: newExtent x asInteger;
				sdwordAtOffset: 12 put: newExtent y asInteger;
				yourself)!

getFieldNames
	^#(#left #top #right #bottom)!

left: leftInteger top: topInteger right: rightInteger bottom: bottomInteger 
	"Answer a new instance of the receiver with the specified position
	corner positions."

	"Implementation Note: For performance reasons do this all with low-level
	inline code."

	^self basicNew bytes: ((ByteArray newFixed: 16)
				sdwordAtOffset: 0 put: leftInteger;
				sdwordAtOffset: 4 put: topInteger;
				sdwordAtOffset: 8 put: rightInteger;
				sdwordAtOffset: 12 put: bottomInteger;
				yourself)!

uninitialize
	"Private - Unitialize the receiver as it is about to be removed from the system.
	Make sure our alias disappears with us."

	self environment removeKey: #RECTL ifAbsent: []! !

!RECT class categoriesForMethods!
defineFields!public!template definition! !
extent:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
left:top:right:bottom:!instance creation!public! !
uninitialize!class hierarchy-removing!private! !
!

