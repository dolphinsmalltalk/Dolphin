"Filed out from Dolphin Smalltalk 7"!

ADODBField20 subclass: #ADODBField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''!
ADODBField guid: (IID fromString: '{00000569-0000-0010-8000-00AA006D2EA4}')!
ADODBField comment: '<ADODBField> is a wrapper class for the COM interface ''ADODB.Field'' generated from type information in the ''Microsoft ActiveX Data Objects 2.5 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!ADODBField categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODBField methodsFor!

get_Status: pFStatus
	"Private - Get the value of the 'Status' property of the receiver.
				HRESULT __stdcall Status(
			[out, retval] long* pFStatus);"

	<virtual stdcall: hresult 29 sdword*>
	^self invalidCall
!

status
	"Answer the <sdword> value of the 'Status' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_Status: answer.
	^answer asObject
! !
!ADODBField categoriesFor: #get_Status:!**auto generated**!COM Interfaces-Field!private! !
!ADODBField categoriesFor: #status!**auto generated**!properties!public! !

!ADODBField class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Field'
		ADODBField defineTemplate"

	self
		defineFunction: #get_Status:
			argumentTypes: 'sdword*'
! !
!ADODBField class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

