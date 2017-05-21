"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IAdviseSink
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAdviseSink guid: (IID fromString: '{0000010F-0000-0000-C000-000000000046}')!
IAdviseSink comment: '<IAdviseSink> is a wrapper class for the COM interface ''OCIDL.IAdviseSink'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IAdviseSink categoriesForClass!COM-Interfaces! !
!IAdviseSink methodsFor!

OnClose 
	"Private - Invoke the OnClose() method of the COM object wrapped by the receiver.

		void __stdcall OnClose();
	"

	<virtual stdcall: hresult 8>
	^self invalidCall
!

OnDataChange: pFormatetc pStgmed: pStgmed
	"Private - Invoke the OnDataChange() method of the COM object wrapped by the receiver.

		void __stdcall OnDataChange(
			[in] FORMATETC* pFormatetc,
			[in] STGMEDIUM* pStgmed);
	"

	<virtual stdcall: hresult 4 FORMATETC* STGMEDIUM*>
	^self invalidCall
!

OnRename: pmk
	"Private - Invoke the OnRename() method of the COM object wrapped by the receiver.

		void __stdcall OnRename(
			[in] IMoniker* pmk);
	"

	<virtual stdcall: hresult 6 IMoniker*>
	^self invalidCall
!

OnSave
	"Private - Invoke the OnSave() method of the COM object wrapped by the receiver.

		void OnSave()
	"

	<virtual stdcall: hresult 7>
	^self invalidCall
!

OnViewChange: dwAspect lindex: lindex
	"Private - Invoke the RemoteOnViewChange() method of the COM object wrapped by the receiver.

		void __stdcall RemoteOnViewChange(
			[in] unsigned long dwAspect,
			[in] long lindex);
	"

	<virtual stdcall: hresult 5 dword sdword>
	^self invalidCall
! !
!IAdviseSink categoriesFor: #OnClose!COM Interfaces-IAdviseSink!private! !
!IAdviseSink categoriesFor: #OnDataChange:pStgmed:!COM Interfaces-IAdviseSink!private! !
!IAdviseSink categoriesFor: #OnRename:!COM Interfaces-IAdviseSink!private! !
!IAdviseSink categoriesFor: #OnSave!COM Interfaces-IAdviseSink!private! !
!IAdviseSink categoriesFor: #OnViewChange:lindex:!COM Interfaces-IAdviseSink!private! !

IAdviseSink methodProtocol: #IAdviseSink attributes: #() selectors: #(#OnClose #OnDataChange:pStgmed: #OnRename: #OnSave #OnViewChange:lindex:)!

!IAdviseSink class methodsFor!

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
!IAdviseSink class categoriesFor: #defineFunctions!initializing!public! !

