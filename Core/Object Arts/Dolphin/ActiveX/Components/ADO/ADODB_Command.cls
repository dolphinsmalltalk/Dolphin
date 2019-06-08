"Filed out from Dolphin Smalltalk 7"!

ADODBCommand15 subclass: #ADODB_Command
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''!
ADODB_Command guid: (IID fromString: '{0000054E-0000-0010-8000-00AA006D2EA4}')!
ADODB_Command comment: '<ADODB_Command> is a wrapper class for the COM interface ''ADODB._Command'' generated from type information in the ''Microsoft ActiveX Data Objects 2.5 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!ADODB_Command categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB_Command methodsFor!

Cancel
	"Invoke the Cancel() method of the COM object.

		HRESULT __stdcall Cancel();"

	<virtual stdcall: hresult 26>
	^self invalidCall: _failureCode!

get_State: plObjState
	"Private - Get the value of the 'State' property of the receiver.
				HRESULT __stdcall State(
			[out, retval] long* plObjState);"

	<virtual stdcall: hresult 25 sdword*>
	^self invalidCall: _failureCode!

state
	"Answer the <sdword> value of the 'State' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_State: answer.
	^answer asObject
! !
!ADODB_Command categoriesFor: #Cancel!**auto generated**!COM Interfaces-_Command!public! !
!ADODB_Command categoriesFor: #get_State:!**auto generated**!COM Interfaces-_Command!private! !
!ADODB_Command categoriesFor: #state!**auto generated**!properties!public! !

!ADODB_Command class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (Command) for which the receiver is the default interface."

	^CLSID fromString: '{00000507-0000-0010-8000-00AA006D2EA4}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB._Command'
		ADODB_Command defineTemplate"

	self
		defineFunction: #get_State:
			argumentTypes: 'sdword*';
		defineFunction: #Cancel
! !
!ADODB_Command class categoriesFor: #clsid!**auto generated**!constants!private! !
!ADODB_Command class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

