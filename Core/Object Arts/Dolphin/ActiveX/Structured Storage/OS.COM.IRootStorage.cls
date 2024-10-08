﻿"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown
	subclass: #'OS.COM.IRootStorage'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.IRootStorage guid: (OS.COM.IID fromString: '{00000012-0000-0000-c000-000000000046}')!

OS.COM.IRootStorage isEgressOnly: true!

OS.COM.IRootStorage comment: 'IRootStorage is a COMInterface class to wrap the standard COM interface of the same name.

IRootStorage is for saving a users data in low-memory situations. Its single method is used to switch a storage object to a different underlying file and to save the storage object to that file, which it guarantees to do, even in low-memory conditions.'!

!OS.COM.IRootStorage categoriesForClass!COM-Interfaces! !

!OS.COM.IRootStorage methodsFor!

SwitchToFile: pszFile
	"Invoke the SwitchToFile() method of the object wrapped by the receiver.
	
		HRESULT __stdcall SwitchToFile(
			[in] LPWSTR pszFile);

	"

	<virtual stdcall: hresult 4 lpwstr>
	^self invalidCall: _failureCode! !

!OS.COM.IRootStorage categoriesForMethods!
SwitchToFile:!**auto generated**!COM Interfaces-OBJIDL.IRootStorage!primitives!public! !
!

OS.COM.IRootStorage methodProtocol: #IRootStorage attributes: #(#readOnly) selectors: #(#SwitchToFile:)!

!OS.COM.IRootStorage class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OBJIDL.IRootStorage'
		IRootStorage defineTemplate
	"

	self defineFunction: #SwitchToFile: argumentTypes: 'lpwstr'! !

!OS.COM.IRootStorage class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

