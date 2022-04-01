"Filed out from Dolphin Smalltalk"!

Kernel.AbstractChunkSourceFiler subclass: #'Kernel.ChunkSourceFiler'
	instanceVariableNames: 'sourceFileIndex environment'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.ChunkSourceFiler guid: (Core.GUID fromString: '{f6955c37-fa6c-4624-8c16-caaa6ce9e039}')!
Kernel.ChunkSourceFiler comment: '`ChunkSourceFiler` is the standard chunk-format `SourceFiler` that stores packages and classes in Dolphin 8 (paxVersion 2.1) format.'!
!Kernel.ChunkSourceFiler categoriesForClass!Development! !
!Kernel.ChunkSourceFiler methodsFor!

emitClassName: aClass
	(aClass isInBaseEnvironment and: 
			[| localEnv |
			localEnv := self environment ?? Smalltalk.
			aClass environment == localEnv or: 
					[| var |
					var := localEnv fullBindingFor: aClass unqualifiedName.
					var notNil and: [var value == aClass]]])
		ifTrue: [stream nextPutAll: aClass name]
		ifFalse: [aClass printFullNameOn: stream]!

environment
	^environment
!

environment: aNamespace
	environment := aNamespace
!

sourceFileIndex: anInteger
	"Private - Set the <integer> source file index associated with the receiver."

	sourceFileIndex := anInteger! !
!Kernel.ChunkSourceFiler categoriesForMethods!
emitClassName:!private!source filing-file out! !
environment!accessing!public! !
environment:!accessing!public! !
sourceFileIndex:!accessing!private! !
!

!Kernel.ChunkSourceFiler class methodsFor!

fileOutExtensionForClass: aClass
	^'cls'! !
!Kernel.ChunkSourceFiler class categoriesForMethods!
fileOutExtensionForClass:!enquiries!public! !
!

