"Filed out from Dolphin Smalltalk 1.0 Beta 2 - but hacked subsequently to work in Dolphin 8"!

Object subclass: #HexadecimalConverter
	instanceVariableNames: 'text convertedTextStream chunkSize '
	classVariableNames: ''
	poolDictionaries: ''!

HexadecimalConverter class instanceVariableNames: ''!

HexadecimalConverter comment: ''!

!HexadecimalConverter categoriesForClass!No category! !

!HexadecimalConverter methodsFor!

appendCharacter: aCharacter
	convertedTextStream nextPut: aCharacter!

appendConvertedText: aString
	| count |
	count := 0.
	aString do: [:character|
		"D8: Was Character>>asciiValue, but this fails in D7.1 and later if the code unit is > 127"
		self appendHexadecimal: character codeUnit zeroPadTo: 2.
		count := count + 1.
		count >= 4 ifTrue: [count := 0. self appendSpace]]!

appendHexadecimal: aNumber zeroPadTo: minimumSize
	self appendString: (aNumber 
		printStringRadix: 16 zeroPadTo: minimumSize)!

appendNewLine
	convertedTextStream cr!

appendSpace
	convertedTextStream space!

appendSpaces: numberOfSpaces
	numberOfSpaces timesRepeat: [convertedTextStream space]!

appendString: aString
	convertedTextStream nextPutAll: aString!

appendUnconvertedText: aString
	aString do: [:character |
		"D8: In the original sample this used Character>>#isPrintable, but now that includes CR/LF, etc, messing up the output"
		self appendCharacter: (character isControl
			ifFalse: [character]
			ifTrue: [$.])]!

chunkSize
	^chunkSize!

chunkSize: anInteger
	chunkSize := anInteger!

convertedText
	| textStream chunk offset |
	self prepareToAppend.
	textStream := ReadStream on: self text.
	offset := 0.
	[textStream atEnd] whileFalse: [
		chunk := textStream nextAvailable: self chunkSize.
		self appendNewLine.
		self appendHexadecimal: offset zeroPadTo: 6.
		self appendString: ': '.
		self appendConvertedText: chunk.
		self appendString: '   '.
		self appendUnconvertedText: chunk.
		offset := offset + chunk size].
	^convertedTextStream contents!

initialize
	self chunkSize: 20!

prepareToAppend
	convertedTextStream := WriteStream on: (String new: 1000).
!

text
	^text!

text: aString
	text := aString! !

!HexadecimalConverter categoriesFor: #appendCharacter:!private stream appending! !
!HexadecimalConverter categoriesFor: #appendConvertedText:!private stream appending! !
!HexadecimalConverter categoriesFor: #appendHexadecimal:zeroPadTo:!private stream appending! !
!HexadecimalConverter categoriesFor: #appendNewLine!private stream appending! !
!HexadecimalConverter categoriesFor: #appendSpace!private stream appending! !
!HexadecimalConverter categoriesFor: #appendSpaces:!private stream appending! !
!HexadecimalConverter categoriesFor: #appendString:!private stream appending! !
!HexadecimalConverter categoriesFor: #appendUnconvertedText:!private stream appending! !
!HexadecimalConverter categoriesFor: #chunkSize!public querying! !
!HexadecimalConverter categoriesFor: #chunkSize:!public specification! !
!HexadecimalConverter categoriesFor: #convertedText!public querying! !
!HexadecimalConverter categoriesFor: #initialize!initializing! !
!HexadecimalConverter categoriesFor: #prepareToAppend!private stream appending! !
!HexadecimalConverter categoriesFor: #text!public querying! !
!HexadecimalConverter categoriesFor: #text:!public specification! !

!HexadecimalConverter class methodsFor!

example1
	"HexadecimalConverter example1"
	^(self new text: 'testing ONE TWO THREE: 1 2 3 4')
		convertedText!

example2
	"HexadecimalConverter example2"
	| openFilename stream data |
	openFilename := FileOpenDialog new
		fileTypes: #( ('All Files (*.*)' '*.*') );
		defaultExtension: '';
		showModal.
	openFilename isNil ifTrue: [^''].
	stream := FileStream read: openFilename.
	data := stream contents.
	stream close.
	^(self new text: data)
		convertedText!

new
	^super new initialize! !

!HexadecimalConverter class categoriesFor: #example1!examples! !
!HexadecimalConverter class categoriesFor: #example2!examples! !
!HexadecimalConverter class categoriesFor: #new!instance creation! !

