"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Environment13
	subclass: #'WebView2.ICoreWebView2Environment14'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2Environment14 guid: (OS.COM.IID fromString: '{a5e9fad9-c875-59da-9bd7-473aa5ca1cef}')!

WebView2.ICoreWebView2Environment14 comment: '`ICoreWebView2Environment14` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Environment14'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(a5e9fad9-c875-59da-9bd7-473aa5ca1cef)
]
interface ICoreWebView2Environment14 : ICoreWebView2Environment13
 {
	[id(0x600e0000)]
	HRESULT __stdcall CreateWebFileSystemFileHandle(
		[in]LPWSTR Path,
		[in]COREWEBVIEW2_FILE_SYSTEM_HANDLE_PERMISSION Permission,
		[out, retval]ICoreWebView2FileSystemHandle** value);
	[id(0x600e0001)]
	HRESULT __stdcall CreateWebFileSystemDirectoryHandle(
		[in]LPWSTR Path,
		[in]COREWEBVIEW2_FILE_SYSTEM_HANDLE_PERMISSION Permission,
		[out, retval]ICoreWebView2FileSystemHandle** value);
	[id(0x600e0002)]
	HRESULT __stdcall CreateObjectCollection(
		[in]unsigned int length,
		[in]IUnknown** items,
		[out, retval]ICoreWebView2ObjectCollection** objectCollection);
};
```
'!

!WebView2.ICoreWebView2Environment14 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2Environment14 methodsFor!

CreateObjectCollection: length items: items objectCollection: objectCollection
	"Private - Invoke the CreateObjectCollection() method of the COM object.

		HRESULT __stdcall CreateObjectCollection(
			[in]unsigned int length,
			[in]IUnknown** items,
			[out, retval]ICoreWebView2ObjectCollection** objectCollection);"

	<virtual stdcall: hresult 29 uint32 IUnknown** ICoreWebView2ObjectCollection**>
	^self invalidCall: _failureCode!

CreateWebFileSystemDirectoryHandle: path permission: permission value: value
	"Private - Invoke the CreateWebFileSystemDirectoryHandle() method of the COM object.

		HRESULT __stdcall CreateWebFileSystemDirectoryHandle(
			[in]LPWSTR Path,
			[in]COREWEBVIEW2_FILE_SYSTEM_HANDLE_PERMISSION Permission,
			[out, retval]ICoreWebView2FileSystemHandle** value);"

	<virtual stdcall: hresult 28 lpwstr int32 ICoreWebView2FileSystemHandle**>
	^self invalidCall: _failureCode!

CreateWebFileSystemFileHandle: path permission: permission value: value
	"Private - Invoke the CreateWebFileSystemFileHandle() method of the COM object.

		HRESULT __stdcall CreateWebFileSystemFileHandle(
			[in]LPWSTR Path,
			[in]COREWEBVIEW2_FILE_SYSTEM_HANDLE_PERMISSION Permission,
			[out, retval]ICoreWebView2FileSystemHandle** value);"

	<virtual stdcall: hresult 27 lpwstr int32 ICoreWebView2FileSystemHandle**>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2Environment14 categoriesForMethods!
CreateObjectCollection:items:objectCollection:!**auto generated**!COM Interfaces-ICoreWebView2Environment14!private! !
CreateWebFileSystemDirectoryHandle:permission:value:!**auto generated**!COM Interfaces-ICoreWebView2Environment14!private! !
CreateWebFileSystemFileHandle:permission:value:!**auto generated**!COM Interfaces-ICoreWebView2Environment14!private! !
!

!WebView2.ICoreWebView2Environment14 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Environment14'
		ICoreWebView2Environment14 defineTemplate"

	self
		defineFunction: #CreateWebFileSystemFileHandle:permission:value:
			argumentTypes: 'lpwstr int32 ICoreWebView2FileSystemHandle**';
		defineFunction: #CreateWebFileSystemDirectoryHandle:permission:value:
			argumentTypes: 'lpwstr int32 ICoreWebView2FileSystemHandle**';
		defineFunction: #CreateObjectCollection:items:objectCollection:
			argumentTypes: 'uint32 IUnknown** ICoreWebView2ObjectCollection**'
! !

!WebView2.ICoreWebView2Environment14 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

