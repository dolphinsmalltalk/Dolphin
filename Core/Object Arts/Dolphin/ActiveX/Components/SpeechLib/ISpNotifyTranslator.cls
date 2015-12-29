"Filed out from Dolphin Smalltalk X6"!

ISpNotifySink subclass: #ISpNotifyTranslator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpNotifyTranslator guid: (IID fromString: '{ACA16614-5D3D-11D2-960E-00C04F8EE628}')!
ISpNotifyTranslator comment: '<ISpNotifyTranslator> is a wrapper class for the COM interface ''SpeechLib.ISpNotifyTranslator'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpNotifyTranslator Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(ACA16614-5D3D-11D2-960E-00C04F8EE628), 
	helpstring("ISpNotifyTranslator Interface"), 
	restricted
]
interface ISpNotifyTranslator : ISpNotifySink {
	[id(0x60020000)]
	HRESULT __stdcall InitWindowMessage(
		[in] wireHWND hWnd,
		[in] unsigned int Msg,
		[in] UINT_PTR wParam,
		[in] LONG_PTR lParam);
	[id(0x60020001)]
	HRESULT __stdcall InitCallback(
		[in] void** pfnCallback,
		[in] UINT_PTR wParam,
		[in] LONG_PTR lParam);
	[id(0x60020002)]
	HRESULT __stdcall InitSpNotifyCallback(
		[in] void** pSpCallback,
		[in] UINT_PTR wParam,
		[in] LONG_PTR lParam);
	[id(0x60020003)]
	HRESULT __stdcall InitWin32Event(
		void* hEvent,
		long fCloseHandleOnRelease);
	[id(0x60020004)]
	HRESULT __stdcall Wait(
		[in] unsigned long dwMilliseconds);
	[id(0x60020005)]
	void* __stdcall GetEventHandle();
};
'!
!ISpNotifyTranslator categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpNotifyTranslator methodsFor!

getEventHandle
	"Answer the <VOID> result of invoking the GetEventHandle() method of the COM object."

	^self GetEventHandle
!

GetEventHandle
	"Private - Invoke the GetEventHandle() method of the COM object.

		void* __stdcall GetEventHandle();"

	<virtual stdcall: void* 10>
	^self invalidCall
!

initCallback: pfnCallback wParam: wParam lParam: lParam
	"Invoke the InitCallback() method of the COM object."

	^self
		InitCallback: pfnCallback
		wParam: wParam
		lParam: lParam
!

InitCallback: pfnCallback wParam: wParam lParam: lParam
	"Private - Invoke the InitCallback() method of the COM object.

		HRESULT __stdcall InitCallback(
			[in] void** pfnCallback,
			[in] UINT_PTR wParam,
			[in] LONG_PTR lParam);"

	<virtual stdcall: hresult 6 void** dword sdword>
	^self invalidCall
!

initSpNotifyCallback: pSpCallback wParam: wParam lParam: lParam
	"Invoke the InitSpNotifyCallback() method of the COM object."

	^self
		InitSpNotifyCallback: pSpCallback
		wParam: wParam
		lParam: lParam
!

InitSpNotifyCallback: pSpCallback wParam: wParam lParam: lParam
	"Private - Invoke the InitSpNotifyCallback() method of the COM object.

		HRESULT __stdcall InitSpNotifyCallback(
			[in] void** pSpCallback,
			[in] UINT_PTR wParam,
			[in] LONG_PTR lParam);"

	<virtual stdcall: hresult 7 void** dword sdword>
	^self invalidCall
!

initWin32Event: hEvent fCloseHandleOnRelease: fCloseHandleOnRelease
	"Invoke the InitWin32Event() method of the COM object."

	^self
		InitWin32Event: hEvent
		fCloseHandleOnRelease: fCloseHandleOnRelease
!

InitWin32Event: hEvent fCloseHandleOnRelease: fCloseHandleOnRelease
	"Private - Invoke the InitWin32Event() method of the COM object.

		HRESULT __stdcall InitWin32Event(
			void* hEvent,
			long fCloseHandleOnRelease);"

	<virtual stdcall: hresult 8 void* sdword>
	^self invalidCall
!

initWindowMessage: hWnd msg: msg wParam: wParam lParam: lParam
	"Invoke the InitWindowMessage() method of the COM object."

	^self
		InitWindowMessage: hWnd
		Msg: msg
		wParam: wParam
		lParam: lParam
!

InitWindowMessage: hWnd Msg: msg wParam: wParam lParam: lParam
	"Private - Invoke the InitWindowMessage() method of the COM object.

		HRESULT __stdcall InitWindowMessage(
			[in] wireHWND hWnd,
			[in] unsigned int Msg,
			[in] UINT_PTR wParam,
			[in] LONG_PTR lParam);"

	<virtual stdcall: hresult 5 handle* dword dword sdword>
	^self invalidCall
!

wait: dwMilliseconds
	"Invoke the Wait() method of the COM object."

	^self Wait: dwMilliseconds
!

Wait: dwMilliseconds
	"Private - Invoke the Wait() method of the COM object.

		HRESULT __stdcall Wait(
			[in] unsigned long dwMilliseconds);"

	<virtual stdcall: hresult 9 dword>
	^self invalidCall
! !
!ISpNotifyTranslator categoriesFor: #getEventHandle!**auto generated**!methods!public! !
!ISpNotifyTranslator categoriesFor: #GetEventHandle!**auto generated**!COM Interfaces-ISpNotifyTranslator!private! !
!ISpNotifyTranslator categoriesFor: #initCallback:wParam:lParam:!**auto generated**!methods!public! !
!ISpNotifyTranslator categoriesFor: #InitCallback:wParam:lParam:!**auto generated**!COM Interfaces-ISpNotifyTranslator!private! !
!ISpNotifyTranslator categoriesFor: #initSpNotifyCallback:wParam:lParam:!**auto generated**!methods!public! !
!ISpNotifyTranslator categoriesFor: #InitSpNotifyCallback:wParam:lParam:!**auto generated**!COM Interfaces-ISpNotifyTranslator!private! !
!ISpNotifyTranslator categoriesFor: #initWin32Event:fCloseHandleOnRelease:!**auto generated**!methods!public! !
!ISpNotifyTranslator categoriesFor: #InitWin32Event:fCloseHandleOnRelease:!**auto generated**!COM Interfaces-ISpNotifyTranslator!private! !
!ISpNotifyTranslator categoriesFor: #initWindowMessage:msg:wParam:lParam:!**auto generated**!methods!public! !
!ISpNotifyTranslator categoriesFor: #InitWindowMessage:Msg:wParam:lParam:!COM Interfaces-ISpNotifyTranslator!private! !
!ISpNotifyTranslator categoriesFor: #wait:!**auto generated**!methods!public! !
!ISpNotifyTranslator categoriesFor: #Wait:!**auto generated**!COM Interfaces-ISpNotifyTranslator!private! !

!ISpNotifyTranslator class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SpNotifyTranslator) for which the receiver is the default interface."

	^CLSID fromString: '{E2AE5372-5D40-11D2-960E-00C04F8EE628}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpNotifyTranslator'
		ISpNotifyTranslator defineTemplate"

	self
		defineFunction: #InitWindowMessage:Msg:wParam:lParam:
			argumentTypes: 'handle* dword dword sdword';
		defineFunction: #InitCallback:wParam:lParam:
			argumentTypes: 'void** dword sdword';
		defineFunction: #InitSpNotifyCallback:wParam:lParam:
			argumentTypes: 'void** dword sdword';
		defineFunction: #InitWin32Event:fCloseHandleOnRelease:
			argumentTypes: 'void* sdword';
		defineFunction: #Wait:
			argumentTypes: 'dword';
		defineFunction: #GetEventHandle
			returnType: 'void*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpNotifyTranslator initializeTypeLib"

	typeLib := SpeechLib! !
!ISpNotifyTranslator class categoriesFor: #clsid!**auto generated**!constants!private! !
!ISpNotifyTranslator class categoriesFor: #defineFunctions!initializing!public! !
!ISpNotifyTranslator class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

