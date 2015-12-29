"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #MD5
	instanceVariableNames: 'state'
	classVariableNames: 'ABCDTable IndexTable ShiftTable SinTable'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MD5 guid: (GUID fromString: '{FA0C31D4-0F14-4D7E-99E4-7CDA284CC053}')!
MD5 comment: 'From Squeak3.1alpha of 20 February 2001 [latest update: #3679] on 23 February 2001 at 10:54:55 pm'!
!MD5 categoriesForClass!System-MD5! !
!MD5 methodsFor!

ffA: a B: b C: c D: d M: m S: s T: t
	"compute a = b + ((a + f(b,c,d) + m + t) <<< s)
	'DSM 1/20/2000 13:38'"
	^ a += (self fX: b Y: c Z: d); += m; += t; leftRotateBy: s; += b.
!

finalValue
	"Concatenate the state values to produce the 128-bite result
	'DSM 1/20/2000 17:56'"
	^ (( state at: 1) asReverseInteger bitShift: 96) +
	  (( state at: 2) asReverseInteger bitShift: 64) +
	  (( state at: 3) asReverseInteger bitShift: 32) +
	  (( state at: 4) asReverseInteger)!

fX: x Y: y Z: z
	" compute 'xy or (not x)z'
	'DSM 1/20/2000 01:47'"
	^ x copy bitAnd: y; bitOr: (x copy bitInvert; bitAnd: z)
!

ggA: a B: b C: c D: d M: m S: s T: t
	"compute a = b + ((a + g(b,c,d) + m + t) <<< s)
	'DSM 1/20/2000 13:38'"
	^ a += (self gX: b Y: c Z: d); += m; += t; leftRotateBy: s; += b.
!

gX: x Y: y Z: z
	" compute 'xz or y(not z)'
	'DSM 1/20/2000 01:48'"
	^ x copy bitAnd: z; bitOr: (z copy bitInvert; bitAnd: y)

	!

hashMessage: aStringOrByteArray
	"MD5 new hashMessage: 'foo'
	'DSM 1/20/2000 15:29'"
	^ self hashStream: (ReadStream on: aStringOrByteArray asByteArray)
!

hashStream: aPositionableStream
	"MD5 new hashStream: (ReadStream on: 'foo')
	'mdr 2/23/2001 22:49'"
	| startPosition buf bitLength |
	self initialize.

	"aPositionableStream atEnd ifTrue: [self error: 'empty stream']."

	startPosition := aPositionableStream position.
	[aPositionableStream atEnd] whileFalse: [
		"swChanged; modified from #next: "
		buf := aPositionableStream nextAvailable: 64.
		(aPositionableStream atEnd not and: [buf size = 64])
			ifTrue: [self processBuffer: buf]
			ifFalse: [
				bitLength := (aPositionableStream position - startPosition) * 8.
				self processFinalBuffer: buf bitLength: bitLength]].

	^ self finalValue
!

hhA: a B: b C: c D: d M: m S: s T: t
	"compute a = b + ((a + h(b,c,d) + m + t) <<< s)
	'DSM 1/20/2000 13:38'"
	^ a += (self hX: b Y: c Z: d); += m; += t; leftRotateBy: s; += b.
!

hX: x Y: y Z: z
	" compute 'x xor y xor z'
	'DSM 1/20/2000 01:48'"
	^ x copy bitXor: y; bitXor: z

	!

iiA: a B: b C: c D: d M: m S: s T: t
	"compute a = b + ((a + i(b,c,d) + m + t) <<< s)
	'DSM 1/20/2000 13:39'"
	^ a += (self iX: b Y: c Z: d); += m; += t; leftRotateBy: s; += b.
!

initialize
	"Some magic numbers to get the process started
	 'DSM 1/20/2000 17:56'"
	
	"swChanged; modified from squeak's {}"
	state := OrderedCollection 
		with: 	(ThirtyTwoBitRegister new load: 16r67452301)
		with: (ThirtyTwoBitRegister new load: 16rEFCDAB89)
		with: (ThirtyTwoBitRegister new load: 16r98BADCFE)
		with: (ThirtyTwoBitRegister new load: 16r10325476)
!

iX: x Y: y Z: z
	" compute 'y xor (x or (not z))'
	'DSM 1/20/2000 01:48'!!"
	^ y copy bitXor: (z copy bitInvert; bitOr: x)
!

processBuffer: aByteArray
	"Process a 64-byte buffer
	'mdr 2/23/2001 22:50'"

	| saveState data |
	saveState := state collect: [ :item | item copy ].
	data := Array new: 16.
	1 to: 16 do: [ :index |
		data at: index put:
			(ThirtyTwoBitRegister new reverseLoadFrom: aByteArray at: (index * 4) - 3)].
	self rounds: data.
	1 to: 4 do: [ :index | (state at: index) += (saveState at: index) ].
!

processFinalBuffer: aByteArray bitLength: bitLength
	"Pad the buffer until we have an even 64 bytes, then transform
	'DSM 1/20/2000 17:55'"

	| out |
	out := ByteArray new: 64.
	out replaceFrom: 1 to: aByteArray size with: aByteArray startingAt: 1.
	aByteArray size < 56 ifTrue: [
		out at: aByteArray size + 1 put: 128. "trailing bit"
		self storeLength: bitLength in: out.
		self processBuffer: out.
		^ self].

	"not enough room for the length, so just pad this one, then..."
	aByteArray size < 64 ifTrue: [ out at: aByteArray size + 1 put: 128 ].
	self processBuffer: out.

	"process one additional block of padding ending with the length"
	out := ByteArray new: 64.  "filled with zeros"
	aByteArray size = 64 ifTrue: [ out at: 1 put: 128].
	self storeLength: bitLength in: out.
	self processBuffer: out.
!

round: data selector: selector round: round
	"Do one round with the given function
	'DSM 1/20/2000 17:57'"

	| shiftIndex template abcd |
	1 to: 16 do: [ :i |
		shiftIndex := (i - 1) \\ 4 + 1.
		abcd := ABCDTable at: shiftIndex.
		"swChanged; modified from squeak's {}"
		template := Array new: 7.
		template
			at: 1 put: (abcd at: 1);
			at: 2 put: (abcd at: 2);
			at: 3 put: (abcd at: 3);
			at: 4 put: (abcd at: 4);
			at: 5 put: ((IndexTable at: round) at: i);
			at: 6 put: ((ShiftTable at: round) at: shiftIndex);
			at: 7 put: (	SinTable at: round - 1 * 16 + i ).
		self step: data template: template selector: selector ].
!

rounds: data 
	"Perform the four rounds with different functions
	'DSM 1/20/2000 17:58'"

	"swChanged: modified from doWithIndex:"

	#(#ffA:B:C:D:M:S:T: #ggA:B:C:D:M:S:T: #hhA:B:C:D:M:S:T: #iiA:B:C:D:M:S:T:) keysAndValuesDo: 
			[:index :selector | 
			self 
				round: data
				selector: selector
				round: index]!

step: data template: item selector: selector
	"Perform one step in the round
	 'DSM 1/20/2000 17:58'"

	| args |
	"swChanged; modified from squeak's {}"
	args :=  Array new: 7.
	args
		at: 1 put: (state at: (item at: 1));
		at: 2 put: (state at: (item at: 2));
		at: 3 put: (state at: (item at: 3));
		at: 4 put: (state at: (item at: 4));
		at: 5 put: (data at: (item at: 5));
		at: 6 put: (item at: 6);
		at: 7 put: (item at: 7).

	(self perform: selector withArguments: args).
!

storeLength: bitLength in: aByteArray
	"Fill in the final 8 bytes of the given ByteArray with a 64-bit
	little-endian representation of the original message length in bits.
	'DSM 1/20/2000 17:19'"

	| n i |
	n := bitLength.
	i := aByteArray size - 8 + 1.
	[n > 0] whileTrue: [
		aByteArray at: i put: (n bitAnd: 16rFF).
		n := n bitShift: -8.
		i := i + 1].
! !
!MD5 categoriesFor: #ffA:B:C:D:M:S:T:!functions!private! !
!MD5 categoriesFor: #finalValue!buffers!private! !
!MD5 categoriesFor: #fX:Y:Z:!functions!private! !
!MD5 categoriesFor: #ggA:B:C:D:M:S:T:!functions!private! !
!MD5 categoriesFor: #gX:Y:Z:!functions!private! !
!MD5 categoriesFor: #hashMessage:!operations!public! !
!MD5 categoriesFor: #hashStream:!operations!public! !
!MD5 categoriesFor: #hhA:B:C:D:M:S:T:!functions!private! !
!MD5 categoriesFor: #hX:Y:Z:!functions!private! !
!MD5 categoriesFor: #iiA:B:C:D:M:S:T:!functions!private! !
!MD5 categoriesFor: #initialize!initialization!public! !
!MD5 categoriesFor: #iX:Y:Z:!functions!private! !
!MD5 categoriesFor: #processBuffer:!buffers!private! !
!MD5 categoriesFor: #processFinalBuffer:bitLength:!buffers!private! !
!MD5 categoriesFor: #round:selector:round:!private!rounds! !
!MD5 categoriesFor: #rounds:!private!rounds! !
!MD5 categoriesFor: #step:template:selector:!functions!private! !
!MD5 categoriesFor: #storeLength:in:!buffers!private! !

!MD5 class methodsFor!

clear
	#swAdded.
	ABCDTable := IndexTable := ShiftTable := SinTable := nil!

hashForFileNamed: fileName 
	"	| fs hash |
	fs := FileStream read: fileName text: false.
	fs isFileStream 
		ifTrue: [[hash := self hashStream: fs] ensure: [fs close]]
		ifFalse: [self error: 'File could not be opened'].
	^hash
"

	"using command line MD5.EXE because Smalltalk implementation of MD5 is too slow for large files"

	| result tokens |
	(ItcSystemManager fileExists: fileName) ifFalse: [self error: 'File does not exist'].
	result := ItcSystemManager 
				startExternalProgram: (ItcSystemManager isRunningOnLinux ifTrue: ['md5sum'] ifFalse: ['md5'])
				commandLineParameters: (ItcSystemManager isRunningOnLinux ifTrue: ['-b '] ifFalse: ['']) , '"' 
						, fileName , '"'.
	tokens := result itcSubStrings: $ .
	(tokens size > 1 and: [tokens first size = 32]) 
		ifFalse: [self error: 'Invalid result from command line MD5 utility'].
	^tokens first asUppercase!

hashMessage: aStringOrByteArray 
	"'DSM 1/20/2000 18:03'"

	SinTable isNil ifTrue: [self initialize].
	^self new hashMessage: aStringOrByteArray!

hashStream: aPositionableStream 
	"'DSM 1/20/2000 18:03'"

	SinTable isNil ifTrue: [self initialize].
	^self new hashStream: aPositionableStream!

initialize
	"
	MD5 initialize
	'mdr 2/23/2001 22:50'"

	"Obscure fact: those magic hex numbers that are hard to type in correctly are
	actually the result of a simple trigonometric function and are therefore
	easier to compute than proofread.  Laziness is sometimes a virtue."

	| c |
	c := 2 raisedTo: 32.
	SinTable := Array new: 64.
	1 to: 64
		do: [:i | SinTable at: i put: (ThirtyTwoBitRegister new load: (c * i sin abs) truncated)].
	"swChanged; modified from squeak's {}"
	ShiftTable := Array 
				with: #(7 12 17 22)
				with: #(5 9 14 20)
				with: #(4 11 16 23)
				with: #(6 10 15 21).
	IndexTable := Array 
				with: #(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16)
				with: #(2 7 12 1 6 11 16 5 10 15 4 9 14 3 8 13)
				with: #(6 9 12 15 2 5 8 11 14 1 4 7 10 13 16 3)
				with: #(1 8 15 6 13 4 11 2 9 16 7 14 5 12 3 10).
	ABCDTable := Array 
				with: #(1 2 3 4)
				with: #(4 1 2 3)
				with: #(3 4 1 2)
				with: #(2 3 4 1)!

test
	"MD5 test
	'mdr 2/23/2001 22:48'"

	(MD5 hashMessage: 'a') = 16r0CC175B9C0F1B6A831C399E269772661
		ifFalse: [ self error: 'failed'].
	(MD5 hashMessage: 'abc') = 16r900150983CD24FB0D6963F7D28E17F72
		ifFalse: [ self error: 'failed'].
	(MD5 hashMessage: 'message digest') = 16rF96B697D7CB7938D525A2F31AAF161D0
		ifFalse: [ self error: 'failed'].
	(MD5 hashMessage:
		'abcdefghijklmnopqrstuvwxyz') = 16rC3FCD3D76192E4007DFB496CCA67E13B
		ifFalse: [ self error: 'failed'].
	(MD5 hashMessage:

	'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789') =
		16rD174AB98D277D9F5A5611C2C9F419D9F
		ifFalse: [ self error: 'failed'].
	(MD5 hashMessage:
	'12345678901234567890123456789012345678901234567890123456789012345678901234567890') = 		16r57EDF4A22BE3C955AC49DA2E2107B67A
		ifFalse: [ self error: 'failed'].
!

uninitialize
	#swAdded.
	self clear! !
!MD5 class categoriesFor: #clear!class initialization!public! !
!MD5 class categoriesFor: #hashForFileNamed:!public!utilities! !
!MD5 class categoriesFor: #hashMessage:!public!utilities! !
!MD5 class categoriesFor: #hashStream:!public!utilities! !
!MD5 class categoriesFor: #initialize!class initialization!public! !
!MD5 class categoriesFor: #test!public!testing! !
!MD5 class categoriesFor: #uninitialize!class initialization!private! !

