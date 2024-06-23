"Filed out from Dolphin Smalltalk"!

STON.JsonWriter
	subclass: #'STON.JsonPrettyPrinter'
	instanceVariableNames: 'level'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

STON.JsonPrettyPrinter guid: (Core.GUID fromString: '{27fb8c25-44b6-4a59-8c62-0d761139087c}')!

STON.JsonPrettyPrinter comment: ''!

!STON.JsonPrettyPrinter categoriesForClass!STON-Core-Writer! !

!STON.JsonPrettyPrinter methodsFor!

encodeList: elements
	writeStream nextPut: $[.
	elements isEmpty
		ifTrue: [writeStream space]
		ifFalse: 
			[level := level + 1.
			elements do: 
					[:each |
					self
						newlineIndent;
						nextPut: each]
				separatedBy: [writeStream nextPut: $,].
			level := level - 1.
			self newlineIndent].
	writeStream nextPut: $]!

encodeMap: pairs
	writeStream nextPut: ${.
	pairs isEmpty
		ifTrue: [writeStream space]
		ifFalse: 
			[| keys |
			level := level + 1.
			"In Json mode the keys must be strings, so we know we can sort them for stable ordering."
			keys := pairs keys asSortedArray.
			keys do: 
					[:key |
					self newlineIndent.
					self encodeKey: key value: (pairs at: key)]
				separatedBy: [writeStream nextPut: $,].
			level := level - 1.
			self newlineIndent].
	writeStream nextPut: $}!

indentedDo: block
	level := level + 1.
	block value.
	level := level - 1!

initialize
	super initialize.
	level := 0!

listElementSeparator
	writeStream nextPut: $,.
	self newlineIndent
!

mapElementSeparator
	writeStream nextPut: $,.
	self newlineIndent
!

newlineIndent
	writeStream nextPutAll: newLine.
	level timesRepeat: [writeStream tab]!

prettyPrintSpace
	writeStream space! !

!STON.JsonPrettyPrinter categoriesForMethods!
encodeList:!public!writing! !
encodeMap:!public!writing! !
indentedDo:!helpers!private! !
initialize!initialization!private! !
listElementSeparator!helpers!private! !
mapElementSeparator!helpers!private! !
newlineIndent!helpers!private! !
prettyPrintSpace!helpers!private! !
!

