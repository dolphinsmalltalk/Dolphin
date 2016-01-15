"Filed out from Dolphin Smalltalk 7"!

PresenterTest subclass: #ReferenceViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ReferenceViewTest guid: (GUID fromString: '{A38C1B83-5CC7-4717-8BC4-29B681ABE8F9}')!
ReferenceViewTest comment: ''!
!ReferenceViewTest categoriesForClass!Unclassified! !
!ReferenceViewTest methodsFor!

classToTest
	^self subclassResponsibility!

initializePresenter
	presenter := ReferenceView 
				resourceIdentifier: (ResourceIdentifier class: Presenter name: 'OK Cancel button block').
	presenter showShell!

testRecreate
	"Test that recreate does not create an orphaned child (#1667), and that it preserves
	settings that were not present originally."

	self assert: presenter subViews size = 1.
	self deny: presenter referee hasBorder.
	presenter subViews first hasBorder: true.
	presenter recreate.
	self assert: presenter subViews size = 1.
	self assert: presenter referee hasBorder! !
!ReferenceViewTest categoriesFor: #classToTest!helpers!private! !
!ReferenceViewTest categoriesFor: #initializePresenter!public!Running! !
!ReferenceViewTest categoriesFor: #testRecreate!public!unit tests! !

