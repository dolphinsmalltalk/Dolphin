"Filed out from Dolphin Smalltalk 7"!

Kernel.AbstractChunkSourceFiler subclass: #'Kernel.ChunkSourceFiler'
	instanceVariableNames: 'sourceFileIndex'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.ChunkSourceFiler guid: (Core.GUID fromString: '{f6955c37-fa6c-4624-8c16-caaa6ce9e039}')!
Kernel.ChunkSourceFiler comment: '`ChunkSourceFiler` is the standard chunk-format `SourceFiler` that stores packages and classes in Dolphin 8 (paxVersion 2.1) format.'!
!Kernel.ChunkSourceFiler categoriesForClass!Development! !
!Kernel.ChunkSourceFiler methodsFor!

sourceFileIndex: anInteger
	"Private - Set the <integer> source file index associated with the receiver."

	sourceFileIndex := anInteger! !
!Kernel.ChunkSourceFiler categoriesFor: #sourceFileIndex:!accessing!private! !

!Kernel.ChunkSourceFiler class methodsFor!

fileOutExtensionForClass: aClass
	^'cls'! !
!Kernel.ChunkSourceFiler class categoriesFor: #fileOutExtensionForClass:!enquiries!public! !

