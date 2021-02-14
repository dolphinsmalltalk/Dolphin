"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'OS.IShellFolder'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.IShellFolder guid: (OS.COM.IID fromString: '{000214e6-0000-0000-c000-000000000046}')!
OS.IShellFolder comment: ''!
!OS.IShellFolder categoriesForClass!COM-Interfaces! !
!OS.IShellFolder methodsFor!

BindToObject: bindToObject pbc: pbc riid: riid ppvOut: ppvOut
	"Callout for the IShellFolder::BindToObject() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in IShellFolder>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 6 lpvoid lpvoid REFGUID lppvoid>
	^self invalidCall: _failureCode!

BindToStorage: bindToStorage pbc: pbc riid: riid ppv: ppv
	"Callout for the IShellFolder::BindToStorage() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in IShellFolder>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 7 lpvoid lpvoid REFGUID lppvoid>
	^self invalidCall: _failureCode!

CompareIDs: compareIDs pidl1: pidl1 pidl2: pidl2
	"Callout for the IShellFolder::CompareIDs() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in IShellFolder>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 8 dword lpvoid lpvoid>
	^self invalidCall: _failureCode!

CreateViewObject: createViewObject riid: riid ppvOut: ppvOut
	"Callout for the IShellFolder::CreateViewObject() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in IShellFolder>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 9 handle REFGUID lppvoid>
	^self invalidCall: _failureCode!

EnumObjects: enumObjects grfFlags: grfFlags ppenumIDList: ppenumIDList
	"Callout for the IShellFolder::EnumObjects() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in IShellFolder>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 5 handle dword lppvoid>
	^self invalidCall: _failureCode!

GetAttributesOf: getAttributesOf apidl: apidl rgfInOut: rgfInOut
	"Callout for the IShellFolder::GetAttributesOf() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in IShellFolder>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 10 dword lppvoid dword*>
	^self invalidCall: _failureCode!

GetDisplayNameOf: getDisplayNameOf uFlags: uFlags lpName: lpName
	"Callout for the IShellFolder::GetDisplayNameOf() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in IShellFolder>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 12 lpvoid dword lpvoid>
	^self invalidCall: _failureCode!

GetUIObjectOf: getUIObjectOf cidl: cidl apidl: apidl riid: riid prgfInOut: prgfInOut ppvOut: ppvOut
	"Callout for the IShellFolder::GetUIObjectOf() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in IShellFolder>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 11 handle dword lppvoid REFGUID dword* lppvoid>
	^self invalidCall: _failureCode!

idlFromPath: path 
	"Answer an ITEMIDLIST from the specified <readableString> path."

	^ITEMIDLIST fromAddress: (self pidlFromPath: path)!

ParseDisplayName: parseDisplayName pbc: pbc lpwszDisplayName: lpwszDisplayName pchEaten: pchEaten ppidl: ppidl pdwAttributes: pdwAttributes
	"Callout for the IShellFolder::ParseDisplayName() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in IShellFolder>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 4 handle lpvoid lpwstr dword* lppvoid dword*>
	^self invalidCall: _failureCode!

pidlFromPath: path
	"Answer a PIDL from the specified <readableString> path."

	| answer |
	answer := WindowsShellMemory new.
	self
		ParseDisplayName: nil
		pbc: nil
		lpwszDisplayName: path
		pchEaten: nil
		ppidl: answer
		pdwAttributes: nil.
	^answer!

SetNameOf: setNameOf pidl: pidl lpszName: lpszName uFlags: uFlags ppidlOut: ppidlOut
	"Callout for the IShellFolder::SetNameOf() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in IShellFolder>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 13 handle lpvoid lpwstr dword lppvoid>
	^self invalidCall: _failureCode! !
!OS.IShellFolder categoriesFor: #BindToObject:pbc:riid:ppvOut:!COM Interfaces-IShellFolder!public! !
!OS.IShellFolder categoriesFor: #BindToStorage:pbc:riid:ppv:!COM Interfaces-IShellFolder!public! !
!OS.IShellFolder categoriesFor: #CompareIDs:pidl1:pidl2:!COM Interfaces-IShellFolder!public! !
!OS.IShellFolder categoriesFor: #CreateViewObject:riid:ppvOut:!COM Interfaces-IShellFolder!public! !
!OS.IShellFolder categoriesFor: #EnumObjects:grfFlags:ppenumIDList:!COM Interfaces-IShellFolder!public! !
!OS.IShellFolder categoriesFor: #GetAttributesOf:apidl:rgfInOut:!COM Interfaces-IShellFolder!public! !
!OS.IShellFolder categoriesFor: #GetDisplayNameOf:uFlags:lpName:!COM Interfaces-IShellFolder!public! !
!OS.IShellFolder categoriesFor: #GetUIObjectOf:cidl:apidl:riid:prgfInOut:ppvOut:!COM Interfaces-IShellFolder!public! !
!OS.IShellFolder categoriesFor: #idlFromPath:!public! !
!OS.IShellFolder categoriesFor: #ParseDisplayName:pbc:lpwszDisplayName:pchEaten:ppidl:pdwAttributes:!COM Interfaces-IShellFolder!public! !
!OS.IShellFolder categoriesFor: #pidlFromPath:!operations!public! !
!OS.IShellFolder categoriesFor: #SetNameOf:pidl:lpszName:uFlags:ppidlOut:!COM Interfaces-IShellFolder!public! !

!OS.IShellFolder class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface IShellFolder
		IShellFolder compileFunctions
	"

	self
		defineFunction: #ParseDisplayName:pbc:lpwszDisplayName:pchEaten:ppidl:pdwAttributes:
			argumentTypes: 'handle void* lpwstr dword* lppvoid dword*';
		defineFunction: #EnumObjects:grfFlags:ppenumIDList:
			argumentTypes: 'handle dword lppvoid';
		defineFunction: #BindToObject:pbc:riid:ppvOut:
			argumentTypes: 'lpvoid void* GUID* lppvoid';
		defineFunction: #BindToStorage:pbc:riid:ppv:
			argumentTypes: 'lpvoid void* GUID* lppvoid';
		defineFunction: #CompareIDs:pidl1:pidl2:
			argumentTypes: 'dword lpvoid lpvoid';
		defineFunction: #CreateViewObject:riid:ppvOut:
			argumentTypes: 'handle GUID* lppvoid';
		defineFunction: #GetAttributesOf:apidl:rgfInOut:
			argumentTypes: 'dword lppvoid dword*';
		defineFunction: #GetUIObjectOf:cidl:apidl:riid:prgfInOut:ppvOut:
			argumentTypes: 'handle dword lppvoid GUID* dword* lppvoid';
		defineFunction: #GetDisplayNameOf:uFlags:lpName:
			argumentTypes: 'lpvoid dword lpvoid';
		defineFunction: #SetNameOf:pidl:lpszName:uFlags:ppidlOut:
			argumentTypes: 'handle lpvoid lpwstr dword lppvoid'
! !
!OS.IShellFolder class categoriesFor: #defineFunctions!initializing!public! !

