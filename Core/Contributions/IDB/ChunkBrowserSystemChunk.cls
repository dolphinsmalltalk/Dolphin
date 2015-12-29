"Filed out from Dolphin Smalltalk X6"!

ChunkBrowserOtherChunk subclass: #ChunkBrowserSystemChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserSystemChunk guid: (GUID fromString: '{E2344DF7-4685-46A5-A350-969184292B80}')!
ChunkBrowserSystemChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserSystemChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserSystemChunk methodsFor!

compressedChanges
	identity1 := 'Compressed changes'!

compressedSources
	identity1 := 'Compressed sources'!

imageSave
	identity1 := 'Image save'!

imageStart
	identity1 := 'Image start'!

initializeIdentity
	"
	''11:06:39, 03 April 2002: Dolphin Smalltalk
	''11:06:39, 03 April 2002: Loading package
	''11:06:39, 03 April 2002: Loading source package
	''11:06:39, 03 April 2002: Uninstalling package
	''11:06:39, 03 April 2002: Image saved
	''11:06:39, 03 April 2002: Compressed sources
	''11:06:39, 03 April 2002: Compressed changes
	"

	| terminate |
	self perform: (self class symbolFor: rawText).
	(identity2 isEmpty and: [(terminate := rawText indexOfSubCollection: ': ') ~= 0]) 
		ifTrue: [identity2 := rawText copyFrom: 2 to: terminate - 1]!

isImageSave
	^identity1 = 'Image save'!

loadPackage
	"11:28:22, 06 April 2002: Loading package 'DSDN' from: C:\Documents and Settings\Ian\My Documents\Dolphin Smalltalk 5.0\DSDN\DSDN.pac"

	identity1 := 'Load package'.
	identity2 := self packageName!

packageName
	| quoteIndex |
	quoteIndex := (rawText indexOf: $') + 1.
	^rawText copyFrom: quoteIndex
		to: (rawText 
				nextIndexOf: $'
				from: quoteIndex
				to: rawText size) - 1!

restore
	^nil!

uninstallPackage
	"15:15:09, 07 April 2002: Uninstalling package 'ChunkBrowser'"

	identity1 := 'Uninstall package'.
	identity2 := self packageName! !
!ChunkBrowserSystemChunk categoriesFor: #compressedChanges!operations!public! !
!ChunkBrowserSystemChunk categoriesFor: #compressedSources!operations!public! !
!ChunkBrowserSystemChunk categoriesFor: #imageSave!operations!public! !
!ChunkBrowserSystemChunk categoriesFor: #imageStart!operations!public! !
!ChunkBrowserSystemChunk categoriesFor: #initializeIdentity!initializing!public! !
!ChunkBrowserSystemChunk categoriesFor: #isImageSave!public!testing! !
!ChunkBrowserSystemChunk categoriesFor: #loadPackage!operations!public! !
!ChunkBrowserSystemChunk categoriesFor: #packageName!helpers!public! !
!ChunkBrowserSystemChunk categoriesFor: #restore!operations!public! !
!ChunkBrowserSystemChunk categoriesFor: #uninstallPackage!operations!public! !

!ChunkBrowserSystemChunk class methodsFor!

chunkType
	^#System!

isChunkClassFor: aString 
	"
	''11:06:39, 03 April 2002: Dolphin Smalltalk
	''11:06:39, 03 April 2002: Loading package
	''11:06:39, 03 April 2002: Loading source package
	''11:06:39, 03 April 2002: Uninstalling package
	''11:06:39, 03 April 2002: Image saved
	''11:06:39, 03 April 2002: Compressed sources
	''11:06:39, 03 April 2002: Compressed changes
	''11:06:39, 03 April 2002: Compressing sources...
	"

	| stream |
	(aString size > 10 and: [aString first = $" and: [aString last = $"]]) ifFalse: [^false].
	stream := aString readStream.
	[Time readFrom: stream] on: InvalidFormat do: [:e | ^false].
	^(self symbolFor: aString) notNil!

symbolFor: aString 
	| lookup |
	lookup := ##((Dictionary new)
				at: ': Dolphin Smalltalk' put: #imageStart;
				at: ': Loading package' put: #loadPackage;
				at: ': Loading source package' put: #loadPackage;
				at: ': Uninstalling package' put: #uninstallPackage;
				at: ': Image saved' put: #imageSave;
				at: ': Compressed sources' put: #compressedSources;
				at: ': Compressed changes' put: #compressedChanges;
				at: ': Compressing sources...' put: #compressedSources;
				yourself).
	^(lookup associations detect: [:each | (aString indexOfSubCollection: each key) ~= 0] ifNone: [^nil]) 
		value! !
!ChunkBrowserSystemChunk class categoriesFor: #chunkType!constants!public! !
!ChunkBrowserSystemChunk class categoriesFor: #isChunkClassFor:!public!testing! !
!ChunkBrowserSystemChunk class categoriesFor: #symbolFor:!constants!public! !

