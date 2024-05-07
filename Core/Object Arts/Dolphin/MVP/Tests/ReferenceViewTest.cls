"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #ReferenceViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ReferenceViewTest guid: (GUID fromString: '{a38c1b83-5cc7-4717-8bc4-29b681abe8f9}')!

ReferenceViewTest isAbstract: true!

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

	self assert: presenter subViews size equals: 1.
	self deny: presenter referee hasBorder.
	presenter subViews first hasBorder: true.
	presenter recreate.
	self assert: presenter subViews size equals: 1.
	self assert: presenter referee hasBorder! !

!ReferenceViewTest categoriesForMethods!
classToTest!helpers!private! !
initializePresenter!public!Running! !
testRecreate!public!unit tests! !
!

