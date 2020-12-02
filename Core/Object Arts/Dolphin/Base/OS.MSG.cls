"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #MSG
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_hwnd' -> 16r0.
		'_OffsetOf_lParam' -> 16rC.
		'_OffsetOf_message' -> 16r4.
		'_OffsetOf_time' -> 16r10.
		'_OffsetOf_wParam' -> 16r8.
		'_OffsetOf_x' -> 16r14.
		'_OffsetOf_y' -> 16r18
	}!
MSG guid: (GUID fromString: '{87b4c5ff-026e-11d3-9fd7-00a0cc3e4a32}')!
MSG comment: 'MSG is an <ExternalStructure> to wrap the Win32 structure of the same name.

MSG is an represents the state associated with a Windows message retrieved via GetMessage().'!
!MSG categoriesForClass!External-Data-Structured-Win32! !
!MSG methodsFor!

hwnd
	"Answer the <Integer> value of the receiver's 'hwnd' field."

	^bytes uintPtrAtOffset: _OffsetOf_hwnd!

isInput
	"Answer whether the receiver represents an input event."

	| msg |
	msg := self message.
	^(msg >= WM_KEYFIRST and: [ msg <= WM_KEYLAST ]) or: [
		msg >= WM_MOUSEFIRST and: [ msg <= WM_MOUSELAST ]]
!

isKeyboardInput
	"Answer whether the receiver represents a keyboard event (e.g. a WM_KEYDOWN)."

	| msg |
	msg := self message.
	^msg >= WM_KEYFIRST and: [msg <= WM_KEYLAST]!

isMouseInput
	"Answer whether the receiver represents a mouse event (e.g. a WM_MOUSEMOVE)."

	| msg |
	msg := self message.
	^msg >= WM_MOUSEFIRST and: [msg <= WM_MOUSELAST]!

lParam
	"Answer the <Integer> value of the receiver's 'lParam' field."

	^bytes uintPtrAtOffset: _OffsetOf_lParam!

message
	"Answer the <Integer> value of the receiver's 'message' field."

	^bytes dwordAtOffset: _OffsetOf_message!

swParam
	"Answer the <integer> value of the receiver's wParam field, treating
	it as a signed integer."

	^bytes intPtrAtOffset: 8!

time
	"Answer the <Integer> value of the receiver's 'time' field."

	^bytes dwordAtOffset: _OffsetOf_time!

wParam
	"Answer the <Integer> value of the receiver's 'wParam' field."

	^bytes uintPtrAtOffset: _OffsetOf_wParam!

x
	"Answer the <Integer> value of the receiver's 'x' field."

	^bytes sdwordAtOffset: _OffsetOf_x!

y
	"Answer the <Integer> value of the receiver's 'y' field."

	^bytes sdwordAtOffset: _OffsetOf_y! !
!MSG categoriesFor: #hwnd!**compiled accessors**!public! !
!MSG categoriesFor: #isInput!public!testing! !
!MSG categoriesFor: #isKeyboardInput!public!testing! !
!MSG categoriesFor: #isMouseInput!public!testing! !
!MSG categoriesFor: #lParam!**compiled accessors**!public! !
!MSG categoriesFor: #message!**compiled accessors**!public! !
!MSG categoriesFor: #swParam!accessing!public! !
!MSG categoriesFor: #time!**compiled accessors**!public! !
!MSG categoriesFor: #wParam!**compiled accessors**!public! !
!MSG categoriesFor: #x!**compiled accessors**!public! !
!MSG categoriesFor: #y!**compiled accessors**!public! !

!MSG class methodsFor!

defineFields
	"Define the fields of the Win32 MSG structure.

		MSG compileDefinition
	
		typedef 		struct tagMSG {
			HWND hwnd;
			UINT message;
			ULONG_PTR wParam;
			LONG_PTR lParam;
			ULONG time;
			POINT pt;
		} MSG;
	"

	self
		defineField: #hwnd type: UINT_PTRField readOnly;
		defineField: #message type: DWORDField readOnly;
		defineField: #wParam type: UINT_PTRField readOnly;
		defineField: #lParam type: UINT_PTRField readOnly;
		defineField: #time type: DWORDField readOnly;
		defineField: #x type: SDWORDField readOnly;
		defineField: #y type: SDWORDField readOnly
	"The real structure has a POINT here instead of x and y, but that is not part of the base Dolphin package any more so we 'inline' it"!

getFieldNames
	^#(#hwnd #message #wParam #lParam #time #x #y)! !
!MSG class categoriesFor: #defineFields!public!template definition! !
!MSG class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

