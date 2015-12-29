"Filed out from Dolphin Smalltalk X6.2"!

EmailMIMEDecoder subclass: #EmailQuotedPrintableDecoder
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'singelton'!
EmailQuotedPrintableDecoder guid: (GUID fromString: '{62F05317-D8BF-434C-BE1F-238F64BC9CF3}')!
EmailQuotedPrintableDecoder comment: ''!
!EmailQuotedPrintableDecoder categoriesForClass!Unclassified! !
!EmailQuotedPrintableDecoder methodsFor!

decodeFrom: aCollection 
	| inStream outStream streamSize character hexString |
	inStream := ReadStream on: aCollection.
	streamSize := inStream size.
	outStream := WriteStream on: String new.
	[inStream atEnd] whileFalse: 
			[character := inStream next.
			character = $= 
				ifTrue: 
					[streamSize - inStream position >= 2 
						ifTrue: 
							[hexString := inStream next: 2.
							hexString first = 13 asCharacter 
								ifFalse: [character := (self hexToInt: hexString) asCharacter]
								ifTrue: [character := nil]]].
			character isNil ifFalse: [outStream nextPut: character]].
	^outStream contents!

hexToInt: aString 
	| n |
	n := 0.
	aString asLowercase do: 
			[:ch | 
			n := n * 16.
			n := n 
						+ (ch isDigit ifTrue: [ch asInteger - $0 asInteger] ifFalse: [ch asInteger - $a asInteger + 10])].
	^n! !
!EmailQuotedPrintableDecoder categoriesFor: #decodeFrom:!public! !
!EmailQuotedPrintableDecoder categoriesFor: #hexToInt:!public! !

!EmailQuotedPrintableDecoder class methodsFor!

decodeFrom: aString

	^self default decodeFrom: aString!

default

	singelton isNil 
		ifTrue: [singelton := self new].
	^singelton!

reset

	singelton := nil! !
!EmailQuotedPrintableDecoder class categoriesFor: #decodeFrom:!public! !
!EmailQuotedPrintableDecoder class categoriesFor: #default!public! !
!EmailQuotedPrintableDecoder class categoriesFor: #reset!public! !

