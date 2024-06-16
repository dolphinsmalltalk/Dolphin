"Filed out from Dolphin Smalltalk"!

MenuItemDialog subclass: #MenuDialog
	instanceVariableNames: 'autoDismissPresenter checkColumnModePresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MenuDialog guid: (GUID fromString: '{b784ea93-af68-4152-b6b3-99f12c3aca87}')!

MenuDialog comment: 'MenuDialog is the <MenuItemDialog> used for editing the properties of a sub-menu entry.

Instance Variables:
	autoDismissPresenter			<BooleanPresenter>
	checkColumnModePresenter	<ChoicePresenter>

'!

!MenuDialog categoriesForClass!MVP-Presenters! !

!MenuDialog methodsFor!

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
	autoDismissPresenter model: (aspectBuffer aspectValue: #isAutoDismiss)!

onCardChanged
	cardsPresenter currentCard = inspector view parentView ifTrue: [inspector refresh]! !

!MenuDialog categoriesForMethods!
createComponents!initializing!public! !
model:!accessing!public! !
onCardChanged!event handling!private! !
!

!MenuDialog class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^Menu new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(12582916 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 608 nil nil nil 5 nil nil nil 608 578 1 1 nil nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 608 34 2 8 1140850688 131073 688 nil nil nil 5 nil nil nil 688 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 140 1 0 0 32 0 0 0] 193 720 8 '' 688 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 170 192 992 590342 ##(Smalltalk.Rectangle) 1010 1 1 1010 7 7 786 138 144 34 1 850 #createWindow: 34 1 898 930 8 #[5 0 0 0 146 0 0 0 148 1 0 0 181 0 0 0] 193 640 8 '' 608 3 34 1 688 1010 193 193 nil 27 nil nil 410 ##(Smalltalk.CardContainer) 34 16 nil 416 34 2 8 1140850688 131073 1296 nil nil nil 5 nil nil nil 1296 656710 1 ##(Smalltalk.CardLayout) 138 144 34 3 721414 ##(Smalltalk.Association) 8 '&General' 410 ##(Smalltalk.DialogView) 34 34 nil 1296 34 2 8 1074266112 131073 1472 nil nil nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 2 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #chooseIcon 8 'Choose &Icon' 1 1 nil nil nil 1586 1 1618 #clearIcon 8 '&Clear Icon' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 1472 852230 ##(Smalltalk.FramingLayout) 170 176 34 18 410 ##(Smalltalk.StaticBitmap) 34 17 nil 1472 34 2 8 1140850958 1 1792 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 327686 ##(Smalltalk.Color) #darkShadow3d nil 5 nil nil nil 1792 nil 8 1759212608 852486 ##(Smalltalk.NullConverter) nil nil nil nil 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[107 0 0 0 83 0 0 0 123 0 0 0 99 0 0 0] 193 1824 nil 1792 850 #text: 34 1 8 '' 1792 3 8 #() 1010 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousLeft 195 2242 #fixedViewLeft 33 2242 #fixedPreviousTop -3 2242 #fixedViewTop 33 410 ##(Smalltalk.StaticText) 34 16 nil 1472 34 2 8 1140850944 1 2320 nil nil nil 5 nil nil nil 2320 nil 8 1759212608 1970 nil nil nil 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[10 0 0 0 51 0 0 0 100 0 0 0 71 0 0 0] 193 2352 nil 2320 850 #text: 34 1 8 'Symbolic &Name:' 2320 3 8 #() 1010 193 193 nil 27 2210 2242 #fixedParentLeft 1 2272 181 2242 #fixedPreviousBottom 29 2304 41 410 ##(Smalltalk.PushButton) 34 20 nil 1472 34 2 8 1140924416 1 2672 nil nil nil 5 nil nil nil 2672 nil 8 1759007584 1618 #chooseIcon 8 '...' 1 1 nil nil false nil nil nil 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[134 0 0 0 79 0 0 0 158 0 0 0 103 0 0 0] 193 2704 8 '...' 2672 850 #isEnabled: 8 #(false) 2672 3 8 #() 1010 193 193 nil 29 2210 2242 #fixedPreviousRight 15 2272 49 2288 1 2304 49 410 ##(Smalltalk.StaticText) 34 16 nil 1472 34 2 8 1140850944 1 3024 nil nil nil 5 nil nil nil 3024 nil 8 1759212608 1970 nil nil nil 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[10 0 0 0 85 0 0 0 90 0 0 0 106 0 0 0] 193 3056 nil 3024 850 #text: 34 1 8 '&Icon:' 3024 3 8 #() 1010 193 193 nil 27 2210 2640 1 2272 161 2656 31 2304 43 410 ##(Smalltalk.TextEdit) 34 16 nil 1472 34 2 8 1140916352 1025 3344 nil 1922 #default nil 5 nil nil nil 3344 nil 8 1759000288 1970 nil nil 1 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[105 0 0 0 15 0 0 0 125 1 0 0 37 0 0 0] 193 3376 nil 3344 850 #setMarginWidths: 34 1 8 #(3 3) 3344 3 8 #() 1010 193 193 nil 27 2210 3008 11 2242 #fixedParentRight 1 2242 #fixedParentTop 11 2304 45 410 ##(Smalltalk.TextEdit) 34 16 nil 1472 34 2 8 1140916352 1025 3712 nil 3408 nil 5 nil nil nil 3712 nil 8 1759000288 1970 nil nil 1 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[105 0 0 0 48 0 0 0 125 1 0 0 70 0 0 0] 193 3744 nil 3712 850 #setMarginWidths: 34 1 8 #(3 3) 3712 3 8 #() 1010 193 193 nil 27 2210 3008 11 3680 1 2288 -5 2304 45 410 ##(Smalltalk.StaticRectangle) 34 14 nil 1472 34 2 8 1140850696 1 4032 nil nil nil 5 1538 nil true 34 2 1586 1 1618 #chooseIcon 8 '&Choose' 1 1 nil nil nil 1586 1 1618 #clearIcon 8 'Set to &Nil' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 4032 nil 8 1759212608 786 138 144 34 3 850 #createWindow: 34 1 898 930 8 #[103 0 0 0 79 0 0 0 127 0 0 0 103 0 0 0] 193 4064 nil 4032 850 #isEnabled: 8 #(false) 4032 850 #contextMenu: 34 1 4096 4032 3 8 #() 1010 193 193 nil 27 2210 3008 -39 2272 49 2288 -7 2304 49 410 ##(Smalltalk.PushButton) 34 20 nil 1472 34 2 8 1140924480 1 4496 nil nil nil 5 nil nil nil 4496 nil 8 1759007584 1618 #clearIcon 8 '&Clear Icon' 1 1 nil 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'EditClear.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil false nil nil nil 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[166 0 0 0 79 0 0 0 190 0 0 0 103 0 0 0] 193 4528 8 '&Clear Icon' 4496 850 #isEnabled: 8 #(false) 4496 3 8 #() 1010 193 193 nil 29 2210 3008 17 2272 49 2288 1 2304 49 410 ##(Smalltalk.StaticText) 34 16 nil 1472 34 2 8 1140850944 1 4960 nil nil nil 5 nil nil nil 4960 nil 8 1759212608 1970 nil nil nil 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[10 0 0 0 18 0 0 0 100 0 0 0 39 0 0 0] 193 4992 nil 4960 850 #text: 34 1 8 'Menu &Title:' 4960 3 8 #() 1010 193 193 nil 27 2210 2640 1 2272 181 3696 17 2304 43 170 192 34 6 3712 8 'command' 3344 8 'title' 1792 8 'icon' 1058 1010 21 21 1010 21 21 nil nil nil nil 3 nil nil nil nil 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 false 8 2006356512 nil nil nil nil 786 138 144 34 3 850 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 1058 1010 1 1 1010 783 227 193 1472 850 #contextMenu: 34 1 1552 1472 850 #setWindowText: 34 1 8 '' 1472 3 34 9 4960 3344 2320 3712 3024 1792 4032 2672 4496 1010 193 193 nil 29 1426 8 '&Advanced' 410 ##(Smalltalk.DialogView) 34 34 nil 1296 34 2 8 1073741824 131073 5760 nil nil nil 5 nil nil nil 5760 656390 ##(Smalltalk.GridLayout) 7 1 1 1 170 192 34 4 410 ##(Smalltalk.CheckBox) 34 16 nil 5760 34 2 8 1140927779 1 5888 1858 nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 5888 nil 8 1759007584 1970 nil nil nil 786 138 144 34 1 850 #createWindow: 34 1 898 930 8 #[15 0 0 0 20 0 0 0 115 1 0 0 48 0 0 0] 193 5920 8 '&Close menu automatically when mouse outside for ~10 secs?' 5888 3 8 #() 1010 193 193 nil 27 8 'autoDismiss' 410 ##(Smalltalk.CheckBox) 34 16 nil 5760 34 2 8 1140862243 1 6224 1858 nil false 1904 nil nil nil 5 nil nil nil 6224 nil 8 1759007584 1970 nil nil nil 786 138 144 34 1 850 #createWindow: 34 1 898 930 8 #[15 0 0 0 48 0 0 0 115 1 0 0 75 0 0 0] 193 6256 8 '&Images (if any) share the checkmark column?' 6224 3 8 #() 1010 193 193 nil 27 8 'checkColumnMode' 1058 1010 31 41 1010 41 21 nil nil nil nil 3 nil nil nil nil 1 nil 193 5410 nil nil 1 false 8 2006356512 nil nil nil nil 786 138 144 34 2 850 #createWindow: 34 1 5538 1058 1010 1 1 1010 783 227 193 5760 850 #setWindowText: 34 1 8 '' 5760 1 34 2 5888 6224 1010 193 193 nil 29 1426 8 '&Inspector' 410 ##(Smalltalk.DialogView) 34 34 nil 1296 34 2 8 1074266112 131073 6864 nil nil nil 133 nil nil nil 6864 578 1 1 nil nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 6864 34 2 8 1409286144 131073 6944 nil nil nil 5 nil nil nil 6944 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 2 1426 410 ##(Smalltalk.Splitter) 34 12 nil 6944 34 2 8 1140850688 1 7088 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 7088 nil 1 #left nil nil nil 1010 1 1 1010 9 9 nil 7184 nil 786 138 144 34 1 850 #createWindow: 34 1 898 930 8 #[193 0 0 0 0 0 0 0 198 0 0 0 113 0 0 0] 193 7120 8 '' 7088 3 8 #() 1010 193 193 nil 27 1 1426 410 ##(Smalltalk.TreeView) 34 27 nil 6944 34 2 8 1140916771 1025 7408 590918 3 ##(Smalltalk.TreeModel) nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 992 3408 nil 13 1538 nil true 34 12 1586 1 1618 #inspectIt 8 '&Inspect' 1 1 4610 nil true 4656 8 'BasicInspector.ico' 4704 nil nil 1586 1 1618 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1586 1 1618 #browseClass 8 '&Browse Class' 1 1 4610 nil true 4656 8 'ClassBrowserShell.ico' 4704 nil nil 7746 4097 1586 1 1618 #copyAspect 8 '&Copy' 1 1 nil nil nil 1586 1 1618 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 7746 4097 1586 1 1618 #editAspect 8 '&Edit' 1 1 nil nil nil 1586 1 1618 #nilAspect 8 'Set to &Nil' 1 1 nil nil nil 7746 4097 1586 1 1618 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 7408 nil 8 1758766000 459270 ##(Smalltalk.Message) #valueText 8 #() 8178 #valueImage 8208 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil 170 176 992 nil #smallIcons 9 170 ##(Smalltalk.PluggableLookupTable) 992 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[0 0 0 0 0 0 0 0 193 0 0 0 113 0 0 0] 193 7440 8 '' 7408 850 #contextMenu: 34 1 7584 7408 3 8 #() 1010 193 193 nil 27 3 false 170 192 34 4 7408 8 'aspects' 410 ##(Smalltalk.CardContainer) 34 16 nil 6944 34 2 8 1140850688 131073 8560 nil 1922 #face3d nil 5 nil nil nil 8560 1362 138 144 992 nil nil nil nil 170 192 992 nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 8560 34 2 8 1140916866 1 8688 590662 2 ##(Smalltalk.ListModel) 138 144 992 nil 7520 nil nil 1 nil nil nil 8688 nil 8 1758664336 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 8 #[29 105 60 106] 8832 7 257 nil ##(Smalltalk.IconicListAbstract) 8256 nil nil nil nil nil #smallIcons nil nil nil nil nil 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[0 0 0 0 0 0 0 0 193 0 0 0 113 0 0 0] 193 8720 8 '' 8688 850 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8688 3 8 #() 1010 193 193 nil 27 786 138 144 34 1 850 #createWindow: 34 1 898 930 8 #[198 0 0 0 0 0 0 0 135 1 0 0 113 0 0 0] 193 8592 8 '' 8560 3 34 1 8688 1010 193 193 nil 27 8 'display' nil 786 138 144 34 1 850 #createWindow: 34 1 898 930 8 #[0 0 0 0 0 0 0 0 135 1 0 0 113 0 0 0] 193 6976 8 '' 6944 3 34 3 7408 7088 8560 1010 193 193 nil 27 170 192 34 2 6944 8 'inspector' nil nil nil nil nil 3 nil nil nil nil 1 nil 193 5410 nil nil 1 nil 8 2006356512 nil nil nil nil 786 138 144 34 2 850 #createWindow: 34 1 5538 1058 1010 9 29 1010 791 255 193 6864 850 #setWindowText: 34 1 8 '' 6864 1 34 1 6944 1010 193 193 nil 29 1472 nil nil nil 170 192 992 nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 1296 34 2 8 1140916736 1 9824 8754 138 144 34 3 1456 5744 6848 nil 7520 nil nil 1 nil nil nil 9824 nil 8 1758664336 8178 #displayString 8 #() ##(Smalltalk.IconicListAbstract) 8256 nil nil nil nil nil #noIcons nil nil nil nil nil 786 138 144 34 3 850 #createWindow: 34 1 898 930 8 #[0 0 0 0 0 0 0 0 143 1 0 0 141 0 0 0] 193 9856 8 '' 9824 850 #setSingleSelection: 8 #(1) 9824 850 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 9824 3 8 #() 1010 193 193 nil 27 786 138 144 34 1 850 #createWindow: 34 1 898 930 8 #[5 0 0 0 5 0 0 0 148 1 0 0 146 0 0 0] 193 1328 8 '' 1296 3 34 4 1472 5760 6864 9824 1010 193 193 nil 27 170 192 34 2 1296 8 'cards' 1058 1010 11 11 1010 11 11 nil nil nil nil 11723 nil nil nil nil 1 nil 193 5410 nil nil 1 nil 8 2006356512 nil nil nil nil 786 138 144 34 2 850 #createWindow: 34 1 5538 1058 1010 1 1 1010 851 451 193 416 850 #setWindowText: 34 1 8 'Menu Properties' 416 1 34 2 1296 608 1010 193 193 nil 29 )! !

!MenuDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

