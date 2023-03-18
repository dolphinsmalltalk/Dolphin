"Filed out from Dolphin Smalltalk"!

UI.ValuePresenter
	subclass: #'UI.TextPresenter'
	instanceVariableNames: 'findDetails'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.TextPresenter guid: (Core.GUID fromString: '{87b4c6d2-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.TextPresenter comment: 'TextPresenter is a <valuePresenter> that displays a <valueModel> onto a <readableString> value. A TextPresenter can be connected to any <valueView> capable of displaying <readableString> values. Often, this will be a <TextEdit> although alternative views may be chosen with the installation of an appropriate <typeConverter>.'!
!UI.TextPresenter categoriesForClass!MVP-Presenters!MVP-Resources-Text fields! !
!UI.TextPresenter methodsFor!

clear
	"Remove all contents in the receiver's view"

	self value: ''!

dragOver: session
	"The drag operation described by the <DragDropSession>, session,
	has moved to a new position over the receiver's window. Use the session 
	to provide feedback to the user about allowable operations etc.
	Implementation Note: Override this message to suggest a default drop action of 
	pasting in the String at the drop position."

	session operation: ((session isFormatAvailable: #String) ifTrue: [session intendedOperation]).
	"Superclass triggers event to allow observers to override."
	super dragOver: session!

drop: session
	"The drag operation described by the <DragDropSession>, session, has culminated
	in a drop over the receiver.
	Implementation Note: Override this message to implement default action of 
	pasting in the String or Chunk at the drop position. However any observers of the
	#drop: trigger of the receiver get first crack - they should set the suggested target to 
	nil in order to pre-empt the default action."

	| targetPos answer |
	answer := super drop: session.
	targetPos := session suggestedTarget.
	targetPos isNil
		ifFalse: 
			[self view caretPosition: targetPos.
			session dragObjects do: 
					[:each |
					| text |
					text := each format: #String.
					self replaceSelection: text]].
	^answer!

findDetails
	"Answers the findDetails instance variable. The Array has four elements:
	(findWhatString, isForwardsBoolean, isCaseSensitiveBoolean, isWholeWordBoolean)."

	^findDetails!

findDetails: aFindDetails 
	"Sets the findDetails instance variable to the argument."

	findDetails := aFindDetails!

hasSelection
	"Answer true if the receiver has a current selection"

	^self view hasSelection!

isModified
	"Answer whether the text in the receiver's model has been modified."

	^self view isModified!

isModified: aBoolean
	"Set/reset the receiver's dirty flag."

	self view isModified: aBoolean!

isReadOnly
	^self view isReadOnly!

isReadOnly: aBoolean 
	self view isReadOnly: aBoolean!

replaceSelection: aString
	"Replace the current selected range of text with aString"
	
	^self view replaceSelection: aString!

selectionRange
	"Answers an interval identifying the selected range of text"
	
	^self view selectionRange!

selectionRange: anInterval
	"Sets anInterval to be the selected range of text"
	
	^self view selectionRange: anInterval
! !
!UI.TextPresenter categoriesForMethods!
clear!operations!public! !
dragOver:!drag & drop!public! !
drop:!drag & drop!public! !
findDetails!accessing!public! !
findDetails:!public!searching! !
hasSelection!public!selection! !
isModified!public!testing! !
isModified:!modes!public! !
isReadOnly!public!testing! !
isReadOnly:!accessing!public! !
replaceSelection:!operations!public! !
selectionRange!public!selection! !
selectionRange:!public!selection! !
!

UI.TextPresenter methodProtocol: #textPresenter attributes: #() selectors: #(#clear #findDetails #findDetails: #hasSelection #isModified #isModified: #replaceSelection: #selectionRange #selectionRange:)!

!UI.TextPresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^String new asValue!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.TextEdit} 34 16 nil nil 34 2 8 1140916352 1025 416 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 416 nil 8 1815092992 1049094 #{UI.NullConverter} nil nil 1 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 658 241 39 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 119 24 0 0 29 0 0 0] 8 #() 658 193 193 nil 27)!

resource_Multiline_text
	"Answer the literal data from which the 'Multiline text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Multiline_text)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.MultilineTextEdit} 34 16 nil nil 34 2 8 1143017796 1025 416 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 416 nil 8 1815092992 1049094 #{UI.NullConverter} nil nil 9 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 658 401 161 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 199 24 0 0 90 0 0 0] 8 #() 658 193 193 nil 27)!

resource_Password_text
	"Answer the literal data from which the 'Password text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Password_text)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.TextEdit} 34 16 nil nil 34 2 8 1140916384 1025 416 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 416 nil 8 1815092992 1049094 #{UI.NullConverter} nil nil 1 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 658 241 39 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 119 24 0 0 29 0 0 0] 8 #() 658 193 193 nil 27)!

resource_Static_text
	"Answer the literal data from which the 'Static text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Static_text)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.StaticText} 34 16 nil nil 34 2 8 1140850944 65 416 nil nil nil 7 nil nil nil 416 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 626 241 39 416 578 #text: 34 1 8 'Static Text' 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 119 24 0 0 29 0 0 0] 8 #() 626 193 193 nil 27)! !
!UI.TextPresenter class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
resource_Multiline_text!public!resources-views! !
resource_Password_text!public!resources-views! !
resource_Static_text!public!resources-views! !
!

