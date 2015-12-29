"Filed out from Dolphin Smalltalk X6.2"!

StsChangedCommentNode subclass: #StsChangedPrerequisitesNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsChangedPrerequisitesNode guid: (GUID fromString: '{1AEAD018-4539-451E-B703-1622C1A9F8AC}')!
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

