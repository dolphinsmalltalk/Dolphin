"Filed out from Dolphin Smalltalk 7"!

UI.SelectableItemsPresenter subclass: #'UI.TreePresenter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.TreePresenter guid: (Core.GUID fromString: '{87b4c688-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.TreePresenter comment: 'TreePresenter implements a <treePresenter> component that can be used to display the contents of a <treeModel> within a <treeView>. This is similar to the way a tree view is used to display a file system''s contents in the Window''s explorer. For presentation of a tree as a hierarchy of nested "folders" see the <FolderPresenter> class.

TreePresenter conforms to <selectableItems> to provide methods for accessing the current selection. In addition, the <treePresenter> protocol allows the tree to be navigating using the #expand: , #collapse: and #up methods.

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
!UI.TreePresenter categoriesFor: #collapse:!operations!public! !
!UI.TreePresenter categoriesFor: #expand:!operations!public! !
!UI.TreePresenter categoriesFor: #expandAll:!operations!public! !
!UI.TreePresenter categoriesFor: #hasSelection!public!selection! !
!UI.TreePresenter categoriesFor: #isExpanded:!public!testing! !
!UI.TreePresenter categoriesFor: #onAboutToEditLabel:!event handling!public! !
!UI.TreePresenter categoriesFor: #onLabelOf:editedTo:!event handling!public! !
!UI.TreePresenter categoriesFor: #selectableItems!accessing!private! !
!UI.TreePresenter categoriesFor: #up!operations!public! !

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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.TreeView) 34 27 nil nil 34 2 8 1409352231 1025 416 787526 3 ##(UI.TreeModel) nil 1638406 ##(Kernel.IdentitySearchPolicy) 721670 ##(UI.TreeNode) nil nil nil 170 192 8 #() 917510 ##(Graphics.Color) #default nil 5 nil nil nil 416 nil 8 1920462864 786950 ##(Core.Message) #displayString 8 #() ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil 170 176 592 nil #noIcons 1 170 192 592 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 882 401 571 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 199 12 0 0 39 1 0 0] 8 #() 882 193 193 nil 27)! !
!UI.TreePresenter class categoriesFor: #defaultModel!models!public! !
!UI.TreePresenter class categoriesFor: #icon!constants!public! !
!UI.TreePresenter class categoriesFor: #resource_Default_view!public!resources-views! !

