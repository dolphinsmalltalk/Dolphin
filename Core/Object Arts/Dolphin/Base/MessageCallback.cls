"Filed out from Dolphin Smalltalk"!

ExternalCallback subclass: #MessageCallback
	instanceVariableNames: 'receiver selector closure'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MessageCallback guid: (GUID fromString: '{87b4c578-026e-11d3-9fd7-00a0cc3e4a32}')!
MessageCallback comment: ''!
!MessageCallback categoriesForClass!System-Support! !
!MessageCallback methodsFor!

closure
	"Answer the user supplied 'closure' object supplied when the receiver was created.
	This can be anything appropriate to the callbacks purposes."

	^closure!

closure: anObject
	"Set the user supplied 'closure' object. 
	This can be anything appropriate to the callbacks purposes.
	Answer the receiver."

	closure := anObject!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: receiver;
		space;
		print: selector;
		space;
		print: self argumentTypes;
		nextPut: $)!

receiver: anObject
	"Private - Record the receiver of the callback."

	receiver := anObject!

selector: aSymbol
	"Private - Set the selector to send when the receiver is evaluated."

	selector := aSymbol!

valueWithArgumentsAt: anAddress
	"Private - Evaluate the receiver with arguments instantiated from the raw data at anAddress."

	^receiver perform: selector withArgumentsAt: anAddress descriptor: descriptor! !
!MessageCallback categoriesForMethods!
closure!accessing!public! !
closure:!accessing!public! !
printOn:!development!printing!public! !
receiver:!initializing!private! !
selector:!initializing!private! !
valueWithArgumentsAt:!evaluating!private! !
!

