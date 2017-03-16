"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ADODB_ADO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''!
ADODB_ADO guid: (IID fromString: '{00000534-0000-0010-8000-00AA006D2EA4}')!
ADODB_ADO comment: '<ADODB_ADO> is a wrapper class for the COM interface ''ADODB._ADO'' generated from type information in the ''Microsoft ActiveX Data Objects 2.5 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!ADODB_ADO categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB_ADO methodsFor!

get_Properties: ppvObject
	"Private - Get the value of the 'Properties' property of the receiver.
				HRESULT __stdcall Properties(
			[out, retval] Properties** ppvObject);"

	<virtual stdcall: hresult 8 ADODBProperties**>
	^self invalidCall
!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

properties
	"Answer the <ADODBProperties> value of the 'Properties' property of the receiver."

	| answer |
	answer := ADODBProperties newPointer.
	self get_Properties: answer.
	^answer asObject
! !
!ADODB_ADO categoriesFor: #get_Properties:!**auto generated**!COM Interfaces-_ADO!private! !
!ADODB_ADO categoriesFor: #isExtensible!**auto generated**!public!testing! !
!ADODB_ADO categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ADODB_ADO categoriesFor: #properties!**auto generated**!properties!public! !

!ADODB_ADO class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB._ADO'
		ADODB_ADO defineTemplate"

	self
		defineFunction: #get_Properties:
			argumentTypes: 'ADODBProperties**'
! !
!ADODB_ADO class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

