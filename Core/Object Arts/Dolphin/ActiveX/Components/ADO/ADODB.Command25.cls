"Filed out from Dolphin Smalltalk 7"!

ADODB.Command15 subclass: #'ADODB.Command25'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB.Command25 guid: (OS.COM.IID fromString: '{0000154e-0000-0010-8000-00aa006d2ea4}')!
ADODB.Command25 comment: '`ADODBCommand25` is a wrapper class for the COM interface ''ADODB.Command25'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(0000154e-0000-0010-8000-00aa006d2ea4), 
	helpcontext(0x0012c902), 
	hidden, 
	nonextensible, 
	dual
]
interface Command25 : Command15
 {
	[id(0x00000009), propget, helpcontext(0x0012c948)]
	HRESULT __stdcall State(
		[out, retval]long* plObjState);
	[id(0x0000000a), helpcontext(0x0012c8b8)]
	HRESULT __stdcall Cancel();
};
```
'!
!ADODB.Command25 categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB.Command25 methodsFor!

Cancel
	"Invoke the Cancel() method of the COM object.

		HRESULT __stdcall Cancel();"

	<virtual stdcall: hresult 26>
	^self invalidCall: _failureCode!

get_State: plObjState
	"Private - Get the value of the 'State' property of the receiver.

		HRESULT __stdcall State(
			[out, retval]long* plObjState);"

	<virtual stdcall: hresult 25 sdword*>
	^self invalidCall: _failureCode!

state
	"Answer the <sdword> value of the 'State' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_State: answer.
	^answer asObject! !
!ADODB.Command25 categoriesFor: #Cancel!**auto generated**!COM Interfaces-Command25!public! !
!ADODB.Command25 categoriesFor: #get_State:!**auto generated**!COM Interfaces-Command25!private! !
!ADODB.Command25 categoriesFor: #state!**auto generated**!properties!public! !

!ADODB.Command25 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Command25'
		Command25 defineTemplate"

	self
		defineFunction: #get_State:
			argumentTypes: 'sdword*';
		defineFunction: #Cancel
! !
!ADODB.Command25 class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

