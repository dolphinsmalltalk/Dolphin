"Filed out from Dolphin Smalltalk"!

TestCase subclass: #MethodHistoryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MethodHistoryTest guid: (GUID fromString: '{0b7bcb0c-b98c-45d0-9e5e-f995bd90e04d}')!
MethodHistoryTest comment: ''!
!MethodHistoryTest categoriesForClass!SUnit! !
!MethodHistoryTest methodsFor!

changes

	^'!!MethodHistoryTest methodsFor!!
installedVersionHistoryTestMethod

	"This method is already installéd."

	^1!! !!
!!MethodHistoryTest categoriesFor: #installedVersionHistoryTestMethod!!public!! !!

!!MethodHistoryTest methodsFor!!
installedVersionHistoryTestMethod

	"This method is already installéd."

	^2!! !!
!!MethodHistoryTest categoriesFor: #installedVersionHistoryTestMethod!!public!! !!

!!MethodHistoryTest methodsFor!!
installedVersionHistoryTestMethod

	"This method is already installéd."

	^3!! !!
!!MethodHistoryTest categoriesFor: #installedVersionHistoryTestMethod!!public!! !!

!!MethodHistoryTest methodsFor!!
notInstalledVersionHistoryTestMethod

	"This method is not already installéd."

	^11!! !!
!!MethodHistoryTest categoriesFor: #notInstalledVersionHistoryTestMethod!!public!! !!

"08:50:55, 26 August 2020: Dolphin Smalltalk Professional started"!!

Object subclass: #ATestClass
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''
	classInstanceVariableNames: ''''!!
ATestClass guid: (GUID fromString: ''{0d0471c7-1d5c-4004-a012-b301f85a15ea}'')!!
ATestClass comment: ''''!!
!!ATestClass categoriesForClass!!Kernel-Objects!! !!
!!ATestClass methodsFor!!
installedVersionHistoryTestMethod

	"This shouldn''t be picked up by the test as it''s in a different class"

	^0!! !!
!!ATestClass categoriesFor: #installedVersionHistoryTestMethod!!public!! !!

!!ATestClass methodsFor!!
addedAndRemovedMethod

	^3+4!! !!
!!ATestClass categoriesFor: #addedAndRemovedMethod!!public!! !!

ATestClass removeSelector: #addedAndRemovedMethod ifAbsent: []!!

3+4!!

!!MethodHistoryTest methodsFor!!
installedVersionHistoryTestMethod

	"This method is already installéd."

	^3!! !!
!!MethodHistoryTest categoriesFor: #installedVersionHistoryTestMethod!!public!! !!

!!MethodHistoryTest methodsFor!!
installedVersionHistoryTestMethod

	"This method is already installéd."

	^4!! !!
!!MethodHistoryTest categoriesFor: #installedVersionHistoryTestMethod!!public!! !!

!!MethodHistoryTest methodsFor!!
notInstalledVersionHistoryTestMethod

	"This method is not already installéd."

	^12!! !!
!!MethodHistoryTest categoriesFor: #notInstalledVersionHistoryTestMethod!!public!! !!

!!MethodHistoryTest methodsFor!!
installedVersionHistoryTestMethod

	"This method is already installéd."

	^5!! !!
!!MethodHistoryTest categoriesFor: #installedVersionHistoryTestMethod!!public!! !!

'!

chunkHeader

	^'!!MethodHistoryTest methodsFor!!'!

installedMethodChunkWith: anInteger

	^'!!MethodHistoryTest methodsFor!!
installedVersionHistoryTestMethod

	"This method is already installéd."

	^<1d>!!' expandMacrosWith: anInteger!

installedVersionHistoryTestMethod

	"This method is already installéd."

	^5!

scanForMethodVersions: aSelector inClass: aClass

	"Masquerade as a ChunkFileMethodScanner in order to use local 'sources' "

	| methodVersions |

	methodVersions := ChunkFileMethodScanner new scan: self changes readStream for: ('!!', aClass name, ' methodsFor!!') sourceFileIndex: SourceManager.ChangesIndex.
	^(methodVersions select: [ :each | each selector = aSelector]) do: [ :each | each methodClass: aClass]
!

testMethodHistoryBrowserVersionFoldingOnRead

	"Test consecutive source code-identical method versions are folded when reading the source files"

	| versions browser history prev |

	"Verify we have a duplicate in the test data"
	versions := self scanForMethodVersions: #installedVersionHistoryTestMethod inClass: ##(self).
	self assert: versions size equals: 6.
	self assert: ((versions at: 3) hasSameSourceAs: (versions at: 4)).

	browser := MethodHistoryBrowser new.
	browser scanner: self.

	browser setClass: ##(self) selector: #installedVersionHistoryTestMethod debugger: nil.
	history := browser history.
	self assert: history size equals: 5.

	prev := history first.
	2 to: history size do: 
		[ :index || next |
		next := history at: index.
		self deny: (next hasSameSourceAs: prev).
		prev := next]!

testMethodHistoryBrowserVersionFoldingOnUpdate

	"Test consecutive source code-identical method versions are folded when loading a source-identical version"

	| browser history methodVersion loadedMethod prevSize |

	browser := MethodHistoryBrowser new.
	browser scanner: self.

	browser setClass: ##(self) selector: #installedVersionHistoryTestMethod debugger: nil.
	history := browser history.
	prevSize := history size.
	methodVersion := history last.
	loadedMethod := history last loadedMethod.
	self assert: (methodVersion hasSameSourceAs: loadedMethod).
	self deny: methodVersion sourceDescriptor equals: loadedMethod sourceDescriptor.

	browser onImageChanged: loadedMethod.
	self assert: history size equals: prevSize.
	self assert: (history last hasSameSourceAs: loadedMethod).
	self assert: history last sourceDescriptor equals: loadedMethod sourceDescriptor!

testMethodVersionEndStradlingReadBufferBoundary

	"Test correct reading of a source chunk whose end straddles a read buffer boundary"

	| stream chunk check scanner methodVersions |

	stream := self changes readStream.
	chunk := self installedMethodChunkWith: 1.
	check := stream next: chunk countElements.
	self assert: check equals: chunk.

	stream reset.
	scanner := ChunkFileMethodScanner new.
	scanner readBufferSize: (chunk size - 10).
	methodVersions := scanner scan: stream for: self chunkHeader sourceFileIndex: SourceManager.ChangesIndex.

	self assert: methodVersions size equals: 8.
	self assert: (methodVersions select: [ :each | each selector = #installedVersionHistoryTestMethod]) first getSource last equals: $1!

testMethodVersionOnReadBufferBoundary

	"Test correct reading of a source chunk beginning exactly on the start of the read buffer"

	| stream chunk check scanner methodVersions |

	stream := self changes readStream.
	stream position: 200.
	chunk := self installedMethodChunkWith: 2.
	check := stream next: chunk countElements.
	self assert: check equals: chunk.

	stream reset.
	scanner := ChunkFileMethodScanner new.
	scanner readBufferSize: 200.
	methodVersions := scanner scan: stream for: self chunkHeader sourceFileIndex: SourceManager.ChangesIndex.

	self assert: methodVersions size equals: 8.
	self assert: (methodVersions select: [ :each | each selector = #installedVersionHistoryTestMethod]) second getSource last equals: $2!

testMethodVersionStartStradlingReadBufferBoundary

	"Test correct reading of a source chunk whose start straddles a read buffer boundary"

	| stream chunk check scanner methodVersions |

	stream := self changes readStream.
	stream position: 400.
	chunk := self installedMethodChunkWith: 3.
	check := stream next: chunk countElements.
	self assert: check equals: chunk.

	stream reset.
	scanner := ChunkFileMethodScanner new.
	scanner readBufferSize: 410.
	methodVersions := scanner scan: stream for: self chunkHeader sourceFileIndex: SourceManager.ChangesIndex.

	self assert: methodVersions size equals: 8.
	self assert: (methodVersions select: [ :each | each selector = #installedVersionHistoryTestMethod]) third getSource last equals: $3! !
!MethodHistoryTest categoriesForMethods!
changes!constants!private! !
chunkHeader!constants!private! !
installedMethodChunkWith:!constants!private! !
installedVersionHistoryTestMethod!constants!private! !
scanForMethodVersions:inClass:!helpers!public! !
testMethodHistoryBrowserVersionFoldingOnRead!public!unit tests! !
testMethodHistoryBrowserVersionFoldingOnUpdate!public!unit tests! !
testMethodVersionEndStradlingReadBufferBoundary!public!unit tests! !
testMethodVersionOnReadBufferBoundary!public!unit tests! !
testMethodVersionStartStradlingReadBufferBoundary!public!unit tests! !
!

