"Filed out from Dolphin Smalltalk"!

Object subclass: #ChunkFileMethodScanner
	instanceVariableNames: 'readBufferSize'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ChunkFileMethodScanner guid: (GUID fromString: '{b8b83c19-e601-4265-b607-2a0b2122144b}')!

ChunkFileMethodScanner comment: 'Scans the sources and changes file and answers a collection of either...
- all the method versions for a specified class
- all the method versions for a specified method in a class

Usage
ChunkFileMethodScanner forMethodsInClass: aClass
ChunkFileMethodScanner forMethod: aSymbol inClass: aClass

The answer is a collection of Arrays, one for each method version found.  
Each entry in the Array contains 3 items

at: 1 = the source of the chunk, either #changes or #sources 
at: 2 = the selector the method was saved as, a Symbol 
at: 3 = the method source

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ChunkFileMethodScanner categoriesForClass!IDB Goodies! !

!ChunkFileMethodScanner methodsFor!

defaultReadBufferSize

	"As per original IDB version"

	^500000!

initialize

	readBufferSize := self defaultReadBufferSize!

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
			bytes := aStream basicNextAvailable: readBufferSize.
			offset := 1.
			[offset = 0]
				whileFalse:
					[(offset := bytes indexOfSubCollection: aString startingAt: offset) = 0
						ifFalse:
							[positions add: startPosition + offset + aString size - 1.
							aBoolean ifTrue: [^positions asSortedCollection].
							offset := offset + 1]]].
	^positions asSortedCollection!

readBufferSize
	^readBufferSize!

readBufferSize: anObject
	readBufferSize := anObject!

scan: aStream for: aString sourceFileIndex: anInteger
	"Answer a collection of MethodVersions from aStream. First find all the positions of
	aString in the target file then collect the text from that position. An occurence of aString
	may be followed by one or more definition chunks and will always end with an empty chunk"

	| chunks |
	chunks := OrderedCollection new.
	(self
		positionsOf: aString
		in: aStream
		firstOnly: (anInteger == SourceManager.SourcesIndex))
		do:
			[:offset | 
			| chunk startPos |
			aStream position: offset; skipSeparators.
			startPos := aStream position.
			chunk := self nextChunkFrom: aStream.
			[chunk isEmpty]
				whileFalse:
					[chunks add: (MethodVersion forSource: chunk at: startPos in: (SourceFiles at: anInteger)).
					aStream skipSeparators.
					startPos := aStream position.
					chunk := self nextChunkFrom: aStream]].
	^chunks!

scanChangesFileFor: aString
	"Scan the changes file for method definition chunks preceded by aString"

	^self
		scan: SourceManager default changesStream
		for: aString
		sourceFileIndex: SourceManager.ChangesIndex!

scanForMethodVersions: aMethodSelector inClass: aClass 
	"Answers a collection of MethodVersions containing all the method definitions for
	aClass>>aMethodSelector from both the sources and change files"

	^(self scanForMethodVersionsInClass: aClass) select: [:each | aMethodSelector = each selector]!

scanForMethodVersionsInClass: aClass 
	"Answers a collection of MethodVersions containing all the method definitions, from both the sources
	and change files, belonging to aClass"

	| target |
	target := (String writeStream)
				nextPut: $!!;
				nextPutAll: aClass name;
				nextPutAll: ' methodsFor!!';
				cr;
				contents.
	^((self scanSourcesFileFor: target) , (self scanChangesFileFor: target)) do: [ :each | each methodClass: aClass]!

scanSourcesFileFor: aString
	"Scan the sources file for method definition chunks preceded by aString"

	^self
		scan: SourceManager default sourcesFileStream
		for: aString
		sourceFileIndex: SourceManager.SourcesIndex! !

!ChunkFileMethodScanner categoriesForMethods!
defaultReadBufferSize!constants!public! !
initialize!initializing!public! !
nextChunkFrom:!file operations!public! !
positionsOf:in:firstOnly:!file operations!public! !
readBufferSize!accessing!private! !
readBufferSize:!accessing!private! !
scan:for:sourceFileIndex:!operations!public! !
scanChangesFileFor:!operations!public! !
scanForMethodVersions:inClass:!operations!public! !
scanForMethodVersionsInClass:!operations!public! !
scanSourcesFileFor:!operations!public! !
!

!ChunkFileMethodScanner class methodsFor!

forMethod: aMethodSelector inClass: aClass
	"Answers a collection containing all the method definitions for aClass>>aMethodSelector from
	both the sources and change files"

	^self new scanForMethodVersions: aMethodSelector inClass: aClass!

forMethodsInClass: aClass
	"Answers a collection containing all the method definitions, from both the sources and
	change files, belonging to aClass"

	^self new scanForMethodVersionsInClass: aClass!

new

	^super new initialize! !

!ChunkFileMethodScanner class categoriesForMethods!
forMethod:inClass:!instance creation!public! !
forMethodsInClass:!instance creation!public! !
new!instance creation!public! !
!

