"Filed out from Dolphin Smalltalk 7"!

StdioFileStream subclass: #StdioTextFileStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StdioTextFileStream guid: (GUID fromString: '{8a9acce8-979d-4821-aa11-a5b4157634af}')!
StdioTextFileStream isAbstract: true!
StdioTextFileStream comment: ''!
!StdioTextFileStream categoriesForClass!Collections-Streams! !
!StdioTextFileStream methodsFor!

basicPrint: anObject 
	anObject basicPrintOn: self!

cr
	"Store the line delimiter character sequence (as required by
	the environment) as the next element(s) of the receiver."

	"Implementation Note: Assumes the receiver is in text mode, and 
	will translate the single LF character to a CR/LF pair on output."

	self nextPut: $\n!

crtab
	"Append a line-delimiter and a tab to the receiver."

	self cr; tab!

crtab: anInteger 
	"Append a line-delimiter and the specified number of tabs to the receiver."

	self
		cr;
		tab: anInteger!

externalType
	"Answer a <symbol> which names the external stream type of the receiver."

	^#text!

isText
	"Answer whether the receiver's data is characters.
	X3J20 (draft) includes rational as to why this message is not called #isCharacter."

	^true!

next
	"Answer a <Character> being the next code point decoded from the receiver's future sequence values."

	^self contentsSpecies decodeNextFrom: self!

nextLine
	"Answer a Collection consisting of the receiver contents up to (but not including) the 
	next line delimiter. If there are no further line delimiters in the receiver, then the 
	rest of the receiver's contents are answered. If the receiver is at its end, then an empty 
	collection is answered."

	^self subclassResponsibility! !
!StdioTextFileStream categoriesFor: #basicPrint:!printing!private! !
!StdioTextFileStream categoriesFor: #cr!accessing!public! !
!StdioTextFileStream categoriesFor: #crtab!accessing!public! !
!StdioTextFileStream categoriesFor: #crtab:!accessing!public! !
!StdioTextFileStream categoriesFor: #externalType!accessing!public! !
!StdioTextFileStream categoriesFor: #isText!public!testing! !
!StdioTextFileStream categoriesFor: #next!accessing!public! !
!StdioTextFileStream categoriesFor: #nextLine!accessing!public! !

StdioTextFileStream methodProtocol: #puttableStream attributes: #(#ansi #readOnly) selectors: #(#cr #flush #nextPut: #nextPutAll: #space #tab)!
StdioTextFileStream methodProtocol: #writeFileStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #cr #externalType #flush #isBinary #isEmpty #isText #nextPut: #nextPutAll: #position #position: #reset #setToEnd #space #tab)!

!StdioTextFileStream class methodsFor!

encodingMode
	^$t! !
!StdioTextFileStream class categoriesFor: #encodingMode!constants!private! !

