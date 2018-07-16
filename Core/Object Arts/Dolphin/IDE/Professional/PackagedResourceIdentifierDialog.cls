"Filed out from Dolphin Smalltalk 7"!

ResourceIdentifierDialog subclass: #PackagedResourceIdentifierDialog
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PackagedResourceIdentifierDialog guid: (GUID fromString: '{17c3843c-c032-4108-a7ef-7e784dea4647}')!
PackagedResourceIdentifierDialog comment: 'PackagedResourceIdentifierDialog is a specialised <ResourceIdentifierDialog> that uses the <PackagedClassSelector> for class selection, rather than the standard <ClassHierarchySslector>. 
'!
!PackagedResourceIdentifierDialog categoriesForClass!Development! !
!PackagedResourceIdentifierDialog methodsFor!

classesPresenterClass
	^PackagedClassSelector! !
!PackagedResourceIdentifierDialog categoriesFor: #classesPresenterClass!constants!private! !

!PackagedResourceIdentifierDialog class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 786950 ##(Smalltalk.DefaultColor) #dialog nil 167 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 21 623 578 809 81 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 55 1 0 0 158 1 0 0 95 1 0 0] 8 #() 578 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 960 nil nil nil 7 nil nil nil 960 610 1 17 nil 410 ##(Smalltalk.TextEdit) 34 16 nil 960 34 2 8 1140916224 1025 1040 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 7 nil nil nil 1040 nil 8 1912718128 852486 ##(Smalltalk.NullConverter) nil nil 1 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 559 578 809 45 1040 802 #setMarginWidths: 34 1 8 #(3 3) 1040 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 23 1 0 0 148 1 0 0 45 1 0 0] 8 #() 944 nil 27 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 960 34 2 8 1140916224 131073 1408 nil nil nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 2097153 1180998 4 ##(Smalltalk.CommandDescription) #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1474 nil true 34 4 1522 1 1554 #browseClassPackage 8 'Package <1d>' 1 1 1602 nil true 1648 8 'Package.ico' 1696 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1522 1 1554 #browseClass 8 '&Class' 1 1 1602 nil true 1648 8 'ClassBrowserShell.ico' 1696 nil nil 1522 2097153 1554 #browseClassReferences 8 'Class &References' 1 1 nil nil nil 8 '&Browse' #browse 134217729 nil nil nil nil nil 1842 4097 1474 nil true 34 2 1474 nil true 8 #() 8 '&Edit' #viewsEditMenu 134217729 nil nil nil nil nil 1474 nil true 8 #() 8 '&Show' #viewsShowMenu 134217729 nil nil nil nil nil 8 '&Views' #viewsMenu 134217729 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 1408 706 ##(Smalltalk.PackagedClassSelector) #resource_Choice_view nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 1 578 809 543 1408 802 #contextMenu: 34 1 1488 1408 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 148 1 0 0 15 1 0 0] 928 944 nil 27 170 192 34 4 1040 8 'resourceName' 1408 8 'classSelector' nil 738 138 144 34 1 802 #createAt:extent: 34 2 578 21 21 578 809 603 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 158 1 0 0 55 1 0 0] 34 2 1408 1040 944 nil 27 170 192 928 590342 ##(Smalltalk.Rectangle) 578 21 21 578 21 21 nil nil nil nil 52313 nil nil nil 578 421 721 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2007257760 738 138 144 34 3 802 #createAt:extent: 34 2 578 3839 21 578 881 801 416 802 #text: 34 1 8 'Resource Identification' 416 802 #updateMenuBar 928 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 55 9 0 0 154 1 0 0] 34 2 960 640 944 nil 27 )!

uninitialize
	Smalltalk developmentSystem packagedResourceIdentifierDialogClass == self 
		ifTrue: [Smalltalk developmentSystem packagedResourceIdentifierDialogClass: nil]! !
!PackagedResourceIdentifierDialog class categoriesFor: #resource_Default_view!public!resources-views! !
!PackagedResourceIdentifierDialog class categoriesFor: #uninitialize!class hierarchy-removing!public! !

