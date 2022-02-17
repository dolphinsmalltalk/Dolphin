"Filed out from Dolphin Smallalk"!

ExternalStructure subclass: #COREWEBVIEW2_COLOR
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_A _OffsetOf_B _OffsetOf_G _OffsetOf_R'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
COREWEBVIEW2_COLOR guid: (GUID fromString: '{539947e6-379f-4266-8787-6a5588b61bd1}')!
COREWEBVIEW2_COLOR addClassConstant: '_OffsetOf_A' value: 16r0!
COREWEBVIEW2_COLOR addClassConstant: '_OffsetOf_B' value: 16r3!
COREWEBVIEW2_COLOR addClassConstant: '_OffsetOf_G' value: 16r2!
COREWEBVIEW2_COLOR addClassConstant: '_OffsetOf_R' value: 16r1!
COREWEBVIEW2_COLOR comment: '`COREWEBVIEW2_COLOR` is an `ExternalStructure` class to wrap the struct ''WebView2.COREWEBVIEW2_COLOR'' from type information in the '''' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagCOREWEBVIEW2_COLOR {
	BYTE A;
	BYTE R;
	BYTE G;
	BYTE B;
} COREWEBVIEW2_COLOR;
```
'!
!COREWEBVIEW2_COLOR categoriesForClass!WebView2-Structs! !
!COREWEBVIEW2_COLOR methodsFor!

A
	"Answer the <Integer> value of the receiver's 'A' field."

	^bytes byteAtOffset: _OffsetOf_A!

A: anInteger
	"Set the receiver's 'A' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_A put: anInteger!

B
	"Answer the <Integer> value of the receiver's 'B' field."

	^bytes byteAtOffset: _OffsetOf_B!

B: anInteger
	"Set the receiver's 'B' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_B put: anInteger!

G
	"Answer the <Integer> value of the receiver's 'G' field."

	^bytes byteAtOffset: _OffsetOf_G!

G: anInteger
	"Set the receiver's 'G' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_G put: anInteger!

R
	"Answer the <Integer> value of the receiver's 'R' field."

	^bytes byteAtOffset: _OffsetOf_R!

R: anInteger
	"Set the receiver's 'R' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_R put: anInteger! !
!COREWEBVIEW2_COLOR categoriesForMethods!
A!**compiled accessors**!public! !
A:!**compiled accessors**!public! !
B!**compiled accessors**!public! !
B:!**compiled accessors**!public! !
G!**compiled accessors**!public! !
G:!**compiled accessors**!public! !
R!**compiled accessors**!public! !
R:!**compiled accessors**!public! !
!

!COREWEBVIEW2_COLOR class methodsFor!

defineFields
	"Define the fields of the COREWEBVIEW2_COLOR structure.

	COREWEBVIEW2_COLOR compileDefinition

		typedef 
		struct tagCOREWEBVIEW2_COLOR {
			BYTE A;
			BYTE R;
			BYTE G;
			BYTE B;
		} COREWEBVIEW2_COLOR;
"

	self
		defineField: #A type: BYTEField new offset: 0;
		defineField: #R type: BYTEField new offset: 1;
		defineField: #G type: BYTEField new offset: 2;
		defineField: #B type: BYTEField new offset: 3.
	self byteSize: 4!

getFieldNames
	^#(#A #R #G #B)! !
!COREWEBVIEW2_COLOR class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

