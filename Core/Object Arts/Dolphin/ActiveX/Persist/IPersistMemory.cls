"Filed out from Dolphin Smalltalk 7"!

IPersist subclass: #IPersistMemory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IPersistMemory guid: (IID fromString: '{BD1AE5E0-A6AE-11CE-BD37-504200C10000}')!
IPersistMemory comment: '<IPersistMemory> is a wrapper class for the COM interface ''OCIDL.IPersistMemory'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!IPersistMemory categoriesForClass!COM-Interfaces!OCIDL-Interfaces! !
!IPersistMemory methodsFor!

getSizeMax
	"Answer the <DWORD> result of invoking the COM Object's GetSizeMax() method."

	| answer |
	answer := (DWORD new).
	self
		GetSizeMax: answer.
	^answer asObject
!

GetSizeMax: pCbSize
	"Private - Invoke the GetSizeMax() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetSizeMax(
			[out] unsigned long* pCbSize);
	"

	<virtual stdcall: hresult 8 dword*>
	^self invalidCall
!

initNew  
	"Invoke the InitNew() method of the COM Object."

	self InitNew
!

InitNew 
	"Private - Invoke the InitNew() method of the COM object wrapped by the receiver.

		HRESULT __stdcall InitNew();
	"

	<virtual stdcall: hresult 9>
	^self invalidCall
!

IsDirty 
	"Private - Invoke the IsDirty() method of the COM object wrapped by the receiver.

		HRESULT __stdcall IsDirty();
	"

	<virtual stdcall: hresult 5>
	^self invalidCall
!

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

	<virtual stdcall: hresult 6 byte* dword>
	^self invalidCall
!

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

	<virtual stdcall: hresult 7 byte* sdword dword>
	^self invalidCall
! !
!IPersistMemory categoriesFor: #getSizeMax!**auto generated**!methods!public! !
!IPersistMemory categoriesFor: #GetSizeMax:!**auto generated**!COM Interfaces-IPersistMemory!private! !
!IPersistMemory categoriesFor: #initNew!**auto generated**!methods!public! !
!IPersistMemory categoriesFor: #InitNew!**auto generated**!COM Interfaces-IPersistMemory!private! !
!IPersistMemory categoriesFor: #IsDirty!**auto generated**!COM Interfaces-IPersistMemory!private! !
!IPersistMemory categoriesFor: #load:!methods!public! !
!IPersistMemory categoriesFor: #Load:cbSize:!COM Interfaces-IPersistMemory!private! !
!IPersistMemory categoriesFor: #save:!methods!public! !
!IPersistMemory categoriesFor: #save:cbSize:!methods!public! !
!IPersistMemory categoriesFor: #Save:fClearDirty:cbSize:!COM Interfaces-IPersistMemory!private! !

IPersistMemory methodProtocol: #IPersistMemory attributes: #(#readOnly) selectors: #(#GetSizeMax: #InitNew #IsDirty #Load:cbSize: #Save:fClearDirty:cbSize:)!

!IPersistMemory class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IPersistMemory'
		IPersistMemory defineTemplate
	"

	self
		defineFunction: #IsDirty;
		defineFunction: #Load:cbSize:
			argumentTypes: 'byte* dword';
		defineFunction: #Save:fClearDirty:cbSize:
			argumentTypes: 'byte* sdword dword';
		defineFunction: #GetSizeMax:
			argumentTypes: 'dword*';
		defineFunction: #InitNew
! !
!IPersistMemory class categoriesFor: #defineFunctions!initializing!public! !

