"Filed out from Dolphin Smalltalk"!

UI.ValueDialog subclass: #'Tools.RenameAccessorsDialog'
	instanceVariableNames: 'selectorsPresenter scopePresenter'
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

!

model: anObject 
	"Set the model associated with the receiver."

	super model: anObject.
	scopePresenter choices: self scopeNames.
	scopePresenter model: self model!

scopeNames
	^#(#None #Global #Hierarchy #'Package(s)' #Class #'Method(s)')!

selectors: aCollection
	selectorsPresenter model: aCollection! !
!Tools.RenameAccessorsDialog categoriesForMethods!
createComponents!initializing!public! !
model:!accessing!public! !
scopeNames!constants!public! !
selectors:!public! !
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 31 283 578 739 71 640 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 141 0 0 0 128 1 0 0 176 0 0 0] 8 #() 578 193 193 nil 27 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 944 nil nil nil 7 nil nil nil 944 1048838 #{UI.FramingLayout} 170 176 34 10 410 #{UI.StaticText} 34 16 nil 944 34 2 8 1140850944 1 1072 nil nil nil 7 nil nil nil 1072 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 105 578 441 81 1072 786 #text: 34 1 8 'Please choose the scope (if any) in which these accessors should be renamed:' 1072 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 220 0 0 0 92 0 0 0] 8 #() 928 nil 27 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedParentLeft 1 1410 #fixedViewLeft 441 1410 #fixedPreviousBottom 25 1410 #fixedViewTop 81 410 #{UI.ListBox} 34 17 nil 944 34 2 8 1144062209 262145 1488 787270 2 #{UI.ListModel} 138 144 912 nil 1769478 #{Kernel.IdentitySearchPolicy} 917510 #{Graphics.Color} #default nil 7 nil nil nil 1488 nil 8 1814640640 786950 #{Core.Message} #displayString 8 #() 8 #() false 738 34 2 786 #createAt:extent: 34 2 578 471 1 578 271 81 1488 786 #horizontalExtent: 8 #(0) 1488 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 235 0 0 0 0 0 0 0 114 1 0 0 40 0 0 0] 8 #() 928 nil 27 1378 1410 #fixedPreviousRight 31 1410 #fixedParentRight 3 1410 #fixedPreviousTop -13 1472 81 410 #{UI.StaticText} 34 16 nil 944 34 2 8 1140850944 1 1984 nil nil nil 7 nil nil nil 1984 nil 8 1815137184 1154 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 15 578 441 71 1984 786 #text: 34 1 8 'The following potential accessors for the variable were identified:

' 1984 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 7 0 0 0 220 0 0 0 42 0 0 0] 8 #() 928 nil 27 1378 1424 1 1440 441 1410 #fixedParentTop 15 1472 71 410 #{UI.CheckBox} 34 16 nil 944 34 2 8 1140927779 1 2304 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} false nil nil 7 nil nil nil 2304 nil 8 1815097472 1154 nil nil nil 738 34 3 786 #createAt:extent: 34 2 578 1 195 578 491 43 2304 786 #isEnabled: 8 #(false) 2304 786 #text: 34 1 8 'Show proposed changes?' 2304 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 97 0 0 0 245 0 0 0 118 0 0 0] 8 #() 928 nil 27 1378 1424 1 1440 491 1456 39 1472 43 410 #{UI.ComboBox} 34 17 nil 944 34 2 8 1144063491 1025 2704 1554 138 144 912 nil 1616 1648 nil 7 nil nil nil 2704 nil 8 1814646992 1682 #displayString 8 #() 1728 301 738 34 1 786 #createAt:extent: 34 2 578 469 115 578 271 47 2704 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 234 0 0 0 57 0 0 0 113 1 0 0 80 0 0 0] 8 #() 928 nil 27 1378 1936 29 1952 1 1968 11 1472 43 170 192 34 4 2704 8 'scope' 1488 8 'selectors' nil 738 34 1 786 #createAt:extent: 34 2 578 31 31 578 739 253 944 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 15 0 0 0 128 1 0 0 141 0 0 0] 34 5 1984 1488 1072 2704 2304 928 nil 27 170 192 912 1180166 #{Graphics.Rectangle} 578 31 31 578 31 31 nil nil nil nil 58269 nil nil 578 2049 461 578 831 461 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 738 34 2 786 #createAt:extent: 34 2 578 12287 21 578 831 461 416 786 #text: 34 1 8 'Rename instance variable…' 416 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 158 25 0 0 240 0 0 0] 34 2 640 944 928 nil 27)! !
!Tools.RenameAccessorsDialog class categoriesForMethods!
defaultModel!public! !
resource_Default_view!public!resources-views! !
!

