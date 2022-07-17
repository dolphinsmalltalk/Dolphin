"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest subclass: #'UI.Tests.ReferenceViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ReferenceViewTest guid: (Core.GUID fromString: '{a38c1b83-5cc7-4717-8bc4-29b681abe8f9}')!
UI.Tests.ReferenceViewTest comment: ''!
!UI.Tests.ReferenceViewTest methodsFor!

classToTest
	^ReferenceView!

initializePresenter
	presenter := self classToTest
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
!UI.Tests.ReferenceViewTest categoriesForMethods!
classToTest!helpers!private! !
initializePresenter!public!Running! !
testRecreate!public!unit tests! !
!

