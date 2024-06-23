"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown
	subclass: #'OS.COM.IPrintDialogCallback'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.IPrintDialogCallback guid: (OS.COM.IID fromString: '{5852a2c3-6530-11d1-b6a3-0000f8757bf9}')!

OS.COM.IPrintDialogCallback comment: '`IPrintDialogCallback` is a wrapper class for the COM interface ''Win32.IPrintDialogCallback'' generated from type information in the ''Win32 API'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"Callback interface to receive notifications and messages from the PrintDlgEx function while the Print Property Sheet is displayed."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(5852a2c3-6530-11d1-b6a3-0000f8757bf9), 
	helpstring("Callback interface to receive notifications and messages from the PrintDlgEx function while the Print Property Sheet is displayed.")
]
interface IPrintDialogCallback : IUnknown
 {
	[id(0x60010000), helpstring("Called when PrintDlgEx has finished initializing the General page of the Print Property Sheet.")]
	HRESULT __stdcall InitDone();
	[id(0x60010001), helpstring("Called when the user selects a different printer from the list of installed printers on the General page of the Print Property Sheet.")]
	HRESULT __stdcall SelectionChange();
	[id(0x60010002), helpstring("Called for messages sent to the child dialog box in the lower portion of the General page of the Print Property Sheet.")]
	HRESULT __stdcall HandleMessage(
		[in]wireHWND hDlg,
		[in]unsigned int uMsg,
		[in]UINT_PTR wParam,
		[in]LONG_PTR lParam,
		[out]LONG_PTR* pResult);
};
```
'!

!OS.COM.IPrintDialogCallback categoriesForClass!COM-Interfaces!Win32-Interfaces! !

!OS.COM.IPrintDialogCallback methodsFor!

HandleMessage: hDlg uMsg: uMsg wParam: wParam lParam: lParam pResult: pResult
	"Invoke the HandleMessage() method of the COM object.
	Helpstring: Called for messages sent to the child dialog box in the lower portion of the General page of the Print Property Sheet.

		HRESULT __stdcall HandleMessage(
			[in]wireHWND hDlg,
			[in]unsigned int uMsg,
			[in]UINT_PTR wParam,
			[in]LONG_PTR lParam,
			[out]LONG_PTR* pResult);"

	<virtual stdcall: hresult 6 handle uint32 uintptr intptr intptr*>
	^self invalidCall: _failureCode!

InitDone
	"Invoke the InitDone() method of the COM object.
	Helpstring: Called when PrintDlgEx has finished initializing the General page of the Print Property Sheet.

		HRESULT __stdcall InitDone();"

	<virtual stdcall: hresult 4>
	^self invalidCall: _failureCode!

SelectionChange
	"Invoke the SelectionChange() method of the COM object.
	Helpstring: Called when the user selects a different printer from the list of installed printers on the General page of the Print Property Sheet.

		HRESULT __stdcall SelectionChange();"

	<virtual stdcall: hresult 5>
	^self invalidCall: _failureCode! !

!OS.COM.IPrintDialogCallback categoriesForMethods!
HandleMessage:uMsg:wParam:lParam:pResult:!**auto generated**!COM Interfaces-IPrintDialogCallback!public! !
InitDone!**auto generated**!COM Interfaces-IPrintDialogCallback!public! !
SelectionChange!**auto generated**!COM Interfaces-IPrintDialogCallback!public! !
!

OS.COM.IPrintDialogCallback methodProtocol: #IPrintDialogCallback attributes: #(#readOnly) selectors: #(#HandleMessage:uMsg:wParam:lParam:pResult: #InitDone #SelectionChange)!

!OS.COM.IPrintDialogCallback class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'Win32.IPrintDialogCallback'
		IPrintDialogCallback defineTemplate"

	self
		defineFunction: #InitDone;
		defineFunction: #SelectionChange;
		defineFunction: #HandleMessage:uMsg:wParam:lParam:pResult:
			argumentTypes: 'handle uint32 uintptr intptr intptr*'
! !

!OS.COM.IPrintDialogCallback class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

