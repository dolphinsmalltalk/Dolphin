"Filed out from Dolphin Smalltalk X6"!

ResourceIdentifierDialog subclass: #PackagedResourceIdentifierDialog
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PackagedResourceIdentifierDialog guid: (GUID fromString: '{17C3843C-C032-4108-A7EF-7E784DEA4647}')!
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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26738689 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 560 0 0 0 7 0 0 0 560 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.Presenter)  8 #resource_OK_Cancel_button_block 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  21 633 834 825 81 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 60 1 0 0 166 1 0 0 100 1 0 0] 98 0 834 193 193 0 27 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 960 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 0 0 960 530 1 17 0 410 8 ##(Smalltalk.TextEdit)  98 16 0 960 98 2 8 1140916224 1025 1088 0 482 512 0 7 0 0 0 1088 0 8 4294903807 852486 ##(Smalltalk.NullConverter)  0 0 1 706 202 208 98 3 770 800 98 2 834 1 573 834 825 41 1088 770 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 1088 770 8 #isTextModified: 98 1 32 1088 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 30 1 0 0 156 1 0 0 50 1 0 0] 98 0 944 0 27 0 0 410 576 98 14 0 960 98 2 8 1140916224 131073 1520 0 0 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 4 984134 2 ##(Smalltalk.CommandMenuItem)  2097153 1180998 4 ##(Smalltalk.CommandDescription)  8 #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 1586 0 16 98 4 1634 1 1666 8 #browseClassPackage 8 'Package <1d>' 1 1 1730 0 16 1776 8 'Package.ico' 1824 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 1634 1 1666 8 #browseClass 8 '&Class' 1 1 1730 0 16 1776 8 'ClassBrowserShell.ico' 1824 0 0 1634 2097153 1666 8 #browseClassReferences 8 'Class &References' 1 1 0 0 0 8 '&Browse' 8 #browse 134217729 0 0 0 0 0 1986 4097 1586 0 16 98 2 1586 0 16 98 0 8 '&Edit' 8 #viewsEditMenu 134217729 0 0 0 0 0 1586 0 16 98 0 8 '&Show' 8 #viewsShowMenu 134217729 0 0 0 0 0 8 '&Views' 8 #viewsMenu 134217729 0 0 0 0 0 8 '&Class' 0 134217729 0 0 0 0 0 0 0 1520 642 8 ##(Smalltalk.PackagedClassSelector)  8 #resource_Choice_view 0 706 202 208 98 2 770 800 98 2 834 1 1 834 825 557 1520 770 8 #contextMenu: 98 1 1600 1520 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 156 1 0 0 22 1 0 0] 928 944 0 27 234 256 98 4 1088 8 'resourceName' 1520 8 'classSelector' 0 706 202 208 98 1 770 800 98 2 834 21 21 834 825 613 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 166 1 0 0 60 1 0 0] 98 2 1520 1088 944 0 27 234 256 928 590342 ##(Smalltalk.Rectangle)  834 21 21 834 21 21 0 0 0 0 25077 0 0 0 834 421 721 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 706 202 208 98 3 770 800 98 2 834 2799 21 834 881 801 416 770 8 #text: 98 1 8 'Resource Identification' 416 770 8 #updateMenuBar 928 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 47 7 0 0 154 1 0 0] 98 2 960 560 944 0 27 )!

uninitialize
	Smalltalk developmentSystem packagedResourceIdentifierDialogClass == self 
		ifTrue: [Smalltalk developmentSystem packagedResourceIdentifierDialogClass: nil]! !
!PackagedResourceIdentifierDialog class categoriesFor: #resource_Default_view!public!resources-views! !
!PackagedResourceIdentifierDialog class categoriesFor: #uninitialize!class hierarchy-removing!public! !

