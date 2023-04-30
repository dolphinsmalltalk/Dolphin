"Filed out from Dolphin Smalltalk"!

OS.COM.IPersist
	subclass: #'OS.COM.IPersistMemory'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IPersistMemory guid: (OS.COM.IID fromString: '{bd1ae5e0-a6ae-11ce-bd37-504200c10000}')!
OS.COM.IPersistMemory comment: '<IPersistMemory> is a wrapper class for the COM interface ''OCIDL.IPersistMemory'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!OS.COM.IPersistMemory categoriesForClass!COM-Interfaces!OCIDL-Interfaces! !
!OS.COM.IPersistMemory methodsFor!

getSizeMax
	"Answer the <UInt32> result of invoking the COM Object's GetSizeMax() method."

	| answer |
	answer := (UInt32 new).
	self
		GetSizeMax: answer.
	^answer asObject
!

GetSizeMax: pCbSize
	"Private - Invoke the GetSizeMax() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetSizeMax(
			[out] unsigned long* pCbSize);
	"

	<virtual stdcall: hresult 8 uint32*>
	^self invalidCall: _failureCode!

initNew  
	"Invoke the InitNew() method of the COM Object."

	self InitNew
!

InitNew
	"Private - Invoke the InitNew() method of the COM object wrapped by the receiver.

		HRESULT __stdcall InitNew();
	"

	<virtual stdcall: hresult 9>
	^self invalidCall: _failureCode!

IsDirty
	"Private - Invoke the IsDirty() method of the COM object wrapped by the receiver.

		HRESULT __stdcall IsDirty();
	"

	<virtual stdcall: hresult 5>
	^self invalidCall: _failureCode!

load: aByteArray
	"Load the object from the <ByteArray>, aByteArray."

	self
		Load: aByteArray
		cbSize: aByteArray size
!

Load: pMem cbSize: cbSize
	"Private - Invoke the Load() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Load(
			[in] char* pMem,
			[in] unsigned long cbSize);
	"

	<virtual stdcall: hresult 6 uint8* uint32>
	^self invalidCall: _failureCode!

save: fClearDirty
	"Answer a <ByteArray> containing the persisted representation of the object 
	implementing this interface."

	^self save: fClearDirty cbSize: self getSizeMax
!

save: fClearDirty cbSize: cbSize 
	"Answer a <ByteArray> of <integer> size, cbSize, containing the persisted
	representation of the object implementing this interface."

	| answer |
	answer := ByteArray new: cbSize.
	self
		Save: answer
		fClearDirty: fClearDirty
		cbSize: cbSize.
	^answer
!

Save: pMem fClearDirty: fClearDirty cbSize: cbSize
	"Private - Invoke the Save() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Save(
			[out] char* pMem,
			[in] long fClearDirty,
			[in] unsigned long cbSize);
	"

	<virtual stdcall: hresult 7 uint8* int32 uint32>
	^self invalidCall: _failureCode! !
!OS.COM.IPersistMemory categoriesForMethods!
getSizeMax!**auto generated**!methods!public! !
GetSizeMax:!**auto generated**!COM Interfaces-IPersistMemory!private! !
initNew!**auto generated**!methods!public! !
InitNew!**auto generated**!COM Interfaces-IPersistMemory!private! !
IsDirty!**auto generated**!COM Interfaces-IPersistMemory!private! !
load:!methods!public! !
Load:cbSize:!COM Interfaces-IPersistMemory!private! !
save:!methods!public! !
save:cbSize:!methods!public! !
Save:fClearDirty:cbSize:!COM Interfaces-IPersistMemory!private! !
!

OS.COM.IPersistMemory methodProtocol: #IPersistMemory attributes: #(#readOnly) selectors: #(#GetSizeMax: #InitNew #IsDirty #Load:cbSize: #Save:fClearDirty:cbSize:)!

!OS.COM.IPersistMemory class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IPersistMemory'
		IPersistMemory defineTemplate
	"

	self
		defineFunction: #IsDirty;
		defineFunction: #Load:cbSize:
			argumentTypes: 'byte* uint32';
		defineFunction: #Save:fClearDirty:cbSize:
			argumentTypes: 'byte* int32 uint32';
		defineFunction: #GetSizeMax:
			argumentTypes: 'uint32*';
		defineFunction: #InitNew
! !
!OS.COM.IPersistMemory class categoriesForMethods!
defineFunctions!initializing!public! !
!

