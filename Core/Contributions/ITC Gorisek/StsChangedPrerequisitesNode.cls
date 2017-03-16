"Filed out from Dolphin Smalltalk 7"!

StsChangedCommentNode subclass: #StsChangedPrerequisitesNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsChangedPrerequisitesNode guid: (GUID fromString: '{1aead018-4539-451e-b703-1622c1a9f8ac}')!
StsChangedPrerequisitesNode comment: ''!
!StsChangedPrerequisitesNode categoriesForClass!Unclassified! !
!StsChangedPrerequisitesNode methodsFor!

elementDescription
	^'package prerequisites'!

icon
	^OrderedCollection icon!

leftComment
	^self prerequisiteString: leftEdition prerequisiteNames!

prerequisiteString: aSetOrCollection 
	^aSetOrCollection isNil 
		ifTrue: ['']
		ifFalse: 
			[(aSetOrCollection asSortedCollection: [:a :b | self sourceControl byteCompare: a with: b]) 
				inject: ''
				into: [:sum :each | sum , each , '
']]!

rightComment
	^self prerequisiteString: rightEdition prerequisiteNames! !
!StsChangedPrerequisitesNode categoriesFor: #elementDescription!public! !
!StsChangedPrerequisitesNode categoriesFor: #icon!public! !
!StsChangedPrerequisitesNode categoriesFor: #leftComment!public! !
!StsChangedPrerequisitesNode categoriesFor: #prerequisiteString:!private! !
!StsChangedPrerequisitesNode categoriesFor: #rightComment!public! !

