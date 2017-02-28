"Filed out from Dolphin Smalltalk 7"!

ArrayPointerField subclass: #ConformantArrayPointerField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ConformantArrayPointerField guid: (GUID fromString: '{e228a7a7-fc7a-45fb-a6cd-e0ea5edeecc4}')!
ConformantArrayPointerField comment: 'ConformantArrayPointerField is now deprecated, and should be replaced by use of ArrayPointerField class>>type:lengthField:'!
!ConformantArrayPointerField categoriesForClass!External-Data-Types! !
!ConformantArrayPointerField class methodsFor!

type: aClass length: aSymbol
	#deprecated.
	^ArrayPointerField type: aClass lengthField: aSymbol! !
!ConformantArrayPointerField class categoriesFor: #type:length:!instance creation!public! !

