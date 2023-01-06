"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown subclass: #'OS.COM.IAdviseSink'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IAdviseSink guid: (OS.COM.IID fromString: '{0000010f-0000-0000-c000-000000000046}')!
OS.COM.IAdviseSink comment: '<IAdviseSink> is a wrapper class for the COM interface ''OCIDL.IAdviseSink'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!OS.COM.IAdviseSink categoriesForClass!OBJIDL-Interfaces! !
!OS.COM.IAdviseSink methodsFor!

OnClose
	"Invoke the RemoteOnClose() method of the COM object.

		HRESULT __stdcall RemoteOnClose();"

	<virtual stdcall: hresult 8>
	^self invalidCall: _failureCode!

OnDataChange: pformatetc pStgmed: pStgmed
	"Invoke the OnDataChange() method of the COM object.

		HRESULT __stdcall OnDataChange(
			[in]FORMATETC* pformatetc,
			[in]STGMEDIUM* pStgmed);"

	<virtual stdcall: hresult 4 FORMATETC* STGMEDIUM*>
	^self invalidCall: _failureCode!

OnRename: pmk
	"Invoke the OnRename() method of the COM object.

		HRESULT __stdcall OnRename(
			[in]IMoniker* pmk);"

	<virtual stdcall: hresult 6 IMoniker*>
	^self invalidCall: _failureCode!

OnSave
	"Invoke the OnSave() method of the COM object.

		HRESULT __stdcall OnSave();"

	<virtual stdcall: hresult 7>
	^self invalidCall: _failureCode!

OnViewChange: dwAspect lindex: lindex
	"Invoke the OnViewChange() method of the COM object.

		HRESULT __stdcall OnViewChange(
			[in]unsigned long dwAspect,
			[in]long lindex);"

	<virtual stdcall: hresult 5 dword sdword>
	^self invalidCall: _failureCode! !
!OS.COM.IAdviseSink categoriesForMethods!
OnClose!**auto generated**!COM Interfaces-IAdviseSink!public! !
OnDataChange:pStgmed:!**auto generated**!COM Interfaces-IAdviseSink!public! !
OnRename:!**auto generated**!COM Interfaces-IAdviseSink!public! !
OnSave!**auto generated**!COM Interfaces-IAdviseSink!public! !
OnViewChange:lindex:!**auto generated**!COM Interfaces-IAdviseSink!public! !
!

OS.COM.IAdviseSink methodProtocol: #IAdviseSink attributes: #() selectors: #(#OnClose #OnDataChange:pStgmed: #OnRename: #OnSave #OnViewChange:lindex:)!

!OS.COM.IAdviseSink class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IAdviseSink'
		IAdviseSink defineTemplate

	N.B. IAdviseSink is unusual in that it is asynchronous, and therefore there are no return values.
	"

	self
		defineFunction: #OnDataChange:pStgmed:
			returnType: 'void'
			argumentTypes: 'FORMATETC* STGMEDIUM*';
		defineFunction: #OnViewChange:lindex:
			returnType: 'void'
			argumentTypes: 'dword sdword';
		defineFunction: #OnRename:
			returnType: 'void'
			argumentTypes: 'IMoniker*';
		defineFunction: #OnSave
			returnType: 'void';
		defineFunction: #OnClose
			returnType: 'void'
! !
!OS.COM.IAdviseSink class categoriesForMethods!
defineFunctions!initializing!public! !
!

