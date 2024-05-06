"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #TRIVERTEX
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_alpha _OffsetOf_blue _OffsetOf_green _OffsetOf_red _OffsetOf_x _OffsetOf_y'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

TRIVERTEX guid: (GUID fromString: '{c7529ab7-4488-494b-a3f0-8549402a5f57}')!

TRIVERTEX addClassConstant: '_OffsetOf_alpha' value: 16rE!
TRIVERTEX addClassConstant: '_OffsetOf_blue' value: 16rC!
TRIVERTEX addClassConstant: '_OffsetOf_green' value: 16rA!
TRIVERTEX addClassConstant: '_OffsetOf_red' value: 16r8!
TRIVERTEX addClassConstant: '_OffsetOf_x' value: 16r0!
TRIVERTEX addClassConstant: '_OffsetOf_y' value: 16r4!

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

	^bytes wordAtOffset: _OffsetOf_alpha!

alpha: anInteger
	"Set the receiver's 'alpha' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_alpha put: anInteger!

blue
	"Answer the <Integer> value of the receiver's 'blue' field."

	^bytes wordAtOffset: _OffsetOf_blue!

blue: anInteger
	"Set the receiver's 'blue' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_blue put: anInteger!

color: aColor 
	self
		alpha: aColor alpha << 8;
		red: aColor red << 8;
		green: aColor green << 8;
		blue: aColor blue << 8!

green
	"Answer the <Integer> value of the receiver's 'green' field."

	^bytes wordAtOffset: _OffsetOf_green!

green: anInteger
	"Set the receiver's 'green' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_green put: anInteger!

position: aPoint 
	self
		x: aPoint x;
		y: aPoint y!

red
	"Answer the <Integer> value of the receiver's 'red' field."

	^bytes wordAtOffset: _OffsetOf_red!

red: anInteger
	"Set the receiver's 'red' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_red put: anInteger!

x
	"Answer the <Integer> value of the receiver's 'x' field."

	^bytes sdwordAtOffset: _OffsetOf_x!

x: anInteger
	"Set the receiver's 'x' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_x put: anInteger!

y
	"Answer the <Integer> value of the receiver's 'y' field."

	^bytes sdwordAtOffset: _OffsetOf_y!

y: anInteger
	"Set the receiver's 'y' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_y put: anInteger! !

!TRIVERTEX categoriesForMethods!
alpha!**compiled accessors**!public! !
alpha:!**compiled accessors**!public! !
blue!**compiled accessors**!public! !
blue:!**compiled accessors**!public! !
color:!accessing!public! !
green!**compiled accessors**!public! !
green:!**compiled accessors**!public! !
position:!accessing!public! !
red!**compiled accessors**!public! !
red:!**compiled accessors**!public! !
x!**compiled accessors**!public! !
x:!**compiled accessors**!public! !
y!**compiled accessors**!public! !
y:!**compiled accessors**!public! !
!

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

!TRIVERTEX class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

