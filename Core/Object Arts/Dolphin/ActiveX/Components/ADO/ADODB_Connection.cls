"Filed out from Dolphin Smalltalk 7"!

ADODBConnection15 subclass: #ADODB_Connection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''!
ADODB_Connection guid: (IID fromString: '{00000550-0000-0010-8000-00AA006D2EA4}')!
ADODB_Connection comment: '<ADODB_Connection> is a wrapper class for the COM interface ''ADODB._Connection'' generated from type information in the ''Microsoft ActiveX Data Objects 2.5 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!ADODB_Connection categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB_Connection methodsFor!

Cancel
	"Invoke the Cancel() method of the COM object.

		HRESULT __stdcall Cancel();"

	<virtual stdcall: hresult 37>
	^self invalidCall: _failureCode! !
!ADODB_Connection categoriesFor: #Cancel!**auto generated**!COM Interfaces-_Connection!public! !

!ADODB_Connection class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (Connection) for which the receiver is the default interface."

	^CLSID fromString: '{00000514-0000-0010-8000-00AA006D2EA4}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB._Connection'
		ADODB_Connection defineTemplate"

	self
		defineFunction: #Cancel
! !
!ADODB_Connection class categoriesFor: #clsid!**auto generated**!constants!private! !
!ADODB_Connection class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

