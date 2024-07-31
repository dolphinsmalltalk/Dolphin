"Filed out from Dolphin Smalltalk"!

UI.Dialog
	subclass: #'UI.DolphinSureTrustWarning'
	instanceVariableNames: 'certificateImage description alwaysTrust'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.DolphinSureTrustWarning guid: (Core.GUID fromString: '{6abda145-ee5e-4214-9709-78362121ec65}')!

UI.DolphinSureTrustWarning comment: 'A DolphinSureTrustWarning dialog is used to presenter a publisher''s digital certificate and to prompt the user to see if contents from this publisher should be trusted. The model for this dialog is the certificate itself and, if it is accepted, it is entered into a temporary or permanent trust store as appropriate.  

DolphinSureTrustWarning showModal

Instance Variables:
	certificateImage	<ImagePresenter> used to display the certificate.
	description		<TextPresenter> used to display a description of the signed class.
	alwaysTrust	<BooleanPresenter> used to indicate whether the user always wants to trust this certificate.

'!

!UI.DolphinSureTrustWarning categoriesForClass!System-Binary class loading! !

!UI.DolphinSureTrustWarning methodsFor!

alwaysTrust
	"Answer true if the user has checked the always trust check box"

	^alwaysTrust value!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	certificateImage := self add: ImagePresenter new name: 'certificateImage'.
	description := self add: TextPresenter new name: 'description'.
	alwaysTrust := self add: BooleanPresenter new name: 'alwaysTrust'.

!

description: aStringDescription
	"Private - Sets the usage description for the receiver"

	description value: aStringDescription
!

displayImageAtDpi: anInteger
	certificateImage value: (self model value imageAtDpi: anInteger)!

ok
	"The user has chose to trust the receiver's certificate so add it to an appropriate trust store"

	self alwaysTrust 
		ifTrue: [self model bePermanentlyTrusted]
		ifFalse: [self model beTemporarilyTrusted].
	super ok.
!

onDpiChanged: aDpiChangeEvent
	| result |
	result := super onDpiChanged: aDpiChangeEvent.
	self displayImageAtDpi: aDpiChangeEvent newDpi.
	^result!

onViewAvailable
	self displayImageAtDpi: self view dpi!

validateUserInterface
	"Set the state of the receiver accordingly. "

	super validateUserInterface.
	alwaysTrust view isEnabled: self model canBePermanentlyTrusted
! !

!UI.DolphinSureTrustWarning categoriesForMethods!
alwaysTrust!accessing!public! !
createComponents!initializing!public! !
description:!accessing!private! !
displayImageAtDpi:!operations!private! !
ok!commands!public! !
onDpiChanged:!event handling!public! !
onViewAvailable!event handling!public! !
validateUserInterface!operations!public! !
!

!UI.DolphinSureTrustWarning class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized. This should be an instance of DolphinSureCertificate"

	^Security.ObjectArtsRootCertificate new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13107200 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 6 18 #{UI.CheckBox} 50 16 nil 32 50 2 8 1140924451 1 256 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 5 nil nil nil 256 nil nil 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[23 0 0 0 109 1 0 0 77 1 0 0 139 1 0 0] 193 288 8 '&Always trust content with this certificate?' 256 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 8 'alwaysTrust' 18 #{UI.ImageView} 50 21 nil 32 50 2 8 1140850944 1 672 322 nil false 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 786 #hash 8 #() 774 #{Graphics.Gdiplus.Image} nil true 582 1 #{Graphics.Gdiplus.ImageFromFileInitializer} 8 'Resources\DolphinSureCert.jpg' 6 #{Kernel.InstallRelativeFileLocator} 6 #{Graphics.Color} #default nil 5 nil nil nil 672 nil nil 386 nil nil nil 880 #scale 1 nil nil 418 50 1 466 #createWindow: 50 1 514 546 8 #[5 0 0 0 5 0 0 0 89 1 0 0 255 0 0 0] 193 704 nil 672 3 8 #() 626 193 193 nil 27 8 'certificateImage' 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850945 1 1184 nil nil nil 5 nil 130 nil true 162 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 88 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 32 0 83 0 101 0 109 0 105 0 98 0 111 0 108 0 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1184 nil nil 386 nil nil nil 418 50 2 466 #createWindow: 50 1 514 546 8 #[22 0 0 0 4 1 0 0 81 1 0 0 20 1 0 0] 193 1216 nil 1184 466 #text: 50 1 8 'Unknown' 1184 3 8 #() 626 193 193 nil 27 8 'description' nil nil nil nil nil 1 nil nil nil nil 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 418 50 2 466 #createWindow: 50 1 518 #{UI.CreateDialog} 518 #{Graphics.Rectangle} 626 7679 21 626 8409 981 193 32 466 #setWindowText: 50 1 8 'Security Warning' 32 1 50 6 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 1776 nil 992 nil 5 nil nil nil 1776 nil nil 1350 4 #{UI.CommandDescription} #cancel 8 '&No, don''t install' 1 1 nil nil false nil nil nil 418 50 2 466 #createWindow: 50 1 514 546 8 #[190 0 0 0 144 1 0 0 79 1 0 0 174 1 0 0] 193 1808 8 '&No, don''t install' 1776 466 #isEnabled: 8 #(false) 1776 3 8 #() 626 193 193 nil 29 256 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 2080 nil 992 nil 5 nil nil nil 2080 nil nil 1842 #ok 8 '&Yes, trust this content' 1 1 nil nil false nil nil nil 418 50 2 466 #createWindow: 50 1 514 546 8 #[20 0 0 0 144 1 0 0 165 0 0 0 174 1 0 0] 193 2112 8 '&Yes, trust this content' 2080 466 #isEnabled: 8 #(false) 2080 3 8 #() 626 193 193 nil 29 672 1184 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2368 nil nil nil 5 nil nil nil 2368 nil nil 386 nil nil nil 418 50 2 466 #createWindow: 50 1 514 546 8 #[20 0 0 0 26 1 0 0 79 1 0 0 106 1 0 0] 193 2400 nil 2368 466 #text: 50 1 8 'Do you want to install and run this content? The authenticity certificate for the original publisher is displayed above. 

"DolphinSure" is a security mechanism provided by Object Arts Ltd exclusively for Dolphin Smalltalk applications.' 2368 3 8 #() 626 193 193 nil 27 626 193 193 nil 29)!

showModalOn: aDolphinSureCertificate description: aStringDescription
	"Creates and shows an instance of the receiver on aDolphinSureCertificate and with aStringDescription"

	^(self createOn: aDolphinSureCertificate)
		description: aStringDescription;
		showModal
! !

!UI.DolphinSureTrustWarning class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
showModalOn:description:!instance creation!public! !
!

