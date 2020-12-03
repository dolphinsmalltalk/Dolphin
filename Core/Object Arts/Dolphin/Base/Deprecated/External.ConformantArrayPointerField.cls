"Filed out from Dolphin Smalltalk 7"!

External.ArrayPointerField subclass: #'External.ConformantArrayPointerField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ConformantArrayPointerField guid: (Core.GUID fromString: '{e228a7a7-fc7a-45fb-a6cd-e0ea5edeecc4}')!
External.ConformantArrayPointerField comment: 'ConformantArrayPointerField is now deprecated, and should be replaced by use of ArrayPointerField class>>type:lengthField:'!
!External.ConformantArrayPointerField categoriesForClass!Deprecated! !
!External.ConformantArrayPointerField class methodsFor!

type: aClass length: aSymbol
	^ArrayPointerField type: aClass arrayLength: (ConformantArrayFieldLength lengthField: aSymbol)! !
!External.ConformantArrayPointerField class categoriesFor: #type:length:!instance creation!public! !

