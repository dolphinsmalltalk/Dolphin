"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'ADODB.IRecFields'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB.IRecFields guid: (OS.COM.IID fromString: '{00000563-0000-0010-8000-00aa006d2ea4}')!
ADODB.IRecFields comment: '<ADODBIRecFields> is a wrapper class for the COM interface ''ADODB.IRecFields'' generated from type information in the ''Microsoft ActiveX Data Objects 2.5 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!ADODB.IRecFields categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB.IRecFields methodsFor!

ADOCheck
	"Invoke the ADOCheck() method of the COM object.

		HRESULT __stdcall ADOCheck();"

	<virtual stdcall: hresult 4>
	^self invalidCall: _failureCode! !
!ADODB.IRecFields categoriesFor: #ADOCheck!**auto generated**!COM Interfaces-IRecFields!public! !

!ADODB.IRecFields class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.IRecFields'
		IRecFields defineTemplate"

	self
		defineFunction: #ADOCheck
! !
!ADODB.IRecFields class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

