"Filed out from Dolphin Smalltalk"!

UI.Shell
	subclass: #'UI.Examples.BetterHelloWorld'
	instanceVariableNames: 'textToDisplayPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.BetterHelloWorld guid: (Core.GUID fromString: '{00e258da-1b1a-42c4-89c3-e3ed1983a682}')!
UI.Examples.BetterHelloWorld comment: 'This is the presenter for the Better Hello World example package. The full sample shows an MVP "triad" of elements consisting of a ValueModel, a composite ShellView (drawn with the ViewComposer) and this presenter class that ties all the pieces together. See the package comment for more details and links to tutorial videos that explain how this example was put together.'!
!UI.Examples.BetterHelloWorld methodsFor!

createComponents
	super createComponents.
	textToDisplayPresenter := self add: TextPresenter new name: 'textToDisplay'.
	!

editMe
	BetterHelloWorld show: 'Editable view' on: self model!

model: aModel
	super model: aModel.
	textToDisplayPresenter model: aModel! !
!UI.Examples.BetterHelloWorld categoriesForMethods!
createComponents!public! !
editMe!public! !
model:!public! !
!

!UI.Examples.BetterHelloWorld class methodsFor!

defaultModel
	^'Hello World' asValue!

icon
	"Answers an Icon that can be used to represent this class."

	^##((TextTileIcon text: $\x1F389 color: Color crimson)
		fontStyle: #bold;
		yourself)!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #default nil 7 nil nil nil 32 nil 550 #{Core.IdentityDictionary} 1 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850945 1 160 nil nil nil 7 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONT} 8 #[224 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 86 101 114 100 97 110 97 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 160 98 #steelBlue 8 1853387904 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 306 231 241 306 731 131 160 450 #text: 50 1 8 'Static Text' 160 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 115 0 0 0 120 0 0 0 224 1 0 0 185 0 0 0] 8 #() 306 193 193 nil 27 8 'textToDisplay' nil nil nil nil nil 12701 nil nil nil nil 1 nil nil 402 50 1 450 #createAt:extent: 50 2 306 6143 21 306 1201 801 32 578 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 87 14 0 0 154 1 0 0] 50 2 160 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 816 nil nil nil 7 nil nil nil 816 nil 8 1853182784 1350 4 #{UI.CommandDescription} #editMe 8 'Edit' 1 1 nil nil true nil nil nil 402 50 3 450 #createAt:extent: 50 2 306 365 411 306 471 161 816 450 #isEnabled: 8 #(false) 816 450 #text: 50 1 8 'Edit' 816 578 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 182 0 0 0 205 0 0 0 161 1 0 0 29 1 0 0] 8 #() 640 nil 29 640 nil 27)!

resource_Editable_view
	"Answer the literal data from which the 'Editable view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Editable_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #default nil 7 nil nil nil 32 nil 550 #{Core.IdentityDictionary} 1 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140916353 1 160 nil nil nil 7 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONT} 8 #[224 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 86 101 114 100 97 110 97 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 160 98 #coral 8 1853175488 518 #{UI.NullConverter} nil nil 1 #focusLost nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 306 191 151 306 801 151 160 450 #setMarginWidths: 50 1 8 #(10 10) 160 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 75 0 0 0 239 1 0 0 150 0 0 0] 8 #() 306 193 193 nil 45 8 'textToDisplay' nil nil nil nil nil 1 nil nil nil nil 1 nil nil 402 50 1 450 #createAt:extent: 50 2 306 6143 21 306 1201 801 32 578 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 87 14 0 0 154 1 0 0] 50 1 160 640 nil 27)! !
!UI.Examples.BetterHelloWorld class categoriesForMethods!
defaultModel!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
resource_Editable_view!public!resources-views! !
!

