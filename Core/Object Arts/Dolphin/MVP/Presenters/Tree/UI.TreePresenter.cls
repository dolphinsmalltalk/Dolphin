"Filed out from Dolphin Smalltalk"!

UI.SelectableItemsPresenter
	subclass: #'UI.TreePresenter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.TreePresenter guid: (Core.GUID fromString: '{87b4c688-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.TreePresenter comment: 'TreePresenter implements a <treePresenter> component that can be used to display the contents of a <treeModel> within a <treeView>. This is similar to the way a tree view is used to display a file system''s contents in the Windows explorer. For presentation of a tree as a hierarchy of nested "folders" see the <FolderPresenter> class.

TreePresenter conforms to <selectableItems> to provide methods for accessing the current selection. In addition, the <treePresenter> protocol allows the tree to be navigated using the #expand: , #collapse: and #up methods.

'!

!UI.TreePresenter categoriesForClass!MVP-Presenters!MVP-Resources-Trees! !

!UI.TreePresenter methodsFor!

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

isExpanded: anObject
	"Answers if the node associated with anObject is expanded."

	^self view isExpanded: anObject!

onAboutToEditLabel: aLabelEditingEvent
	"An in-place edit is being initiated in the receiver's view. Forward back to the view."

	self view onAboutToEditLabel: aLabelEditingEvent!

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

!UI.TreePresenter categoriesForMethods!
collapse:!operations!public! !
expand:!operations!public! !
expandAll:!operations!public! !
hasSelection!public!selection! !
isExpanded:!public!testing! !
onAboutToEditLabel:!event handling!public! !
onLabelOf:editedTo:!event handling!public! !
selectableItems!accessing!private! !
up!operations!public! !
!

UI.TreePresenter methodProtocol: #treePresenter attributes: #(#readOnly) selectors: #(#collapse: #ensureVisible #expand: #expandAll: #onAboutToDisplayMenu: #onActionPerformed #onCloseRequested #onIdleEntered #onInputMaskRequired: #onKeyPressed: #onKeyReleased: #onKeyTyped: #onKillFocus #onLeftButtonDoubleClicked: #onLeftButtonPressed: #onLeftButtonReleased: #onMouseMoved: #onPositionChanged: #onPositionChanging: #onRightButtonDoubleClicked: #onRightButtonPressed: #onRightButtonReleased: #onSetFocus #onTipTextRequired: #onViewClosed #onViewOpened #parentPresenter #performAction #setFocus #show #topShell #up #view)!

!UI.TreePresenter class methodsFor!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.TreeView} 38 #{Core.Array} 35 nil nil 50 2 8 1409352231 1025 32 1094 3 #{UI.TreeModel} nil 6 #{Kernel.IdentitySearchPolicy} 774 #{UI.TreeNode} nil nil nil 550 #{Core.IdentityDictionary} 0 6 #{Graphics.Color} #default nil 5 nil nil nil 32 nil nil 518 #{Core.Message} #displayString 8 #() 274 #iconImageIndex 8 #() 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil 550 #{Core.LookupTable} 0 nil #noIcons 1 210 0 1 262 #{UI.TreeViewDynamicUpdateMode} 32 nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 562 401 571 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 199 12 0 0 39 1 0 0] 8 #() 562 193 193 nil 29)! !

!UI.TreePresenter class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

