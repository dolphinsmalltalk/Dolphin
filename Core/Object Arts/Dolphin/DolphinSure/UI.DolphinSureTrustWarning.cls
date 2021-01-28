"Filed out from Dolphin Smalltalk 7"!

UI.Dialog subclass: #'UI.DolphinSureTrustWarning'
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
	"Answer true if the user has checked the alway trust check box"

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
!UI.DolphinSureTrustWarning categoriesFor: #alwaysTrust!accessing!public! !
!UI.DolphinSureTrustWarning categoriesFor: #createComponents!initializing!public! !
!UI.DolphinSureTrustWarning categoriesFor: #description:!accessing!private! !
!UI.DolphinSureTrustWarning categoriesFor: #model:!accessing!public! !
!UI.DolphinSureTrustWarning categoriesFor: #ok!commands!public! !
!UI.DolphinSureTrustWarning categoriesFor: #validateUserInterface!operations!public! !

!UI.DolphinSureTrustWarning class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized. This should be an instance of DolphinSureCertificate"

	^Security.ObjectArtsRootCertificate new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 786950 ##(Smalltalk.ThemeColor) #dialog nil 167 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 0 105 0 99 0 114 0 111 0 115 0 111 0 102 0 116 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 nil 170 192 34 6 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850945 1 640 nil nil nil 7 nil 498 nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 578 193 193 nil 640 nil 8 1912674480 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 51 521 578 611 41 640 898 #text: 34 1 8 'Unknown
' 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 25 0 0 0 4 1 0 0 74 1 0 0 24 1 0 0] 8 #() 578 193 193 nil 27 8 'description' 410 ##(Smalltalk.CheckBox) 34 16 nil 416 34 2 8 1140924451 1 1120 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 7 nil nil nil 1120 nil 8 1912725136 802 nil nil nil 834 138 144 34 2 898 #createAt:extent: 34 2 578 45 733 578 621 61 1120 898 #text: 34 1 8 '&Always trust content with this certificate?' 1120 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 22 0 0 0 110 1 0 0 76 1 0 0 140 1 0 0] 8 #() 1088 nil 27 8 'alwaysTrust' 410 ##(Smalltalk.ImageView) 34 21 nil 416 34 2 8 1140850944 1 1504 1186 nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 1618 #hash 8 #() 657478 3 ##(Smalltalk.OLEPicture) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Resources\DolphinSureCert.jpg' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 524806 ##(Smalltalk.IPicture) nil nil 578 677 491 578 17887 12965 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 7 nil nil nil 1504 nil 8 4294903431 802 nil nil nil 1712 #centered 1 nil nil 834 138 144 34 1 898 #createAt:extent: 34 2 578 11 11 578 681 501 1504 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 89 1 0 0 255 0 0 0] 8 #() 1088 nil 27 8 'certificateImage' nil nil nil nil nil 5 nil nil nil nil 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2007257760 834 138 144 34 3 898 #createAt:extent: 34 2 578 3839 21 578 731 961 416 898 #text: 34 1 8 'Security Warning' 416 898 #updateMenuBar 8 #() 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 236 8 0 0 234 1 0 0] 34 6 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 2432 nil 1890 1920 nil 7 nil nil nil 2432 nil 8 1912725136 1180998 4 ##(Smalltalk.CommandDescription) #cancel 8 '&No, don''t install' 1 1 nil nil true nil nil nil 834 138 144 34 2 898 #createAt:extent: 34 2 578 381 801 578 291 61 2432 898 #text: 34 1 8 '&No, don''t install' 2432 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 190 0 0 0 144 1 0 0 79 1 0 0 174 1 0 0] 8 #() 1088 nil 29 1120 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 2784 nil 1890 1920 nil 7 nil nil nil 2784 nil 8 1912725136 2530 #ok 8 '&Yes, trust this content' 1 1 nil nil false nil nil nil 834 138 144 34 3 898 #createAt:extent: 34 2 578 41 801 578 291 61 2784 898 #isEnabled: 8 #(false) 2784 898 #text: 34 1 8 '&Yes, trust this content' 2784 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 144 1 0 0 165 0 0 0 174 1 0 0] 8 #() 1088 nil 29 1504 640 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3152 nil nil nil 7 nil nil nil 3152 nil 8 1912674480 802 nil nil nil 834 138 144 34 2 898 #createAt:extent: 34 2 578 45 559 578 631 171 3152 898 #text: 34 1 8 'Do you want to install and run this content? The authenticity certificate for the original publisher is displayed above. 

"DolphinSure" is a security mechanism provided by Object Arts Ltd (www.object-arts.com) exclusively for Dolphin Smalltalk applications.' 3152 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 22 0 0 0 23 1 0 0 81 1 0 0 108 1 0 0] 8 #() 1088 nil 27 1088 nil 27)!

showModalOn: aDolphinSureCertificate description: aStringDescription
	"Creates and shows an instance of the receiver on aDolphinSureCertificate and with aStringDescription"

	^(self createOn: aDolphinSureCertificate)
		description: aStringDescription;
		showModal
! !
!UI.DolphinSureTrustWarning class categoriesFor: #defaultModel!models!public! !
!UI.DolphinSureTrustWarning class categoriesFor: #resource_Default_view!public!resources-views! !
!UI.DolphinSureTrustWarning class categoriesFor: #showModalOn:description:!instance creation!public! !

