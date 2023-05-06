"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.SemVerParser'
	instanceVariableNames: 'stream last next classification'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'AlphaMask' -> 16r10.
			'ClassificationTable'
				-> #[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 16 0 0 1 2 3 4 5 6 7 8 9 10 0 0 0 0 0 0 0 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 0 0 0 0 0 0 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 0 0 0 0 0 0].
			'DigitMask' -> 16rF.
			'IdentifierMask' -> 16r1F
		}!
Kernel.SemVerParser guid: (Core.GUID fromString: '{10ccbfc5-65d9-401c-beac-6c8fd3ac6913}')!
Kernel.SemVerParser comment: 'Simple parser for SemVer 2.0 specification version strings. 

Attempts to parse a `SemVer` from a `<sequencedStream>`, stopping at the end of any valid SemVer 2.0 version string sequence, or as soon as an invalid sequence is detected.

## Instance Variables:
  `stream`			`<sequencedStream>`. Input stream of characters.
  `end`			`<integer> position of the end of the SemVer identified so far`
  `next`			`<Character>` The next, unconsumed, character.
  `classification`	`<integer>` classification of the character in the SemVer lexicon

'!
!Kernel.SemVerParser categoriesForClass!Kernel-Objects! !
!Kernel.SemVerParser methodsFor!

parse
	"Answer a new `SemVer` parsed from the SemVer 2.0 version string in the stream to which the receiver is attached, leaving it positioned after the end of the valid sequence, or at the position where an invalid sequence is detected.
	Answer nil if the initial sequence is not a valid SemVer."

	| major minor patch prerelease buildmetadata |
	major := self parseVersionInteger.
	(major isNil or: [next ~~ $.]) ifTrue: [^nil].
	self step.
	minor := self parseVersionInteger.
	(minor isNil or: [next ~~ $.]) ifTrue: [^nil].
	self step.
	patch := self parseVersionInteger.
	patch ifNil: [^nil].
	next == $-
		ifTrue: 
			[self step.	"-"
			prerelease := WriteStream on: (AnsiString new: 4).
			
			[(self parsePrereleaseIdentifier: prerelease) ifFalse: [^nil].
			next == $.] whileTrue: 
						[prerelease nextPut: $..
						self step].
			prerelease := prerelease contents].
	next == $+
		ifTrue: 
			[self step.	"+"
			buildmetadata := WriteStream on: (AnsiString new: 4).
			
			[(self parseMetadataIdentifier: buildmetadata) ifFalse: [^nil].
			next == $.] whileTrue: 
						[buildmetadata nextPut: $..
						self step].
			buildmetadata := buildmetadata contents].
	stream position: last.
	^SemVer
		major: major
		minor: minor
		patch: patch
		prerelease: prerelease
		buildmetadata: buildmetadata!

parseMetadataIdentifier: aWriteStream
	"There must be at least one character in the identifier"

	(classification anyMask: IdentifierMask) ifFalse: [^false].
	aWriteStream nextPut: next.
	
	[self step.
	classification anyMask: IdentifierMask] whileTrue: [aWriteStream nextPut: next].
	^true!

parsePrereleaseIdentifier: aWriteStream
	| multi leadingZero |
	"A prerelease identifier must have at least one hyphen, digit or letter."
	(classification anyMask: IdentifierMask) ifFalse: [^false].
	leadingZero := next == $0.
	multi := false.
	
	[aWriteStream nextPut: next.
	self step.
	classification anyMask: IdentifierMask] whileTrue: 
				[(classification noMask: DigitMask) ifTrue: [leadingZero := false].
				multi := true].
	^(leadingZero & multi) not!

parseVersionInteger
	| int leadingZero pos |
	(classification anyMask: DigitMask) ifFalse: [^nil].
	leadingZero := next == $0.
	int := classification - 1.
	pos := last.
	
	[self step.
	classification anyMask: DigitMask] whileTrue: [int := int * 10 + classification - 1].
	"Leading zeroes are not permitted"
	^(leadingZero and: [last - pos > 1]) ifFalse: [int]!

setStream: aReadStream
	stream := aReadStream.
	self step!

step
	last := stream position.
	next := stream nextAvailable
				ifNil: 
					[last := stream position.
					$\x1A].
	classification := ClassificationTable lookup: next code! !
!Kernel.SemVerParser categoriesForMethods!
parse!parsing!public! !
parseMetadataIdentifier:!parsing!private! !
parsePrereleaseIdentifier:!parsing!private! !
parseVersionInteger!parsing!private! !
setStream:!initializing!private! !
step!parsing!private! !
!

!Kernel.SemVerParser class methodsFor!

initializeClassificationTable
	| classificationTable |
	classificationTable := ByteArray new: 128.
	'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
		do: [:alpha | classificationTable at: alpha codePoint put: AlphaMask].
	'01234567890' do: [:digit | classificationTable at: digit codePoint put: digit digitValue + 1].
	classificationTable at: $- codePoint put: AlphaMask.
	classificationTable beReadOnlyObject.
	self addClassConstant: 'ClassificationTable' value: classificationTable!

on: aReadStream
	^self new
		setStream: aReadStream;
		yourself! !
!Kernel.SemVerParser class categoriesForMethods!
initializeClassificationTable!public! !
on:!public! !
!

