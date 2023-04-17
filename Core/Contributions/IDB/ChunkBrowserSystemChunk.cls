"Filed out from Dolphin Smalltalk"!

ChunkBrowserOtherChunk subclass: #ChunkBrowserSystemChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserSystemChunk guid: (GUID fromString: '{e2344df7-4685-46a5-a350-969184292b80}')!
ChunkBrowserSystemChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserSystemChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserSystemChunk methodsFor!

initializeIdentity
	"
	'' 2002-04-03T11:06:39+01:00：Dolphin Smalltalk
	'' 2002-04-03T11:06:39+01:00：Loading package 'DSDN' from：C:\Documents and Settings\Ian\My Documents\Dolphin Smalltalk 5.0\DSDN\DSDN.pac
	'' 2002-04-03T11:06:39+01:00：Loading source package
	'' 2002-04-03T11:06:39+01:00：Uninstalling package 'ChunkBrower'
	'' 2002-04-03T11:06:39+01:00：Image saved
	'' 2002-04-03T11:06:39+01:00：Compressed sources
	'' 2002-04-03T11:06:39+01:00：Compressed changes
	'' 2002-04-03T11:06:39+01:00：Compressing sources...
	"

	identity1 := self class identityFor: rawText.
	identity2 := (identity1 endsWith: 'package')
				ifTrue: [self packageName]
				ifFalse: [(DateAndTime readFrom: (rawText readStream
								next;
								yourself)) displayString]!

isImageSave
	^identity1 = 'Image save'!

packageName
	| quoteIndex |
	quoteIndex := (rawText indexOf: $') + 1.
	^rawText
		copyFrom: quoteIndex
		to:
			(rawText
				nextIndexOf: $'
				from: quoteIndex
				to: rawText size) - 1! !
!ChunkBrowserSystemChunk categoriesForMethods!
initializeIdentity!initializing!public! !
isImageSave!public!testing! !
packageName!helpers!public! !
!

!ChunkBrowserSystemChunk class methodsFor!

chunkType
	^#System!

hasText: aString
	^(self identityFor: aString) notNil!

hasTime: aString
	"'' 2002-04-03T11:06:39+01:00：Image saved''"

	^(DateAndTime readFrom: ((ReadStream on: aString)
				next;
				yourself)
		ifInvalid: nil) notNil!

identityFor: aString
	| lookup |
	lookup := ##({
				'：Dolphin Smalltalk' -> 'Image start'.
				'：Loading package' -> 'Load package'.
				'：Loading source package' -> 'Load package'.
				'：Uninstalling package' -> 'Uninstall package'.
				'：Image saved' -> 'Image save'.
				'：Compressed sources' -> 'Compressed sources'.
				'：Compressed changes' -> 'Compressed changes'.
				'：Compressing sources...' -> 'Compressed sources'
			}).
	^(lookup detect: [:each | (aString indexOfSubCollection: each key startingAt: 1) ~= 0] ifNone: nil)
		ifNotNil: [:arg | arg value]!

isChunkClassFor: aString tokens: anArray
	"
	'' 2002-04-03T11:06:39+01:00：Dolphin Smalltalk
	'' 2002-04-03T11:06:39+01:00：Loading package 'DSDN' from：C:\Documents and Settings\Ian\My Documents\Dolphin Smalltalk 5.0\DSDN\DSDN.pac
	'' 2002-04-03T11:06:39+01:00：Loading source package
	'' 2002-04-03T11:06:39+01:00：Uninstalling package 'ChunkBrower'
	'' 2002-04-03T11:06:39+01:00：Image saved
	'' 2002-04-03T11:06:39+01:00：Compressed sources
	'' 2002-04-03T11:06:39+01:00：Compressed changes
	'' 2002-04-03T11:06:39+01:00：Compressing sources...
	"

	^anArray isEmpty
		and: [(aString includes: $：) and: [(self hasTime: aString) and: [self hasText: aString]]]! !
!ChunkBrowserSystemChunk class categoriesForMethods!
chunkType!constants!public! !
hasText:!public!testing! !
hasTime:!public!testing! !
identityFor:!constants!public! !
isChunkClassFor:tokens:!public!testing! !
!

