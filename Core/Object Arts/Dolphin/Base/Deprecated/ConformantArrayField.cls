"Filed out from Dolphin Smalltalk 7"!

ArrayField subclass: #ConformantArrayField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ConformantArrayField guid: (GUID fromString: '{566d946d-0a7e-49cf-93b1-5e39f9c65447}')!
ConformantArrayField comment: 'ConformantArrayField is now deprecated, and should be replaced by use of ArrayField class>>type:lengthField:'!
!ConformantArrayField categoriesForClass!External-Data-Types! !
!ConformantArrayField class methodsFor!

type: aClass length: aSymbol
	#deprecated.
	^ArrayField type: aClass lengthField: aSymbol! !
!ConformantArrayField class categoriesFor: #type:length:!instance creation!public! !

