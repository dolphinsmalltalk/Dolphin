"Filed out from Dolphin Smalltalk 7"!

External.ArrayField subclass: #'External.ConformantArrayField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ConformantArrayField guid: (Core.GUID fromString: '{566d946d-0a7e-49cf-93b1-5e39f9c65447}')!
External.ConformantArrayField comment: 'ConformantArrayField is now deprecated, and should be replaced by use of ArrayField class>>type:lengthField:'!
!External.ConformantArrayField categoriesForClass!Deprecated! !
!External.ConformantArrayField class methodsFor!

type: aClass length: aSymbol
	^ArrayField type: aClass arrayLength: (ConformantArrayFieldLength lengthField: aSymbol)! !
!External.ConformantArrayField class categoriesFor: #type:length:!instance creation!public! !

