"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #MSG
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_hwnd _OffsetOf_lParam _OffsetOf_message _OffsetOf_time _OffsetOf_wParam _OffsetOf_x _OffsetOf_y'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MSG guid: (GUID fromString: '{87b4c5ff-026e-11d3-9fd7-00a0cc3e4a32}')!

MSG addClassConstant: '_OffsetOf_hwnd' value: 16r0!
MSG addClassConstant: '_OffsetOf_lParam' value: 16rC!
MSG addClassConstant: '_OffsetOf_message' value: 16r4!
MSG addClassConstant: '_OffsetOf_time' value: 16r10!
MSG addClassConstant: '_OffsetOf_wParam' value: 16r8!
MSG addClassConstant: '_OffsetOf_x' value: 16r14!
MSG addClassConstant: '_OffsetOf_y' value: 16r18!

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

!MSG categoriesForMethods!
hwnd!**compiled accessors**!public! !
isInput!public!testing! !
isKeyboardInput!public!testing! !
isMouseInput!public!testing! !
lParam!**compiled accessors**!public! !
message!**compiled accessors**!public! !
swParam!accessing!public! !
time!**compiled accessors**!public! !
wParam!**compiled accessors**!public! !
x!**compiled accessors**!public! !
y!**compiled accessors**!public! !
!

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

!MSG class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

