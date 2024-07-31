"Filed out from Dolphin Smalltalk"!

UI.ValueDialog
	subclass: #'Tools.RenameAccessorsDialog'
	instanceVariableNames: 'selectorsPresenter scopePresenter showChangesPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.RenameAccessorsDialog guid: (Core.GUID fromString: '{0131b7a6-c39c-4be0-b124-1004a06770da}')!

Tools.RenameAccessorsDialog comment: ''!

!Tools.RenameAccessorsDialog categoriesForClass!MVP-Presenters! !

!Tools.RenameAccessorsDialog methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	selectorsPresenter := self add: ListPresenter new name: 'selectors'.
	scopePresenter := self add: ChoicePresenter new name: 'scope'.
	showChangesPresenter := self add: BooleanPresenter new name: 'showChanges'!

model: anObject 
	"Set the model associated with the receiver."

	super model: anObject.
	scopePresenter choices: self scopeNames.
	scopePresenter model: self model!

scopeNames
	^#(#None #Global #Hierarchy #'Package(s)' #Class #'Method(s)')!

selectors: aCollection
	selectorsPresenter model: aCollection!

showChanges
	^showChangesPresenter value! !

!Tools.RenameAccessorsDialog categoriesForMethods!
createComponents!initializing!public! !
model:!accessing!public! !
scopeNames!constants!public! !
selectors:!public! !
showChanges!accessing!public! !
!

!Tools.RenameAccessorsDialog class methodsFor!

defaultModel
	^#None!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 240 nil nil nil 5 nil nil nil 240 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_Refactoring_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[15 0 0 0 111 0 0 0 128 1 0 0 146 0 0 0] 193 272 8 '' 240 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 576 nil nil nil 5 nil nil nil 576 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 8 18 #{UI.ListBox} 50 17 nil 576 50 2 8 1144078593 262145 720 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 nil nil nil 720 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() false 338 50 1 386 #createWindow: 50 1 434 466 8 #[235 0 0 0 0 0 0 0 114 1 0 0 40 0 0 0] 193 752 8 '' 720 3 8 #() 546 193 193 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 31 1170 #fixedParentRight 3 1170 #fixedPreviousTop -13 1170 #fixedViewTop 81 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850944 1 1248 nil nil nil 5 nil nil nil 1248 nil nil 518 #{UI.NullConverter} nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 7 0 0 0 220 0 0 0 42 0 0 0] 193 1280 nil 1248 386 #text: 50 1 8 'The following potential accessors for the variable were identified:

' 1248 3 8 #() 546 193 193 nil 27 1138 1170 #fixedParentLeft 1 1170 #fixedViewLeft 441 1170 #fixedParentTop 15 1232 71 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850944 1 1600 nil nil nil 5 nil nil nil 1600 nil nil 1314 nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 52 0 0 0 220 0 0 0 92 0 0 0] 193 1632 nil 1600 386 #text: 50 1 8 'Please choose the scope (if any) in which these accessors should be renamed:' 1600 3 8 #() 546 193 193 nil 27 1138 1552 1 1568 441 1170 #fixedPreviousBottom 25 1232 81 18 #{UI.ComboBox} 50 17 nil 576 50 2 8 1144063491 1025 1904 786 818 0 nil 864 896 nil 5 nil nil nil 1904 nil nil 914 #displayString 8 #() 960 301 338 50 1 386 #createWindow: 50 1 434 466 8 #[234 0 0 0 57 0 0 0 113 1 0 0 230 0 0 0] 193 1936 8 '' 1904 3 8 #() 546 193 193 nil 27 1138 1184 29 1200 1 1216 11 1232 43 674 #{Core.IdentityDictionary} 50 4 1904 8 'scope' 720 8 'selectors' nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[15 0 0 0 15 0 0 0 128 1 0 0 111 0 0 0] 193 608 8 '' 576 3 50 4 1248 720 1600 1904 546 193 193 nil 27 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 546 31 31 546 31 31 nil nil nil nil 1 nil nil 546 2049 461 546 831 401 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 338 50 2 386 #createWindow: 50 1 518 #{UI.CreateDialog} 2466 546 7679 21 546 8509 421 193 32 386 #setWindowText: 50 1 8 'Rename instance variable…' 32 1 50 2 576 240 546 193 193 nil 29)! !

!Tools.RenameAccessorsDialog class categoriesForMethods!
defaultModel!public! !
resource_Default_view!public!resources-views! !
!

