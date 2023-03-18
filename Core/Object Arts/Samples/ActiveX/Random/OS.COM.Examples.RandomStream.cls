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

get_LowerBound: plLowerBound
	"Private - Implement IRandomStream::LowerBound().
	Answer the receiver's lower bound via the [out] parameter, plLowerBound."

	plLowerBound value: lowerBound.
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
	stream := Random new.
	!

interfaceClass
	"Answer the dual interface supported by the receiver."

	^IRandomStream!

Next: next 
	"Private - Implement IRandomStream::Next().
	Answer the next pseudo-random number in the sequence defined by the receiver
	via the [out] parameter, next."

	next value: (stream next * (upperBound-lowerBound) + lowerBound) asInteger.
	^S_OK!

put_LowerBound: value
	"Private - Implement IRandomStream::put_LowerBound().
	Set the receiver's lowerBound from the [in] parameter, value."

	lowerBound := value.
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
	^S_OK! !
!OS.COM.Examples.RandomStream categoriesForMethods!
get_LowerBound:!COM Interfaces-IRandomStream!private! !
get_Seed:!COM Interfaces-IRandomStream!private! !
get_UpperBound:!COM Interfaces-IRandomStream!private! !
initialize!initializing!private! !
interfaceClass!constants!public! !
Next:!COM Interfaces-IRandomStream!private! !
put_LowerBound:!COM Interfaces-IRandomStream!private! !
put_Seed:!COM Interfaces-IRandomStream!private! !
put_UpperBound:!COM Interfaces-IRandomStream!private! !
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

