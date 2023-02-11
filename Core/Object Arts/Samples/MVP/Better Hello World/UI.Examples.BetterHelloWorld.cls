"Filed out from Dolphin Smalltalk"!

UI.Shell subclass: #'UI.Examples.BetterHelloWorld'
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 #{Graphics.Color} #default nil 39 nil nil nil 416 nil 170 192 34 2 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850945 1 528 nil nil nil 7 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[224 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 86 101 114 100 97 110 97 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 528 466 #steelBlue 8 1815137184 1049094 #{UI.NullConverter} nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 674 231 241 674 731 131 528 818 #text: 34 1 8 'Static Text' 528 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 115 0 0 0 120 0 0 0 224 1 0 0 185 0 0 0] 8 #() 674 193 193 nil 27 8 'textToDisplay' nil nil nil nil nil 66579 nil nil nil nil 1 nil nil 770 34 1 818 #createAt:extent: 34 2 674 12287 21 674 1201 801 416 946 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 87 26 0 0 154 1 0 0] 34 2 528 410 #{UI.PushButton} 34 20 nil 416 34 2 8 1140924416 1 1184 nil nil nil 7 nil nil nil 1184 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #editMe 8 'Edit' 1 1 nil nil true nil nil nil 770 34 3 818 #createAt:extent: 34 2 674 365 411 674 471 161 1184 818 #isEnabled: 8 #(false) 1184 818 #text: 34 1 8 'Edit' 1184 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 182 0 0 0 205 0 0 0 161 1 0 0 29 1 0 0] 8 #() 1008 nil 29 1008 nil 27)!

resource_Editable_view
	"Answer the literal data from which the 'Editable view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Editable_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 #{Graphics.Color} #default nil 39 nil nil nil 416 nil 170 192 34 2 410 #{UI.TextEdit} 34 16 nil 416 34 2 8 1140916353 1 528 nil nil nil 7 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[224 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 86 101 114 100 97 110 97 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 528 466 #coral 8 1815092992 1049094 #{UI.NullConverter} nil nil 1 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 674 191 151 674 801 151 528 818 #setMarginWidths: 34 1 8 #(10 10) 528 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 75 0 0 0 239 1 0 0 150 0 0 0] 8 #() 674 193 193 nil 27 8 'textToDisplay' nil nil nil nil nil 1 nil nil nil nil 1 nil nil 770 34 1 818 #createAt:extent: 34 2 674 12287 21 674 1201 801 416 946 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 87 26 0 0 154 1 0 0] 34 1 528 1008 nil 27)! !
!UI.Examples.BetterHelloWorld class categoriesForMethods!
defaultModel!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
resource_Editable_view!public!resources-views! !
!

