"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'UI.Tests.ReferenceViewTest'
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
	presenter baseStyle: WS_CLIPSIBLINGS | WS_TABSTOP | WS_GROUP.
	presenter contextMenu: Menu new.
	presenter showShell!

testConfigureReferee
	"Test that recreate does not create an orphaned child (#1667), and that it preserves
	settings that were not present originally."

	| referee |
	self assert: presenter subViews size equals: 1.
	referee := presenter referee.
	self assert: referee isTabStop.
	self assert: referee isGroupStop.
	self deny: referee isDragSource.
	self deny: referee isDropTarget.
	self deny: referee isManaged.
	self assert: referee rectangle equals: presenter rectangle.
	self assert: referee inheritContextMenu.
	self assertIsNil: referee contextMenu.
	self assert: referee queryContextMenu identicalTo: presenter contextMenu!

testRecreate
	"Test that recreate does not create an orphaned child (#1667), and that it preserves
	settings that were not present originally."

	| referee hwnd |
	self assert: presenter subViews size equals: 1.
	referee := presenter referee.
	self deny: referee hasBorder.
	referee hasBorder: true.
	presenter
		isGroupStop: false;
		isDragSource: true;
		isDropTarget: true.
	self deny: referee isGroupStop.
	hwnd := referee handle.
	presenter recreate.
	self assert: presenter referee identicalTo: referee.
	self deny: referee handle equals: hwnd.
	referee := presenter referee.
	self assert: presenter subViews size equals: 1.
	self assert: referee hasBorder.
	self deny: referee isGroupStop.
	self assert: referee isDragSource.
	self assert: referee isDropTarget! !

!UI.Tests.ReferenceViewTest categoriesForMethods!
classToTest!helpers!private! !
initializePresenter!public!Running! !
testConfigureReferee!public!unit tests! !
testRecreate!public!unit tests! !
!

