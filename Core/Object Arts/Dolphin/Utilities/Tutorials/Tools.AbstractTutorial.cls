"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Tools.AbstractTutorial'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.AbstractTutorial guid: (Core.GUID fromString: '{8351f1af-403d-4300-b06d-942ca7abe1db}')!
Tools.AbstractTutorial comment: 'Parent class of all ProfStef tutorials.

To create your own tutorial:
- subclass AbstractTutorial
- implement a few methods which returns a Lesson instance
- implement tutorial which returns a Collection of selectors to the methods you''ve created.'!
!Tools.AbstractTutorial categoriesForClass!Kernel-Objects! !
!Tools.AbstractTutorial methodsFor!

indexOfLesson: aSelector
	^self tableOfContents indexOf: aSelector.
!

lessonAt: anInteger
	| lessonSelector |
	lessonSelector := self tableOfContents at: anInteger.
	^ self perform: lessonSelector asSymbol.
!

name	
	^self class name asString
!

size
	^ self tableOfContents size
!

tableOfContents
^ #(
  'welcome'
  'testLesson'
  'theEnd'
)
!

testLesson
	^Tools.Lesson title: 'Test Lesson' contents: '"This lesson is a test"'!

theEnd
	^Tools.Lesson title: 'The End' contents: '"And that''d be pretty much it :)"'!

welcome
	^Tools.Lesson title: 'Welcome' contents: '"Hi, this is a test tutorial."'! !
!Tools.AbstractTutorial categoriesFor: #indexOfLesson:!accessing!public! !
!Tools.AbstractTutorial categoriesFor: #lessonAt:!accessing!public! !
!Tools.AbstractTutorial categoriesFor: #name!accessing!public! !
!Tools.AbstractTutorial categoriesFor: #size!accessing!public! !
!Tools.AbstractTutorial categoriesFor: #tableOfContents!accessing!public! !
!Tools.AbstractTutorial categoriesFor: #testLesson!pages!public! !
!Tools.AbstractTutorial categoriesFor: #theEnd!pages!public! !
!Tools.AbstractTutorial categoriesFor: #welcome!pages!public! !

!Tools.AbstractTutorial class methodsFor!

icon
	"Answers an Icon that can be used to represent this class."

	^##((TextTileIcon text: $\x1F393
		color: Color orchid)
		textcolor: Color white;
		yourself)! !
!Tools.AbstractTutorial class categoriesFor: #icon!constants!public! !

