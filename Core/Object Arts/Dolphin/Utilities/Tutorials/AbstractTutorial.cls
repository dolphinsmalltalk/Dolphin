"Filed out from Dolphin Smalltalk 7"!

Object subclass: #AbstractTutorial
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AbstractTutorial guid: (GUID fromString: '{8351f1af-403d-4300-b06d-942ca7abe1db}')!
AbstractTutorial comment: 'Parent class of all ProfStef tutorials.

To create your own tutorial:
- subclass AbstractTutorial
- implement a few methods which returns a Lesson instance
- implement tutorial which returns a Collection of selectors to the methods you''ve created.'!
!AbstractTutorial categoriesForClass!Kernel-Objects! !
!AbstractTutorial methodsFor!

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
	^ Lesson
		title: 'Test Lesson' 
		contents: '"This lesson is a test"'
!

theEnd
	^ Lesson
		title: 'The End' 
		contents: '"And that''d be pretty much it :)"'
!

welcome
	^ Lesson
		title: 'Welcome' 
		contents: '"Hi, this is a test tutorial."'
! !
!AbstractTutorial categoriesFor: #indexOfLesson:!accessing!public! !
!AbstractTutorial categoriesFor: #lessonAt:!accessing!public! !
!AbstractTutorial categoriesFor: #name!accessing!public! !
!AbstractTutorial categoriesFor: #size!accessing!public! !
!AbstractTutorial categoriesFor: #tableOfContents!accessing!public! !
!AbstractTutorial categoriesFor: #testLesson!pages!public! !
!AbstractTutorial categoriesFor: #theEnd!pages!public! !
!AbstractTutorial categoriesFor: #welcome!pages!public! !

!AbstractTutorial class methodsFor!

icon
	"Answers an Icon that can be used to represent this class."

	^##((TextTileIcon text: $\x1F393
		color: Color orchid)
		textcolor: Color white;
		yourself)! !
!AbstractTutorial class categoriesFor: #icon!constants!public! !

