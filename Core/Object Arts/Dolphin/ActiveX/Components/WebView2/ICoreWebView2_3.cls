"Filed out from Dolphin Smalltalk"!

ICoreWebView2_2 subclass: #ICoreWebView2_3
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ICoreWebView2_3 guid: (OS.COM.IID fromString: '{a0d6df20-3b92-416d-aa0c-437a9c727857}')!
ICoreWebView2_3 comment: '`ICoreWebView2_3` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_3'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(a0d6df20-3b92-416d-aa0c-437a9c727857)
]
interface ICoreWebView2_3 : ICoreWebView2_2
 {
	[id(0x60030000)]
	HRESULT __stdcall TrySuspend(
		[in]ICoreWebView2TrySuspendCompletedHandler* handler);
	[id(0x60030001)]
	HRESULT __stdcall Resume();
	[id(0x60030002), propget]
	HRESULT __stdcall IsSuspended(
		[out, retval]long* IsSuspended);
	[id(0x60030003)]
	HRESULT __stdcall SetVirtualHostNameToFolderMapping(
		[in]LPWSTR hostName,
		[in]LPWSTR folderPath,
		[in]COREWEBVIEW2_HOST_RESOURCE_ACCESS_KIND accessKind);
	[id(0x60030004)]
	HRESULT __stdcall ClearVirtualHostNameToFolderMapping(
		[in]LPWSTR hostName);
};
```
'!
!ICoreWebView2_3 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2_3 methodsFor!

ClearVirtualHostNameToFolderMapping: hostName
	"Private - Invoke the ClearVirtualHostNameToFolderMapping() method of the COM object.

		HRESULT __stdcall ClearVirtualHostNameToFolderMapping(
			[in]LPWSTR hostName);"

	<virtual stdcall: hresult 73 lpwstr>
	^self invalidCall: _failureCode!

get_IsSuspended: isSuspended
	"Private - Get the value of the 'IsSuspended' property of the receiver.

		HRESULT __stdcall IsSuspended(
			[out, retval]long* IsSuspended);"

	<virtual stdcall: hresult 71 sdword*>
	^self invalidCall: _failureCode!

Resume
	"Private - Invoke the Resume() method of the COM object.

		HRESULT __stdcall Resume();"

	<virtual stdcall: hresult 70>
	^self invalidCall: _failureCode!

SetVirtualHostNameToFolderMapping: hostName folderPath: folderPath accessKind: accessKind
	"Private - Invoke the SetVirtualHostNameToFolderMapping() method of the COM object.

		HRESULT __stdcall SetVirtualHostNameToFolderMapping(
			[in]LPWSTR hostName,
			[in]LPWSTR folderPath,
			[in]COREWEBVIEW2_HOST_RESOURCE_ACCESS_KIND accessKind);"

	<virtual stdcall: hresult 72 lpwstr lpwstr sdword>
	^self invalidCall: _failureCode!

TrySuspend: handler
	"Private - Invoke the TrySuspend() method of the COM object.

		HRESULT __stdcall TrySuspend(
			[in]ICoreWebView2TrySuspendCompletedHandler* handler);"

	<virtual stdcall: hresult 69 ICoreWebView2TrySuspendCompletedHandler*>
	^self invalidCall: _failureCode! !
!ICoreWebView2_3 categoriesForMethods!
ClearVirtualHostNameToFolderMapping:!**auto generated**!COM Interfaces-ICoreWebView2_3!private! !
get_IsSuspended:!**auto generated**!COM Interfaces-ICoreWebView2_3!private! !
Resume!**auto generated**!COM Interfaces-ICoreWebView2_3!private! !
SetVirtualHostNameToFolderMapping:folderPath:accessKind:!**auto generated**!COM Interfaces-ICoreWebView2_3!private! !
TrySuspend:!**auto generated**!COM Interfaces-ICoreWebView2_3!private! !
!

!ICoreWebView2_3 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_3'
		ICoreWebView2_3 defineTemplate"

	self
		defineFunction: #TrySuspend:
			argumentTypes: 'ICoreWebView2TrySuspendCompletedHandler*';
		defineFunction: #Resume;
		defineFunction: #get_IsSuspended:
			argumentTypes: 'sdword*';
		defineFunction: #SetVirtualHostNameToFolderMapping:folderPath:accessKind:
			argumentTypes: 'lpwstr lpwstr sdword';
		defineFunction: #ClearVirtualHostNameToFolderMapping:
			argumentTypes: 'lpwstr'
! !
!ICoreWebView2_3 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

