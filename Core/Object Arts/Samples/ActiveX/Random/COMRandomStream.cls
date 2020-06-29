"Filed out from Dolphin Smalltalk 7"!

AXDualImp subclass: #COMRandomStream
	instanceVariableNames: 'lowerBound upperBound stream'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
COMRandomStream guid: (GUID fromString: '{f560cd26-00a1-4a4f-9833-03ae165a2e11}')!
COMRandomStream comment: 'COMRandomStream is part of the COM Random Stream sample. See the "RandomStream sample" package for further details.'!
!COMRandomStream categoriesForClass!COM-Implementations! !
!COMRandomStream methodsFor!

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
	Set the receivers lowerBound from the [in] parameter, value."

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
!COMRandomStream categoriesFor: #get_LowerBound:!COM Interfaces-IRandomStream!private! !
!COMRandomStream categoriesFor: #get_Seed:!COM Interfaces-IRandomStream!private! !
!COMRandomStream categoriesFor: #get_UpperBound:!COM Interfaces-IRandomStream!private! !
!COMRandomStream categoriesFor: #initialize!initializing!private! !
!COMRandomStream categoriesFor: #interfaceClass!constants!public! !
!COMRandomStream categoriesFor: #Next:!COM Interfaces-IRandomStream!private! !
!COMRandomStream categoriesFor: #put_LowerBound:!COM Interfaces-IRandomStream!private! !
!COMRandomStream categoriesFor: #put_Seed:!COM Interfaces-IRandomStream!private! !
!COMRandomStream categoriesFor: #put_UpperBound:!COM Interfaces-IRandomStream!private! !

!COMRandomStream class methodsFor!

clsid
	"Answer the receiver's CLSID."

	^CLSID fromString: '{A1D42F35-E6C0-11D2-833B-0020AFAB8EFE}'!

progID
	"Answer the receiver's programmatic ID, typically used from scripting or macro languagues to 
	create instances of the receiver, e.g. 'Dolphin.Object.1'"

	^'Dolphin.RandomStream.1'! !
!COMRandomStream class categoriesFor: #clsid!constants!private! !
!COMRandomStream class categoriesFor: #progID!constants!public! !

