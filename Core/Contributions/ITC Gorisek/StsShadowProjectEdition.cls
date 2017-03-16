"Filed out from Dolphin Smalltalk 7"!

StsProjectEdition subclass: #StsShadowProjectEdition
	instanceVariableNames: 'isPresentInLocalRepository'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsShadowProjectEdition guid: (GUID fromString: '{cd48a80c-d6c0-40ad-8511-9bd875475422}')!
StsShadowProjectEdition comment: ''!
!StsShadowProjectEdition categoriesForClass!Unclassified! !
!StsShadowProjectEdition methodsFor!

icon
	^isPresentInLocalRepository = true ifTrue: [super icon] ifFalse: [Boolean icon]!

isPresentInLocalRepository
	^isPresentInLocalRepository!

isPresentInLocalRepository: anObject
	isPresentInLocalRepository := anObject! !
!StsShadowProjectEdition categoriesFor: #icon!public! !
!StsShadowProjectEdition categoriesFor: #isPresentInLocalRepository!accessing!public! !
!StsShadowProjectEdition categoriesFor: #isPresentInLocalRepository:!accessing!public! !

