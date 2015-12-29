"Filed out from Dolphin Smalltalk X6.2"!

StsProjectEdition subclass: #StsShadowProjectEdition
	instanceVariableNames: 'isPresentInLocalRepository'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsShadowProjectEdition guid: (GUID fromString: '{CD48A80C-D6C0-40AD-8511-9BD875475422}')!
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

