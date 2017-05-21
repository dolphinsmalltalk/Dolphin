"Filed out from Dolphin Smalltalk 7"!

HelpImagesCreationTest subclass: #WebImagesCreationTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebImagesCreationTest guid: (GUID fromString: '{38a0262d-4eab-4f67-a734-10f2b3eb0fbb}')!
WebImagesCreationTest comment: ''!
!WebImagesCreationTest categoriesForClass!Unclassified! !
!WebImagesCreationTest methodsFor!

createImageOfTool: aClass 
	^self createImageOfTool: aClass using: [:shell | ]!

createImageOfTool: aClass scale: scale
	^self createImageOfTool: aClass scale: scale using: [:shell | ]!

createImageOfTool: aClass scale: scale using: aMonadicValuable 
	| tool |
	tool := aClass show.
	tool extent: self defaultToolExtent.
	aMonadicValuable value: tool.
	SessionManager inputState pumpMessages.
	tool view saveWebImageNamed: aClass name scale: scale.
	tool exit!

defaultToolExtent
	^800 @ 600! !
!WebImagesCreationTest categoriesFor: #createImageOfTool:!private! !
!WebImagesCreationTest categoriesFor: #createImageOfTool:scale:!private! !
!WebImagesCreationTest categoriesFor: #createImageOfTool:scale:using:!private! !
!WebImagesCreationTest categoriesFor: #defaultToolExtent!private! !

