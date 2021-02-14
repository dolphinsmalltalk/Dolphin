"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'OS.COM.IPersist'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IPersist guid: (OS.COM.IID fromString: '{0000010c-0000-0000-c000-000000000046}')!
OS.COM.IPersist isNonInstantiable: true!
OS.COM.IPersist comment: '<IPersist> is a wrapper class for the custom interface ''OBJIDL.IPersist'' generated from type information in the ''ObjIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

IPersist is at the root of the COM persistance interface hierarchy. The single behaviour provided is an accessor to get the CLSID of the implementing object. Subclasses add the ability to persist to/from ole streams (IPersistStream[Init]), structured storages (IPersistStorage), property bags (IPersistPropertyBag[2]), files (IPersistFile), or a fixed size memory block (IPersistMemory). All of these subinterfaces have some form or Save and Load methods for pickling and reconstituting the implementing COM object.'!
!OS.COM.IPersist categoriesForClass!COM-Interfaces! !
!OS.COM.IPersist methodsFor!

clsid
	"Answer the receivers <CLSID>."

	| answer |
	answer := CLSID new.
	self GetClassID: answer.
	^answer!

GetClassID: pClassID
	"Invoke the GetClassID() method of the object wrapped by the receiver.
	
		HRESULT __stdcall GetClassID(
			[out] GUID* pClassID);
	"

	<virtual stdcall: hresult 4 guid*>
	^self invalidCall: _failureCode!

isDirty
	"Answer whether the receiver is 'dirty' (i.e. has unsaved modifications).
	The OLE documentation states that we should consider all errors to be an
	indication that the object has changed (we suppress the automatic exception
	generation for HRESULT error return values, by specifying that IsDirty()
	returns an SDWORD). IPersist itself does not implement this, but all of its
	sub-interfaces do."

	^self IsDirty ~~ S_FALSE!

IsDirty 
	"Private - Invoke the IsDirty() method of the COM object wrapped by the receiver."

	^self subclassResponsibility! !
!OS.COM.IPersist categoriesFor: #clsid!accessing!public! !
!OS.COM.IPersist categoriesFor: #GetClassID:!**auto generated**!COM Interfaces-OBJIDL.IPersist!primitives!public! !
!OS.COM.IPersist categoriesFor: #isDirty!public!testing! !
!OS.COM.IPersist categoriesFor: #IsDirty!private!testing! !

OS.COM.IPersist methodProtocol: #IPersist attributes: #(#readOnly) selectors: #(#GetClassID:)!

!OS.COM.IPersist class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OBJIDL.IPersist'
		IPersist defineTemplate
	"

	self
		defineFunction: #GetClassID:
			argumentTypes: 'GUID*'
! !
!OS.COM.IPersist class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

