"Filed out from Dolphin Smalltalk 7"!

ContainerViewTest subclass: #StyledContainerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StyledContainerTest guid: (GUID fromString: '{C2D30AF9-3DDD-440F-ADD5-535CD0E410A9}')!
StyledContainerTest comment: ''!
!StyledContainerTest categoriesForClass!Unclassified! !
!StyledContainerTest methodsFor!

containerClass
	^StyledContainer!

parentBackcolor
	^Color green!

styledBorderColor
	^Color blue!

testBorderedNcRectangle
	"Check that applying a border correctly changes the NC and Client rectagle calcs"
	
	super testBorderedNcRectangle!

testNcCalcSize
	"Border off - simple text"

	super testNcCalcSize!

testNonBorderedNcRectangle
	"Check that applying a border correctly changes the NC and Client rectagle calcs"

	super testNonBorderedNcRectangle! !
!StyledContainerTest categoriesFor: #containerClass!private! !
!StyledContainerTest categoriesFor: #parentBackcolor!private! !
!StyledContainerTest categoriesFor: #styledBorderColor!private! !
!StyledContainerTest categoriesFor: #testBorderedNcRectangle!public! !
!StyledContainerTest categoriesFor: #testNcCalcSize!public! !
!StyledContainerTest categoriesFor: #testNonBorderedNcRectangle!public! !

