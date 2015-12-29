"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #RECT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RECT guid: (GUID fromString: '{0A6E055D-001B-4817-B07D-FE982CA46330}')!
RECT comment: '<RECT> is an <ExternalStructure> class to wrap the standard Win32 structure of the same name.

The RECT structure is used in many places in the Windows API to represent a rectangle consisting of 32-bit co-ordinates for top-left and bottom-right corners. <RECTL> is an alias for the same class/structure. RECT supports conversions to and from the Smalltalk <Rectangle> class.'!
!RECT categoriesForClass!Win32-Structs! !
!RECT methodsFor!

area
	"Answer the area of the receiver; the product of width and height."

	^self width * self height!

asObject
	"Answer a suitable Smalltalk object to represent the receiver's value, in this case
	a <Rectangle>."

	^self asRectangle
!

asRectangle
	"Answer a new Rectangle that matches the receiver."

	^self topLeft corner: self bottomRight!

bottom
	"Answer the receiver's bottom field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #bottom)!

bottom: anObject 
	"Set the receiver's bottom field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #bottom) put: anObject!

bottomRight
	"Answer a Point representing the bottom right position of the receiver."

	^self right @ self bottom!

center
	"Answer a <Point> representing the position of the centre of the receiver."

	^self centerX @ self centerY!

centerX
	"Answer the x-coordinate of the point at the receiver's centre. Used in conjunction with
	#centerX:"

	^(self left + self right) // 2!

centerY
	"Answer the y-coordinate of the point at the receiver's centre. Used in conjunction with
	#centerY:"

	^(self top + self bottom) // 2!

extent
	"Answer a Point representing the extent of the receiver. The x coordinate 
	is the width and the y coordinate is the height."

	^self width @ self height!

extent: newExtent
	"Set the extent of the receiver to aPoint. (The origin remains the same and
	the corner stays in the same quadrant it was in relative to the origin point.
	If aPoint contains any negative value, the result is undefined)."

	self right: self left + newExtent x.
	self bottom: self top + newExtent y!

height
	"Answer the height of the receiver."

	^self bottom - self top!

left
	"Answer the receiver's left field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

left: anObject 
	"Set the receiver's left field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

origin
	"Answer the Point at the top left corner of the receiver"

	^self topLeft
!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	self isNull ifTrue: [^super printOn: aStream].
	aStream
		basicPrint: self;
		nextPut: $(;
		print: self topLeft;
		nextPutAll: ', ';
		print: self bottomRight;
		nextPut: $)!

right
	"Answer the receiver's right field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #right)!

right: anObject 
	"Set the receiver's right field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #right) put: anObject!

top
	"Answer the receiver's top field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #top)!

top: anObject 
	"Set the receiver's top field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #top) put: anObject!

topLeft
	"Answer a Point representing the top left position of the receiver."

	^self left @ self top!

width
	"Answer the width of the receiver."

	^self right - self left! !
!RECT categoriesFor: #area!accessing!public! !
!RECT categoriesFor: #asObject!converting!public! !
!RECT categoriesFor: #asRectangle!converting!public! !
!RECT categoriesFor: #bottom!**compiled accessors**!public! !
!RECT categoriesFor: #bottom:!**compiled accessors**!public! !
!RECT categoriesFor: #bottomRight!accessing!public! !
!RECT categoriesFor: #center!accessing!public! !
!RECT categoriesFor: #centerX!accessing!public! !
!RECT categoriesFor: #centerY!accessing!public! !
!RECT categoriesFor: #extent!accessing!public! !
!RECT categoriesFor: #extent:!accessing!public! !
!RECT categoriesFor: #height!accessing!public! !
!RECT categoriesFor: #left!**compiled accessors**!public! !
!RECT categoriesFor: #left:!**compiled accessors**!public! !
!RECT categoriesFor: #origin!accessing!public! !
!RECT categoriesFor: #printOn:!printing!public! !
!RECT categoriesFor: #right!**compiled accessors**!public! !
!RECT categoriesFor: #right:!**compiled accessors**!public! !
!RECT categoriesFor: #top!**compiled accessors**!public! !
!RECT categoriesFor: #top:!**compiled accessors**!public! !
!RECT categoriesFor: #topLeft!accessing!public! !
!RECT categoriesFor: #width!accessing!public! !

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

fromRectangle: aRectangle
	"Answer a new instance of the receiver instantiated from the Smalltalk
	Rectangle, aRectangle."

	^self 
		left: aRectangle left
		top: aRectangle top
		right: aRectangle right
		bottom: aRectangle bottom
!

icon
	"Answer a suitable iconic representation for the receiver."

	^Rectangle icon!

initialize
	"Private - Initialize the receiver.
	Many typelibs refer to RECTL, so it helps to alias that.
		self initialize
	"

	self environment at: #RECTL put: self!

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

left: left top: top width: width height: height
	"Answer a new instance of the receiver with the specified position
	and dimensions."

	^self 
		left: left
		top: top
		right: left+width
		bottom: top+height
!

origin: newOrigin extent: newExtent 
	"Answer a new instance of the receiver with the specified origin and extent"

	^self 
		left: newOrigin x
		top: newOrigin y
		right: newOrigin x + newExtent x
		bottom: newOrigin y + newExtent y!

uninitialize
	"Private - Unitialize the receiver as it is about to be removed from the system.
	Make sure our alias disappears with us."

	self environment removeKey: #RECTL ifAbsent: []! !
!RECT class categoriesFor: #defineFields!initializing!public! !
!RECT class categoriesFor: #fromRectangle:!instance creation!public! !
!RECT class categoriesFor: #icon!constants!public! !
!RECT class categoriesFor: #initialize!development!initializing!private! !
!RECT class categoriesFor: #left:top:right:bottom:!instance creation!public! !
!RECT class categoriesFor: #left:top:width:height:!instance creation!public! !
!RECT class categoriesFor: #origin:extent:!instance creation!public! !
!RECT class categoriesFor: #uninitialize!class hierarchy-removing!private! !

