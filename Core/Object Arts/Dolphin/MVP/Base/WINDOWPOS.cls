"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #WINDOWPOS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cx' -> 16r10.
		'_OffsetOf_cy' -> 16r14.
		'_OffsetOf_flags' -> 16r18.
		'_OffsetOf_hwnd' -> 16r0.
		'_OffsetOf_hwndInsertAfter' -> 16r4.
		'_OffsetOf_x' -> 16r8.
		'_OffsetOf_y' -> 16rC
	}!
WINDOWPOS guid: (GUID fromString: '{cd69a071-3606-11d3-93bd-00a024ca708a}')!
WINDOWPOS comment: ''!
!WINDOWPOS categoriesForClass!External-Data-Structured-Win32! !
!WINDOWPOS methodsFor!

cx
	"Answer the <Integer> value of the receiver's 'cx' field."

	^bytes sdwordAtOffset: _OffsetOf_cx!

cx: anInteger
	"Set the receiver's 'cx' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cx put: anInteger!

cy
	"Answer the <Integer> value of the receiver's 'cy' field."

	^bytes sdwordAtOffset: _OffsetOf_cy!

cy: anInteger
	"Set the receiver's 'cy' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cy put: anInteger!

extent
	^self cx @ self cy!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: _OffsetOf_flags!

hwndInsertAfter
	"Answer the <Integer> value of the receiver's 'hwndInsertAfter' field."

	^bytes dwordAtOffset: _OffsetOf_hwndInsertAfter!

isRectangleChanged
	^(self flags allMask: ##(SWP_NOMOVE | SWP_NOSIZE)) not!

position
	^self x @ self y!

rectangle
	^self position extent: self extent!

x
	"Answer the <Integer> value of the receiver's 'x' field."

	^bytes sdwordAtOffset: _OffsetOf_x!

y
	"Answer the <Integer> value of the receiver's 'y' field."

	^bytes sdwordAtOffset: _OffsetOf_y! !
!WINDOWPOS categoriesFor: #cx!**compiled accessors**!public! !
!WINDOWPOS categoriesFor: #cx:!**compiled accessors**!public! !
!WINDOWPOS categoriesFor: #cy!**compiled accessors**!public! !
!WINDOWPOS categoriesFor: #cy:!**compiled accessors**!public! !
!WINDOWPOS categoriesFor: #extent!accessing!public! !
!WINDOWPOS categoriesFor: #flags!**compiled accessors**!public! !
!WINDOWPOS categoriesFor: #hwndInsertAfter!**compiled accessors**!public! !
!WINDOWPOS categoriesFor: #isRectangleChanged!public!testing! !
!WINDOWPOS categoriesFor: #position!accessing!public! !
!WINDOWPOS categoriesFor: #rectangle!accessing!public! !
!WINDOWPOS categoriesFor: #x!**compiled accessors**!public! !
!WINDOWPOS categoriesFor: #y!**compiled accessors**!public! !

!WINDOWPOS class methodsFor!

defineFields
	"Define the layout of the Win32 WINDOWPOS structure.

		WINDOWPOS compileDefinition

		typedef struct _WINDOWPOS {
			HWND hwnd;
			HWND hwndInsertAfter;
			int x;
			int y;
			int cx;
			int cy;
			UINT flags; } WINDOWPOS; 
	"

	self
		defineField: #hwnd type: DWORDField filler;
		defineField: #hwndInsertAfter type: DWORDField readOnly;
		defineField: #x type: SDWORDField readOnly;
		defineField: #y type: SDWORDField readOnly;
		defineField: #cx type: SDWORDField new;
		defineField: #cy type: SDWORDField new;
		defineField: #flags type: DWORDField readOnly
!

getFieldNames
	^#(#hwndInsertAfter #x #y #cx #cy #flags)! !
!WINDOWPOS class categoriesFor: #defineFields!public!template definition! !
!WINDOWPOS class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

