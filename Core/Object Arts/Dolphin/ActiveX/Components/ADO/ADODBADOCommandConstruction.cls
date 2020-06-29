"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #ADODBADOCommandConstruction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
ADODBADOCommandConstruction guid: (IID fromString: '{00000517-0000-0010-8000-00aa006d2ea4}')!
ADODBADOCommandConstruction comment: '<ADODBADOCommandConstruction> is a wrapper class for the COM interface ''ADODB.ADOCommandConstruction'' generated from type information in the ''Microsoft ActiveX Data Objects 2.5 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!ADODBADOCommandConstruction categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODBADOCommandConstruction methodsFor!

get_OLEDBCommand: ppOLEDBCommand
	"Private - Get the value of the 'OLEDBCommand' property of the receiver.

		HRESULT __stdcall OLEDBCommand(
			[out, retval]IUnknown** ppOLEDBCommand);"

	<virtual stdcall: hresult 4 IUnknown**>
	^self invalidCall: _failureCode!

oledbCommand
	"Answer the <IUnknown> value of the 'OLEDBCommand' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get_OLEDBCommand: answer.
	^answer asObject!

oledbCommand: ppOLEDBCommand
	"Set the 'OLEDBCommand' property of the receiver to the <IUnknown*> value of the argument."

	self put_OLEDBCommand: ppOLEDBCommand!

put_OLEDBCommand: ppOLEDBCommand
	"Private - Set the value of the 'OLEDBCommand' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, ppOLEDBCommand.

		HRESULT __stdcall OLEDBCommand(
			[in]IUnknown* ppOLEDBCommand);"

	<virtual stdcall: hresult 5 IUnknown*>
	^self invalidCall: _failureCode! !
!ADODBADOCommandConstruction categoriesFor: #get_OLEDBCommand:!**auto generated**!COM Interfaces-ADOCommandConstruction!private! !
!ADODBADOCommandConstruction categoriesFor: #oledbCommand!**auto generated**!properties!public! !
!ADODBADOCommandConstruction categoriesFor: #oledbCommand:!**auto generated**!properties!public! !
!ADODBADOCommandConstruction categoriesFor: #put_OLEDBCommand:!**auto generated**!COM Interfaces-ADOCommandConstruction!private! !

!ADODBADOCommandConstruction class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.ADOCommandConstruction'
		ADODBADOCommandConstruction defineTemplate"

	self
		defineFunction: #get_OLEDBCommand:
			argumentTypes: 'IUnknown**';
		defineFunction: #put_OLEDBCommand:
			argumentTypes: 'IUnknown*'
! !
!ADODBADOCommandConstruction class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

