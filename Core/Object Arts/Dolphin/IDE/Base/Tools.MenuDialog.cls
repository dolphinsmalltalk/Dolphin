"Filed out from Dolphin Smalltalk"!

Tools.MenuItemDialog
	subclass: #'Tools.MenuDialog'
	instanceVariableNames: 'autoDismissPresenter checkColumnModePresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.MenuDialog guid: (Core.GUID fromString: '{b784ea93-af68-4152-b6b3-99f12c3aca87}')!

Tools.MenuDialog comment: 'MenuDialog is the <MenuItemDialog> used for editing the properties of a sub-menu entry.

Instance Variables:
	autoDismissPresenter			<BooleanPresenter>
	checkColumnModePresenter	<ChoicePresenter>

'!

!Tools.MenuDialog categoriesForClass!MVP-Presenters! !

!Tools.MenuDialog methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	checkColumnModePresenter := self add: BooleanPresenter new name: 'checkColumnMode'.
	autoDismissPresenter := self add: BooleanPresenter new name: 'autoDismiss'!

model: aMenu 
	"Set the model associated with the receiver."

	| aspectBuffer |
	super model: aMenu.
	aspectBuffer := self model.
	checkColumnModePresenter model: (aspectBuffer aspectValue: #hasSharedImageColumn).
	autoDismissPresenter model: (aspectBuffer aspectValue: #isAutoDismiss)! !

!Tools.MenuDialog categoriesForMethods!
createComponents!initializing!public! !
model:!accessing!public! !
!

!Tools.MenuDialog class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^Menu new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(12582916 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 240 nil nil nil 5 nil nil nil 240 210 1 1 nil nil nil nil 18 #{UI.ReferenceView} 50 14 nil 240 50 2 8 1140850688 131073 320 nil nil nil 5 nil nil nil 320 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 0 0 0 0 140 1 0 0 32 0 0 0] 193 352 8 '' 320 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 626 1 1 626 7 7 418 50 1 466 #createWindow: 50 1 514 546 8 #[5 0 0 0 146 0 0 0 148 1 0 0 181 0 0 0] 193 272 8 '' 240 3 50 1 320 626 193 193 nil 27 nil nil 18 #{UI.CardContainer} 50 16 nil 32 50 2 8 1140850688 131073 912 nil nil nil 5 nil nil nil 912 1350 1 #{UI.CardLayout} 550 #{Core.OrderedCollection} 3 518 #{Core.Association} 8 '&General' 18 #{UI.DialogView} 50 34 nil 912 50 2 8 1074266112 131073 1088 nil nil nil 5 2886 4 #{UI.Menu} nil true 50 2 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #chooseIcon 8 'Choose &Icon' 1 1 nil nil nil 1202 1 1234 #clearIcon 8 '&Clear Icon' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 1088 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 18 18 #{UI.TextEdit} 50 20 nil 1088 50 2 8 1140916352 1025 1424 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 1424 nil nil 518 #{UI.NullConverter} nil nil 1 #focusLost nil nil nil 418 50 2 466 #createWindow: 50 1 514 546 8 #[105 0 0 0 15 0 0 0 125 1 0 0 37 0 0 0] 193 1456 nil 1424 466 #setMarginWidths: 50 1 8 #(3 3) 1424 3 8 #() 626 193 193 nil 45 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 11 1778 #fixedParentRight 1 1778 #fixedParentTop 11 1778 #fixedViewTop 45 18 #{UI.StaticText} 50 16 nil 1088 50 2 8 1140850944 1 1856 nil nil nil 5 nil nil nil 1856 nil nil 1522 nil nil nil 418 50 2 466 #createWindow: 50 1 514 546 8 #[10 0 0 0 18 0 0 0 100 0 0 0 39 0 0 0] 193 1888 nil 1856 466 #text: 50 1 8 'Menu &Title:' 1856 3 8 #() 626 193 193 nil 27 1746 1778 #fixedParentLeft 1 1778 #fixedViewLeft 181 1824 17 1840 43 18 #{UI.TextEdit} 50 20 nil 1088 50 2 8 1140916352 1025 2176 nil 1504 nil 5 nil nil nil 2176 nil nil 1522 nil nil 1 #focusLost nil nil nil 418 50 2 466 #createWindow: 50 1 514 546 8 #[105 0 0 0 48 0 0 0 125 1 0 0 70 0 0 0] 193 2208 nil 2176 466 #setMarginWidths: 50 1 8 #(3 3) 2176 3 8 #() 626 193 193 nil 45 1746 1792 11 1808 1 1778 #fixedPreviousTop -5 1840 45 18 #{UI.StaticText} 50 16 nil 1088 50 2 8 1140850944 1 2480 nil nil nil 5 nil nil nil 2480 nil nil 1522 nil nil nil 418 50 2 466 #createWindow: 50 1 514 546 8 #[10 0 0 0 51 0 0 0 100 0 0 0 71 0 0 0] 193 2512 nil 2480 466 #text: 50 1 8 'Symbolic &Name:' 2480 3 8 #() 626 193 193 nil 27 1746 2144 1 2160 181 1778 #fixedPreviousBottom 29 1840 41 18 #{UI.StaticRectangle} 50 14 nil 1088 50 2 8 1140850696 1 2784 nil nil nil 5 1154 nil true 50 2 1202 1 1234 #chooseIcon 8 '&Choose' 1 1 nil nil nil 1202 1 1234 #clearIcon 8 'Set to &Nil' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 2784 nil nil 418 50 3 466 #createWindow: 50 1 514 546 8 #[103 0 0 0 79 0 0 0 127 0 0 0 103 0 0 0] 193 2816 8 '' 2784 466 #isEnabled: 8 #(false) 2784 466 #contextMenu: 50 1 2848 2784 3 8 #() 626 193 193 nil 27 1746 1792 -39 2160 49 2464 -7 1840 49 18 #{UI.PushButton} 50 20 nil 1088 50 2 8 1140924416 1 3232 nil nil nil 5 nil nil nil 3232 nil nil 1234 #chooseIcon 8 '…' 1 1 nil nil false nil nil nil 418 50 2 466 #createWindow: 50 1 514 546 8 #[134 0 0 0 79 0 0 0 158 0 0 0 103 0 0 0] 193 3264 8 '…' 3232 466 #isEnabled: 8 #(false) 3232 3 8 #() 626 193 193 nil 29 1746 1792 15 2160 49 2464 1 1840 49 18 #{UI.PushButton} 50 20 nil 1088 50 2 8 1140924480 1 3536 nil nil nil 5 nil nil nil 3536 nil nil 1234 #clearIcon 8 '&Clear Icon' 1 1 nil 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'EditClear.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil false nil nil nil 418 50 2 466 #createWindow: 50 1 514 546 8 #[166 0 0 0 79 0 0 0 190 0 0 0 103 0 0 0] 193 3568 8 '&Clear Icon' 3536 466 #isEnabled: 8 #(false) 3536 3 8 #() 626 193 193 nil 29 1746 1792 17 2160 49 2464 1 1840 49 18 #{UI.StaticBitmap} 50 17 nil 1088 50 2 8 1140850958 1 3968 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 1490 #darkShadow3d nil 5 nil nil nil 3968 nil nil 1522 nil nil nil nil 418 50 1 466 #createWindow: 50 1 514 546 8 #[107 0 0 0 83 0 0 0 123 0 0 0 99 0 0 0] 193 4000 nil 3968 3 8 #() 626 193 193 nil 27 1746 1778 #fixedPreviousLeft 195 2160 33 2464 -3 1840 33 18 #{UI.StaticText} 50 16 nil 1088 50 2 8 1140850944 1 4304 nil nil nil 5 nil nil nil 4304 nil nil 1522 nil nil nil 418 50 2 466 #createWindow: 50 1 514 546 8 #[10 0 0 0 85 0 0 0 90 0 0 0 106 0 0 0] 193 4336 nil 4304 466 #text: 50 1 8 '&Icon:' 4304 3 8 #() 626 193 193 nil 27 1746 2144 1 2160 161 2768 31 1840 43 1378 656 50 6 2176 8 'command' 3968 8 'icon' 1424 8 'title' 690 626 21 21 626 21 21 nil nil nil nil 1 nil nil nil nil 1 nil 193 774 #{Core.Semaphore} nil nil 1 false nil nil nil nil nil 418 50 3 466 #createWindow: 50 1 518 #{UI.CreateDialog} 690 626 9 49 626 791 275 193 1088 466 #contextMenu: 50 1 1168 1088 466 #setWindowText: 50 1 8 '' 1088 3 50 9 1856 1424 2480 2176 4304 3968 2784 3232 3536 626 193 193 nil 29 1042 8 '&Advanced' 18 #{UI.DialogView} 50 34 nil 912 50 2 8 1073741824 131073 5040 nil nil nil 5 nil nil nil 5040 1030 #{UI.GridLayout} 7 1 1 1 1378 656 50 4 18 #{UI.CheckBox} 50 16 nil 5040 50 2 8 1140927779 1 5168 4034 nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 5 nil nil nil 5168 nil nil 1522 nil nil nil 418 50 1 466 #createWindow: 50 1 514 546 8 #[15 0 0 0 20 0 0 0 115 1 0 0 48 0 0 0] 193 5200 8 '&Close menu automatically when mouse outside for ~10 secs?' 5168 3 8 #() 626 193 193 nil 27 8 'autoDismiss' 18 #{UI.CheckBox} 50 16 nil 5040 50 2 8 1140862243 1 5472 4034 nil false 4080 nil nil nil 5 nil nil nil 5472 nil nil 1522 nil nil nil 418 50 1 466 #createWindow: 50 1 514 546 8 #[15 0 0 0 48 0 0 0 115 1 0 0 75 0 0 0] 193 5504 8 '&Images (if any) share the checkmark column?' 5472 3 8 #() 626 193 193 nil 27 8 'checkColumnMode' 690 626 31 41 626 41 21 nil nil nil nil 1 nil nil nil nil 1 nil 193 4722 nil nil 1 false nil nil nil nil nil 418 50 2 466 #createWindow: 50 1 4818 690 626 9 49 626 791 275 193 5040 466 #setWindowText: 50 1 8 '' 5040 1 50 2 5168 5472 626 193 193 nil 29 1042 8 '&Inspector' 18 #{UI.DialogView} 50 34 nil 912 50 2 8 1074266112 131073 6048 nil nil nil 133 nil nil nil 6048 210 1 1 nil nil nil nil 18 #{UI.ContainerView} 50 15 nil 6048 50 2 8 1409286144 131073 6128 nil nil nil 5 nil nil nil 6128 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.Dictionary} 50 2 1042 18 #{UI.TreeView} 50 35 nil 6128 50 2 8 1140916771 1025 6288 1094 3 #{UI.TreeModel} nil 6 #{Kernel.IdentitySearchPolicy} 774 #{UI.TreeNode} nil nil nil 658 0 1504 nil 13 1154 nil true 50 12 1202 1 1234 #inspectIt 8 '&Inspect' 1 1 3634 nil true 3666 8 'BasicInspector.ico' 3728 65541 nil nil nil 1202 1 1234 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 1202 1 1234 #browseClass 8 '&Browse Class' 1 1 3634 nil true 3666 8 'ClassBrowserShell.ico' 3728 65541 nil nil nil 6642 4097 1202 1 1234 #copyAspect 8 '&Copy' 1 1 nil nil nil 1202 1 1234 #pasteAspect 8 '&Paste <d>' 1 1 nil nil nil 6642 4097 1202 1 1234 #editAspect 8 '&Edit' 1 1 nil nil nil 1202 1 1234 #resetAspect 8 '&Set to Nil/Default' 1 1 nil nil nil 6642 4097 1202 1 1234 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 6288 nil nil 518 #{Core.Message} #valueText 8 #() 7074 #valueImage 7104 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil 550 #{Core.LookupTable} 0 nil #smallIcons 9 658 0 1 262 #{UI.TreeViewLazyUpdateMode} 6288 nil nil nil nil nil nil 418 50 2 466 #createWindow: 50 1 514 546 8 #[0 0 0 0 0 0 0 0 193 0 0 0 113 0 0 0] 193 6320 8 '' 6288 466 #contextMenu: 50 1 6464 6288 3 8 #() 626 193 193 nil 29 3 1042 18 #{UI.Splitter} 50 12 nil 6128 50 2 8 1140850688 1 7456 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 7456 nil 1 #left nil nil nil 626 1 1 626 9 9 nil 7552 nil 418 50 1 466 #createWindow: 50 1 514 546 8 #[193 0 0 0 0 0 0 0 198 0 0 0 113 0 0 0] 193 7488 8 '' 7456 3 8 #() 626 193 193 nil 27 1 false 1378 656 50 4 6288 8 'aspects' 18 #{UI.CardContainer} 50 16 nil 6128 50 2 8 1140850688 131073 7792 nil 1490 #face3d nil 5 nil nil nil 7792 978 1010 0 nil nil nil nil 658 0 nil 18 #{UI.TabViewXP} 50 28 nil 7792 50 2 8 1140916866 1 7920 838 2 #{UI.ListModel} 1010 0 nil 6400 nil nil 1 nil nil nil 7920 nil nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 1 83886081 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | nil]' 8 #[29 105 60 106] 8048 7 257 nil 7074 #iconImageIndex 8 #() 7152 nil nil nil nil nil #smallIcons nil nil nil nil nil 418 50 2 466 #createWindow: 50 1 514 546 8 #[0 0 0 0 0 0 0 0 193 0 0 0 113 0 0 0] 193 7952 8 '' 7920 466 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 7920 3 8 #() 626 193 193 nil 27 418 50 1 466 #createWindow: 50 1 514 546 8 #[198 0 0 0 0 0 0 0 135 1 0 0 113 0 0 0] 193 7824 8 '' 7792 3 50 1 7920 626 193 193 nil 27 8 'display' nil 418 50 1 466 #createWindow: 50 1 514 546 8 #[0 0 0 0 0 0 0 0 135 1 0 0 113 0 0 0] 193 6160 8 '' 6128 3 50 3 6288 7456 7792 626 193 193 nil 27 1378 656 50 2 6128 8 'inspector' nil nil nil nil nil 1 nil nil nil nil 1 nil 193 4722 nil nil 1 nil nil nil nil nil nil 418 50 2 466 #createWindow: 50 1 4818 690 626 9 49 626 791 275 193 6048 466 #setWindowText: 50 1 8 '' 6048 1 50 1 6128 626 193 193 nil 29 1088 nil nil nil 1378 656 50 6 5040 8 'Advanced' 1088 8 'General' 6048 8 'Inspector' nil 18 #{UI.TabViewXP} 50 28 nil 912 50 2 8 1140916736 1 9056 7986 1010 3 1072 5024 6032 nil 6400 nil nil 1 nil nil nil 9056 nil nil 7074 #displayString 8 #() 8144 7152 nil nil nil nil nil #noIcons nil nil nil nil nil 418 50 3 466 #createWindow: 50 1 514 546 8 #[0 0 0 0 0 0 0 0 143 1 0 0 141 0 0 0] 193 9088 8 '' 9056 466 #setSingleSelection: 8 #(1) 9056 466 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 9056 3 8 #() 626 193 193 nil 27 418 50 1 466 #createWindow: 50 1 514 546 8 #[5 0 0 0 5 0 0 0 148 1 0 0 146 0 0 0] 193 944 8 '' 912 3 50 4 1088 5040 6048 9056 626 193 193 nil 27 1378 656 50 2 912 8 'cards' 690 626 11 11 626 11 11 nil nil nil nil 1 nil nil nil nil 1 nil 193 4722 nil nil 1 nil nil nil nil nil nil 418 50 2 466 #createWindow: 50 1 4818 690 626 7679 21 626 8529 471 193 32 466 #setWindowText: 50 1 8 'Menu Properties' 32 1 50 2 912 240 626 193 193 nil 29)! !

!Tools.MenuDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

