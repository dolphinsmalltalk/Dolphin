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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13107200 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 0 105 0 99 0 114 0 111 0 115 0 111 0 102 0 116 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 nil 170 192 34 6 410 #{UI.ImageView} 34 21 nil 416 34 2 8 1140850944 1 640 918598 2 #{UI.ValueHolder} nil false 1835526 #{Kernel.PluggableSearchPolicy} 786950 #{Core.Message} #= 8 #() 770 #hash 8 #() 1508102 #{Graphics.Gdiplus.Bitmap} nil true 2753286 #{Graphics.Gdiplus.BitmapFromFileInitializer} nil 8 'Resources\DolphinSureCert.jpg' 2031622 #{Kernel.ImageRelativeFileLocator} 917510 #{Graphics.Color} #default nil 7 nil nil nil 640 nil 8 4294903431 1049094 #{UI.NullConverter} nil nil nil 864 #centered 1 nil nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 11 11 578 681 501 640 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 89 1 0 0 255 0 0 0] 8 #() 578 193 193 nil 27 8 'certificateImage' 410 #{UI.CheckBox} 34 16 nil 416 34 2 8 1140924451 1 1264 706 nil nil 1572870 #{Kernel.NeverSearchPolicy} false nil nil 7 nil nil nil 1264 nil 8 1815097472 1010 nil nil nil 1042 34 2 1090 #createAt:extent: 34 2 578 45 733 578 621 61 1264 1090 #text: 34 1 8 '&Always trust content with this certificate?' 1264 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 22 0 0 0 110 1 0 0 76 1 0 0 140 1 0 0] 8 #() 1232 nil 27 8 'alwaysTrust' 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850945 1 1616 nil nil nil 7 nil 498 nil true 655622 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 578 193 193 nil 1616 nil 8 1815137184 1010 nil nil nil 1042 34 2 1090 #createAt:extent: 34 2 578 51 521 578 611 41 1616 1090 #text: 34 1 8 'Unknown
' 1616 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 25 0 0 0 4 1 0 0 74 1 0 0 24 1 0 0] 8 #() 1232 nil 27 8 'description' nil nil nil nil nil 3 nil nil nil nil 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 1042 34 2 1090 #createAt:extent: 34 2 578 12287 21 578 731 961 416 1090 #text: 34 1 8 'Security Warning' 416 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 108 25 0 0 234 1 0 0] 34 6 410 #{UI.PushButton} 34 20 nil 416 34 2 8 1140924416 1 2240 nil 976 nil 7 nil nil nil 2240 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #cancel 8 '&No, don''t install' 1 1 nil nil false nil nil nil 1042 34 2 1090 #createAt:extent: 34 2 578 381 801 578 291 61 2240 1090 #text: 34 1 8 '&No, don''t install' 2240 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 190 0 0 0 144 1 0 0 79 1 0 0 174 1 0 0] 8 #() 1232 nil 29 1264 410 #{UI.PushButton} 34 20 nil 416 34 2 8 1140924416 1 2560 nil 976 nil 7 nil nil nil 2560 nil 8 1815097472 2322 #ok 8 '&Yes, trust this content' 1 1 nil nil false nil nil nil 1042 34 3 1090 #createAt:extent: 34 2 578 41 801 578 291 61 2560 1090 #isEnabled: 8 #(false) 2560 1090 #text: 34 1 8 '&Yes, trust this content' 2560 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 144 1 0 0 165 0 0 0 174 1 0 0] 8 #() 1232 nil 29 640 1616 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 2896 nil nil nil 7 nil nil nil 2896 nil 8 1815137184 1010 nil nil nil 1042 34 2 1090 #createAt:extent: 34 2 578 45 559 578 631 171 2896 1090 #text: 34 1 8 'Do you want to install and run this content? The authenticity certificate for the original publisher is displayed above. 

"DolphinSure" is a security mechanism provided by Object Arts Ltd (www.object-arts.com) exclusively for Dolphin Smalltalk applications.' 2896 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 22 0 0 0 23 1 0 0 81 1 0 0 108 1 0 0] 8 #() 1232 nil 27 1232 nil 27)!

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

