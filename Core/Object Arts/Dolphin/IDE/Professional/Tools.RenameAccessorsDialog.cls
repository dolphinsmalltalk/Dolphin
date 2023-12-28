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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_Refactoring_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 210 31 223 210 739 71 272 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 111 0 0 0 128 1 0 0 146 0 0 0] 8 #() 210 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 576 nil nil nil 5 nil nil nil 576 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 8 18 #{UI.ListBox} 50 17 nil 576 50 2 8 1144078593 262145 720 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 nil nil nil 720 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() false 370 50 2 418 #createAt:extent: 50 2 210 471 1 210 271 81 720 418 #horizontalExtent: 8 #(0) 720 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 235 0 0 0 0 0 0 0 114 1 0 0 40 0 0 0] 8 #() 560 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 31 1186 #fixedParentRight 3 1186 #fixedPreviousTop -13 1186 #fixedViewTop 81 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850944 1 1264 nil nil nil 5 nil nil nil 1264 nil nil 518 #{UI.NullConverter} nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 15 210 441 71 1264 418 #text: 50 1 8 'The following potential accessors for the variable were identified:

' 1264 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 7 0 0 0 220 0 0 0 42 0 0 0] 8 #() 560 nil 27 1154 1186 #fixedParentLeft 1 1186 #fixedViewLeft 441 1186 #fixedParentTop 15 1248 71 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850944 1 1616 nil nil nil 5 nil nil nil 1616 nil nil 1330 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 105 210 441 81 1616 418 #text: 50 1 8 'Please choose the scope (if any) in which these accessors should be renamed:' 1616 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 220 0 0 0 92 0 0 0] 8 #() 560 nil 27 1154 1568 1 1584 441 1186 #fixedPreviousBottom 25 1248 81 18 #{UI.ComboBox} 50 17 nil 576 50 2 8 1144063491 1025 1920 786 818 0 nil 864 896 nil 5 nil nil nil 1920 nil nil 914 #displayString 8 #() 960 301 370 50 1 418 #createAt:extent: 50 2 210 469 115 210 271 47 1920 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 234 0 0 0 57 0 0 0 113 1 0 0 80 0 0 0] 8 #() 560 nil 27 1154 1200 29 1216 1 1232 11 1248 43 674 #{Core.IdentityDictionary} 50 4 1920 8 'scope' 720 8 'selectors' nil 370 50 1 418 #createAt:extent: 50 2 210 31 31 210 739 193 576 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 15 0 0 0 128 1 0 0 111 0 0 0] 50 4 1264 720 1616 1920 560 nil 27 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 210 31 31 210 31 31 nil nil nil nil 1 nil nil 210 2049 461 210 831 401 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 370 50 2 418 #createAt:extent: 50 2 210 6143 21 210 831 401 32 418 #text: 50 1 8 'Rename instance variable…' 32 498 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 158 13 0 0 210 0 0 0] 50 2 576 272 560 nil 27)! !
!Tools.RenameAccessorsDialog class categoriesForMethods!
defaultModel!public! !
resource_Default_view!public!resources-views! !
!

