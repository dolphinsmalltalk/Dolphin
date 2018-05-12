"Filed out from Dolphin Smalltalk 7"!

ADODB_Collection subclass: #ADODBErrors
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''!
ADODBErrors guid: (IID fromString: '{00000501-0000-0010-8000-00AA006D2EA4}')!
ADODBErrors comment: '<ADODBErrors> is a wrapper class for the COM interface ''ADODB.Errors'' generated from type information in the ''Microsoft ActiveX Data Objects 2.5 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!ADODBErrors categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODBErrors methodsFor!

Clear
	"Invoke the Clear() method of the COM object.

		HRESULT __stdcall Clear();"

	<virtual stdcall: hresult 12>
	^self invalidCall
!

get_Item: index ppvObject: ppvObject
	"Private - Get the value of the 'Item' property of the receiver.
				HRESULT __stdcall Item(
			[in] VARIANT Index,
			[out, retval] Error** ppvObject);"

	<virtual stdcall: hresult 11 variant ADODBError**>
	^self invalidCall
!

item: index
	"Answer the <ADODBError> value of the 'Item' property of the receiver."

	| answer |
	answer := ADODBError newPointer.
	self
		get_Item: index asVariant
		ppvObject: answer.
	^answer asObject
! !
!ADODBErrors categoriesFor: #Clear!**auto generated**!COM Interfaces-Errors!public! !
!ADODBErrors categoriesFor: #get_Item:ppvObject:!**auto generated**!COM Interfaces-Errors!private! !
!ADODBErrors categoriesFor: #item:!**auto generated**!properties!public! !

!ADODBErrors class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Errors'
		ADODBErrors defineTemplate"

	self
		defineFunction: #get_Item:ppvObject:
			argumentTypes: 'variant ADODBError**';
		defineFunction: #Clear
! !
!ADODBErrors class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

