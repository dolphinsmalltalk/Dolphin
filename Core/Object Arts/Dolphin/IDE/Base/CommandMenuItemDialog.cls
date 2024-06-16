"Filed out from Dolphin Smalltalk"!

MenuItemDialog subclass: #CommandMenuItemDialog
	instanceVariableNames: 'acceleratorPresenter isRadioButtonStylePresenter isDefaultPresenter isModalPresenter'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!

CommandMenuItemDialog guid: (GUID fromString: '{87b4c6a2-026e-11d3-9fd7-00a0cc3e4a32}')!

CommandMenuItemDialog comment: 'CommandMenuItemDialog is a <dialogPresenter> used to edit the contents of an <CommandMenuItem> model.

Instance Variables:
	acceleratorPresenter			<AcceleratorPresenter> for the #accelerator aspect.
	isRadioButtonStylePresenter	<BooleanPresenter>
	isDefaultPresenter			<BooleanPresenter>
	isModalPresenter			<BooleanPresenter>


'!

!CommandMenuItemDialog categoriesForClass!MVP-Presenters! !

!CommandMenuItemDialog methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	acceleratorPresenter := self add: AcceleratorPresenter new name: 'accelerator'.
	isRadioButtonStylePresenter := self add: BooleanPresenter new name: 'isRadioButtonStyle'.
	isDefaultPresenter := self add: BooleanPresenter new name: 'isDefault'.
	isModalPresenter := self add: BooleanPresenter new name: 'isModal'.
!

model: aCommandMenuItem 
	"Set the model associated with the receiver."

	| aspectBuffer |
	super model: aCommandMenuItem.
	aspectBuffer := self model.
	acceleratorPresenter model: (aspectBuffer aspectValue: #acceleratorKey).
	isRadioButtonStylePresenter model: (aspectBuffer aspectValue: #isRadioButtonStyle).
	isDefaultPresenter model: (aspectBuffer aspectValue: #isDefault).
	isModalPresenter model: (aspectBuffer aspectValue: #isModalCommand)! !

!CommandMenuItemDialog categoriesForMethods!
createComponents!initializing!public! !
model:!accessing!public! !
!

!CommandMenuItemDialog class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^CommandMenuItem new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(12845056 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 608 nil nil nil 5 nil nil nil 608 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() false 170 192 720 590342 ##(Smalltalk.Rectangle) 328198 ##(Smalltalk.Point) 1 1 786 7 7 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[5 0 0 0 171 0 0 0 12 2 0 0 206 0 0 0] 193 640 8 '' 608 3 34 1 410 ##(Smalltalk.ReferenceView) 34 14 nil 608 34 2 8 1140850688 131073 1056 nil nil nil 5 nil nil nil 1056 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[0 0 0 0 0 0 0 0 4 2 0 0 32 0 0 0] 193 1088 8 '' 1056 3 720 786 193 193 nil 27 786 193 193 nil 27 nil nil 410 ##(Smalltalk.CardContainer) 34 16 nil 416 34 2 8 1140850688 131073 1328 nil nil nil 5 nil nil nil 1328 656710 1 ##(Smalltalk.CardLayout) 138 144 34 3 721414 ##(Smalltalk.Association) 8 '&Inspector' 410 ##(Smalltalk.DialogView) 34 34 nil 1328 34 2 8 1074266112 131073 1504 nil nil nil 133 nil nil nil 1504 578 1 1 nil nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 1504 34 2 8 1409286144 131073 1584 nil nil nil 5 nil nil nil 1584 674 138 ##(Smalltalk.Dictionary) 34 2 1458 410 ##(Smalltalk.Splitter) 34 12 nil 1584 34 2 8 1140850688 1 1712 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 1712 nil 1 #left nil nil nil 786 1 1 786 9 9 nil 1808 nil 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[253 0 0 0 0 0 0 0 2 1 0 0 138 0 0 0] 193 1744 8 '' 1712 3 8 #() 786 193 193 nil 27 1 1458 410 ##(Smalltalk.TreeView) 34 27 nil 1584 34 2 8 1140916771 1025 2032 590918 3 ##(Smalltalk.TreeModel) nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 720 327686 ##(Smalltalk.Color) #default nil 13 265030 4 ##(Smalltalk.Menu) nil true 34 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 2290 1 2322 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2290 1 2322 #browseClass 8 '&Browse Class' 1 1 2370 nil true 2416 8 'ClassBrowserShell.ico' 2464 nil nil 2546 4097 2290 1 2322 #copyAspect 8 '&Copy' 1 1 nil nil nil 2290 1 2322 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 2546 4097 2290 1 2322 #editAspect 8 '&Edit' 1 1 nil nil nil 2290 1 2322 #nilAspect 8 'Set to &Nil' 1 1 nil nil nil 2546 4097 2290 1 2322 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 2032 nil 8 1758766000 459270 ##(Smalltalk.Message) #valueText 8 #() 2978 #valueImage 3008 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil 170 176 720 nil #smallIcons 9 170 ##(Smalltalk.PluggableLookupTable) 720 834 138 144 34 2 898 #createWindow: 34 1 946 978 8 #[0 0 0 0 0 0 0 0 253 0 0 0 138 0 0 0] 193 2064 8 '' 2032 898 #contextMenu: 34 1 2256 2032 3 8 #() 786 193 193 nil 27 3 false 170 192 34 4 410 ##(Smalltalk.CardContainer) 34 16 nil 1584 34 2 8 1140850688 131073 3344 nil 2210 #face3d nil 5 nil nil nil 3344 1394 138 144 720 nil nil nil nil 170 192 720 nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 3344 34 2 8 1140916866 1 3472 590662 2 ##(Smalltalk.ListModel) 138 144 720 nil 2144 nil nil 1 nil nil nil 3472 nil 8 1758664336 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 8 #[29 105 60 106] 3616 7 257 nil ##(Smalltalk.IconicListAbstract) 3056 nil nil nil nil nil #smallIcons nil nil nil nil nil 834 138 144 34 2 898 #createWindow: 34 1 946 978 8 #[0 0 0 0 0 0 0 0 253 0 0 0 138 0 0 0] 193 3504 8 '' 3472 898 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 3472 3 8 #() 786 193 193 nil 27 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[2 1 0 0 0 0 0 0 255 1 0 0 138 0 0 0] 193 3376 8 '' 3344 3 34 1 3472 786 193 193 nil 27 8 'display' 2032 8 'aspects' nil 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[0 0 0 0 0 0 0 0 255 1 0 0 138 0 0 0] 193 1616 8 '' 1584 3 34 3 2032 1712 3344 786 193 193 nil 27 170 192 34 2 1584 8 'inspector' nil nil nil nil nil 3 nil nil nil nil 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 834 138 144 34 2 898 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 754 786 9 29 786 1031 305 193 1504 898 #setWindowText: 34 1 8 '' 1504 1 34 1 1584 786 193 193 nil 29 1458 8 '&Styles' 410 ##(Smalltalk.DialogView) 34 34 nil 1328 34 2 8 1074266112 131073 4672 nil nil nil 5 nil nil nil 4672 nil 170 192 34 6 410 ##(Smalltalk.CheckBox) 34 16 nil 4672 34 2 8 1140924419 1 4768 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 4768 nil 8 1759007584 852486 ##(Smalltalk.NullConverter) nil nil nil 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[15 0 0 0 48 0 0 0 128 0 0 0 73 0 0 0] 193 4800 8 'Default' 4768 3 8 #() 786 193 193 nil 27 8 'isDefault' 410 ##(Smalltalk.CheckBox) 34 16 nil 4672 34 2 8 1140924419 1 5136 4834 nil nil 4880 false nil nil 5 nil nil nil 5136 nil 8 1759007584 4914 nil nil nil 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[15 0 0 0 20 0 0 0 135 0 0 0 45 0 0 0] 193 5168 8 'Radio button' 5136 3 8 #() 786 193 193 nil 27 8 'isRadioButtonStyle' 410 ##(Smalltalk.CheckBox) 34 16 nil 4672 34 2 8 1140924419 1 5440 4834 nil nil 4880 false nil nil 5 nil nil nil 5440 nil 8 1759007584 4914 nil nil nil 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[140 0 0 0 20 0 0 0 253 0 0 0 45 0 0 0] 193 5472 8 'Modal' 5440 3 8 #() 786 193 193 nil 27 8 'isModal' nil nil nil nil nil 3 nil nil nil nil 1 nil 193 4354 nil nil 1 false 8 2006356512 nil nil nil nil 834 138 144 34 2 898 #createWindow: 34 1 4482 754 786 1 1 786 1023 277 193 4672 898 #setWindowText: 34 1 8 '' 4672 1 34 3 5136 4768 5440 786 193 193 nil 29 1458 8 '&General' 410 ##(Smalltalk.DialogView) 34 34 nil 1328 34 2 8 1073741824 131073 6032 nil nil nil 5 nil nil nil 6032 nil 170 192 34 8 410 ##(Smalltalk.TextEdit) 34 16 nil 6032 34 2 8 1140916352 1025 6128 nil 2224 nil 5 nil nil nil 6128 nil 8 1759000288 4914 nil nil 1 834 138 144 34 2 898 #createWindow: 34 1 946 978 8 #[106 0 0 0 43 0 0 0 70 1 0 0 65 0 0 0] 193 6160 nil 6128 898 #setMarginWidths: 34 1 8 #(3 3) 6128 3 8 #() 786 193 193 nil 27 8 'command' 410 ##(Smalltalk.HotKey) 34 17 nil 6032 34 2 8 1140916224 1 6448 4834 nil nil 4880 1 2224 nil 5 nil nil nil 6448 nil 8 1759471856 852486 ##(Smalltalk.AccelToHotKey) nil nil 471 1 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[106 0 0 0 73 0 0 0 206 0 0 0 95 0 0 0] 193 6480 8 '' 6448 3 8 #() 786 193 193 nil 27 8 'accelerator' 410 ##(Smalltalk.TextEdit) 34 16 nil 6032 34 2 8 1140916352 1025 6768 nil 2224 nil 5 nil nil nil 6768 nil 8 1759000288 4914 nil nil 1 834 138 144 34 2 898 #createWindow: 34 1 946 978 8 #[106 0 0 0 13 0 0 0 70 1 0 0 35 0 0 0] 193 6800 nil 6768 898 #setMarginWidths: 34 1 8 #(3 3) 6768 3 8 #() 786 193 193 nil 27 8 'title' 410 ##(Smalltalk.StaticBitmap) 34 17 nil 6032 34 2 8 1140850958 1 7088 4834 nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 5 nil nil nil 7088 nil 8 1759212608 4914 nil nil nil nil 834 138 144 34 2 898 #createWindow: 34 1 946 978 8 #[10 1 0 0 77 0 0 0 26 1 0 0 93 0 0 0] 193 7120 nil 7088 898 #text: 34 1 8 '' 7088 3 8 #() 786 193 193 nil 27 8 'icon' 754 786 1 1 786 21 21 nil nil nil nil 3 nil nil nil nil 1 nil 193 4354 nil nil 1 false 8 2006356512 nil nil nil nil 834 138 144 34 2 898 #createWindow: 34 1 4482 754 786 1 1 786 1023 277 193 6032 898 #setWindowText: 34 1 8 '' 6032 3 34 10 410 ##(Smalltalk.StaticText) 34 16 nil 6032 34 2 8 1140850944 1 7744 nil nil nil 5 nil nil nil 7744 nil 8 1759212608 4914 nil nil nil 834 138 144 34 2 898 #createWindow: 34 1 946 978 8 #[15 0 0 0 18 0 0 0 95 0 0 0 33 0 0 0] 193 7776 nil 7744 898 #text: 34 1 8 'Item &text:' 7744 3 8 #() 786 193 193 nil 27 6768 410 ##(Smalltalk.StaticText) 34 16 nil 6032 34 2 8 1140850944 1 8048 nil nil nil 5 nil nil nil 8048 nil 8 1759212608 4914 nil nil nil 834 138 144 34 2 898 #createWindow: 34 1 946 978 8 #[15 0 0 0 48 0 0 0 95 0 0 0 63 0 0 0] 193 8080 nil 8048 898 #text: 34 1 8 '&Command:' 8048 3 8 #() 786 193 193 nil 27 6128 410 ##(Smalltalk.StaticText) 34 16 nil 6032 34 2 8 1140850944 1 8352 nil nil nil 5 nil nil nil 8352 nil 8 1759212608 4914 nil nil nil 834 138 144 34 2 898 #createWindow: 34 1 946 978 8 #[15 0 0 0 75 0 0 0 105 0 0 0 90 0 0 0] 193 8384 nil 8352 898 #text: 34 1 8 '&Accelerator key:' 8352 3 8 #() 786 193 193 nil 27 6448 410 ##(Smalltalk.StaticText) 34 16 nil 6032 34 2 8 1140850944 1 8656 nil nil nil 5 nil nil nil 8656 nil 8 1759212608 4914 nil nil nil 834 138 144 34 2 898 #createWindow: 34 1 946 978 8 #[231 0 0 0 77 0 0 0 5 1 0 0 92 0 0 0] 193 8688 nil 8656 898 #text: 34 1 8 '&Icon:' 8656 3 8 #() 786 193 193 nil 27 7088 410 ##(Smalltalk.StaticRectangle) 34 14 nil 6032 34 2 8 1140850952 1 8960 nil 2224 nil 5 nil nil nil 8960 nil 8 1759212608 834 138 144 34 2 898 #createWindow: 34 1 946 978 8 #[6 1 0 0 73 0 0 0 29 1 0 0 96 0 0 0] 193 8992 nil 8960 898 #isEnabled: 8 #(false) 8960 3 8 #() 786 193 193 nil 27 410 ##(Smalltalk.PushButton) 34 20 nil 6032 34 2 8 1140924416 1 9232 nil 2224 nil 5 nil nil nil 9232 nil 8 1759007584 2322 #chooseIcon 8 '...' 1 1 nil nil false nil nil nil 834 138 144 34 2 898 #createWindow: 34 1 946 978 8 #[35 1 0 0 74 0 0 0 55 1 0 0 94 0 0 0] 193 9264 8 '...' 9232 898 #isEnabled: 8 #(false) 9232 3 8 #() 786 193 193 nil 29 786 193 193 nil 29 6032 nil nil nil 170 192 720 nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 1328 34 2 8 1140916736 1 9584 3538 138 144 34 3 6016 1488 4656 nil 2144 nil nil 1 nil nil nil 9584 nil 8 1758664336 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 3056 nil nil nil nil nil #noIcons nil nil nil nil nil 834 138 144 34 3 898 #createWindow: 34 1 946 978 8 #[0 0 0 0 0 0 0 0 7 2 0 0 166 0 0 0] 193 9616 8 '' 9584 898 #setSingleSelection: 8 #(1) 9584 898 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 9584 3 8 #() 786 193 193 nil 27 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[5 0 0 0 5 0 0 0 12 2 0 0 171 0 0 0] 193 1360 8 '' 1328 3 34 4 4672 1504 6032 9584 786 193 193 nil 27 170 192 34 2 1328 8 'cards' 754 786 11 11 786 11 11 nil nil nil nil 10883 nil nil nil nil 1 nil 193 4354 nil nil 1 nil 8 2006356512 nil nil nil nil 834 138 144 34 2 898 #createWindow: 34 1 4482 754 786 1 1 786 1091 501 193 416 898 #setWindowText: 34 1 8 'Command Properties' 416 1 34 2 1328 608 786 193 193 nil 29 )! !

!CommandMenuItemDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

