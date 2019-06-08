"Filed out from Dolphin Smalltalk 7"!

ADODB_DynaCollection subclass: #ADODBParameters
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''!
ADODBParameters guid: (IID fromString: '{0000050D-0000-0010-8000-00AA006D2EA4}')!
ADODBParameters comment: '<ADODBParameters> is a wrapper class for the COM interface ''ADODB.Parameters'' generated from type information in the ''Microsoft ActiveX Data Objects 2.5 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!ADODBParameters categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODBParameters methodsFor!

get_Item: index ppvObject: ppvObject
	"Private - Get the value of the 'Item' property of the receiver.
				HRESULT __stdcall Item(
			[in] VARIANT Index,
			[out, retval] _Parameter** ppvObject);"

	<virtual stdcall: hresult 13 variant ADODB_Parameter**>
	^self invalidCall: _failureCode!

item: index
	"Answer the <ADODB_Parameter> value of the 'Item' property of the receiver."

	| answer |
	answer := ADODB_Parameter newPointer.
	self
		get_Item: index asVariant
		ppvObject: answer.
	^answer asObject
! !
!ADODBParameters categoriesFor: #get_Item:ppvObject:!**auto generated**!COM Interfaces-Parameters!private! !
!ADODBParameters categoriesFor: #item:!**auto generated**!properties!public! !

!ADODBParameters class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Parameters'
		ADODBParameters defineTemplate"

	self
		defineFunction: #get_Item:ppvObject:
			argumentTypes: 'variant ADODB_Parameter**'
! !
!ADODBParameters class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

