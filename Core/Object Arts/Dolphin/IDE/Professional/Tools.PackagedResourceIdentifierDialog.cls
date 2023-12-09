"Filed out from Dolphin Smalltalk"!

Tools.ResourceIdentifierDialog
	subclass: #'Tools.PackagedResourceIdentifierDialog'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.PackagedResourceIdentifierDialog guid: (Core.GUID fromString: '{17c3843c-c032-4108-a7ef-7e784dea4647}')!
Tools.PackagedResourceIdentifierDialog comment: 'PackagedResourceIdentifierDialog is a specialised <ResourceIdentifierDialog> that uses the <PackagedClassSelector> for class selection, rather than the standard <ClassHierarchySslector>. 
'!
!Tools.PackagedResourceIdentifierDialog categoriesForClass!MVP-Presenters!MVP-Resources-Dialogs! !
!Tools.PackagedResourceIdentifierDialog methodsFor!

classesPresenterClass
	^PackagedClassSelector! !
!Tools.PackagedResourceIdentifierDialog categoriesForMethods!
classesPresenterClass!constants!private! !
!

!Tools.PackagedResourceIdentifierDialog class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 210 21 623 210 809 81 272 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 55 1 0 0 158 1 0 0 95 1 0 0] 8 #() 210 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 576 nil nil nil 5 nil nil nil 576 242 1 17 nil 18 #{UI.TextEdit} 50 20 nil 576 50 2 8 1140916224 1025 656 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 656 nil nil 518 #{UI.NullConverter} nil nil 1 #focusLost nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 559 210 809 45 656 418 #setMarginWidths: 50 1 8 #(3 3) 656 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 23 1 0 0 148 1 0 0 45 1 0 0] 8 #() 560 nil 45 nil nil 18 #{UI.ReferenceView} 50 14 nil 576 50 2 8 1140916224 131073 976 nil nil nil 5 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 2097153 1350 4 #{UI.CommandDescription} #findClass 8 'Find…' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'FindClass.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 1042 nil true 50 4 1090 1 1122 #browseClassPackage 8 'Package <d>' 1 1 1170 nil true 1202 8 'Package.ico' 1264 65541 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 1090 1 1122 #browseClass 8 '&Class' 1 1 1170 nil true 1202 8 'ClassBrowserShell.ico' 1264 65541 nil nil nil 1090 2097153 1122 #browseClassReferences 8 'Class &References' 1 1 nil nil nil 8 '&Browse' #browse 134217729 nil nil nil nil nil 1426 4097 1042 nil true 50 2 1042 nil true 8 #() 8 '&Edit' #viewsEditMenu 134217729 nil nil nil nil nil 1042 nil true 8 #() 8 '&Show' #viewsShowMenu 134217729 nil nil nil nil nil 8 '&Views' #viewsMenu 134217729 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 976 338 #{Tools.PackagedClassSelector} #resource_Choice_view nil 370 50 1 418 #createAt:extent: 50 2 210 1 1 210 809 543 976 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 148 1 0 0 15 1 0 0] 544 560 nil 27 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 976 8 'classSelector' 656 8 'resourceName' nil 370 50 1 418 #createAt:extent: 50 2 210 21 21 210 809 603 576 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 158 1 0 0 55 1 0 0] 50 2 976 656 560 nil 27 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 210 21 21 210 21 21 nil nil nil nil 1 nil nil nil 210 421 721 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 370 50 2 418 #createAt:extent: 50 2 210 6143 21 210 881 801 32 418 #text: 50 1 8 'Resource Identification' 32 498 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 183 13 0 0 154 1 0 0] 50 2 576 272 560 nil 27)!

uninitialize
	SmalltalkSystem.Current
		ifNotNil: 
			[:devsys |
			devsys packagedResourceIdentifierDialogClass == self
				ifTrue: [devsys packagedResourceIdentifierDialogClass: nil]]! !
!Tools.PackagedResourceIdentifierDialog class categoriesForMethods!
resource_Default_view!public!resources-views! !
uninitialize!class hierarchy-removing!public! !
!

