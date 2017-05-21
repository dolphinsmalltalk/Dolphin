"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #INPApplet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'NPDolphinConstants'
	classInstanceVariableNames: ''!
INPApplet guid: (IID fromString: '{EB83765C-6B7F-11D3-97BB-0080C8D59432}')!
INPApplet comment: '<INPApplet> is a wrapper class for the COM interface ''NPDolphin.INPApplet'' generated from type information in the ''Dolphin Internet Browser Plugin 1.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"Dolphin Plugin image applet instance"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!INPApplet categoriesForClass!Plugin-Interfaces! !
!INPApplet methodsFor!

get_Instance: pInstance
	"Get the value of the 'Instance' property of the receiver.
	Helpstring: 'The Netscape instance handle (an opaque value to the plug-in instance)'

		HRESULT __stdcall Instance(
			[out, retval] unsigned long* pInstance);
	"

	<virtual stdcall: hresult 4 dword*>
	^self invalidCall
!

OnDestroy: ppbSaved pcSaved: pcSaved
	"Invoke the OnDestroy() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnDestroy(
			[out] char** ppbSaved,
			[out] long* pcSaved);
	"

	<virtual stdcall: hresult 9 byte** sdword*>
	^self invalidCall
!

OnEvent: nEvent wParam: wParam lParam: lParam pRet: pRet
	"Invoke the OnEvent() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnEvent(
			long nEvent,
			long wParam,
			long lParam,
			[out, retval] short* pRet);
	"

	<virtual stdcall: hresult 7 sdword sdword sdword sword*>
	^self invalidCall
!

OnNewStream: piStream szURL: szURL pSType: pSType ppiHandler: ppiHandler
	"Invoke the OnNewStream() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnNewStream(
			[in] INPStream* piStream,
			[in] LPSTR szURL,
			[out] unsigned short* pSType,
			[out, retval] INPStreamEvents** ppiHandler);
	"

	<virtual stdcall: hresult 6 INPStream* lpstr word* INPStreamEvents**>
	^self invalidCall
!

OnSetWindow: hWnd x: x y: y cx: cx cy: cy clipTop: clipTop clipLeft: clipLeft clipBottom: clipBottom clipRight: clipRight
	"Invoke the OnSetWindow() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnSetWindow(
			[in] long hWnd,
			[in] long x,
			[in] long y,
			[in] long cx,
			[in] long cy,
			[in] long clipTop,
			[in] long clipLeft,
			[in] long clipBottom,
			[in] long clipRight);
	"

	<virtual stdcall: hresult 5 sdword sdword sdword sdword sdword sdword sdword sdword sdword>
	^self invalidCall
!

OnURLNotify: szURL npReason: npReason dwNotifyData: dwNotifyData
	"Invoke the OnURLNotify() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnURLNotify(
			[in] LPSTR szURL,
			[in] short npReason,
			[in] unsigned long dwNotifyData);
	"

	<virtual stdcall: hresult 8 lpstr sword dword>
	^self invalidCall
! !
!INPApplet categoriesFor: #get_Instance:!COM Interfaces-INPApplet!public! !
!INPApplet categoriesFor: #OnDestroy:pcSaved:!**auto generated**!COM Interfaces-INPApplet!public! !
!INPApplet categoriesFor: #OnEvent:wParam:lParam:pRet:!**auto generated**!COM Interfaces-INPApplet!public! !
!INPApplet categoriesFor: #OnNewStream:szURL:pSType:ppiHandler:!**auto generated**!COM Interfaces-INPApplet!public! !
!INPApplet categoriesFor: #OnSetWindow:x:y:cx:cy:clipTop:clipLeft:clipBottom:clipRight:!**auto generated**!COM Interfaces-INPApplet!public! !
!INPApplet categoriesFor: #OnURLNotify:npReason:dwNotifyData:!**auto generated**!COM Interfaces-INPApplet!public! !

INPApplet methodProtocol: #'NPDolphin.INPApplet' attributes: #() selectors: #(#get_Instance: #OnDestroy:pcSaved: #OnEvent:wParam:lParam:pRet: #OnNewStream:szURL:pSType:ppiHandler: #OnSetWindow:x:y:cx:cy:clipTop:clipLeft:clipBottom:clipRight: #OnURLNotify:npReason:dwNotifyData:)!

!INPApplet class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'NPDolphin.INPApplet'
		INPApplet defineTemplate
	"

	self
		defineFunction: #get_Instance:
			argumentTypes: 'dword*';
		defineFunction: #OnSetWindow:x:y:cx:cy:clipTop:clipLeft:clipBottom:clipRight:
			argumentTypes: 'sdword sdword sdword sdword sdword sdword sdword sdword sdword';
		defineFunction: #OnNewStream:szURL:pSType:ppiHandler:
			argumentTypes: 'INPStream* lpstr word* INPStreamEvents**';
		defineFunction: #OnEvent:wParam:lParam:pRet:
			argumentTypes: 'sdword sdword sdword sword*';
		defineFunction: #OnURLNotify:npReason:dwNotifyData:
			argumentTypes: 'lpstr sword dword';
		defineFunction: #OnDestroy:pcSaved:
			argumentTypes: 'byte** sdword*'
! !
!INPApplet class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

