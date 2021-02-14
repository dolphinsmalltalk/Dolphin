"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'OS.COM.IServiceProvider'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IServiceProvider guid: (OS.COM.IID fromString: '{6d5140c1-7436-11ce-8034-00aa006009fa}')!
OS.COM.IServiceProvider comment: '`OS.COM.IServiceProvider` is a wrapper class for the COM interface ''OCIDL.IServiceProvider'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!OS.COM.IServiceProvider categoriesForClass!COM-Interfaces! !
!OS.COM.IServiceProvider methodsFor!

queryService: guidService riid: riid
	"Query the 'service' identified by the <GUID>, guidService, answering an
	interface pointer of appropriate class for the <IID>, riid, on an object
	implementing that service."

	| answer |
	answer := (Interface classForIID: riid ifNone: [IUnknown]) newPointer.
	self
		QueryService: guidService
		riid: riid
		ppvObject: answer.
	^answer!

QueryService: guidService riid: riid ppvObject: ppvObject
	"Private - Invoke the QueryService() method of the COM object wrapped by the receiver.

		HRESULT __stdcall QueryService(
			[in] GUID* guidService,
			[in] GUID* riid,
			[out] IUnknown** ppvObject);
	"

	<virtual stdcall: hresult 4 guid* guid* IUnknown**>
	^self invalidCall: _failureCode! !
!OS.COM.IServiceProvider categoriesFor: #queryService:riid:!methods!public! !
!OS.COM.IServiceProvider categoriesFor: #QueryService:riid:ppvObject:!COM Interfaces-IServiceProvider!private! !

OS.COM.IServiceProvider methodProtocol: #IServiceProvider attributes: #(#readOnly) selectors: #(#QueryService:riid:ppvObject:)!

!OS.COM.IServiceProvider class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IServiceProvider'
		IServiceProvider defineTemplate
	"

	self
		defineFunction: #QueryService:riid:ppvObject:
			argumentTypes: 'GUID* GUID* IUnknown**'
! !
!OS.COM.IServiceProvider class categoriesFor: #defineFunctions!initializing!public! !

