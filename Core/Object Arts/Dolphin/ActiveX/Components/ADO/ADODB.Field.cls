"Filed out from Dolphin Smalltalk"!

ADODB.Field20
	subclass: #'ADODB.Field'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

ADODB.Field guid: (OS.COM.IID fromString: '{00001569-0000-0010-8000-00aa006d2ea4}')!

ADODB.Field comment: '`Field` is a wrapper class for the COM interface ''ADODB.Field'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00001569-0000-0010-8000-00aa006d2ea4), 
	helpcontext(0x0012c908), 
	hidden, 
	nonextensible, 
	dual
]
interface Field : Field20
 {
	[id(0x0000045c), propget, helpcontext(0x0012c90e)]
	HRESULT __stdcall Status(
		[out, retval]long* pFStatus);
};
```
'!

!ADODB.Field categoriesForClass!ADODB-Interfaces!COM-Interfaces! !

!ADODB.Field methodsFor!

get_Status: pFStatus
	"Private - Get the value of the 'Status' property of the receiver.

		HRESULT __stdcall Status(
			[out, retval]long* pFStatus);"

	<virtual stdcall: hresult 29 int32*>
	^self invalidCall: _failureCode!

status
	"Answer the <sdword> value of the 'Status' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_Status: answer.
	^answer asObject! !

!ADODB.Field categoriesForMethods!
get_Status:!**auto generated**!COM Interfaces-Field!private! !
status!**auto generated**!properties!public! !
!

!ADODB.Field class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Field'
		Field defineTemplate"

	self
		defineFunction: #get_Status:
			argumentTypes: 'sdword*'
! !

!ADODB.Field class categoriesForMethods!
defineFunctions!**auto generated**!initializing!private! !
!

