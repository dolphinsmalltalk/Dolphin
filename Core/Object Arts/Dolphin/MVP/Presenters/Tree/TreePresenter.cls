"Filed out from Dolphin Smalltalk 7"!

SelectableItemsPresenter subclass: #TreePresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TreePresenter guid: (GUID fromString: '{87b4c688-026e-11d3-9fd7-00a0cc3e4a32}')!
TreePresenter comment: 'TreePresenter implements a <treePresenter> component that can be used to display the contents of a <treeModel> within a <treeView>. This is similar to the way a tree view is used to display a file system''s contents in the Window''s explorer. For presentation of a tree as a hierarchy of nested "folders" see the <FolderPresenter> class.

TreePresenter conforms to <selectableItems> to provide methods for accessing the current selection. In addition, the <treePresenter> protocol allows the tree to be navigating using the #expand: , #collapse: and #up methods.

'!
!TreePresenter categoriesForClass!MVP-Presenters!MVP-Resources-Trees! !
!TreePresenter methodsFor!

collapse: anObject
	"Collapse the displayed hierarchy below anObject.
	Note that this does not actually remove any nodes from the receiver's model,
	i.e. the effect is purely on the view (but see TreeModel>>collapse:)"

	self view collapse: anObject!

expand: anObject
	"Expand the displayed hierarchy below anObject."

	self view expand: anObject!

expandAll: anObject 
	"Expand the complete hierarchy below anObject (i.e. expand the node and, recursively, all its sub-nodes)."

	self view expandAll: anObject!

hasSelection
	"Answer true if the receiver has a selection."

	^self view hasSelection!

onAboutToEditLabel: anObject
	"The receiver's element, anObject, is about to have its label edited in the receiver.
	Forward back to the view."

	^self view onAboutToEditLabel: anObject!

onLabelOf: anObject editedTo: text
	"The receiver's element, anObject, has had its label edited in the receiver to the 
	specified text. Answer whether to accept the edited text."

	^self view onLabelOf: anObject editedTo: text!

selectableItems
	"Private - Answer the name of the <selectableItems> component that actually handles the selectable items in the receiver"
	
	^self view!

up	
	"Display the contents of the immediate parent of the selected tree item"

	| parent |
	parent := self model parentOf: self selectionOrNil.
	self expand: parent! !
!TreePresenter categoriesFor: #collapse:!operations!public! !
!TreePresenter categoriesFor: #expand:!operations!public! !
!TreePresenter categoriesFor: #expandAll:!operations!public! !
!TreePresenter categoriesFor: #hasSelection!public!selection! !
!TreePresenter categoriesFor: #onAboutToEditLabel:!event handling!public! !
!TreePresenter categoriesFor: #onLabelOf:editedTo:!event handling!public! !
!TreePresenter categoriesFor: #selectableItems!accessing!private! !
!TreePresenter categoriesFor: #up!operations!public! !

TreePresenter methodProtocol: #treePresenter attributes: #(#readOnly) selectors: #(#collapse: #ensureVisible #expand: #expandAll: #onAboutToDisplayMenu: #onActionPerformed #onCloseRequested #onIdleEntered #onInputMaskRequired: #onKeyPressed: #onKeyReleased: #onKeyTyped: #onKillFocus #onLeftButtonDoubleClicked: #onLeftButtonPressed: #onLeftButtonReleased: #onMouseMoved: #onPositionChanged: #onPositionChanging: #onRightButtonDoubleClicked: #onRightButtonPressed: #onRightButtonReleased: #onSetFocus #onTipTextRequired: #onViewClosed #onViewOpened #parentPresenter #performAction #setFocus #show #topShell #up #view)!

!TreePresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^TreeModel new!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.TreeView)  98 27 0 0 98 2 8 1409351719 1025 416 590918 3 ##(Smalltalk.TreeModel)  0 1310726 ##(Smalltalk.IdentitySearchPolicy)  525062 ##(Smalltalk.TreeNode)  0 0 0 234 256 98 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 0 8 4294903619 459270 ##(Smalltalk.Message)  8 #displayString 98 0 8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 234 240 608 17 8 #noIcons 1 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  2799 21 962 401 571 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 63 6 0 0 39 1 0 0] 98 0 962 193 193 0 27 )! !
!TreePresenter class categoriesFor: #defaultModel!models!public! !
!TreePresenter class categoriesFor: #icon!constants!public! !
!TreePresenter class categoriesFor: #resource_Default_view!public!resources-views! !

