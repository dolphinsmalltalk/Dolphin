"Filed out from Dolphin Smalltalk/98 release 1"!

COMInterfaceImp subclass: #COMRandomStream
	instanceVariableNames: 'lowerBound upperBound stream '
	classVariableNames: ''
	poolDictionaries: ''!

COMRandomStream class instanceVariableNames: ''!

COMRandomStream comment: ''!

!COMRandomStream categoriesForClass!No category! !

!COMRandomStream methodsFor!

initialize
	"Private - Initialize the reciever's instance variables (suitably for the lottery)."

	lowerBound := 1.
	upperBound := 49.
	stream := Random new.
	!

LowerBound: pdwLowerBound
	"Private - Implement IRandomStream::LowerBound().
	Answer the receiver's lower bound via the [out] parameter, pdwLowerBound."

	pdwLowerBound value: lowerBound.
	^S_OK!

Next: next 
	"Private - Implement IRandomStream::Next().
	Answer the next pseudo-random number in the sequence defined by the receiver
	via the [out] parameter, next."

	next value: (stream next * (upperBound-lowerBound) + lowerBound) asInteger.
	^S_OK!

Seed: seed 
	"Private - Implement IRandomStream::Seed().
	Answer the receiver's seed through the [out] parameter, seed"

	seed value: stream seed.
	^S_OK!

SetLowerBound: value
	"Private - Implement IRandomStream::SetLowerBound().
	Set the receivers lowerBound from the [in] parameter, value."

	lowerBound := value.
	^S_OK!

SetSeed: dwValue
	"Private - Implement IRandomStream::SetSeed().
	Set the receiver's seed from the [in] parameter, dwValue."

	stream seed: dwValue.
	^S_OK!

SetUpperBound: value
	"Private - Implement IRandomStream::SetUpperBound.
	Set the receiver's upperBound from the [in] parameter, value."

	upperBound := value.
	^S_OK!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver.
	N.B. By the rules of COM, this set must remain constant. All
	interfaces also support IUnknown."

	^#( ##(IRandomStream))!

UpperBound: pdwUpperBound
	"Private - Implement IRandomStream::UpperBound().
	Answer the receiver's upper bound via the [out] parameter, pdwUpperBound."

	pdwUpperBound value: upperBound.
	^S_OK! !

!COMRandomStream categoriesFor: #initialize!initializing! !
!COMRandomStream categoriesFor: #LowerBound:!COM Interfaces-IRandomStream! !
!COMRandomStream categoriesFor: #Next:!COM Interfaces-IRandomStream! !
!COMRandomStream categoriesFor: #Seed:!COM Interfaces-IRandomStream! !
!COMRandomStream categoriesFor: #SetLowerBound:!COM Interfaces-IRandomStream! !
!COMRandomStream categoriesFor: #SetSeed:!COM Interfaces-IRandomStream! !
!COMRandomStream categoriesFor: #SetUpperBound:!COM Interfaces-IRandomStream! !
!COMRandomStream categoriesFor: #supportedInterfaces!constants! !
!COMRandomStream categoriesFor: #UpperBound:!COM Interfaces-IRandomStream! !

!COMRandomStream class methodsFor!

clsid
	"Answer the receiver's CLSID."

	^CLSID fromString: '{110CA0A1-DFA0-101C-9029-040224007802}'!

new
	"Answer a new initialized instance of the receiver."

	^super new initialize! !

!COMRandomStream class categoriesFor: #clsid!constants! !
!COMRandomStream class categoriesFor: #new!instance creation! !

