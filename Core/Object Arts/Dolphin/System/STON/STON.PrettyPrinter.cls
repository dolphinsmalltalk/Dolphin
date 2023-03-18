"Filed out from Dolphin Smalltalk"!

STON.Writer
	subclass: #'STON.PrettyPrinter'
	instanceVariableNames: 'level'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.PrettyPrinter guid: (Core.GUID fromString: '{80975c9b-d51d-43ef-833f-a673161ea9dd}')!
STON.PrettyPrinter comment: ''!
!STON.PrettyPrinter categoriesForClass!STON-Core-Writer! !
!STON.PrettyPrinter methodsFor!

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
			keys := pairs keys.
			"Attempt to sort the keys so the output order is stable if possible"
			[keys := keys asSortedArray] on: Error do: [:ex | ].
			keys do: 
					[:key |
					self
						newlineIndent;
						encodeKey: key value: (pairs at: key)]
				separatedBy: [writeStream nextPut: $,].
			level := level - 1.
			self newlineIndent].
	writeStream nextPut: $}!

indentedDo: aNiladicValuable
	level := level + 1.
	aNiladicValuable value.
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
!STON.PrettyPrinter categoriesForMethods!
encodeList:!public!writing! !
encodeMap:!public!writing! !
indentedDo:!helpers!private! !
initialize!initialize/release!private! !
listElementSeparator!helpers!private! !
mapElementSeparator!helpers!private! !
newlineIndent!helpers!private! !
prettyPrintSpace!helpers!private! !
!

