"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IDocHostUIHandlerDispatch
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IDocHostUIHandlerDispatch guid: (IID fromString: '{425b5af0-65f1-11d1-9611-0000f81e0d0d}')!
IDocHostUIHandlerDispatch comment: '<IDocHostUIHandlerDispatch> is a wrapper class for the COM interface ''ActiveXHost.IDocHostUIHandlerDispatch'' generated from type information in the ''Dolphin Smalltalk Active-X Host Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IDocHostUIHandlerDispatch Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(425B5AF0-65F1-11D1-9611-0000F81E0D0D), 
	helpstring("IDocHostUIHandlerDispatch Interface")
]
interface IDocHostUIHandlerDispatch : IDispatch {
	[id(0x60020000)] 
	HRESULT __stdcall ShowContextMenu(
		[in] unsigned long dwID,
		[in] unsigned long x,
		[in] unsigned long y,
		[in] IUnknown* pcmdtReserved,
		[in] IDispatch* pdispReserved,
		[out, retval] HRESULT* dwRetVal);
	[id(0x60020001)] 
	HRESULT __stdcall GetHostInfo(
		[in, out] unsigned long* pdwFlags,
		[in, out] unsigned long* pdwDoubleClick);
	[id(0x60020002)] 
	HRESULT __stdcall ShowUI(
		[in] unsigned long dwID,
		[in] IUnknown* pActiveObject,
		[in] IUnknown* pCommandTarget,
		[in] IUnknown* pFrame,
		[in] IUnknown* pDoc,
		[out, retval] HRESULT* dwRetVal);
	[id(0x60020003)] 
	HRESULT __stdcall HideUI();
	[id(0x60020004)] 
	HRESULT __stdcall UpdateUI();
	[id(0x60020005)] 
	HRESULT __stdcall EnableModeless(
		[in] VARIANT_BOOL fEnable);
	[id(0x60020006)] 
	HRESULT __stdcall OnDocWindowActivate(
		[in] VARIANT_BOOL fActivate);
	[id(0x60020007)] 
	HRESULT __stdcall OnFrameWindowActivate(
		[in] VARIANT_BOOL fActivate);
	[id(0x60020008)] 
	HRESULT __stdcall ResizeBorder(
		[in] long left,
		[in] long top,
		[in] long right,
		[in] long bottom,
		[in] IUnknown* pUIWindow,
		[in] VARIANT_BOOL fFrameWindow);
	[id(0x60020009)] 
	HRESULT __stdcall TranslateAccelerator(
		[in] ULONG_PTR hWnd,
		[in] unsigned long nMessage,
		[in] ULONG_PTR wParam,
		[in] ULONG_PTR lParam,
		[in] BSTR bstrGuidCmdGroup,
		[in] unsigned long nCmdID,
		[out, retval] HRESULT* dwRetVal);
	[id(0x6002000a)] 
	HRESULT __stdcall GetOptionKeyPath(
		[out] BSTR* pbstrKey,
		[in] unsigned long dw);
	[id(0x6002000b)] 
	HRESULT __stdcall GetDropTarget(
		[in] IUnknown* pDropTarget,
		[out] IUnknown** ppDropTarget);
	[id(0x6002000c)] 
	HRESULT __stdcall GetExternal(
		[out] IDispatch** ppDispatch);
	[id(0x6002000d)] 
	HRESULT __stdcall TranslateUrl(
		[in] unsigned long dwTranslate,
		[in] BSTR bstrURLIn,
		[out] BSTR* pbstrURLOut);
	[id(0x6002000e)] 
	HRESULT __stdcall FilterDataObject(
		[in] IUnknown* pDO,
		[out] IUnknown** ppDORet);
};
'!
!IDocHostUIHandlerDispatch categoriesForClass!ActiveXHost-Interfaces!COM-Interfaces! !
!IDocHostUIHandlerDispatch methodsFor!

EnableModeless: fEnable
	"Invoke the EnableModeless() method of the COM object.

		HRESULT __stdcall EnableModeless(
			[in] VARIANT_BOOL fEnable);"

	<virtual stdcall: hresult 13 varbool>
	^self invalidCall: _failureCode!

filterDataObject: pDO
	"Answer the <IUnknown> result of invoking the FilterDataObject() method of the COM object."

	| answer |
	answer := IUnknown newPointer.
	self
		FilterDataObject: pDO
		ppDORet: answer.
	^answer asObject
!

FilterDataObject: pDO ppDORet: ppDORet
	"Private - Invoke the FilterDataObject() method of the COM object.

		HRESULT __stdcall FilterDataObject(
			[in] IUnknown* pDO,
			[out] IUnknown** ppDORet);"

	<virtual stdcall: hresult 22 IUnknown* IUnknown**>
	^self invalidCall: _failureCode!

getDropTarget: pDropTarget
	"Answer the <IUnknown> result of invoking the GetDropTarget() method of the COM object."

	| answer |
	answer := IUnknown newPointer.
	self
		GetDropTarget: pDropTarget
		ppDropTarget: answer.
	^answer asObject
!

GetDropTarget: pDropTarget ppDropTarget: ppDropTarget
	"Private - Invoke the GetDropTarget() method of the COM object.

		HRESULT __stdcall GetDropTarget(
			[in] IUnknown* pDropTarget,
			[out] IUnknown** ppDropTarget);"

	<virtual stdcall: hresult 19 IUnknown* IUnknown**>
	^self invalidCall: _failureCode!

getExternal
	"Answer the <IDispatch> result of invoking the GetExternal() method of the COM object."

	| answer |
	answer := IDispatch newPointer.
	self GetExternal: answer.
	^answer asObject
!

GetExternal: ppDispatch
	"Private - Invoke the GetExternal() method of the COM object.

		HRESULT __stdcall GetExternal(
			[out] IDispatch** ppDispatch);"

	<virtual stdcall: hresult 20 IDispatch**>
	^self invalidCall: _failureCode!

getHostInfo: pdwFlags pdwDoubleClick: pdwDoubleClick
	"Invoke the GetHostInfo() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (DWORD new value: pdwFlags; yourself);
				basicAt: 2 put: (DWORD new value: pdwDoubleClick; yourself);
				yourself.
	self
		GetHostInfo: (answer basicAt: 1)
		pdwDoubleClick: (answer basicAt: 2).
	^answer collect: [:each | each asObject]
!

GetHostInfo: pdwFlags pdwDoubleClick: pdwDoubleClick
	"Private - Invoke the GetHostInfo() method of the COM object.

		HRESULT __stdcall GetHostInfo(
			[in, out] unsigned long* pdwFlags,
			[in, out] unsigned long* pdwDoubleClick);"

	<virtual stdcall: hresult 9 dword* dword*>
	^self invalidCall: _failureCode!

getOptionKeyPath: dw
	"Answer the <BSTR> result of invoking the GetOptionKeyPath() method of the COM object."

	| answer |
	answer := BSTR new.
	self
		GetOptionKeyPath: answer
		dw: dw.
	^answer asObject
!

GetOptionKeyPath: pbstrKey dw: dw
	"Private - Invoke the GetOptionKeyPath() method of the COM object.

		HRESULT __stdcall GetOptionKeyPath(
			[out] BSTR* pbstrKey,
			[in] unsigned long dw);"

	<virtual stdcall: hresult 18 bstr* dword>
	^self invalidCall: _failureCode!

HideUI
	"Invoke the HideUI() method of the COM object.

		HRESULT __stdcall HideUI();"

	<virtual stdcall: hresult 11>
	^self invalidCall: _failureCode!

OnDocWindowActivate: fActivate
	"Invoke the OnDocWindowActivate() method of the COM object.

		HRESULT __stdcall OnDocWindowActivate(
			[in] VARIANT_BOOL fActivate);"

	<virtual stdcall: hresult 14 varbool>
	^self invalidCall: _failureCode!

OnFrameWindowActivate: fActivate
	"Invoke the OnFrameWindowActivate() method of the COM object.

		HRESULT __stdcall OnFrameWindowActivate(
			[in] VARIANT_BOOL fActivate);"

	<virtual stdcall: hresult 15 varbool>
	^self invalidCall: _failureCode!

ResizeBorder: left top: top right: right bottom: bottom pUIWindow: pUIWindow fFrameWindow: fFrameWindow
	"Invoke the ResizeBorder() method of the COM object.

		HRESULT __stdcall ResizeBorder(
			[in] long left,
			[in] long top,
			[in] long right,
			[in] long bottom,
			[in] IUnknown* pUIWindow,
			[in] VARIANT_BOOL fFrameWindow);"

	<virtual stdcall: hresult 16 sdword sdword sdword sdword IUnknown* varbool>
	^self invalidCall: _failureCode!

showContextMenu: dwID x: x y: y pcmdtReserved: pcmdtReserved pdispReserved: pdispReserved
	"Answer the <HRESULT> result of invoking the ShowContextMenu() method of the COM object."

	| answer |
	answer := (HRESULT new).
	self
		ShowContextMenu: dwID
		x: x
		y: y
		pcmdtReserved: pcmdtReserved
		pdispReserved: pdispReserved
		dwRetVal: answer.
	^answer asObject
!

ShowContextMenu: dwID x: x y: y pcmdtReserved: pcmdtReserved pdispReserved: pdispReserved dwRetVal: dwRetVal
	"Private - Invoke the ShowContextMenu() method of the COM object.

		HRESULT __stdcall ShowContextMenu(
			[in] unsigned long dwID,
			[in] unsigned long x,
			[in] unsigned long y,
			[in] IUnknown* pcmdtReserved,
			[in] IDispatch* pdispReserved,
			[out, retval] HRESULT* dwRetVal);"

	<virtual stdcall: hresult 8 dword dword dword IUnknown* IDispatch* hresult*>
	^self invalidCall: _failureCode!

showUI: dwID pActiveObject: pActiveObject pCommandTarget: pCommandTarget pFrame: pFrame pDoc: pDoc
	"Answer the <HRESULT> result of invoking the ShowUI() method of the COM object."

	| answer |
	answer := (HRESULT new).
	self
		ShowUI: dwID
		pActiveObject: pActiveObject
		pCommandTarget: pCommandTarget
		pFrame: pFrame
		pDoc: pDoc
		dwRetVal: answer.
	^answer asObject
!

ShowUI: dwID pActiveObject: pActiveObject pCommandTarget: pCommandTarget pFrame: pFrame pDoc: pDoc dwRetVal: dwRetVal
	"Private - Invoke the ShowUI() method of the COM object.

		HRESULT __stdcall ShowUI(
			[in] unsigned long dwID,
			[in] IUnknown* pActiveObject,
			[in] IUnknown* pCommandTarget,
			[in] IUnknown* pFrame,
			[in] IUnknown* pDoc,
			[out, retval] HRESULT* dwRetVal);"

	<virtual stdcall: hresult 10 dword IUnknown* IUnknown* IUnknown* IUnknown* hresult*>
	^self invalidCall: _failureCode!

translateAccelerator: hWnd nMessage: nMessage wParam: wParam lParam: lParam bstrGuidCmdGroup: bstrGuidCmdGroup nCmdID: nCmdID
	"Answer the <HRESULT> result of invoking the TranslateAccelerator() method of the COM object."

	| answer |
	answer := (HRESULT new).
	self
		TranslateAccelerator: hWnd
		nMessage: nMessage
		wParam: wParam
		lParam: lParam
		bstrGuidCmdGroup: bstrGuidCmdGroup
		nCmdID: nCmdID
		dwRetVal: answer.
	^answer asObject
!

TranslateAccelerator: hWnd nMessage: nMessage wParam: wParam lParam: lParam bstrGuidCmdGroup: bstrGuidCmdGroup nCmdID: nCmdID dwRetVal: dwRetVal
	"Private - Invoke the TranslateAccelerator() method of the COM object.

		HRESULT __stdcall TranslateAccelerator(
			[in] ULONG_PTR hWnd,
			[in] unsigned long nMessage,
			[in] ULONG_PTR wParam,
			[in] ULONG_PTR lParam,
			[in] BSTR bstrGuidCmdGroup,
			[in] unsigned long nCmdID,
			[out, retval] HRESULT* dwRetVal);"

	<virtual stdcall: hresult 17 uintptr dword uintptr uintptr bstr dword hresult*>
	^self invalidCall: _failureCode!

translateUrl: dwTranslate bstrURLIn: bstrURLIn
	"Answer the <BSTR> result of invoking the TranslateUrl() method of the COM object."

	| answer |
	answer := BSTR new.
	self
		TranslateUrl: dwTranslate
		bstrURLIn: bstrURLIn
		pbstrURLOut: answer.
	^answer asObject
!

TranslateUrl: dwTranslate bstrURLIn: bstrURLIn pbstrURLOut: pbstrURLOut
	"Private - Invoke the TranslateUrl() method of the COM object.

		HRESULT __stdcall TranslateUrl(
			[in] unsigned long dwTranslate,
			[in] BSTR bstrURLIn,
			[out] BSTR* pbstrURLOut);"

	<virtual stdcall: hresult 21 dword bstr bstr*>
	^self invalidCall: _failureCode!

UpdateUI
	"Invoke the UpdateUI() method of the COM object.

		HRESULT __stdcall UpdateUI();"

	<virtual stdcall: hresult 12>
	^self invalidCall: _failureCode! !
!IDocHostUIHandlerDispatch categoriesFor: #EnableModeless:!**auto generated**!COM Interfaces-IDocHostUIHandlerDispatch!public! !
!IDocHostUIHandlerDispatch categoriesFor: #filterDataObject:!**auto generated**!methods!public! !
!IDocHostUIHandlerDispatch categoriesFor: #FilterDataObject:ppDORet:!**auto generated**!COM Interfaces-IDocHostUIHandlerDispatch!private! !
!IDocHostUIHandlerDispatch categoriesFor: #getDropTarget:!**auto generated**!methods!public! !
!IDocHostUIHandlerDispatch categoriesFor: #GetDropTarget:ppDropTarget:!**auto generated**!COM Interfaces-IDocHostUIHandlerDispatch!private! !
!IDocHostUIHandlerDispatch categoriesFor: #getExternal!**auto generated**!methods!public! !
!IDocHostUIHandlerDispatch categoriesFor: #GetExternal:!**auto generated**!COM Interfaces-IDocHostUIHandlerDispatch!private! !
!IDocHostUIHandlerDispatch categoriesFor: #getHostInfo:pdwDoubleClick:!**auto generated**!methods!public! !
!IDocHostUIHandlerDispatch categoriesFor: #GetHostInfo:pdwDoubleClick:!**auto generated**!COM Interfaces-IDocHostUIHandlerDispatch!private! !
!IDocHostUIHandlerDispatch categoriesFor: #getOptionKeyPath:!**auto generated**!methods!public! !
!IDocHostUIHandlerDispatch categoriesFor: #GetOptionKeyPath:dw:!**auto generated**!COM Interfaces-IDocHostUIHandlerDispatch!private! !
!IDocHostUIHandlerDispatch categoriesFor: #HideUI!**auto generated**!COM Interfaces-IDocHostUIHandlerDispatch!public! !
!IDocHostUIHandlerDispatch categoriesFor: #OnDocWindowActivate:!**auto generated**!COM Interfaces-IDocHostUIHandlerDispatch!public! !
!IDocHostUIHandlerDispatch categoriesFor: #OnFrameWindowActivate:!**auto generated**!COM Interfaces-IDocHostUIHandlerDispatch!public! !
!IDocHostUIHandlerDispatch categoriesFor: #ResizeBorder:top:right:bottom:pUIWindow:fFrameWindow:!**auto generated**!COM Interfaces-IDocHostUIHandlerDispatch!public! !
!IDocHostUIHandlerDispatch categoriesFor: #showContextMenu:x:y:pcmdtReserved:pdispReserved:!**auto generated**!methods!public! !
!IDocHostUIHandlerDispatch categoriesFor: #ShowContextMenu:x:y:pcmdtReserved:pdispReserved:dwRetVal:!**auto generated**!COM Interfaces-IDocHostUIHandlerDispatch!private! !
!IDocHostUIHandlerDispatch categoriesFor: #showUI:pActiveObject:pCommandTarget:pFrame:pDoc:!**auto generated**!methods!public! !
!IDocHostUIHandlerDispatch categoriesFor: #ShowUI:pActiveObject:pCommandTarget:pFrame:pDoc:dwRetVal:!**auto generated**!COM Interfaces-IDocHostUIHandlerDispatch!private! !
!IDocHostUIHandlerDispatch categoriesFor: #translateAccelerator:nMessage:wParam:lParam:bstrGuidCmdGroup:nCmdID:!**auto generated**!methods!public! !
!IDocHostUIHandlerDispatch categoriesFor: #TranslateAccelerator:nMessage:wParam:lParam:bstrGuidCmdGroup:nCmdID:dwRetVal:!**auto generated**!COM Interfaces-IDocHostUIHandlerDispatch!private! !
!IDocHostUIHandlerDispatch categoriesFor: #translateUrl:bstrURLIn:!**auto generated**!methods!public! !
!IDocHostUIHandlerDispatch categoriesFor: #TranslateUrl:bstrURLIn:pbstrURLOut:!**auto generated**!COM Interfaces-IDocHostUIHandlerDispatch!private! !
!IDocHostUIHandlerDispatch categoriesFor: #UpdateUI!**auto generated**!COM Interfaces-IDocHostUIHandlerDispatch!public! !

!IDocHostUIHandlerDispatch class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ActiveXHost.IDocHostUIHandlerDispatch'
		IDocHostUIHandlerDispatch defineTemplate"

	self
		defineFunction: #ShowContextMenu:x:y:pcmdtReserved:pdispReserved:dwRetVal:
			argumentTypes: 'dword dword dword IUnknown* IDispatch* hresult*';
		defineFunction: #GetHostInfo:pdwDoubleClick:
			argumentTypes: 'dword* dword*';
		defineFunction: #ShowUI:pActiveObject:pCommandTarget:pFrame:pDoc:dwRetVal:
			argumentTypes: 'dword IUnknown* IUnknown* IUnknown* IUnknown* hresult*';
		defineFunction: #HideUI;
		defineFunction: #UpdateUI;
		defineFunction: #EnableModeless:
			argumentTypes: 'varbool';
		defineFunction: #OnDocWindowActivate:
			argumentTypes: 'varbool';
		defineFunction: #OnFrameWindowActivate:
			argumentTypes: 'varbool';
		defineFunction: #ResizeBorder:top:right:bottom:pUIWindow:fFrameWindow:
			argumentTypes: 'sdword sdword sdword sdword IUnknown* varbool';
		defineFunction: #TranslateAccelerator:nMessage:wParam:lParam:bstrGuidCmdGroup:nCmdID:dwRetVal:
			argumentTypes: 'dword dword dword dword bstr dword hresult*';
		defineFunction: #GetOptionKeyPath:dw:
			argumentTypes: 'bstr* dword';
		defineFunction: #GetDropTarget:ppDropTarget:
			argumentTypes: 'IUnknown* IUnknown**';
		defineFunction: #GetExternal:
			argumentTypes: 'IDispatch**';
		defineFunction: #TranslateUrl:bstrURLIn:pbstrURLOut:
			argumentTypes: 'dword bstr bstr*';
		defineFunction: #FilterDataObject:ppDORet:
			argumentTypes: 'IUnknown* IUnknown**'
! !
!IDocHostUIHandlerDispatch class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

