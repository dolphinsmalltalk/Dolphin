"Filed out from Dolphin Smalltalk 7"!

UI.Tests.PresenterTest subclass: #'UI.Tests.SelectableItemsTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.SelectableItemsTest guid: (Core.GUID fromString: '{eb11681e-441a-44d4-af4c-de1ea399a79e}')!
UI.Tests.SelectableItemsTest isNonInstantiable: true!
UI.Tests.SelectableItemsTest comment: ''!
!UI.Tests.SelectableItemsTest categoriesForClass!Unclassified! !
!UI.Tests.SelectableItemsTest methodsFor!

assertContains: anObject
	"Private - Asserts that the receiver contains anObject. We do this by trying to select the object since this allows
	us to verify whether the view is actually displaying the object in addition to it just appearing in the model"

	| sel |
	sel := presenter selectionOrNil.
	presenter selection: anObject.
	self assert: presenter selection identicalTo: anObject.
	presenter selectionOrNil: sel!

denyContains: anObject 
	"Private - Asserts that the receiver does not contain anObject. We do this by trying to select the object since this allows
	us to verify whether the view is actually displaying the object in addition to it jsut appearing in the model"

	| sel |
	sel := presenter selectionOrNil.
	[self should: [presenter selection: anObject] raise: NotFoundError] 
		ensure: [presenter selectionOrNil: sel]! !
!UI.Tests.SelectableItemsTest categoriesFor: #assertContains:!helpers!private! !
!UI.Tests.SelectableItemsTest categoriesFor: #denyContains:!helpers!private! !

