"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #TRIVERTEX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TRIVERTEX guid: (GUID fromString: '{c7529ab7-4488-494b-a3f0-8549402a5f57}')!
TRIVERTEX comment: '<TRIVERTEX> is an <ExternalStructure> class to wrap the struct ''Win32.TRIVERTEX'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains the following helpstring for this struct
	"Contains color and position information"

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(C7529AB7-4488-494B-A3F0-8549402A5F57), helpstring("Contains color and position information")]
struct tagTRIVERTEX {
	long x;
	long y;
	COLOR16 Red;
	COLOR16 Green;
	COLOR16 Blue;
	COLOR16 Alpha;
} TRIVERTEX;
'!
!TRIVERTEX categoriesForClass!Win32-Structs! !
!TRIVERTEX methodsFor!

alpha
	"Answer the receiver's alpha field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #alpha)!

alpha: anObject 
	"Set the receiver's alpha field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #alpha) put: anObject!

blue
	"Answer the receiver's blue field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #blue)!

blue: anObject 
	"Set the receiver's blue field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #blue) put: anObject!

color: aColor 
	self
		alpha: aColor alpha << 8;
		red: aColor red << 8;
		green: aColor green << 8;
		blue: aColor blue << 8!

green
	"Answer the receiver's green field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #green)!

green: anObject 
	"Set the receiver's green field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #green) put: anObject!

position: aPoint 
	self
		x: aPoint x;
		y: aPoint y!

red
	"Answer the receiver's red field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #red)!

red: anObject 
	"Set the receiver's red field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #red) put: anObject!

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
!TRIVERTEX categoriesFor: #alpha!**compiled accessors**!public! !
!TRIVERTEX categoriesFor: #alpha:!**compiled accessors**!public! !
!TRIVERTEX categoriesFor: #blue!**compiled accessors**!public! !
!TRIVERTEX categoriesFor: #blue:!**compiled accessors**!public! !
!TRIVERTEX categoriesFor: #color:!accessing!public! !
!TRIVERTEX categoriesFor: #green!**compiled accessors**!public! !
!TRIVERTEX categoriesFor: #green:!**compiled accessors**!public! !
!TRIVERTEX categoriesFor: #position:!accessing!public! !
!TRIVERTEX categoriesFor: #red!**compiled accessors**!public! !
!TRIVERTEX categoriesFor: #red:!**compiled accessors**!public! !
!TRIVERTEX categoriesFor: #x!**compiled accessors**!public! !
!TRIVERTEX categoriesFor: #x:!**compiled accessors**!public! !
!TRIVERTEX categoriesFor: #y!**compiled accessors**!public! !
!TRIVERTEX categoriesFor: #y:!**compiled accessors**!public! !

!TRIVERTEX class methodsFor!

defineFields
	"Define the fields of the TRIVERTEX structure.

	TRIVERTEX  compileDefinition

		typedef [uuid(C7529AB7-4488-494B-A3F0-8549402A5F57), helpstring('Contains color and position information')]
		struct tagTRIVERTEX {
			long x;
			long y;
			COLOR16 Red;
			COLOR16 Green;
			COLOR16 Blue;
			COLOR16 Alpha;
		} TRIVERTEX;
"

	self
		defineField: #x type: SDWORDField new;
		defineField: #y type: SDWORDField new;
		defineField: #red type: WORDField new;
		defineField: #green type: WORDField new;
		defineField: #blue type: WORDField new;
		defineField: #alpha type: WORDField new! !
!TRIVERTEX class categoriesFor: #defineFields!initializing!public! !

