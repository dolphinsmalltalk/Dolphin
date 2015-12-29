"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #ChunkFileMethodScanner
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkFileMethodScanner guid: (GUID fromString: '{B8B83C19-E601-4265-B607-2A0B2122144B}')!
ChunkFileMethodScanner comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006-2008 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkFileMethodScanner categoriesForClass!IDB Goodies! !
!ChunkFileMethodScanner methodsFor!

nextChunkFrom: aStream
	"Answer the contents of the next chunk, without bangs, in aStream"

	| result |
	aStream skipSeparators.
	result := aStream upTo: $!!.
	[aStream atEnd or: [(aStream peekFor: $!!) not]]
		whileFalse: [result := result , '!!' , (aStream upTo: $!!)].
	^result!

positionsOf: aString in: aStream firstOnly: aBoolean
	"Answer a collection of integers representing all the positions of aString in aStream. If
	aBoolean is true (when checking the sources steam) then return after the first, and only,
	entry is founs"

	| positions |
	positions := Set new.
	aStream reset.
	[aStream atEnd]
		whileFalse:
			[| startPosition bytes offset |
			aStream position > aString size ifTrue: [aStream position: aStream position - aString size].
			startPosition := aStream position.
			bytes := aStream nextAvailable: 500000.
			offset := 1.
			[offset = 0]
				whileFalse:
					[(offset := bytes indexOfSubCollection: aString startingAt: offset) = 0
						ifFalse:
							[positions add: startPosition + offset + aString size - 1.
							aBoolean ifTrue: [^positions asSortedCollection].
							offset := offset + 1]]].
	^positions asSortedCollection!

scan: aStream for: aString source: aSymbol
	"Answer a collection of method definitions from aStream. First find all the positions of
	aString in the target file then collect the text from that position. An occurence of aString
	may be followed by one or more definition chunks and will always end with an empty chunk

	each item
		at: 1 = #changes or #sources 
		at: 2 = selector as Symbol 
		at: 3 = method source"

	| chunks selectorParser |
	selectorParser := SelectorParser new.
	chunks := OrderedCollection new.
	(self
		positionsOf: aString
		in: aStream
		firstOnly: aSymbol == #sources)
		do:
			[:offset | 
			| chunk |
			aStream position: offset.
			chunk := self nextChunkFrom: aStream.
			[chunk isEmpty]
				whileFalse:
					[chunks
						add:
							(Array
								with: aSymbol
								with: (selectorParser parse: chunk) asSymbol
								with: chunk).
					chunk := self nextChunkFrom: aStream]].
	^chunks!

scanChangesFileFor: aString
	"Scan the changes file for method definition chunks preceded by aString"

	#idbToDo.	"Temporary fix for Dolphin bug.  Do not attempt to read change log if it is less than one buffer in size"
	SourceManager default changesStream size <= FileStream bufferSize ifTrue: [^OrderedCollection new].
	^self
		scan: SourceManager default changesStream
		for: aString
		source: #changes!

scanForMethodChunks: aMethodSelector inClass: aClass
	"Answers a collection of Arrays containing all the method definitions for
	aClass>>aMethodSelector from both the sources and change files.

	each item
		at: 1 = #changes or #sources 
		at: 2 = selector as Symbol 
		at: 3 = method source"

	^(self scanForMethodChunksInClass: aClass) select: [:each | aMethodSelector = each second]!

scanForMethodChunksInClass: aClass
	"Answers a collection of Arrays containing all the method definitions, from both the sources
	and change files, belonging to aClass

	each item
		at: 1 = #changes or #sources 
		at: 2 = selector as Symbol 
		at: 3 = method source"

	| target |
	target := '!!<1s> methodsFor!!' expandMacrosWith: aClass name.
	^(self scanSourcesFileFor: target) , (self scanChangesFileFor: target)!

scanSourcesFileFor: aString
	"Scan the sources file for method definition chunks preceded by aString"

	^self
		scan: SourceManager default sourcesFileStream
		for: aString
		source: #sources! !
!ChunkFileMethodScanner categoriesFor: #nextChunkFrom:!file operations!public! !
!ChunkFileMethodScanner categoriesFor: #positionsOf:in:firstOnly:!file operations!public! !
!ChunkFileMethodScanner categoriesFor: #scan:for:source:!operations!public! !
!ChunkFileMethodScanner categoriesFor: #scanChangesFileFor:!operations!public! !
!ChunkFileMethodScanner categoriesFor: #scanForMethodChunks:inClass:!operations!public! !
!ChunkFileMethodScanner categoriesFor: #scanForMethodChunksInClass:!operations!public! !
!ChunkFileMethodScanner categoriesFor: #scanSourcesFileFor:!operations!public! !

!ChunkFileMethodScanner class methodsFor!

forMethod: aMethodSelector inClass: aClass
	"Answers a collection containing all the method definitions for aClass>>aMethodSelector from
	both the sources and change files"

	^self new scanForMethodChunks: aMethodSelector inClass: aClass!

forMethodsInClass: aClass
	"Answers a collection containing all the method definitions, from both the sources and
	change files, belonging to aClass"

	^self new scanForMethodChunksInClass: aClass! !
!ChunkFileMethodScanner class categoriesFor: #forMethod:inClass:!instance creation!public! !
!ChunkFileMethodScanner class categoriesFor: #forMethodsInClass:!instance creation!public! !

