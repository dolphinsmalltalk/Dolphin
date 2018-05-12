"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ADODBADOStreamConstruction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''!
ADODBADOStreamConstruction guid: (IID fromString: '{00000568-0000-0010-8000-00AA006D2EA4}')!
ADODBADOStreamConstruction comment: '<ADODBADOStreamConstruction> is a wrapper class for the COM interface ''ADODB.ADOStreamConstruction'' generated from type information in the ''Microsoft ActiveX Data Objects 2.5 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!ADODBADOStreamConstruction categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODBADOStreamConstruction methodsFor!

get_Stream: ppStm
	"Private - Get the value of the 'Stream' property of the receiver.
				HRESULT __stdcall Stream(
			[out, retval] IUnknown** ppStm);"

	<virtual stdcall: hresult 8 IUnknown**>
	^self invalidCall
!

put_Stream: ppStm
	"Private - Set the value of the 'Stream' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, ppStm.
				HRESULT __stdcall Stream(
			[in] IUnknown* ppStm);"

	<virtual stdcall: hresult 9 IUnknown*>
	^self invalidCall
!

stream
	"Answer the <IUnknown> value of the 'Stream' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get_Stream: answer.
	^answer asObject
!

stream: ppStm
	"Set the 'Stream' property of the receiver to the <IUnknown*> value of the argument."

	self put_Stream: ppStm
! !
!ADODBADOStreamConstruction categoriesFor: #get_Stream:!**auto generated**!COM Interfaces-ADOStreamConstruction!private! !
!ADODBADOStreamConstruction categoriesFor: #put_Stream:!**auto generated**!COM Interfaces-ADOStreamConstruction!private! !
!ADODBADOStreamConstruction categoriesFor: #stream!**auto generated**!properties!public! !
!ADODBADOStreamConstruction categoriesFor: #stream:!**auto generated**!properties!public! !

!ADODBADOStreamConstruction class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.ADOStreamConstruction'
		ADODBADOStreamConstruction defineTemplate"

	self
		defineFunction: #get_Stream:
			argumentTypes: 'IUnknown**';
		defineFunction: #put_Stream:
			argumentTypes: 'IUnknown*'
! !
!ADODBADOStreamConstruction class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

