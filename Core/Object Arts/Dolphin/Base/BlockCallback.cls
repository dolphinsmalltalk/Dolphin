"Filed out from Dolphin Smalltalk X6"!

ExternalCallback subclass: #BlockCallback
	instanceVariableNames: 'block'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BlockCallback guid: (GUID fromString: '{87B4C577-026E-11D3-9FD7-00A0CC3E4A32}')!
BlockCallback comment: ''!
!BlockCallback categoriesForClass!System-Support! !
!BlockCallback methodsFor!

block: aBlockClosure
	"Private - Record the block to be evaluated when the callback represented
	by the receiver is entered.
	N.B. The argument really must be a BlockClosure - other valuables are not
	acceptable."

	block := aBlockClosure!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: block;
		space;
		print: self argumentTypes;
		nextPut: $)!

valueWithArgumentsAt: anAddress
	"Private - Evaluate the receiver with arguments instantiated from the raw data at anAddress.
	For performance and consistency (with outbound external calls) reasons, we use a VM supplied
	primitive to instantiate and push the arguments and perform the message, but there is no reason
	that this cannot be done in Smalltalk if different argument conversions are required. The standard
	conversions are the same as those performed for return types by the external call primitive (see
	the ExternalLibrary class)."

	^block valueWithArgumentsAt: anAddress descriptor: descriptor! !
!BlockCallback categoriesFor: #block:!accessing!private! !
!BlockCallback categoriesFor: #printOn:!development!printing!public! !
!BlockCallback categoriesFor: #valueWithArgumentsAt:!evaluating!private! !

