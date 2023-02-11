"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch subclass: #'OS.COM.Examples.IRandomStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.Examples.IRandomStream guid: (OS.COM.IID fromString: '{0e2cea3b-e6c4-11d2-833b-0020afab8efe}')!
OS.COM.Examples.IRandomStream comment: '<IRandomStream> is a wrapper class for the COM interface ''RANDOMLib.IRandomStream'' generated from type information in the ''Random 1.0 Type Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"IRandomStream Interface"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!OS.COM.Examples.IRandomStream categoriesForClass!COM-Interfaces! !
!OS.COM.Examples.IRandomStream methodsFor!

get_LowerBound: pVal
	"Private - Get the value of the 'LowerBound' property of the receiver.

		HRESULT __stdcall LowerBound(
			[out, retval] long* pVal);"

	<virtual stdcall: hresult 11 int32*>
	^self invalidCall: _failureCode!

get_Seed: pVal
	"Private - Get the value of the 'Seed' property of the receiver.

		HRESULT __stdcall Seed(
			[out, retval] long* pVal);"

	<virtual stdcall: hresult 9 int32*>
	^self invalidCall: _failureCode!

get_UpperBound: pVal
	"Private - Get the value of the 'UpperBound' property of the receiver.

		HRESULT __stdcall UpperBound(
			[out, retval] long* pVal);"

	<virtual stdcall: hresult 13 int32*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

lowerBound
	"Answer the <sdword> value of the 'LowerBound' property of the receiver.
	Helpstring: 'Lower bound of range of random numbers generated'"

	| answer |
	answer := (Int32 new).
	self get_LowerBound: answer.
	^answer asObject
!

lowerBound: pVal
	"Set the 'LowerBound' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'Lower bound of range of random numbers generated'"

	self put_LowerBound: pVal
!

next
	"Answer the <Int32> result of invoking the Next() method of the COM object.
	Helpstring: 'Answer the next random number in the stream'"

	| answer |
	answer := (Int32 new).
	self Next: answer.
	^answer asObject
!

Next: plNext
	"Private - Invoke the Next() method of the COM object.
	Helpstring: 'Answer the next random number in the stream'

		HRESULT __stdcall Next(
			[out, retval] long* plNext);"

	<virtual stdcall: hresult 8 int32*>
	^self invalidCall: _failureCode!

put_LowerBound: pVal
	"Private - Set the value of the 'LowerBound' property of the object wrapped by the 
	 receiver to the <sdword> argument, pVal.

		HRESULT __stdcall LowerBound(
			[in] long pVal);"

	<virtual stdcall: hresult 12 int32>
	^self invalidCall: _failureCode!

put_Seed: pVal
	"Private - Set the value of the 'Seed' property of the object wrapped by the 
	 receiver to the <sdword> argument, pVal.

		HRESULT __stdcall Seed(
			[in] long pVal);"

	<virtual stdcall: hresult 10 int32>
	^self invalidCall: _failureCode!

put_UpperBound: pVal
	"Private - Set the value of the 'UpperBound' property of the object wrapped by the 
	 receiver to the <sdword> argument, pVal.

		HRESULT __stdcall UpperBound(
			[in] long pVal);"

	<virtual stdcall: hresult 14 int32>
	^self invalidCall: _failureCode!

seed
	"Answer the <sdword> value of the 'Seed' property of the receiver.
	Helpstring: 'Current random seed'"

	| answer |
	answer := (Int32 new).
	self get_Seed: answer.
	^answer asObject
!

seed: pVal
	"Set the 'Seed' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'Current random seed'"

	self put_Seed: pVal
!

upperBound
	"Answer the <sdword> value of the 'UpperBound' property of the receiver.
	Helpstring: 'Upper bound of range of random numbers generated'"

	| answer |
	answer := (Int32 new).
	self get_UpperBound: answer.
	^answer asObject
!

upperBound: pVal
	"Set the 'UpperBound' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'Upper bound of range of random numbers generated'"

	self put_UpperBound: pVal
! !
!OS.COM.Examples.IRandomStream categoriesForMethods!
get_LowerBound:!**auto generated**!COM Interfaces-IRandomStream!private! !
get_Seed:!**auto generated**!COM Interfaces-IRandomStream!private! !
get_UpperBound:!**auto generated**!COM Interfaces-IRandomStream!private! !
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
lowerBound!**auto generated**!properties!public! !
lowerBound:!**auto generated**!properties!public! !
next!**auto generated**!methods!public! !
Next:!**auto generated**!COM Interfaces-IRandomStream!private! !
put_LowerBound:!**auto generated**!COM Interfaces-IRandomStream!private! !
put_Seed:!**auto generated**!COM Interfaces-IRandomStream!private! !
put_UpperBound:!**auto generated**!COM Interfaces-IRandomStream!private! !
seed!**auto generated**!properties!public! !
seed:!**auto generated**!properties!public! !
upperBound!**auto generated**!properties!public! !
upperBound:!**auto generated**!properties!public! !
!

!OS.COM.Examples.IRandomStream class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (RandomStream) for which the receiver is the default interface."

	^CLSID fromString: '{A1D42F35-E6C0-11D2-833B-0020AFAB8EFE}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'RANDOMLib.IRandomStream'
		IRandomStream defineTemplate"

	self
		defineFunction: #Next:
			argumentTypes: 'sdword*';
		defineFunction: #get_Seed:
			argumentTypes: 'sdword*';
		defineFunction: #put_Seed:
			argumentTypes: 'sdword';
		defineFunction: #get_LowerBound:
			argumentTypes: 'sdword*';
		defineFunction: #put_LowerBound:
			argumentTypes: 'sdword';
		defineFunction: #get_UpperBound:
			argumentTypes: 'sdword*';
		defineFunction: #put_UpperBound:
			argumentTypes: 'sdword'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IRandomStream initializeTypeLib"

	typeLib := RANDOMLib! !
!OS.COM.Examples.IRandomStream class categoriesForMethods!
clsid!**auto generated**!constants!private! !
defineFunctions!**auto generated**!initializing!public! !
initializeTypeLib!**auto generated**!initializing!private! !
!

