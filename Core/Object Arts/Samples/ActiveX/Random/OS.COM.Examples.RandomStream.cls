"Filed out from Dolphin Smalltalk"!

OS.COM.DualInterfaceImplementation
	subclass: #'OS.COM.Examples.RandomStream'
	instanceVariableNames: 'lowerBound upperBound stream'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Examples.RandomStream guid: (Core.GUID fromString: '{f560cd26-00a1-4a4f-9833-03ae165a2e11}')!

OS.COM.Examples.RandomStream comment: 'OS.COM.Examples.RandomStream is part of the COM Random Stream sample. See the "RandomStream sample" package for further details.'!

!OS.COM.Examples.RandomStream categoriesForClass!COM-Implementations! !

!OS.COM.Examples.RandomStream methodsFor!

get_Increment: pVal
	"Private - Implement the getter for the 'Increment' property of the receiver.

		HRESULT __stdcall Increment(
			[out, retval]unsigned long* pVal);"

	pVal value: stream increment.
	^S_OK!

get_LowerBound: plLowerBound
	"Private - Implement IRandomStream::LowerBound().
	Answer the receiver's lower bound via the [out] parameter, plLowerBound."

	plLowerBound value: lowerBound.
	^S_OK!

get_Modulus: pVal
	"Private - Get the value of the 'Modulus' property of the receiver.

		HRESULT __stdcall Modulus(
			[out, retval]unsigned long* pVal);"

	pVal value: stream modulus.
	^S_OK!

get_Multiplier: pVal
	"Private - Get the value of the 'Multiplier' property of the receiver.

		HRESULT __stdcall Multiplier(
			[out, retval]unsigned long* pVal);"

	pVal value: stream multiplier.
	^S_OK!

get_Seed: plSeed 
	"Private - Implement IRandomStream::Seed().
	Answer the receiver's seed through the [out] parameter, seed"

	plSeed value: stream seed.
	^S_OK!

get_UpperBound: plUpperBound
	"Private - Implement IRandomStream::get_UpperBound().
	Answer the receiver's upper bound via the [out] parameter, plUpperBound."

	plUpperBound value: upperBound.
	^S_OK!

initialize
	"Private - Initialize the reciever's instance variables (suitably for the lottery)."

	lowerBound := 1.
	upperBound := 49.
	stream := RandomLinearCongruential newANSIC!

interfaceClass
	"Answer the primary dual interface supported by the receiver."

	^IRandomStream!

Next: next 
	"Private - Implement IRandomStream::Next().
	Answer the next pseudo-random number in the sequence defined by the receiver
	via the [out] parameter, next."

	next value: (stream next * (upperBound-lowerBound) + lowerBound) asInteger.
	^S_OK!

put_Increment: pVal
	"Private - Implement the prop put for 'Increment' property.

		HRESULT __stdcall Increment(
			[in]unsigned long pVal);"

	stream increment: pVal.
	^S_OK!

put_LowerBound: value
	"Private - Implement IRandomStream::put_LowerBound().
	Set the receiver's lowerBound from the [in] parameter, value."

	lowerBound := value.
	^S_OK!

put_Modulus: pVal
	"Private - Implement the prop put for 'Modulus' property.

		HRESULT __stdcall Modulus(
			[in]unsigned long pVal);"

	stream modulus: pVal.
	^S_OK!

put_Multiplier: pVal
	"Private - Implement the prop put for 'Multiplier' property.

		HRESULT __stdcall Multiplier(
			[in]unsigned long pVal);"

	stream multiplier: pVal.
	^S_OK!

put_Seed: newValue
	"Private - Implement IRandomStream::put_Seed().
	Set the receiver's seed from the [in] parameter, dwValue."

	stream seed: newValue.
	^S_OK!

put_UpperBound: value
	"Private - Implement IRandomStream::put_UpperBound.
	Set the receiver's upperBound from the [in] parameter, value."

	upperBound := value.
	^S_OK!

supportedInterfaces
	"Not strictly necessary to specify IRandomStream and IRandomStream2 since the latter is derived from the former, but we want them to be separate instances for testing purposes."

	^{ IUnknown. IDispatch. IRandomStream. IRandomStream2 }! !

!OS.COM.Examples.RandomStream categoriesForMethods!
get_Increment:!COM Interfaces-IRandomStream2!private! !
get_LowerBound:!COM Interfaces-IRandomStream!private! !
get_Modulus:!COM Interfaces-IRandomStream2!private! !
get_Multiplier:!COM Interfaces-IRandomStream2!private! !
get_Seed:!COM Interfaces-IRandomStream!private! !
get_UpperBound:!COM Interfaces-IRandomStream!private! !
initialize!initializing!private! !
interfaceClass!constants!public! !
Next:!COM Interfaces-IRandomStream!private! !
put_Increment:!COM Interfaces-IRandomStream2!private! !
put_LowerBound:!COM Interfaces-IRandomStream!private! !
put_Modulus:!COM Interfaces-IRandomStream2!private! !
put_Multiplier:!COM Interfaces-IRandomStream2!private! !
put_Seed:!COM Interfaces-IRandomStream!private! !
put_UpperBound:!COM Interfaces-IRandomStream!private! !
supportedInterfaces!constants!public! !
!

!OS.COM.Examples.RandomStream class methodsFor!

clsid
	"Answer the receiver's CLSID."

	^CLSID fromString: '{A1D42F35-E6C0-11D2-833B-0020AFAB8EFE}'!

progID
	"Answer the receiver's programmatic ID, typically used from scripting or macro languagues to 
	create instances of the receiver, e.g. 'Dolphin.Object.1'"

	^'Dolphin.RandomStream.1'! !

!OS.COM.Examples.RandomStream class categoriesForMethods!
clsid!constants!private! !
progID!constants!public! !
!

