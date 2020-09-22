"Filed out from Dolphin Smalltalk 7"!

ADODBCommand15 subclass: #ADODBCommand25
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
ADODBCommand25 guid: (IID fromString: '{0000154e-0000-0010-8000-00aa006d2ea4}')!
ADODBCommand25 comment: '`ADODBCommand25` is a wrapper class for the COM interface ''ADODB.Command25'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

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
!ADODBCommand25 categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODBCommand25 methodsFor!

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
!ADODBCommand25 categoriesFor: #Cancel!**auto generated**!COM Interfaces-Command25!public! !
!ADODBCommand25 categoriesFor: #get_State:!**auto generated**!COM Interfaces-Command25!private! !
!ADODBCommand25 categoriesFor: #state!**auto generated**!properties!public! !

!ADODBCommand25 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Command25'
		ADODBCommand25 defineTemplate"

	self
		defineFunction: #get_State:
			argumentTypes: 'sdword*';
		defineFunction: #Cancel
! !
!ADODBCommand25 class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

