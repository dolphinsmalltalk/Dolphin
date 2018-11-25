"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #MSG
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MSG guid: (GUID fromString: '{87b4c5ff-026e-11d3-9fd7-00a0cc3e4a32}')!
MSG comment: 'MSG is an <ExternalStructure> to wrap the Win32 structure of the same name.

MSG is an represents the state associated with a Windows message retrieved via GetMessage().'!
!MSG categoriesForClass!External-Data-Structured-Win32! !
!MSG methodsFor!

hwnd
	"Answer the <Integer> value of the receiver's 'hwnd' field."

	^bytes uintPtrAtOffset: 0!

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

	^bytes uintPtrAtOffset: ##(self offsetOf: #lParam)!

message
	"Answer the <Integer> value of the receiver's 'message' field."

	^bytes dwordAtOffset: ##(self offsetOf: #message)!

swParam
	"Answer the <integer> value of the receiver's wParam field, treating
	it as a signed integer."

	^bytes intPtrAtOffset: 8!

wParam
	"Answer the <Integer> value of the receiver's 'wParam' field."

	^bytes uintPtrAtOffset: ##(self offsetOf: #wParam)! !
!MSG categoriesFor: #hwnd!**compiled accessors**!public! !
!MSG categoriesFor: #isInput!public!testing! !
!MSG categoriesFor: #isKeyboardInput!public!testing! !
!MSG categoriesFor: #isMouseInput!public!testing! !
!MSG categoriesFor: #lParam!**compiled accessors**!public! !
!MSG categoriesFor: #message!**compiled accessors**!public! !
!MSG categoriesFor: #swParam!accessing!public! !
!MSG categoriesFor: #wParam!**compiled accessors**!public! !

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
		beUncompiled;
		defineField: #time type: DWORDField readOnly;
		defineField: #x type: SDWORDField readOnly;
		defineField: #y type: SDWORDField readOnly
	"The real structure has a POINT here, but that is not part of the base Dolphin package any more so we 'inline' it"!

getFieldList
	^#(#hwnd #message #wParam #lParam #time #x #y)! !
!MSG class categoriesFor: #defineFields!initializing!public! !
!MSG class categoriesFor: #getFieldList!**compiled accessors**!constants!private! !

