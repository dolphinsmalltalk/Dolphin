"Filed out from Dolphin Smalltalk"!

OS.COM.Examples.IRandomStream
	subclass: #'OS.COM.Examples.IRandomStream2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Examples.IRandomStream2 guid: (OS.COM.IID fromString: '{32829fc4-b067-4665-99ae-8f9e452d996e}')!

OS.COM.Examples.IRandomStream2 comment: '`IRandomStream2` is a wrapper class for the COM interface ''RANDOMLib.IRandomStream2'' generated from type information in the ''Random 1.1 Type Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IRandomStream2 Interface"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(32829fc4-b067-4665-99ae-8f9e452d996e), 
	helpstring("IRandomStream2 Interface"), 
	restricted, 
	nonextensible, 
	dual
]
interface IRandomStream2 : IRandomStream
 {
	[id(0x00000005), propget, helpstring("LCG multiplier")]
	HRESULT __stdcall Multiplier(
		[out, retval]unsigned long* pVal);
	[id(0x00000005), propput, helpstring("LCG multiplier")]
	HRESULT __stdcall Multiplier(
		[in]unsigned long pVal);
	[id(0x00000006), propget, helpstring("LCG increment")]
	HRESULT __stdcall Increment(
		[out, retval]unsigned long* pVal);
	[id(0x00000006), propput, helpstring("LCG increment")]
	HRESULT __stdcall Increment(
		[in]unsigned long pVal);
	[id(0x00000007), propget, helpstring("LCG modulus")]
	HRESULT __stdcall Modulus(
		[out, retval]unsigned long* pVal);
	[id(0x00000007), propput, helpstring("LCG modulus")]
	HRESULT __stdcall Modulus(
		[in]unsigned long pVal);
};
```
'!

!OS.COM.Examples.IRandomStream2 categoriesForClass!COM-Interfaces!RANDOMLib-Interfaces! !

!OS.COM.Examples.IRandomStream2 methodsFor!

get_Increment: pVal
	"Private - Get the value of the 'Increment' property of the receiver.

		HRESULT __stdcall Increment(
			[out, retval]unsigned long* pVal);"

	<virtual stdcall: hresult 17 uint32*>
	^self invalidCall: _failureCode!

get_Modulus: pVal
	"Private - Get the value of the 'Modulus' property of the receiver.

		HRESULT __stdcall Modulus(
			[out, retval]unsigned long* pVal);"

	<virtual stdcall: hresult 19 uint32*>
	^self invalidCall: _failureCode!

get_Multiplier: pVal
	"Private - Get the value of the 'Multiplier' property of the receiver.

		HRESULT __stdcall Multiplier(
			[out, retval]unsigned long* pVal);"

	<virtual stdcall: hresult 15 uint32*>
	^self invalidCall: _failureCode!

increment
	"Answer the <uint32> value of the 'Increment' property of the receiver.
	Helpstring: LCG increment"

	| answer |
	answer := UInt32 new.
	self get_Increment: answer.
	^answer asObject!

increment: pVal
	"Set the 'Increment' property of the receiver to the <uint32> value of the argument.
	Helpstring: LCG increment"

	self put_Increment: pVal!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

modulus
	"Answer the <uint32> value of the 'Modulus' property of the receiver.
	Helpstring: LCG modulus"

	| answer |
	answer := UInt32 new.
	self get_Modulus: answer.
	^answer asObject!

modulus: pVal
	"Set the 'Modulus' property of the receiver to the <uint32> value of the argument.
	Helpstring: LCG modulus"

	self put_Modulus: pVal!

multiplier
	"Answer the <uint32> value of the 'Multiplier' property of the receiver.
	Helpstring: LCG multiplier"

	| answer |
	answer := UInt32 new.
	self get_Multiplier: answer.
	^answer asObject!

multiplier: pVal
	"Set the 'Multiplier' property of the receiver to the <uint32> value of the argument.
	Helpstring: LCG multiplier"

	self put_Multiplier: pVal!

put_Increment: pVal
	"Private - Set the value of the 'Increment' property of the object wrapped by the 
	 receiver to the <uint32> argument, pVal.

		HRESULT __stdcall Increment(
			[in]unsigned long pVal);"

	<virtual stdcall: hresult 18 uint32>
	^self invalidCall: _failureCode!

put_Modulus: pVal
	"Private - Set the value of the 'Modulus' property of the object wrapped by the 
	 receiver to the <uint32> argument, pVal.

		HRESULT __stdcall Modulus(
			[in]unsigned long pVal);"

	<virtual stdcall: hresult 20 uint32>
	^self invalidCall: _failureCode!

put_Multiplier: pVal
	"Private - Set the value of the 'Multiplier' property of the object wrapped by the 
	 receiver to the <uint32> argument, pVal.

		HRESULT __stdcall Multiplier(
			[in]unsigned long pVal);"

	<virtual stdcall: hresult 16 uint32>
	^self invalidCall: _failureCode! !

!OS.COM.Examples.IRandomStream2 categoriesForMethods!
get_Increment:!**auto generated**!COM Interfaces-IRandomStream2!private! !
get_Modulus:!**auto generated**!COM Interfaces-IRandomStream2!private! !
get_Multiplier:!**auto generated**!COM Interfaces-IRandomStream2!private! !
increment!**auto generated**!properties!public! !
increment:!**auto generated**!properties!public! !
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
modulus!**auto generated**!properties!public! !
modulus:!**auto generated**!properties!public! !
multiplier!**auto generated**!properties!public! !
multiplier:!**auto generated**!properties!public! !
put_Increment:!**auto generated**!COM Interfaces-IRandomStream2!private! !
put_Modulus:!**auto generated**!COM Interfaces-IRandomStream2!private! !
put_Multiplier:!**auto generated**!COM Interfaces-IRandomStream2!private! !
!

!OS.COM.Examples.IRandomStream2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'RANDOMLib.IRandomStream2'
		IRandomStream2 defineTemplate"

	self
		defineFunction: #get_Multiplier:
			argumentTypes: 'uint32*';
		defineFunction: #put_Multiplier:
			argumentTypes: 'uint32';
		defineFunction: #get_Increment:
			argumentTypes: 'uint32*';
		defineFunction: #put_Increment:
			argumentTypes: 'uint32';
		defineFunction: #get_Modulus:
			argumentTypes: 'uint32*';
		defineFunction: #put_Modulus:
			argumentTypes: 'uint32'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IRandomStream2 initializeTypeLib"

	typeLib := RANDOMLib! !

!OS.COM.Examples.IRandomStream2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
initializeTypeLib!**auto generated**!initializing!private! !
!

