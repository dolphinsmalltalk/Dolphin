"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #WINDOWPOS
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cx _OffsetOf_cy _OffsetOf_flags _OffsetOf_hwnd _OffsetOf_hwndInsertAfter _OffsetOf_x _OffsetOf_y'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WINDOWPOS guid: (GUID fromString: '{cd69a071-3606-11d3-93bd-00a024ca708a}')!
WINDOWPOS addClassConstant: '_OffsetOf_cx' value: 16r10!
WINDOWPOS addClassConstant: '_OffsetOf_cy' value: 16r14!
WINDOWPOS addClassConstant: '_OffsetOf_flags' value: 16r18!
WINDOWPOS addClassConstant: '_OffsetOf_hwnd' value: 16r0!
WINDOWPOS addClassConstant: '_OffsetOf_hwndInsertAfter' value: 16r4!
WINDOWPOS addClassConstant: '_OffsetOf_x' value: 16r8!
WINDOWPOS addClassConstant: '_OffsetOf_y' value: 16rC!
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
!WINDOWPOS categoriesForMethods!
cx!**compiled accessors**!public! !
cx:!**compiled accessors**!public! !
cy!**compiled accessors**!public! !
cy:!**compiled accessors**!public! !
extent!accessing!public! !
flags!**compiled accessors**!public! !
hwndInsertAfter!**compiled accessors**!public! !
isRectangleChanged!public!testing! !
position!accessing!public! !
rectangle!accessing!public! !
x!**compiled accessors**!public! !
y!**compiled accessors**!public! !
!

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
!WINDOWPOS class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

