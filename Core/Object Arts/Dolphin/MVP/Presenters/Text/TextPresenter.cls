"Filed out from Dolphin Smalltalk"!

ValuePresenter subclass: #TextPresenter
	instanceVariableNames: 'findDetails'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

TextPresenter guid: (GUID fromString: '{87b4c6d2-026e-11d3-9fd7-00a0cc3e4a32}')!

TextPresenter comment: 'TextPresenter is a <valuePresenter> that displays a <valueModel> onto a <readableString> value. A TextPresenter can be connected to any <valueView> capable of displaying <readableString> values. Often, this will be a <TextEdit> although alternative views may be chosen with the installation of an appropriate <typeConverter>.'!

!TextPresenter categoriesForClass!MVP-Presenters!MVP-Resources-Text fields! !

!TextPresenter methodsFor!

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
	targetPos isNil ifFalse: [
		self view caretPosition: targetPos.
		session dragObjects do: [:each | | text |
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

!TextPresenter categoriesForMethods!
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

TextPresenter methodProtocol: #textPresenter attributes: #() selectors: #(#clear #findDetails #findDetails: #hasSelection #isModified #isModified: #replaceSelection: #selectionRange #selectionRange:)!

!TextPresenter class methodsFor!

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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.TextEdit) 34 16 nil nil 34 2 8 1140916352 1025 416 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 nil 8 1903872368 852486 ##(Smalltalk.NullConverter) nil nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 674 241 39 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 247 7 0 0 29 0 0 0] 8 #() 674 193 193 nil 27 )!

resource_Multiline_text
	"Answer the literal data from which the 'Multiline text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Multiline_text)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.MultilineTextEdit) 34 16 nil nil 34 2 8 1143017796 1025 416 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 nil 8 1903872368 852486 ##(Smalltalk.NullConverter) nil nil 9 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 674 401 161 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 71 8 0 0 90 0 0 0] 8 #() 674 193 193 nil 27 )!

resource_Password_text
	"Answer the literal data from which the 'Password text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Password_text)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.TextEdit) 34 16 nil nil 34 2 8 1140916384 1025 416 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 nil 8 1903872368 852486 ##(Smalltalk.NullConverter) nil nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 674 241 39 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 247 7 0 0 29 0 0 0] 8 #() 674 193 193 nil 27 )!

resource_Path_text
	"Answer the literal data from which the 'Path text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Path_text)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.StaticPath) 34 17 nil nil 34 2 8 1140850944 1 416 nil nil nil 7 nil nil nil 416 nil 8 1915124368 852486 ##(Smalltalk.NullConverter) nil nil nil 8 'c:\Program Files\Dolphin Smalltalk' 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 2799 21 658 241 39 416 610 #text: 34 1 528 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 239 5 0 0 29 0 0 0] 8 #() 658 193 193 nil 27 )!

resource_Static_text
	"Answer the literal data from which the 'Static text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Static_text)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.StaticText) 34 16 nil nil 34 2 8 1140850944 65 416 nil nil nil 7 nil nil nil 416 nil 8 1915124368 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3359 21 642 241 39 416 594 #text: 34 1 8 'Static Text' 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 7 7 0 0 29 0 0 0] 8 #() 642 193 193 nil 27 )! !

!TextPresenter class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
resource_Multiline_text!public!resources-views! !
resource_Password_text!public!resources-views! !
resource_Path_text!public!resources-views! !
resource_Static_text!public!resources-views! !
!

