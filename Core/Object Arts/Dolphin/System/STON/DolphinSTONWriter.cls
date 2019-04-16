"Filed out from Dolphin Smalltalk 7"!

STONWriter subclass: #DolphinSTONWriter
	instanceVariableNames: ''
	classVariableNames: 'ExtendedCharacters'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinSTONWriter guid: (GUID fromString: '{56f95579-e6b4-4cd5-8ca6-c7cf2f754593}')!
DolphinSTONWriter comment: ''!
!DolphinSTONWriter categoriesForClass!Unclassified! !
!DolphinSTONWriter methodsFor!

encodeString: aString

	writeStream nextPut: (jsonMode ifTrue: [$"] ifFalse: [$']).
	keepNewLines
		ifTrue: [self encodeStringKeepingNewLines: aString]
		ifFalse: 
			[| stream ch |
			"Superclass implementation does not work correctly for Dolphin's UTF-encoded Strings, as these enumerate code units, not code points. We must stream over the string instead."
			stream := aString readStream.
			[(ch := stream nextAvailable) isNil] whileFalse: [self encodeCharacter: ch]].
	writeStream nextPut: (jsonMode ifTrue: [$"] ifFalse: [$'])!

escape: char with: anObject
	"Instruct me to escape char with object, either a replacement string or #pass"
	
	"self escape: $/ with: '\/'."
	
	self assert: [anObject isString | (anObject == #pass)].
	self assert: [char isOctetCharacter].
	self writeableStonCharacters at: char codePoint + 1 put: anObject!

isSimpleSymbol: aSymbol
	"In Dolphin Symbols can contain any UTF-8 characters, including from outside the basic plane. The basic implementation does not work correctly correctly for extended characters in Pharo either, e.g. try:
		STONWriter new isSimpleSymbol: (Character value: 16r1F42C) asSymbol.
	Which should be false, since #'🐬' is not a simple symbol. The base implementation returns true in Pharo for this example.
	"

	| stream ch |
	aSymbol isEmpty ifTrue: [^false].
	stream := aSymbol readStream.
	[(ch := stream nextAvailable) isNil]
		whileFalse: [(STONSimpleSymbolCharacters at: ch codePoint + 1 ifAbsent: [1]) == 0 ifFalse: [^false]].
	^true! !
!DolphinSTONWriter categoriesFor: #encodeString:!private! !
!DolphinSTONWriter categoriesFor: #escape:with:!initialize/release!public! !
!DolphinSTONWriter categoriesFor: #isSimpleSymbol:!private! !

