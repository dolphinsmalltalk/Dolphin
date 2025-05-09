﻿"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.TRIVERTEX'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_alpha' -> 16rE.
			'_OffsetOf_blue' -> 16rC.
			'_OffsetOf_green' -> 16rA.
			'_OffsetOf_red' -> 16r8.
			'_OffsetOf_x' -> 16r0.
			'_OffsetOf_y' -> 16r4.
			'_TRIVERTEX_Size' -> 16r10
		}!

OS.TRIVERTEX guid: (Core.GUID fromString: '{c7529ab7-4488-494b-a3f0-8549402a5f57}')!

OS.TRIVERTEX comment: '<TRIVERTEX> is an <ExternalStructure> class to wrap the struct ''Win32.TRIVERTEX'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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

!OS.TRIVERTEX categoriesForClass!Win32-Structs! !

!OS.TRIVERTEX methodsFor!

alpha
	"Answer the <Integer> value of the receiver's 'alpha' field."

	^bytes uint16AtOffset: _OffsetOf_alpha!

alpha: anInteger
	"Set the receiver's 'alpha' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_alpha put: anInteger!

blue
	"Answer the <Integer> value of the receiver's 'blue' field."

	^bytes uint16AtOffset: _OffsetOf_blue!

blue: anInteger
	"Set the receiver's 'blue' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_blue put: anInteger!

color: aColor 
	self
		alpha: aColor alpha << 8;
		red: aColor red << 8;
		green: aColor green << 8;
		blue: aColor blue << 8!

green
	"Answer the <Integer> value of the receiver's 'green' field."

	^bytes uint16AtOffset: _OffsetOf_green!

green: anInteger
	"Set the receiver's 'green' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_green put: anInteger!

position: aPoint 
	self
		x: aPoint x;
		y: aPoint y!

red
	"Answer the <Integer> value of the receiver's 'red' field."

	^bytes uint16AtOffset: _OffsetOf_red!

red: anInteger
	"Set the receiver's 'red' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_red put: anInteger!

x
	"Answer the <Integer> value of the receiver's 'x' field."

	^bytes int32AtOffset: _OffsetOf_x!

x: anInteger
	"Set the receiver's 'x' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_x put: anInteger!

y
	"Answer the <Integer> value of the receiver's 'y' field."

	^bytes int32AtOffset: _OffsetOf_y!

y: anInteger
	"Set the receiver's 'y' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_y put: anInteger! !

!OS.TRIVERTEX categoriesForMethods!
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

!OS.TRIVERTEX class methodsFor!

byteSize
	^_TRIVERTEX_Size!

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
		defineField: #x type: Int32Field new;
		defineField: #y type: Int32Field new;
		defineField: #red type: UInt16Field new;
		defineField: #green type: UInt16Field new;
		defineField: #blue type: UInt16Field new;
		defineField: #alpha type: UInt16Field new!

getFieldNames
	^#(#x #y #red #green #blue #alpha)! !

!OS.TRIVERTEX class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

