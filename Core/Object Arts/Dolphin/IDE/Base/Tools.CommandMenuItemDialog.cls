"Filed out from Dolphin Smalltalk"!

Tools.MenuItemDialog
	subclass: #'Tools.CommandMenuItemDialog'
	instanceVariableNames: 'acceleratorPresenter isRadioButtonStylePresenter isDefaultPresenter isModalPresenter hasSubstitutionsPresenter'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.CommandMenuItemDialog guid: (Core.GUID fromString: '{87b4c6a2-026e-11d3-9fd7-00a0cc3e4a32}')!

Tools.CommandMenuItemDialog comment: 'CommandMenuItemDialog is a <dialogPresenter> used to edit the contents of an <CommandMenuItem> model.

Instance Variables:
	acceleratorPresenter			<AcceleratorPresenter> for the #accelerator aspect.
	isRadioButtonStylePresenter	<BooleanPresenter>
	isDefaultPresenter			<BooleanPresenter>
	isModalPresenter			<BooleanPresenter>


'!

!Tools.CommandMenuItemDialog categoriesForClass!MVP-Presenters! !

!Tools.CommandMenuItemDialog methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	acceleratorPresenter := self add: AcceleratorPresenter new name: 'accelerator'.
	isRadioButtonStylePresenter := self add: BooleanPresenter new name: 'isRadioButtonStyle'.
	isDefaultPresenter := self add: BooleanPresenter new name: 'isDefault'.
	isModalPresenter := self add: BooleanPresenter new name: 'isModal'.
	hasSubstitutionsPresenter := self add: BooleanPresenter new name: 'hasSubstitutions'!

model: aCommandMenuItem 
	"Set the model associated with the receiver."

	| aspectBuffer |
	super model: aCommandMenuItem.
	aspectBuffer := self model.
	acceleratorPresenter model: (aspectBuffer aspectValue: #acceleratorKey).
	isRadioButtonStylePresenter model: (aspectBuffer aspectValue: #isRadioButtonStyle).
	isDefaultPresenter model: (aspectBuffer aspectValue: #isDefault).
	isModalPresenter model: (aspectBuffer aspectValue: #isModalCommand).
	hasSubstitutionsPresenter model: (aspectBuffer aspectValue: #hasTextSubstitutions)! !

!Tools.CommandMenuItemDialog categoriesForMethods!
createComponents!initializing!public! !
model:!accessing!public! !
!

!Tools.CommandMenuItemDialog class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^CommandMenuItem new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(12845056 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 240 nil nil nil 5 nil nil nil 240 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 0 false 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 518 #{Graphics.Point} 1 1 434 7 7 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[5 0 0 0 171 0 0 0 12 2 0 0 206 0 0 0] 193 272 8 '' 240 3 50 1 18 #{UI.ReferenceView} 50 14 nil 240 50 2 8 1140850688 131073 688 nil nil nil 5 nil nil nil 688 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 482 50 1 530 #createWindow: 50 1 578 610 8 #[0 0 0 0 0 0 0 0 4 2 0 0 32 0 0 0] 193 720 8 '' 688 3 8 #() 434 193 193 nil 27 434 193 193 nil 27 nil nil 18 #{UI.CardContainer} 50 16 nil 32 50 2 8 1140850688 131073 960 nil nil nil 5 nil nil nil 960 1350 1 #{UI.CardLayout} 550 #{Core.OrderedCollection} 3 518 #{Core.Association} 8 '&Inspector' 18 #{UI.DialogView} 50 34 nil 960 50 2 8 1074266112 131073 1136 nil nil nil 133 nil nil nil 1136 210 1 1 nil nil nil nil 18 #{UI.ContainerView} 50 15 nil 1136 50 2 8 1409286144 131073 1216 nil nil nil 5 nil nil nil 1216 306 518 #{Kernel.STBCollectionProxy} #{Core.Dictionary} 50 2 1090 18 #{UI.TreeView} 50 35 nil 1216 50 2 8 1140916771 1025 1360 1094 3 #{UI.TreeModel} nil 6 #{Kernel.IdentitySearchPolicy} 774 #{UI.TreeNode} nil nil nil 370 0 6 #{Graphics.Color} #default nil 13 2886 4 #{UI.Menu} nil true 50 12 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #inspectIt 8 '&Inspect' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'BasicInspector.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 1618 1 1650 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 1618 1 1650 #browseClass 8 '&Browse Class' 1 1 1698 nil true 1730 8 'ClassBrowserShell.ico' 1792 65541 nil nil nil 1874 4097 1618 1 1650 #copyAspect 8 '&Copy' 1 1 nil nil nil 1618 1 1650 #pasteAspect 8 '&Paste <d>' 1 1 nil nil nil 1874 4097 1618 1 1650 #editAspect 8 '&Edit' 1 1 nil nil nil 1618 1 1650 #resetAspect 8 '&Set to Nil/Default' 1 1 nil nil nil 1874 4097 1618 1 1650 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 1360 nil nil 518 #{Core.Message} #valueText 8 #() 2306 #valueImage 2336 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil 338 0 nil #smallIcons 9 370 0 1 262 #{UI.TreeViewLazyUpdateMode} 1360 nil nil nil nil nil nil 482 50 2 530 #createWindow: 50 1 578 610 8 #[0 0 0 0 0 0 0 0 253 0 0 0 138 0 0 0] 193 1392 8 '' 1360 530 #contextMenu: 50 1 1584 1360 3 8 #() 434 193 193 nil 29 3 1090 18 #{UI.Splitter} 50 12 nil 1216 50 2 8 1140850688 1 2672 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 2672 nil 1 #left nil nil nil 434 1 1 434 9 9 nil 2768 nil 482 50 1 530 #createWindow: 50 1 578 610 8 #[253 0 0 0 0 0 0 0 2 1 0 0 138 0 0 0] 193 2704 8 '' 2672 3 8 #() 434 193 193 nil 27 1 false 518 #{Kernel.STBIdentityDictionaryProxy} 368 50 4 1360 8 'aspects' 18 #{UI.CardContainer} 50 16 nil 1216 50 2 8 1140850688 131073 3024 nil 1538 #face3d nil 5 nil nil nil 3024 1026 1058 0 nil nil nil nil 370 0 nil 18 #{UI.TabViewXP} 50 28 nil 3024 50 2 8 1140916866 1 3152 838 2 #{UI.ListModel} 1058 0 nil 1472 nil nil 1 nil nil nil 3152 nil nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 1 83886081 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | nil]' 8 #[29 105 60 106] 3280 7 257 nil 2306 #iconImageIndex 8 #() 2384 nil nil nil nil nil #smallIcons nil nil nil nil nil 482 50 2 530 #createWindow: 50 1 578 610 8 #[0 0 0 0 0 0 0 0 253 0 0 0 138 0 0 0] 193 3184 8 '' 3152 530 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 3152 3 8 #() 434 193 193 nil 27 482 50 1 530 #createWindow: 50 1 578 610 8 #[2 1 0 0 0 0 0 0 255 1 0 0 138 0 0 0] 193 3056 8 '' 3024 3 50 1 3152 434 193 193 nil 27 8 'display' nil 482 50 1 530 #createWindow: 50 1 578 610 8 #[0 0 0 0 0 0 0 0 255 1 0 0 138 0 0 0] 193 1248 8 '' 1216 3 50 3 1360 2672 3024 434 193 193 nil 27 2962 368 50 2 1216 8 'inspector' nil nil nil nil nil 1 nil nil nil nil 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 482 50 2 530 #createWindow: 50 1 518 #{UI.CreateDialog} 402 434 9 49 434 1031 325 193 1136 530 #setWindowText: 50 1 8 '' 1136 1 50 1 1216 434 193 193 nil 29 1090 8 '&Styles' 18 #{UI.DialogView} 50 34 nil 960 50 2 8 1074266112 131073 4272 nil nil nil 5 nil nil nil 4272 nil 2962 368 50 6 18 #{UI.CheckBox} 50 16 nil 4272 50 2 8 1140924419 1 4368 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 5 nil nil nil 4368 nil nil 518 #{UI.NullConverter} nil nil nil 482 50 1 530 #createWindow: 50 1 578 610 8 #[15 0 0 0 48 0 0 0 128 0 0 0 73 0 0 0] 193 4400 8 'Default' 4368 3 8 #() 434 193 193 nil 27 8 'isDefault' 18 #{UI.CheckBox} 50 16 nil 4272 50 2 8 1140924419 1 4704 4434 nil nil 4480 false nil nil 5 nil nil nil 4704 nil nil 4498 nil nil nil 482 50 1 530 #createWindow: 50 1 578 610 8 #[140 0 0 0 20 0 0 0 253 0 0 0 45 0 0 0] 193 4736 8 'Modal' 4704 3 8 #() 434 193 193 nil 27 8 'isModal' 18 #{UI.CheckBox} 50 16 nil 4272 50 2 8 1140924419 1 4976 4434 nil nil 4480 false nil nil 5 nil nil nil 4976 nil nil 4498 nil nil nil 482 50 1 530 #createWindow: 50 1 578 610 8 #[15 0 0 0 20 0 0 0 135 0 0 0 45 0 0 0] 193 5008 8 'Radio button' 4976 3 8 #() 434 193 193 nil 27 8 'isRadioButtonStyle' nil nil nil nil nil 1 nil nil nil nil 1 nil 193 3986 nil nil 1 false nil nil nil nil nil 482 50 2 530 #createWindow: 50 1 4082 402 434 9 49 434 1031 325 193 4272 530 #setWindowText: 50 1 8 '' 4272 1 50 3 4976 4368 4704 434 193 193 nil 29 1090 8 '&General' 18 #{UI.DialogView} 50 34 nil 960 50 2 8 1073741824 131073 5504 nil nil nil 5 nil nil nil 5504 nil 2962 368 50 10 18 #{UI.HotKey} 50 17 nil 5504 50 2 8 1140916224 1 5600 4434 nil nil 4480 1 1552 nil 5 nil nil nil 5600 nil nil 518 #{UI.AccelToHotKey} nil nil 471 1 482 50 1 530 #createWindow: 50 1 578 610 8 #[106 0 0 0 73 0 0 0 206 0 0 0 95 0 0 0] 193 5632 8 '' 5600 3 8 #() 434 193 193 nil 27 8 'accelerator' 18 #{UI.TextEdit} 50 20 nil 5504 50 2 8 1140916352 1025 5888 nil 1552 nil 5 nil nil nil 5888 nil nil 4498 nil nil 1 #focusLost nil nil nil 482 50 2 530 #createWindow: 50 1 578 610 8 #[106 0 0 0 43 0 0 0 70 1 0 0 65 0 0 0] 193 5920 nil 5888 530 #setMarginWidths: 50 1 8 #(3 3) 5888 3 8 #() 434 193 193 nil 45 8 'command' 18 #{UI.CheckBox} 50 16 nil 5504 50 2 8 1140924419 1 6176 4434 nil nil 4480 false nil nil 5 nil nil nil 6176 nil nil 4498 nil nil nil 482 50 1 530 #createWindow: 50 1 578 610 8 #[81 1 0 0 12 0 0 0 194 1 0 0 37 0 0 0] 193 6208 8 'Has &Substitutions' 6176 3 8 #() 434 193 193 nil 27 8 'hasSubstitutions' 18 #{UI.StaticBitmap} 50 17 nil 5504 50 2 8 1140850958 1 6448 4434 nil false 6 #{Kernel.EqualitySearchPolicy} nil nil nil 5 nil nil nil 6448 nil nil 4498 nil nil nil nil 482 50 1 530 #createWindow: 50 1 578 610 8 #[10 1 0 0 77 0 0 0 26 1 0 0 93 0 0 0] 193 6480 nil 6448 3 8 #() 434 193 193 nil 27 8 'icon' 18 #{UI.TextEdit} 50 20 nil 5504 50 2 8 1140916352 1025 6736 nil 1552 nil 5 nil nil nil 6736 nil nil 4498 nil nil 1 #focusLost nil nil nil 482 50 2 530 #createWindow: 50 1 578 610 8 #[106 0 0 0 13 0 0 0 70 1 0 0 35 0 0 0] 193 6768 nil 6736 530 #setMarginWidths: 50 1 8 #(3 3) 6736 3 8 #() 434 193 193 nil 45 8 'title' 402 434 1 1 434 21 21 nil nil nil nil 1 nil nil nil nil 1 nil 193 3986 nil nil 1 false nil nil nil nil nil 482 50 2 530 #createWindow: 50 1 4082 402 434 9 49 434 1031 325 193 5504 530 #setWindowText: 50 1 8 '' 5504 3 50 11 18 #{UI.StaticText} 50 16 nil 5504 50 2 8 1140850944 1 7280 nil nil nil 5 nil nil nil 7280 nil nil 4498 nil nil nil 482 50 2 530 #createWindow: 50 1 578 610 8 #[15 0 0 0 16 0 0 0 95 0 0 0 31 0 0 0] 193 7312 nil 7280 530 #text: 50 1 8 'Item &text:' 7280 3 8 #() 434 193 193 nil 27 6736 18 #{UI.StaticText} 50 16 nil 5504 50 2 8 1140850944 1 7552 nil nil nil 5 nil nil nil 7552 nil nil 4498 nil nil nil 482 50 2 530 #createWindow: 50 1 578 610 8 #[15 0 0 0 46 0 0 0 95 0 0 0 61 0 0 0] 193 7584 nil 7552 530 #text: 50 1 8 '&Command:' 7552 3 8 #() 434 193 193 nil 27 5888 18 #{UI.StaticText} 50 16 nil 5504 50 2 8 1140850944 1 7824 nil nil nil 5 nil nil nil 7824 nil nil 4498 nil nil nil 482 50 2 530 #createWindow: 50 1 578 610 8 #[15 0 0 0 75 0 0 0 105 0 0 0 90 0 0 0] 193 7856 nil 7824 530 #text: 50 1 8 '&Accelerator key:' 7824 3 8 #() 434 193 193 nil 27 5600 18 #{UI.StaticText} 50 16 nil 5504 50 2 8 1140850944 1 8096 nil nil nil 5 nil nil nil 8096 nil nil 4498 nil nil nil 482 50 2 530 #createWindow: 50 1 578 610 8 #[231 0 0 0 77 0 0 0 5 1 0 0 92 0 0 0] 193 8128 nil 8096 530 #text: 50 1 8 '&Icon:' 8096 3 8 #() 434 193 193 nil 27 6448 18 #{UI.StaticRectangle} 50 14 nil 5504 50 2 8 1140850952 1 8368 nil 1552 nil 5 nil nil nil 8368 nil nil 482 50 2 530 #createWindow: 50 1 578 610 8 #[6 1 0 0 73 0 0 0 29 1 0 0 96 0 0 0] 193 8400 8 '' 8368 530 #isEnabled: 8 #(false) 8368 3 8 #() 434 193 193 nil 27 18 #{UI.PushButton} 50 20 nil 5504 50 2 8 1140924416 1 8624 nil 1552 nil 5 nil nil nil 8624 nil nil 1650 #chooseIcon 8 '…' 1 1 nil nil false nil nil nil 482 50 2 530 #createWindow: 50 1 578 610 8 #[35 1 0 0 74 0 0 0 55 1 0 0 94 0 0 0] 193 8656 8 '…' 8624 530 #isEnabled: 8 #(false) 8624 3 8 #() 434 193 193 nil 29 6176 434 193 193 nil 29 5504 nil nil nil 370 0 nil 18 #{UI.TabViewXP} 50 28 nil 960 50 2 8 1140916736 1 8944 3218 1058 3 5488 1120 4256 nil 1472 nil nil 1 nil nil nil 8944 nil nil 2306 #displayString 3392 3376 2384 nil nil nil nil nil #noIcons nil nil nil nil nil 482 50 3 530 #createWindow: 50 1 578 610 8 #[0 0 0 0 0 0 0 0 7 2 0 0 166 0 0 0] 193 8976 8 '' 8944 530 #setSingleSelection: 8 #(1) 8944 530 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8944 3 8 #() 434 193 193 nil 27 482 50 1 530 #createWindow: 50 1 578 610 8 #[5 0 0 0 5 0 0 0 12 2 0 0 171 0 0 0] 193 992 8 '' 960 3 50 4 5504 1136 4272 8944 434 193 193 nil 27 2962 368 50 2 960 8 'cards' 402 434 11 11 434 11 11 nil nil nil nil 1 nil nil nil nil 1 nil 193 3986 nil nil 1 false nil nil nil nil nil 482 50 2 530 #createWindow: 50 1 4082 402 434 7679 21 434 8769 521 193 32 530 #setWindowText: 50 1 8 'Command Properties' 32 1 50 2 960 240 434 193 193 nil 29)! !

!Tools.CommandMenuItemDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

