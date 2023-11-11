"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2_8
	subclass: #'WebView2.ICoreWebView2_9'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2_9 guid: (OS.COM.IID fromString: '{4d7b2eab-9fdc-468d-b998-a9260b5ed651}')!
WebView2.ICoreWebView2_9 isEgressOnly: true!
WebView2.ICoreWebView2_9 comment: '`ICoreWebView2_9` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_9'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(4d7b2eab-9fdc-468d-b998-a9260b5ed651)
]
interface ICoreWebView2_9 : ICoreWebView2_8
 {
	[id(0x60090000)]
	HRESULT __stdcall add_IsDefaultDownloadDialogOpenChanged(
		[in]ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler* handler,
		[out]EventRegistrationToken* token);
	[id(0x60090001)]
	HRESULT __stdcall remove_IsDefaultDownloadDialogOpenChanged(
		[in]EventRegistrationToken token);
	[id(0x60090002), propget]
	HRESULT __stdcall IsDefaultDownloadDialogOpen(
		[out, retval]long* value);
	[id(0x60090003)]
	HRESULT __stdcall OpenDefaultDownloadDialog();
	[id(0x60090004)]
	HRESULT __stdcall CloseDefaultDownloadDialog();
	[id(0x60090005), propget]
	HRESULT __stdcall DefaultDownloadDialogCornerAlignment(
		[out, retval]COREWEBVIEW2_DEFAULT_DOWNLOAD_DIALOG_CORNER_ALIGNMENT* value);
	[id(0x60090005), propput]
	HRESULT __stdcall DefaultDownloadDialogCornerAlignment(
		[in]COREWEBVIEW2_DEFAULT_DOWNLOAD_DIALOG_CORNER_ALIGNMENT value);
	[id(0x60090007), propget]
	HRESULT __stdcall DefaultDownloadDialogMargin(
		[out, retval]POINT* value);
	[id(0x60090007), propput]
	HRESULT __stdcall DefaultDownloadDialogMargin(
		[in]POINT value);
};
```
'!
!WebView2.ICoreWebView2_9 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2_9 methodsFor!

Add_IsDefaultDownloadDialogOpenChanged: handler token: token
	"Private - Invoke the add_IsDefaultDownloadDialogOpenChanged() method of the COM object.

		HRESULT __stdcall add_IsDefaultDownloadDialogOpenChanged(
			[in]ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler* handler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 89 ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler* int64*>
	^self invalidCall: _failureCode!

CloseDefaultDownloadDialog
	"Private - Invoke the CloseDefaultDownloadDialog() method of the COM object.

		HRESULT __stdcall CloseDefaultDownloadDialog();"

	<virtual stdcall: hresult 93>
	^self invalidCall: _failureCode!

get_DefaultDownloadDialogCornerAlignment: value
	"Private - Get the value of the 'DefaultDownloadDialogCornerAlignment' property of the receiver.

		HRESULT __stdcall DefaultDownloadDialogCornerAlignment(
			[out, retval]COREWEBVIEW2_DEFAULT_DOWNLOAD_DIALOG_CORNER_ALIGNMENT* value);"

	<virtual stdcall: hresult 94 int32*>
	^self invalidCall: _failureCode!

get_DefaultDownloadDialogMargin: value
	"Private - Get the value of the 'DefaultDownloadDialogMargin' property of the receiver.

		HRESULT __stdcall DefaultDownloadDialogMargin(
			[out, retval]POINT* value);"

	<virtual stdcall: hresult 96 POINTL*>
	^self invalidCall: _failureCode!

get_IsDefaultDownloadDialogOpen: value
	"Private - Get the value of the 'IsDefaultDownloadDialogOpen' property of the receiver.

		HRESULT __stdcall IsDefaultDownloadDialogOpen(
			[out, retval]long* value);"

	<virtual stdcall: hresult 91 int32*>
	^self invalidCall: _failureCode!

OpenDefaultDownloadDialog
	"Private - Invoke the OpenDefaultDownloadDialog() method of the COM object.

		HRESULT __stdcall OpenDefaultDownloadDialog();"

	<virtual stdcall: hresult 92>
	^self invalidCall: _failureCode!

put_DefaultDownloadDialogCornerAlignment: value
	"Private - Set the value of the 'DefaultDownloadDialogCornerAlignment' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall DefaultDownloadDialogCornerAlignment(
			[in]COREWEBVIEW2_DEFAULT_DOWNLOAD_DIALOG_CORNER_ALIGNMENT value);"

	<virtual stdcall: hresult 95 int32>
	^self invalidCall: _failureCode!

put_DefaultDownloadDialogMargin: value
	"Private - Set the value of the 'DefaultDownloadDialogMargin' property of the object wrapped by the 
	 receiver to the <POINTL> argument, value.

		HRESULT __stdcall DefaultDownloadDialogMargin(
			[in]POINT value);"

	<virtual stdcall: hresult 97 POINTL>
	^self invalidCall: _failureCode!

Remove_IsDefaultDownloadDialogOpenChanged: token
	"Private - Invoke the remove_IsDefaultDownloadDialogOpenChanged() method of the COM object.

		HRESULT __stdcall remove_IsDefaultDownloadDialogOpenChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 90 int64>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2_9 categoriesForMethods!
Add_IsDefaultDownloadDialogOpenChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2_9!private! !
CloseDefaultDownloadDialog!**auto generated**!COM Interfaces-ICoreWebView2_9!private! !
get_DefaultDownloadDialogCornerAlignment:!**auto generated**!COM Interfaces-ICoreWebView2_9!private! !
get_DefaultDownloadDialogMargin:!**auto generated**!COM Interfaces-ICoreWebView2_9!private! !
get_IsDefaultDownloadDialogOpen:!**auto generated**!COM Interfaces-ICoreWebView2_9!private! !
OpenDefaultDownloadDialog!**auto generated**!COM Interfaces-ICoreWebView2_9!private! !
put_DefaultDownloadDialogCornerAlignment:!**auto generated**!COM Interfaces-ICoreWebView2_9!private! !
put_DefaultDownloadDialogMargin:!**auto generated**!COM Interfaces-ICoreWebView2_9!private! !
Remove_IsDefaultDownloadDialogOpenChanged:!**auto generated**!COM Interfaces-ICoreWebView2_9!private! !
!

!WebView2.ICoreWebView2_9 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_9'
		ICoreWebView2_9 defineTemplate"

	self
		defineFunction: #Add_IsDefaultDownloadDialogOpenChanged:token:
			argumentTypes: 'ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler* sqword*';
		defineFunction: #Remove_IsDefaultDownloadDialogOpenChanged:
			argumentTypes: 'sqword';
		defineFunction: #get_IsDefaultDownloadDialogOpen:
			argumentTypes: 'sdword*';
		defineFunction: #OpenDefaultDownloadDialog;
		defineFunction: #CloseDefaultDownloadDialog;
		defineFunction: #get_DefaultDownloadDialogCornerAlignment:
			argumentTypes: 'sdword*';
		defineFunction: #put_DefaultDownloadDialogCornerAlignment:
			argumentTypes: 'sdword';
		defineFunction: #get_DefaultDownloadDialogMargin:
			argumentTypes: 'POINTL*';
		defineFunction: #put_DefaultDownloadDialogMargin:
			argumentTypes: 'POINTL'
! !
!WebView2.ICoreWebView2_9 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

