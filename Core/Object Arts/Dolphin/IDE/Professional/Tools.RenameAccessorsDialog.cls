"Filed out from Dolphin Smalltalk"!

UI.ValueDialog subclass: #'Tools.RenameAccessorsDialog'
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
showChanges!public! !
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_Refactoring_OK_Cancel_button_block nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 31 223 578 739 71 640 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 111 0 0 0 128 1 0 0 146 0 0 0] 8 #() 578 193 193 nil 27 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 944 nil nil nil 7 nil nil nil 944 1048838 #{UI.FramingLayout} 170 176 34 8 410 #{UI.ComboBox} 34 17 nil 944 34 2 8 1144063491 1025 1072 787270 2 #{UI.ListModel} 138 144 912 nil 1769478 #{Kernel.IdentitySearchPolicy} 917510 #{Graphics.Color} #default nil 7 nil nil nil 1072 nil 8 1833584496 786950 #{Core.Message} #displayString 8 #() 8 #() 301 738 34 1 786 #createAt:extent: 34 2 578 469 115 578 271 47 1072 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 234 0 0 0 57 0 0 0 113 1 0 0 80 0 0 0] 8 #() 928 nil 27 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedPreviousRight 29 1506 #fixedParentRight 1 1506 #fixedPreviousTop 11 1506 #fixedViewTop 43 410 #{UI.ListBox} 34 17 nil 944 34 2 8 1144078593 262145 1584 1138 138 144 912 nil 1200 1232 nil 7 nil nil nil 1584 nil 8 1833835952 1266 #displayString 8 #() 1312 false 738 34 2 786 #createAt:extent: 34 2 578 471 1 578 271 81 1584 786 #horizontalExtent: 8 #(0) 1584 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 235 0 0 0 0 0 0 0 114 1 0 0 40 0 0 0] 8 #() 928 nil 27 1474 1520 31 1536 3 1552 -13 1568 81 410 #{UI.StaticText} 34 16 nil 944 34 2 8 1140850944 1 1920 nil nil nil 7 nil nil nil 1920 nil 8 1834179760 1049094 #{UI.NullConverter} nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 105 578 441 81 1920 786 #text: 34 1 8 'Please choose the scope (if any) in which these accessors should be renamed:' 1920 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 220 0 0 0 92 0 0 0] 8 #() 928 nil 27 1474 1506 #fixedParentLeft 1 1506 #fixedViewLeft 441 1506 #fixedPreviousBottom 25 1568 81 410 #{UI.StaticText} 34 16 nil 944 34 2 8 1140850944 1 2288 nil nil nil 7 nil nil nil 2288 nil 8 1834179760 2002 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 15 578 441 71 2288 786 #text: 34 1 8 'The following potential accessors for the variable were identified:

' 2288 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 7 0 0 0 220 0 0 0 42 0 0 0] 8 #() 928 nil 27 1474 2240 1 2256 441 1506 #fixedParentTop 15 1568 71 170 192 34 4 1584 8 'selectors' 1072 8 'scope' nil 738 34 1 786 #createAt:extent: 34 2 578 31 31 578 739 193 944 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 15 0 0 0 128 1 0 0 111 0 0 0] 34 4 2288 1584 1920 1072 928 nil 27 170 192 912 1180166 #{Graphics.Rectangle} 578 31 31 578 31 31 nil nil nil nil 16817 nil nil 578 2049 461 578 831 401 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2012053952 738 34 2 786 #createAt:extent: 34 2 578 6143 21 578 831 401 416 786 #text: 34 1 8 'Rename instance variable…' 416 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 158 13 0 0 210 0 0 0] 34 2 944 640 928 nil 27)! !
!Tools.RenameAccessorsDialog class categoriesForMethods!
defaultModel!public! !
resource_Default_view!public!resources-views! !
!

