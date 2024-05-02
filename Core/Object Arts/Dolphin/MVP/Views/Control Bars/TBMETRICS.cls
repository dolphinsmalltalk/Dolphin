"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #TBMETRICS
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cxBarPad _OffsetOf_cxButtonSpacing _OffsetOf_cxPad _OffsetOf_cyBarPad _OffsetOf_cyButtonSpacing _OffsetOf_cyPad _OffsetOf_dwMask _OffsetOf_dwSize'
	poolDictionaries: 'ToolbarConstants'
	classInstanceVariableNames: ''!

TBMETRICS guid: (GUID fromString: '{b296885b-f712-4cd1-8e2d-ed9f6e347004}')!

TBMETRICS addClassConstant: '_OffsetOf_cxBarPad' value: 16r10!
TBMETRICS addClassConstant: '_OffsetOf_cxButtonSpacing' value: 16r18!
TBMETRICS addClassConstant: '_OffsetOf_cxPad' value: 16r8!
TBMETRICS addClassConstant: '_OffsetOf_cyBarPad' value: 16r14!
TBMETRICS addClassConstant: '_OffsetOf_cyButtonSpacing' value: 16r1C!
TBMETRICS addClassConstant: '_OffsetOf_cyPad' value: 16rC!
TBMETRICS addClassConstant: '_OffsetOf_dwMask' value: 16r4!
TBMETRICS addClassConstant: '_OffsetOf_dwSize' value: 16r0!

TBMETRICS comment: '`TBMETRICS` is an `ExternalStructure` class to wrap the struct ''Win32.TBMETRICS'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(b296885b-f712-4cd1-8e2d-ed9f6e347004)]
struct tagTBMETRICS {
	unsigned int cbSize;
	DWORD dwMask;
	int cxPad;
	int cyPad;
	int cxBarPad;
	int cyBarPad;
	int cxButtonSpacing;
	int cyButtonSpacing;
} TBMETRICS;
```
'!

!TBMETRICS categoriesForClass!Win32-Structs! !

!TBMETRICS methodsFor!

buttonSpacing
	^self cxButtonSpacing @ self cyButtonSpacing!

buttonSpacing: aPoint
	self
		cxButtonSpacing: aPoint x;
		cyButtonSpacing: aPoint y;
		dwMask: (self dwMask bitOr: TBMF_BUTTONSPACING)!

cxButtonSpacing
	"Answer the <Integer> value of the receiver's 'cxButtonSpacing' field."

	^bytes sdwordAtOffset: _OffsetOf_cxButtonSpacing!

cxButtonSpacing: anInteger
	"Set the receiver's 'cxButtonSpacing' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cxButtonSpacing put: anInteger!

cxPad
	"Answer the <Integer> value of the receiver's 'cxPad' field."

	^bytes sdwordAtOffset: _OffsetOf_cxPad!

cxPad: anInteger
	"Set the receiver's 'cxPad' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cxPad put: anInteger!

cyButtonSpacing
	"Answer the <Integer> value of the receiver's 'cyButtonSpacing' field."

	^bytes sdwordAtOffset: _OffsetOf_cyButtonSpacing!

cyButtonSpacing: anInteger
	"Set the receiver's 'cyButtonSpacing' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cyButtonSpacing put: anInteger!

cyPad
	"Answer the <Integer> value of the receiver's 'cyPad' field."

	^bytes sdwordAtOffset: _OffsetOf_cyPad!

cyPad: anInteger
	"Set the receiver's 'cyPad' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cyPad put: anInteger!

dwMask
	"Answer the <Integer> value of the receiver's 'dwMask' field."

	^bytes dwordAtOffset: _OffsetOf_dwMask!

dwMask: anInteger
	"Set the receiver's 'dwMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwMask put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

padding: aPoint
	self
		cxPad: aPoint x;
		cyPad: aPoint y;
		dwMask: (self dwMask bitOr: TBMF_PAD)! !

!TBMETRICS categoriesForMethods!
buttonSpacing!accessing!public! !
buttonSpacing:!accessing!public! !
cxButtonSpacing!**compiled accessors**!public! !
cxButtonSpacing:!**compiled accessors**!public! !
cxPad!**compiled accessors**!public! !
cxPad:!**compiled accessors**!public! !
cyButtonSpacing!**compiled accessors**!public! !
cyButtonSpacing:!**compiled accessors**!public! !
cyPad!**compiled accessors**!public! !
cyPad:!**compiled accessors**!public! !
dwMask!**compiled accessors**!public! !
dwMask:!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
padding:!accessing!public! !
!

!TBMETRICS class methodsFor!

defineFields
	"Define the fields of the TBMETRICS structure.

	TBMETRICS compileDefinition

		typedef [uuid(b296885b-f712-4cd1-8e2d-ed9f6e347004)]
		struct tagTBMETRICS {
			unsigned int cbSize;
			DWORD dwMask;
			int cxPad;
			int cyPad;
			int cxBarPad;
			int cyBarPad;
			int cxButtonSpacing;
			int cyButtonSpacing;
		} TBMETRICS;
"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride offset: 0;
		defineField: #dwMask type: DWORDField new offset: 4;
		defineField: #cxPad type: SDWORDField new offset: 8;
		defineField: #cyPad type: SDWORDField new offset: 12;
		defineField: #cxBarPad type: SDWORDField uncompiled offset: 16;
		defineField: #cyBarPad type: SDWORDField uncompiled offset: 20;
		defineField: #cxButtonSpacing type: SDWORDField new offset: 24;
		defineField: #cyButtonSpacing type: SDWORDField new offset: 28.
	self byteSize: 32!

getFieldNames
	^#(#dwSize #dwMask #cxPad #cyPad #cxBarPad #cyBarPad #cxButtonSpacing #cyButtonSpacing)! !

!TBMETRICS class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

