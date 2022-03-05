"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #Base64CodecTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Base64CodecTest guid: (GUID fromString: '{29f3cfca-13c2-49dd-bcac-20c64297a7f0}')!
Base64CodecTest comment: ''!
!Base64CodecTest categoriesForClass!Unclassified! !
!Base64CodecTest methodsFor!

roundTrip: bytes
	| stream bytes2 string |
	stream := String writeStream.
	Base64Codec encodeFrom: bytes readStream onto: stream.
	string := stream contents.
	stream := ByteArray writeStream.
	Base64Codec decodeFrom: string readStream onto: stream.
	bytes2 := stream contents.
	self assert: bytes equals: bytes2!

testLineLength
	| codec bytes stream string |
	codec := Base64Codec new.
	bytes := (1 to: 76 / 4 * 3) asByteArray.
	stream := String writeStream.
	codec encodeFrom: bytes readStream onto: stream.
	string := stream contents.
	self assert: string size equals: 76.
	self assert: (string readStream
				nextLine;
				atEnd).
	"Extra byte will cause the line to be wrapped, and of course it will be padded out to a multiple of four"
	bytes := (1 to: 76 / 4 * 3 + 1) asByteArray.
	stream := String writeStream.
	codec encodeFrom: bytes readStream onto: stream.
	string := stream contents.
	self assert: string size equals: 76 + 2 + 4.
	self deny: (string readStream
				nextLine;
				atEnd).
	bytes := (1 to: 76 * 2 / 4 * 3) asByteArray.
	stream := String writeStream.
	codec encodeFrom: bytes readStream onto: stream.
	string := stream contents.
	self assert: string size equals: 76 * 2 + 2.
	self assert: (string readStream
				nextLine;
				nextLine;
				atEnd)
	"self assert: string = pair second"!

testPadding
	#(#(#[0] 'AA==') #(#[1] 'AQ==') #(#[63] 'Pw==') #(#[64] 'QA==') #(#[65] 'QQ==') #(#[2] 'Ag==') #(#[255] '/w==') #(#[1 1] 'AQE=') #(#[2 1] 'AgE=') #(#[2 2] 'AgI=') #(#[2 3] 'AgM=') #(#[63 0] 'PwA=') #(#[64 0] 'QAA=') #(#[65 0] 'QQA=') #(#[63 1] 'PwE=') #(#[64 1] 'QAE=') #(#[65 1] 'QQE=') #(#[255 0] '/wA=') #(#[255 1] '/wE=') #(#[255 63] '/z8=') #(#[255 64] '/0A=') #(#[255 65] '/0E=') #(#[255 255] '//8=') #(#[1 0 0] 'AQAA') #(#[1 0 1] 'AQAB') #(#[1 1 0] 'AQEA') #(#[1 1 1] 'AQEB') #(#[1 1 63] 'AQE/') #(#[1 1 64] 'AQFA') #(#[1 1 65] 'AQFB') #(#[1 63 0] 'AT8A') #(#[1 63 1] 'AT8B') #(#[1 63 63] 'AT8/') #(#[63 63 63] 'Pz8/') #(#[1 64 1] 'AUAB') #(#[1 65 1] 'AUEB') #(#[64 64 64] 'QEBA') #(#[0 255 255] 'AP//') #(#[0 0 255] 'AAD/') #(#[255 255 255] '////'))
		do: 
			[:pair |
			| stream string bytes |
			stream := String writeStream.
			Base64Codec encodeFrom: pair first readStream onto: stream.
			string := stream contents.
			self assert: string equals: pair second.
			stream := ByteArray writeStream.
			Base64Codec decodeFrom: string readStream onto: stream.
			bytes := stream contents.
			self assert: bytes equals: pair first]!

testRFC2440
	#(#(#[16r14 16rFB 16r9C 16r03 16rD9 16r7E] 'FPucA9l+') #(#[16r14 16rFB 16r9C 16r03 16rD9] 'FPucA9k=') #(#[16r14 16rFB 16r9C 16r03] 'FPucAw=='))
		do: 
			[:each |
			| encoded decoded |
			encoded := String writeStream.
			Base64Codec encodeFrom: each first readStream onto: encoded.
			self assert: encoded contents equals: each second.
			decoded := ByteArray writeStream.
			Base64Codec decodeFrom: each second readStream onto: decoded.
			self assert: decoded contents equals: each first]!

testSmokeTest
	| r |
	r := Random new.
	0 to: 255
		do: 
			[:i | 
			self roundTrip: (1 to: i) asByteArray.
			self roundTrip: ((r next: 256) collect: [:each | (each * 256) truncated]) asByteArray]!

testVM
	"Base64 encoding is used to build st patches for the system binaries, so we need to be
	confident that it works."

	| f encoded decoded |
	f := FileStream read: VMLibrary default fileName text: false.
	encoded := String writeStream.
	Base64Codec encodeFrom: f onto: encoded.
	decoded := ByteArray writeStream.
	Base64Codec decodeFrom: encoded contents readStream onto: decoded.
	self assert: decoded contents equals: f contents! !
!Base64CodecTest categoriesForMethods!
roundTrip:!helpers!private! !
testLineLength!public!unit tests! !
testPadding!public!unit tests! !
testRFC2440!public!unit tests! !
testSmokeTest!public!unit tests! !
testVM!public!unit tests! !
!

