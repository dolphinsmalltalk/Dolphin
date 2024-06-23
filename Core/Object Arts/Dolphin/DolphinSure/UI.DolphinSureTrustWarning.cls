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

model: aCertificate
	"Set the model associated with the receiver."

	super model: aCertificate.
	certificateImage value: aCertificate image.

!

ok
	"The user has chose to trust the receiver's certificate so add it to an appropriate trust store"

	self alwaysTrust 
		ifTrue: [self model bePermanentlyTrusted]
		ifFalse: [self model beTemporarilyTrusted].
	super ok.
!

validateUserInterface
	"Set the state of the receiver accordingly. "

	super validateUserInterface.
	alwaysTrust view isEnabled: self model canBePermanentlyTrusted
! !

!UI.DolphinSureTrustWarning categoriesForMethods!
alwaysTrust!accessing!public! !
createComponents!initializing!public! !
description:!accessing!private! !
model:!accessing!public! !
ok!commands!public! !
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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13107200 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 0 105 0 99 0 114 0 111 0 115 0 111 0 102 0 116 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 6 18 #{UI.CheckBox} 50 16 nil 32 50 2 8 1140924451 1 288 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 5 nil nil nil 288 nil nil 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 210 45 733 210 621 61 288 498 #text: 50 1 8 '&Always trust content with this certificate?' 288 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 22 0 0 0 110 1 0 0 76 1 0 0 140 1 0 0] 8 #() 210 193 193 nil 27 8 'alwaysTrust' 18 #{UI.ImageView} 50 21 nil 32 50 2 8 1140850944 1 720 354 nil false 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 834 #hash 8 #() 774 #{Graphics.Gdiplus.Bitmap} nil true 582 1 #{Graphics.Gdiplus.BitmapFromFileInitializer} 8 'Resources\DolphinSureCert.jpg' 6 #{Kernel.ImageRelativeFileLocator} 6 #{Graphics.Color} #default nil 5 nil nil nil 720 nil nil 418 nil nil nil 928 #centered 1 nil nil 450 50 1 498 #createAt:extent: 50 2 210 11 11 210 681 501 720 626 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 89 1 0 0 255 0 0 0] 8 #() 688 nil 27 8 'certificateImage' 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850945 1 1232 nil nil nil 5 nil 130 nil true 162 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 210 193 193 nil 1232 nil nil 418 nil nil nil 450 50 2 498 #createAt:extent: 50 2 210 51 521 210 611 41 1232 498 #text: 50 1 8 'Unknown
' 1232 626 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 25 0 0 0 4 1 0 0 74 1 0 0 24 1 0 0] 8 #() 688 nil 27 8 'description' nil nil nil nil nil 1 nil nil nil nil 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 450 50 2 498 #createAt:extent: 50 2 210 6143 21 210 731 961 32 498 #text: 50 1 8 'Security Warning' 32 626 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 108 13 0 0 234 1 0 0] 50 6 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 1808 nil 1040 nil 5 nil nil nil 1808 nil nil 1350 4 #{UI.CommandDescription} #cancel 8 '&No, don''t install' 1 1 nil nil false nil nil nil 450 50 2 498 #createAt:extent: 50 2 210 381 801 210 291 61 1808 498 #text: 50 1 8 '&No, don''t install' 1808 626 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 190 0 0 0 144 1 0 0 79 1 0 0 174 1 0 0] 8 #() 688 nil 29 288 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 2112 nil 1040 nil 5 nil nil nil 2112 nil nil 1874 #ok 8 '&Yes, trust this content' 1 1 nil nil false nil nil nil 450 50 3 498 #createAt:extent: 50 2 210 41 801 210 291 61 2112 498 #isEnabled: 8 #(false) 2112 498 #text: 50 1 8 '&Yes, trust this content' 2112 626 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 144 1 0 0 165 0 0 0 174 1 0 0] 8 #() 688 nil 29 720 1232 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2432 nil nil nil 5 nil nil nil 2432 nil nil 418 nil nil nil 450 50 2 498 #createAt:extent: 50 2 210 45 559 210 631 171 2432 498 #text: 50 1 8 'Do you want to install and run this content? The authenticity certificate for the original publisher is displayed above. 

"DolphinSure" is a security mechanism provided by Object Arts Ltd exclusively for Dolphin Smalltalk applications.' 2432 626 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 22 0 0 0 23 1 0 0 81 1 0 0 108 1 0 0] 8 #() 688 nil 27 688 nil 27)!

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

