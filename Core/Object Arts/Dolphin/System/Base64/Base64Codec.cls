"Filed out from Dolphin Smalltalk X6"!

Object subclass: #Base64Codec
	instanceVariableNames: 'quadsPerLine isPadded'
	classVariableNames: 'DecodingTable EncodingTable'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Base64Codec guid: (GUID fromString: '{0127A041-211C-4E0B-B214-49AC491B95F8}')!
Base64Codec comment: 'Base64Codec is a simple but fast implementation of the widely used Base64 binary-to-ASCII text encoding scheme. For further details of Base64 see RFC 3548 (http://www.faqs.org/rfcs/rfc3548.html). Note that the implementation of Base64 provided by this class is compatible with MIME in that it splits encoded output into lines of 76 characters separated by a CR/LF pair. 

At present this class has no public instance protocol. There are class side methods to encode (#encodeFrom:onto:) and decode (#decodeFrom:onto:) the complete contents of one stream onto another. In future it is anticipated that the class will be enhanced so that it can be used as a codec in a hypothetical encoding stream that allows for more flexible usage, and this will almost certainly mean that the instance side protocol is changed. It is also anticipated that the class will permit more control over the output in future, e.g. control over the maximum line length to support different standards, whether or not the encoded data is padded to a multiple of four characters, whether or not invalid characters in the encoded data are ignored, etc.

Class Variables:
	DecodingTable		<Array>
	EncodingTable		<String>

'!
!Base64Codec categoriesForClass!Kernel-Objects! !
!Base64Codec methodsFor!

decodeFrom: aGettableStream onto: aPuttableStream 
	[aGettableStream atEnd] whileFalse: 
			[| t1 t2 |
			(t1 := self nextBase64From: aGettableStream) ifNil: [^self].
			(t2 := self nextBase64From: aGettableStream) ifNil: [^self].
			aPuttableStream nextPut: (t1 bitShift: 2) + (t2 bitShift: -4).
			(t1 := self nextBase64From: aGettableStream) ifNil: [^self].
			aPuttableStream nextPut: ((t2 bitAnd: 16rF) bitShift: 4) + (t1 bitShift: -2).
			(t2 := self nextBase64From: aGettableStream) ifNil: [^self].
			aPuttableStream nextPut: ((t1 bitAnd: 16r3) bitShift: 6) + t2]!

encodeFrom: aGettableStream onto: aPuttableStream 
	| count |
	count := 0.
	[aGettableStream atEnd] whileFalse: 
			[| value |
			count == quadsPerLine 
				ifTrue: 
					[aPuttableStream cr.
					count := 0].
			value := aGettableStream next.
			aPuttableStream nextPut: (EncodingTable at: ((value bitAnd: 2r11111100) bitShift: -2) + 1).
			aGettableStream atEnd 
				ifTrue: 
					["Emit a further character for the remaining two bits, and then two padding characters"
					aPuttableStream nextPut: (EncodingTable at: ((value bitShift: 4) bitAnd: 2r110000) + 1).
					isPadded 
						ifTrue: 
							[aPuttableStream
								nextPut: $=;
								nextPut: $=].
					^self].
			value := ((value bitAnd: 2r11) bitShift: 8) + aGettableStream next.
			aPuttableStream nextPut: (EncodingTable at: ((value bitAnd: 2r1111110000) bitShift: -4) + 1).
			aGettableStream atEnd 
				ifTrue: 
					["Emit a further character for the remaining four bits, and then a padding character."
					aPuttableStream nextPut: (EncodingTable at: ((value bitShift: 2) bitAnd: 2r111100) + 1).
					isPadded ifTrue: [aPuttableStream nextPut: $=].
					^self].
			value := ((value bitAnd: 16rF) bitShift: 8) + aGettableStream next.
			aPuttableStream nextPut: (EncodingTable at: ((value bitAnd: 2r111111000000) bitShift: -6) + 1).
			aPuttableStream nextPut: (EncodingTable at: (value bitAnd: 2r111111) + 1).
			count := count + 1].
	^0!

initialize
	self lineLength: 76.
	isPadded := true!

lineLength: anInteger 
	"Private - Set the maximum length of lines emitted by the receiver to be the <integer>
	argument, which must be a multiple of four."

	anInteger \\ 4 = 0 ifFalse: [^self error: 'line length must be a multiple of four'].
	quadsPerLine := anInteger / 4!

nextBase64From: aGettableStream 
	[aGettableStream atEnd] whileFalse: 
			[| value |
			#todo.	"Invalid characters are currently ignored, but should (optionally)
				be treated as an error - see RFC 3548. This is right for MIME though."
			(value := DecodingTable at: aGettableStream next asInteger + 1) < 64 
				ifTrue: [^value]
				ifFalse: [value == 64 ifTrue: [^nil]]].
	^nil! !
!Base64Codec categoriesFor: #decodeFrom:onto:!private! !
!Base64Codec categoriesFor: #encodeFrom:onto:!private! !
!Base64Codec categoriesFor: #initialize!initializing!private! !
!Base64Codec categoriesFor: #lineLength:!accessing!private! !
!Base64Codec categoriesFor: #nextBase64From:!helpers!private! !

!Base64Codec class methodsFor!

decodeFrom: aGettableStream onto: aPuttableStream 
	"Decode the complete set of future sequence values from the <gettableStream> argument,
	assumed to be a text stream containing Base64 encoded data, onto the <puttableStream>
	argument, assumed to be a byte stream."

	self new decodeFrom: aGettableStream onto: aPuttableStream!

encodeFrom: aGettableStream onto: aPuttableStream 
	"Encode the complete set of future sequence values from the <gettableStream> argument,
	assumed to be a byte stream, onto the <puttableStream> argument, assumed to be a text
	stream, using Base64 encoding."

	self new encodeFrom: aGettableStream onto: aPuttableStream!

initialize
	EncodingTable := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'.
	DecodingTable := ByteArray new: 256 withAll: 255.
	EncodingTable keysAndValuesDo: [:i :each | DecodingTable at: each asInteger + 1 put: i - 1].
	DecodingTable at: $= asInteger + 1 put: EncodingTable size!

new
	^(super new)
		initialize;
		yourself! !
!Base64Codec class categoriesFor: #decodeFrom:onto:!operations!public! !
!Base64Codec class categoriesFor: #encodeFrom:onto:!operations!public! !
!Base64Codec class categoriesFor: #initialize!private! !
!Base64Codec class categoriesFor: #new!instance creation!private! !

