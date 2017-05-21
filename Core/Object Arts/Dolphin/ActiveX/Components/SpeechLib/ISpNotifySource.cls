"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #ISpNotifySource
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpNotifySource guid: (IID fromString: '{5EFF4AEF-8487-11D2-961C-00C04F8EE628}')!
ISpNotifySource comment: '<ISpNotifySource> is a wrapper class for the COM interface ''SpeechLib.ISpNotifySource'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpNotifySource Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(5EFF4AEF-8487-11D2-961C-00C04F8EE628), 
	helpstring("ISpNotifySource Interface"), 
	restricted
]
interface ISpNotifySource : IUnknown {
	[id(0x60010000)]
	HRESULT __stdcall SetNotifySink(
		[in] ISpNotifySink* pNotifySink);
	[id(0x60010001)]
	HRESULT __stdcall SetNotifyWindowMessage(
		[in] wireHWND hWnd,
		[in] unsigned int Msg,
		[in] UINT_PTR wParam,
		[in] LONG_PTR lParam);
	[id(0x60010002)]
	HRESULT __stdcall SetNotifyCallbackFunction(
		[in] void** pfnCallback,
		[in] UINT_PTR wParam,
		[in] LONG_PTR lParam);
	[id(0x60010003)]
	HRESULT __stdcall SetNotifyCallbackInterface(
		[in] void** pSpCallback,
		[in] UINT_PTR wParam,
		[in] LONG_PTR lParam);
	[id(0x60010004)]
	HRESULT __stdcall SetNotifyWin32Event();
	[id(0x60010005)]
	HRESULT __stdcall WaitForNotifyEvent(
		[in] unsigned long dwMilliseconds);
	[id(0x60010006)]
	void* __stdcall GetNotifyEventHandle();
};
'!
!ISpNotifySource categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpNotifySource methodsFor!

getNotifyEventHandle
	"Answer the <VOID> result of invoking the GetNotifyEventHandle() method of the COM object."

	^self GetNotifyEventHandle
!

GetNotifyEventHandle
	"Private - Invoke the GetNotifyEventHandle() method of the COM object.

		void* __stdcall GetNotifyEventHandle();"

	<virtual stdcall: void* 10>
	^self invalidCall
!

setNotifyCallbackFunction: pfnCallback wParam: wParam lParam: lParam
	"Invoke the SetNotifyCallbackFunction() method of the COM object."

	^self
		SetNotifyCallbackFunction: pfnCallback
		wParam: wParam
		lParam: lParam
!

SetNotifyCallbackFunction: pfnCallback wParam: wParam lParam: lParam
	"Private - Invoke the SetNotifyCallbackFunction() method of the COM object.

		HRESULT __stdcall SetNotifyCallbackFunction(
			[in] void** pfnCallback,
			[in] UINT_PTR wParam,
			[in] LONG_PTR lParam);"

	<virtual stdcall: hresult 6 void** dword sdword>
	^self invalidCall
!

setNotifyCallbackInterface: pSpCallback wParam: wParam lParam: lParam
	"Invoke the SetNotifyCallbackInterface() method of the COM object."

	^self
		SetNotifyCallbackInterface: pSpCallback
		wParam: wParam
		lParam: lParam
!

SetNotifyCallbackInterface: pSpCallback wParam: wParam lParam: lParam
	"Private - Invoke the SetNotifyCallbackInterface() method of the COM object.

		HRESULT __stdcall SetNotifyCallbackInterface(
			[in] void** pSpCallback,
			[in] UINT_PTR wParam,
			[in] LONG_PTR lParam);"

	<virtual stdcall: hresult 7 void** dword sdword>
	^self invalidCall
!

setNotifySink: pNotifySink
	"Invoke the SetNotifySink() method of the COM object."

	^self SetNotifySink: pNotifySink
!

SetNotifySink: pNotifySink
	"Private - Invoke the SetNotifySink() method of the COM object.

		HRESULT __stdcall SetNotifySink(
			[in] ISpNotifySink* pNotifySink);"

	<virtual stdcall: hresult 4 ISpNotifySink*>
	^self invalidCall
!

setNotifyWin32Event
	"Invoke the SetNotifyWin32Event() method of the COM object."

	^self SetNotifyWin32Event
!

SetNotifyWin32Event
	"Private - Invoke the SetNotifyWin32Event() method of the COM object.

		HRESULT __stdcall SetNotifyWin32Event();"

	<virtual stdcall: hresult 8>
	^self invalidCall
!

setNotifyWindowMessage: hWnd msg: msg wParam: wParam lParam: lParam
	"Invoke the SetNotifyWindowMessage() method of the COM object."

	^self
		SetNotifyWindowMessage: hWnd
		Msg: msg
		wParam: wParam
		lParam: lParam
!

SetNotifyWindowMessage: hWnd Msg: msg wParam: wParam lParam: lParam
	"Private - Invoke the SetNotifyWindowMessage() method of the COM object.

		HRESULT __stdcall SetNotifyWindowMessage(
			[in] wireHWND hWnd,
			[in] unsigned int Msg,
			[in] UINT_PTR wParam,
			[in] LONG_PTR lParam);"

	<virtual stdcall: hresult 5 handle* dword dword sdword>
	^self invalidCall
!

waitForNotifyEvent: dwMilliseconds
	"Invoke the WaitForNotifyEvent() method of the COM object."

	^self WaitForNotifyEvent: dwMilliseconds
!

WaitForNotifyEvent: dwMilliseconds
	"Private - Invoke the WaitForNotifyEvent() method of the COM object.

		HRESULT __stdcall WaitForNotifyEvent(
			[in] unsigned long dwMilliseconds);"

	<virtual stdcall: hresult 9 dword>
	^self invalidCall
! !
!ISpNotifySource categoriesFor: #getNotifyEventHandle!**auto generated**!methods!public! !
!ISpNotifySource categoriesFor: #GetNotifyEventHandle!**auto generated**!COM Interfaces-ISpNotifySource!private! !
!ISpNotifySource categoriesFor: #setNotifyCallbackFunction:wParam:lParam:!**auto generated**!methods!public! !
!ISpNotifySource categoriesFor: #SetNotifyCallbackFunction:wParam:lParam:!**auto generated**!COM Interfaces-ISpNotifySource!private! !
!ISpNotifySource categoriesFor: #setNotifyCallbackInterface:wParam:lParam:!**auto generated**!methods!public! !
!ISpNotifySource categoriesFor: #SetNotifyCallbackInterface:wParam:lParam:!**auto generated**!COM Interfaces-ISpNotifySource!private! !
!ISpNotifySource categoriesFor: #setNotifySink:!**auto generated**!methods!public! !
!ISpNotifySource categoriesFor: #SetNotifySink:!**auto generated**!COM Interfaces-ISpNotifySource!private! !
!ISpNotifySource categoriesFor: #setNotifyWin32Event!**auto generated**!methods!public! !
!ISpNotifySource categoriesFor: #SetNotifyWin32Event!**auto generated**!COM Interfaces-ISpNotifySource!private! !
!ISpNotifySource categoriesFor: #setNotifyWindowMessage:msg:wParam:lParam:!**auto generated**!methods!public! !
!ISpNotifySource categoriesFor: #SetNotifyWindowMessage:Msg:wParam:lParam:!COM Interfaces-ISpNotifySource!private! !
!ISpNotifySource categoriesFor: #waitForNotifyEvent:!**auto generated**!methods!public! !
!ISpNotifySource categoriesFor: #WaitForNotifyEvent:!**auto generated**!COM Interfaces-ISpNotifySource!private! !

!ISpNotifySource class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpNotifySource'
		ISpNotifySource defineTemplate"

	self
		defineFunction: #SetNotifySink:
			argumentTypes: 'ISpNotifySink*';
		defineFunction: #SetNotifyWindowMessage:Msg:wParam:lParam:
			argumentTypes: 'handle* dword dword sdword';
		defineFunction: #SetNotifyCallbackFunction:wParam:lParam:
			argumentTypes: 'void** dword sdword';
		defineFunction: #SetNotifyCallbackInterface:wParam:lParam:
			argumentTypes: 'void** dword sdword';
		defineFunction: #SetNotifyWin32Event;
		defineFunction: #WaitForNotifyEvent:
			argumentTypes: 'dword';
		defineFunction: #GetNotifyEventHandle
			returnType: 'void*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpNotifySource initializeTypeLib"

	typeLib := SpeechLib! !
!ISpNotifySource class categoriesFor: #defineFunctions!initializing!public! !
!ISpNotifySource class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

