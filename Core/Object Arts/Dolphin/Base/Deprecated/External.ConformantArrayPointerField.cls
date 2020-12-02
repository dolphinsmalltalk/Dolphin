"Filed out from Dolphin Smalltalk 7"!

ArrayPointerField subclass: #ConformantArrayPointerField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ConformantArrayPointerField guid: (GUID fromString: '{e228a7a7-fc7a-45fb-a6cd-e0ea5edeecc4}')!
ConformantArrayPointerField comment: 'ConformantArrayPointerField is now deprecated, and should be replaced by use of ArrayPointerField class>>type:lengthField:'!
!ConformantArrayPointerField categoriesForClass!Deprecated! !
!ConformantArrayPointerField class methodsFor!

type: aClass length: aSymbol
	^ArrayPointerField type: aClass arrayLength: (ConformantArrayFieldLength lengthField: aSymbol)! !
!ConformantArrayPointerField class categoriesFor: #type:length:!instance creation!public! !

