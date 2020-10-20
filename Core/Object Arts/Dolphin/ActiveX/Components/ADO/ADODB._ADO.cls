"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'ADODB._ADO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB._ADO guid: (OS.COM.IID fromString: '{00000534-0000-0010-8000-00aa006d2ea4}')!
ADODB._ADO comment: '`_ADO` is a wrapper class for the COM interface ''ADODB._ADO'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00000534-0000-0010-8000-00aa006d2ea4), 
	nonextensible, 
	dual
]
interface _ADO : IDispatch
 {
	[id(0x000001f4), propget, helpcontext(0x0012c900)]
	HRESULT __stdcall Properties(
		[out, retval]Properties** ppvObject);
};
```
'!
!ADODB._ADO categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB._ADO methodsFor!

get_Properties: ppvObject
	"Private - Get the value of the 'Properties' property of the receiver.

		HRESULT __stdcall Properties(
			[out, retval]Properties** ppvObject);"

	<virtual stdcall: hresult 8 Properties**>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

properties
	"Answer the <Properties> value of the 'Properties' property of the receiver."

	| answer |
	answer := Properties newPointer.
	self get_Properties: answer.
	^answer asObject! !
!ADODB._ADO categoriesFor: #get_Properties:!**auto generated**!COM Interfaces-_ADO!private! !
!ADODB._ADO categoriesFor: #isExtensible!**auto generated**!public!testing! !
!ADODB._ADO categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ADODB._ADO categoriesFor: #properties!**auto generated**!properties!public! !

!ADODB._ADO class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB._ADO'
		_ADO defineTemplate"

	self
		defineFunction: #get_Properties:
			argumentTypes: 'Properties**'
! !
!ADODB._ADO class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

