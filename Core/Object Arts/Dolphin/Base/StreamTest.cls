"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #StreamTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StreamTest guid: (GUID fromString: '{f1611eb3-2c1c-491e-a814-c62dcdce0fff}')!
StreamTest isAbstract: true!
StreamTest comment: ''!
!StreamTest categoriesForClass!Unclassified! !
!StreamTest methodsFor!

closeTempStream: aStream
	"Private - Clean up the temporary stream argument."!

streamClass
	^self subclassResponsibility!

streamOn: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	^self streamClass on: aString!

testUpTo
	| pound capitalAwithCircumflex |
	pound := Character value: 16rA3.
	"A-with-circumflex is also the lead byte for pound in UTF-8"
	capitalAwithCircumflex := Character value: 16rC2.
	{AnsiString. Utf8String} do: 
			[:stringClass |
			| chars stream |
			chars := (stringClass with: capitalAwithCircumflex) , 'bcde' , (stringClass with: pound) , 'ghij'.
			self assert: chars class equals: stringClass.
			stream := self streamOn: chars.
			self assert: stream upToEnd equals: chars.
			"Search for a potentially multi-byte char at the start"
			stream reset.
			self assert: (stream upTo: capitalAwithCircumflex) equals: ''.
			"Search for a single-byte char"
			self assert: (stream upTo: $c) equals: 'b'.
			"Search for another multi-byte char after the start"
			self assert: (stream upTo: pound) equals: 'de'.
			"Search for a non-existant char"
			self assert: (stream upTo: $z) equals: 'ghij'.
			self assert: stream atEnd.
			self assert: (stream upTo: $z) equals: ''.
			stream reset.
			"Search for what would be lead byte of pound"
			stream next.
			self assert: (stream upTo: capitalAwithCircumflex) equals: chars asAnsiString allButFirst.
			"Search terminating on last character"
			stream reset.
			self assert: (stream upTo: $j) equals: chars allButLast.
			self assert: stream atEnd.
			"Search for non-existant character"
			stream reset.
			self assert: (stream upTo: $z) equals: chars.
			self assert: stream atEnd.
			self closeTempStream: stream]	"Utf8String. Utf16String"! !
!StreamTest categoriesFor: #closeTempStream:!helpers!private! !
!StreamTest categoriesFor: #streamClass!helpers!private! !
!StreamTest categoriesFor: #streamOn:!helpers!private! !
!StreamTest categoriesFor: #testUpTo!public! !

