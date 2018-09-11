"Filed out from Dolphin Smalltalk 7"!

ExternalRectangle subclass: #RECT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RECT guid: (GUID fromString: '{0a6e055d-001b-4817-b07d-fe982ca46330}')!
RECT comment: '`RECT` is an `ExternalStructure` class to wrap the standard Win32 structure of the same name.

The `RECT` structure is used in many places in the Windows API to represent a rectangle consisting of 32-bit co-ordinates for top-left and bottom-right corners. `RECTL` is an alias for the same class/structure. `RECT` supports conversions to and from the Smalltalk `Rectangle` class.'!
!RECT categoriesForClass!Win32-Structs! !
!RECT methodsFor!

bottom
	"Answer the receiver's bottom field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #bottom)!

bottom: anObject 
	"Set the receiver's bottom field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #bottom) put: anObject!

left
	"Answer the receiver's left field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

left: anObject 
	"Set the receiver's left field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

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

	bytes sdwordAtOffset: ##(self offsetOf: #top) put: anObject! !
!RECT categoriesFor: #bottom!**compiled accessors**!public! !
!RECT categoriesFor: #bottom:!**compiled accessors**!public! !
!RECT categoriesFor: #left!**compiled accessors**!public! !
!RECT categoriesFor: #left:!**compiled accessors**!public! !
!RECT categoriesFor: #right!**compiled accessors**!public! !
!RECT categoriesFor: #right:!**compiled accessors**!public! !
!RECT categoriesFor: #top!**compiled accessors**!public! !
!RECT categoriesFor: #top:!**compiled accessors**!public! !

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
				sdwordAtOffset: 8 put: newExtent x;
				sdwordAtOffset: 12 put: newExtent y;
				yourself)!

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
!RECT class categoriesFor: #defineFields!initializing!public! !
!RECT class categoriesFor: #extent:!instance creation!public! !
!RECT class categoriesFor: #left:top:right:bottom:!instance creation!public! !
!RECT class categoriesFor: #uninitialize!class hierarchy-removing!private! !

