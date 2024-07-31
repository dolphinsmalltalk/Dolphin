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

	^##((TextTileIcon text: $\xED39 fontName: 'Segoe Fluent Icons' color: Color crimson)
		margin:1;
		yourself)!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 32 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850945 1 176 nil nil nil 5 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[224 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 86 0 101 0 114 0 100 0 97 0 110 0 97 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 176 98 #steelBlue nil 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[115 0 0 0 120 0 0 0 224 1 0 0 185 0 0 0] 193 208 nil 176 418 #text: 50 1 8 'Static Text' 176 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 8 'textToDisplay' nil nil nil nil nil 1 nil nil nil nil 1 nil 193 370 50 1 418 #createWindow: 50 1 466 518 #{Graphics.Rectangle} 610 7679 21 610 8879 821 193 80 8 '' 32 1 50 2 176 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 832 nil nil nil 5 nil nil nil 832 nil nil 1350 4 #{UI.CommandDescription} #editMe 8 'Edit' 1 1 nil nil true nil nil nil 370 50 2 418 #createWindow: 50 1 466 498 8 #[182 0 0 0 205 0 0 0 161 1 0 0 29 1 0 0] 193 864 8 'Edit' 832 418 #isEnabled: 8 #(false) 832 3 8 #() 610 193 193 nil 29 610 193 193 nil 27)!

resource_Editable_view
	"Answer the literal data from which the 'Editable view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Editable_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 32 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140916353 1 176 nil nil nil 5 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[224 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 86 0 101 0 114 0 100 0 97 0 110 0 97 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 176 98 #coral nil 518 #{UI.NullConverter} nil nil 1 #focusLost nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[95 0 0 0 75 0 0 0 239 1 0 0 150 0 0 0] 193 208 nil 176 418 #setMarginWidths: 50 1 8 #(10 10) 176 3 8 #() 518 #{Graphics.Point} 193 193 nil 45 8 'textToDisplay' nil nil nil nil nil 1 nil nil nil nil 1 nil 193 370 50 1 418 #createWindow: 50 1 466 518 #{Graphics.Rectangle} 610 7679 21 610 8879 821 193 80 8 '' 32 1 50 1 176 610 193 193 nil 27)! !

!UI.Examples.BetterHelloWorld class categoriesForMethods!
defaultModel!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
resource_Editable_view!public!resources-views! !
!

