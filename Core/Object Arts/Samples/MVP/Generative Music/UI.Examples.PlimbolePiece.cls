"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Examples.PlimbolePiece'
	instanceVariableNames: 'version cells tempo scaleIndex gridSize tenorIndex altoIndex'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Examples.PlimbolePiece guid: (Core.GUID fromString: '{3e10a834-edbf-4954-b29a-832dae7c6298}')!

UI.Examples.PlimbolePiece comment: ''!

!UI.Examples.PlimbolePiece methodsFor!

altoIndex
	^altoIndex!

altoIndex: anInteger
	^altoIndex := anInteger!

asString
	"Answer a signature string that represents the current piece"

	| stream |
	stream := String writeStream.
	stream
		display: self version;
		nextPut: $_;
		display: self scaleIndex - 1;
		nextPut: $_;
		display: self tempo;
		nextPut: $_.

	"Cell positions"
	self cells do: 
			[:each |
			each x
				printOn: stream
				base: 16
				showRadix: false.
			each y
				printOn: stream
				base: 16
				showRadix: false.
			stream display: each directionIndex].

	"Grid size"
	stream nextPut: $_.
	gridSize
		printOn: stream
		base: 16
		showRadix: false.

	"Voices"
	stream nextPut: $_.
	tenorIndex
		printOn: stream
		base: 16
		showRadix: false.
	stream nextPut: $_.
	altoIndex
		printOn: stream
		base: 16
		showRadix: false.
	^stream contents!

cells
	^cells!

cells: anObject
	cells := anObject!

errorInvalidFormat
	InvalidFormat signal: 'Version <1p> plimbole signature' << version!

gridSize
	^gridSize!

gridSize: anInteger
	gridSize := anInteger!

initialize
	version := self class version.
	cells := #().
	scaleIndex := 1.
	tenorIndex := altoIndex := 1.
	gridSize := 9.
	altoIndex := 9.
	tenorIndex := 10.
	tempo := 150.
	^self!

parseSignature: aReadStream
	scaleIndex := 1.
	tenorIndex := altoIndex := 1.
	gridSize := 9.
	altoIndex := 9.
	tenorIndex := 10.

	version := Integer readFrom: aReadStream.
	(#(10 20) includes: version) ifFalse: [self error: 'Wrong version'].
	aReadStream next = $_ ifFalse: [self errorInvalidFormat].
	scaleIndex := (Integer readFrom: aReadStream) + 1.
	aReadStream next = $_ ifFalse: [self errorInvalidFormat].
	tempo := Integer readFrom: aReadStream.
	aReadStream next = $_ ifFalse: [self errorInvalidFormat].
	cells := OrderedCollection new.
	[aReadStream atEnd or: [aReadStream peek = $_]] whileFalse: 
			[| cell x y direction |
			x := aReadStream next digitValue.
			y := aReadStream next digitValue.
			direction := aReadStream next digitValue.
			cell := PlimboleCell location: x @ y direction: direction.
			cells add: cell].

	version = self class version
		ifTrue: 
			["Version 20 format includes grid size and voices"
			aReadStream next = $_ ifFalse: [self errorInvalidFormat].
			gridSize := aReadStream next digitValue.
			aReadStream next = $_ ifFalse: [self errorInvalidFormat].
			tenorIndex := Integer readFrom: aReadStream radix: 16.
			aReadStream next = $_ ifFalse: [self errorInvalidFormat].
			altoIndex := Integer readFrom: aReadStream radix: 16]!

scaleIndex
	^scaleIndex!

scaleIndex: anInteger
	scaleIndex := anInteger!

tempo
	^tempo!

tempo: anInteger
	tempo := anInteger!

tenorIndex
	^tenorIndex!

tenorIndex: anInteger
	tenorIndex := anInteger!

version
	^version! !

!UI.Examples.PlimbolePiece categoriesForMethods!
altoIndex!accessing!public! !
altoIndex:!accessing!public! !
asString!public! !
cells!accessing!public! !
cells:!accessing!public! !
errorInvalidFormat!private! !
gridSize!accessing!public! !
gridSize:!accessing!public! !
initialize!private! !
parseSignature:!private! !
scaleIndex!accessing!public! !
scaleIndex:!accessing!public! !
tempo!accessing!public! !
tempo:!accessing!public! !
tenorIndex!accessing!public! !
tenorIndex:!accessing!public! !
version!accessing!public! !
!

!UI.Examples.PlimbolePiece class methodsFor!

fromString: aString
	| stream |
	stream := aString readStream.
	(aString beginsWith: 'http:') ifTrue: [stream skipToAll: '?q='].
	^self readFrom: stream!

icon
	^PlimbolePresenter icon!

new
	^self basicNew initialize!

readFrom: aReadStream
	^self new
		parseSignature: aReadStream;
		yourself!

version
	^20! !

!UI.Examples.PlimbolePiece class categoriesForMethods!
fromString:!instance creation!public! !
icon!public! !
new!instance creation!public! !
readFrom:!instance creation!public! !
version!constants!public! !
!

