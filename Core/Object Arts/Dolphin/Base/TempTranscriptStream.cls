"Filed out from Intuitive Smalltalk"!

WriteStream subclass: #TempTranscriptStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'No application'!

TempTranscriptStream class instanceVariableNames: ''!

!TempTranscriptStream categoriesForClass!No application!System! !

!TempTranscriptStream methodsFor: 'accessing'!

nextPut: aChar
	"Private - Write aChar to the Transcript."

	VM outputCharToCurrentDoc: aChar! !



