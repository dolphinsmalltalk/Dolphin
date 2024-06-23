"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'UI.Tests.AbstractTextEditTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.AbstractTextEditTest guid: (Core.GUID fromString: '{3f7e7558-eb69-4b84-a91f-de5dba0c2d10}')!

UI.Tests.AbstractTextEditTest isNonInstantiable: true!

UI.Tests.AbstractTextEditTest comment: ''!

!UI.Tests.AbstractTextEditTest methodsFor!

initializePresenter
	super initializePresenter.
	presenter text: self text!

margins
	^self subclassResponsibility!

testApply
	self deny: presenter isModified.
	self deny: presenter isTextModified.
	presenter selectionRange: (1 to: 1).
	presenter cutSelection.
	self assert: presenter isTextModified.
	self assert: presenter isModified.
	presenter apply.
	"The isModified flag indicates that the value has been updated since originally set - it doesn't necessarily mean the model has not been updated. This has to be manually reset when the value is saved (in whatever manner is used to persist it externally) #apply doesn't clear this flag, in fact it sets it if there were pending changes in the view."
	self assert: presenter isModified.
	"The isTextModified flag indicates that he value in the view is updated with respect to the model"
	self deny: presenter isTextModified!

testClearing
	"There are two 'clearing' operations:
		- #clearAll - a command to delete all the text in the control, leaving it in a modified (and undoable) state
		- #clear - reset the control to empty, leaving unmodified and with an empty undo stack."

	self assert: presenter plainText equals: self text.
	self deny: presenter isTextModified.
	self deny: presenter canUndo.
	presenter clearAll.
	self assert: presenter plainText isEmpty.
	self assert: presenter isTextModified.
	self assert: presenter canUndo.
	self undoOnlyModification.
	presenter clear.
	self assert: presenter plainText isEmpty.
	self deny: presenter isTextModified.
	self deny: presenter canUndo!

testPositionOfChar
	| canvas lineHeight metrics i |
	presenter view font: self nonProportionalFont.
	canvas := presenter view canvas.
	canvas font: presenter view actualFont.
	metrics := canvas textMetrics.
	lineHeight := metrics tmHeight.
	i := 0.
	self text do: 
			[:ch |
			| line lineText startOfLine point extent |
			i := i + 1.
			line := presenter view lineFromPosition: i.
			lineText := presenter view plainTextAtLine: line.
			startOfLine := presenter view positionAtLine: line.
			i - startOfLine > lineText size
				ifTrue: [self assert: (String lineDelimiter includes: ch)]
				ifFalse: 
					[| pos |
					extent := canvas textExtent: (lineText first: i - startOfLine).
					point := extent x @ ((line - 1) * lineHeight) + self margins.
					pos := presenter view positionOfChar: i.
					self assert: pos equals: point]].
	canvas free!

text
	^self subclassResponsibility!

undoOnlyModification
	self assert: presenter undo.
	self assert: presenter plainText equals: self text
	"Standard Edit control has only single-level undo, so it can't tell if the undo has cleared all modifications, or just reverted the last one"!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view |
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	view := self view.
	self assert: view view identicalTo: view.
	self assertIsNil: view preferredExtent.
	self deny: view usePreferredExtent.
	self assert: view isManaged.
	self assertIsNil: view font.
	self assertIsNil: view getEvents.
	self assert: view interactor identicalTo: view.
	self assertIsNil: view forecolor! !

!UI.Tests.AbstractTextEditTest categoriesForMethods!
initializePresenter!public!Running! !
margins!constants!private! !
testApply!public! !
testClearing!public!unit tests! !
testPositionOfChar!public!unit tests! !
text!constants!private! !
undoOnlyModification!helpers!private! !
verifyUpgradedView:identifier:!helpers!private! !
!

