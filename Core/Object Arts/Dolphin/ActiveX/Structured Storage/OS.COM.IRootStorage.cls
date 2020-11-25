"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IRootStorage
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IRootStorage guid: (IID fromString: '{00000012-0000-0000-c000-000000000046}')!
IRootStorage comment: 'IRootStorage is a COMInterface class to wrap the standard COM interface of the same name.

IRootStorage is for saving a users data in low-memory situations. Its single method is used to switch a storage object to a different underlying file and to save the storage object to that file, which it guarantees to do, even in low-memory conditions.'!
!IRootStorage categoriesForClass!COM-Interfaces! !
!IRootStorage methodsFor!

SwitchToFile: pszFile
	"Invoke the SwitchToFile() method of the object wrapped by the receiver.
	
		HRESULT __stdcall SwitchToFile(
			[in] LPWSTR pszFile);

	"

	<virtual stdcall: hresult 4 lpwstr>
	^self invalidCall: _failureCode! !
!IRootStorage categoriesFor: #SwitchToFile:!**auto generated**!COM Interfaces-OBJIDL.IRootStorage!primitives!public! !

IRootStorage methodProtocol: #IRootStorage attributes: #(#readOnly) selectors: #(#SwitchToFile:)!

!IRootStorage class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OBJIDL.IRootStorage'
		IRootStorage defineTemplate
	"

	self defineFunction: #SwitchToFile: argumentTypes: 'lpwstr'! !
!IRootStorage class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

