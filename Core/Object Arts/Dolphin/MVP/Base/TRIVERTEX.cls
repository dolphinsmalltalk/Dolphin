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
	"Answer the <Integer> value of the receiver's 'alpha' field."

	^bytes wordAtOffset: ##(self offsetOf: #alpha)!

alpha: anInteger
	"Set the receiver's 'alpha' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #alpha) put: anInteger!

blue
	"Answer the <Integer> value of the receiver's 'blue' field."

	^bytes wordAtOffset: ##(self offsetOf: #blue)!

blue: anInteger
	"Set the receiver's 'blue' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #blue) put: anInteger!

color: aColor 
	self
		alpha: aColor alpha << 8;
		red: aColor red << 8;
		green: aColor green << 8;
		blue: aColor blue << 8!

green
	"Answer the <Integer> value of the receiver's 'green' field."

	^bytes wordAtOffset: ##(self offsetOf: #green)!

green: anInteger
	"Set the receiver's 'green' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #green) put: anInteger!

position: aPoint 
	self
		x: aPoint x;
		y: aPoint y!

red
	"Answer the <Integer> value of the receiver's 'red' field."

	^bytes wordAtOffset: ##(self offsetOf: #red)!

red: anInteger
	"Set the receiver's 'red' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #red) put: anInteger!

x
	"Answer the <Integer> value of the receiver's 'x' field."

	^bytes sdwordAtOffset: 0!

x: anInteger
	"Set the receiver's 'x' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: 0 put: anInteger!

y
	"Answer the <Integer> value of the receiver's 'y' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #y)!

y: anInteger
	"Set the receiver's 'y' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #y) put: anInteger! !
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
		defineField: #alpha type: WORDField new!

getFieldNames
	^#(#x #y #red #green #blue #alpha)! !
!TRIVERTEX class categoriesFor: #defineFields!initializing!public! !
!TRIVERTEX class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

