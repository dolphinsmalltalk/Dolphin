"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #DolphinSureTrustWarning
	instanceVariableNames: 'certificateImage description alwaysTrust'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinSureTrustWarning guid: (GUID fromString: '{6abda145-ee5e-4214-9709-78362121ec65}')!
DolphinSureTrustWarning comment: 'A DolphinSureTrustWarning dialog is used to presenter a publisher''s digital certificate and to prompt the user to see if contents from this publisher should be trusted. The model for this dialog is the certificate itself and, if it is accepted, it is entered into a temporary or permanent trust store as appropriate.  

DolphinSureTrustWarning showModal

Instance Variables:
	certificateImage	<ImagePresenter> used to display the certificate.
	description		<TextPresenter> used to display a description of the signed class.
	alwaysTrust	<BooleanPresenter> used to indicate whether the user always wants to trust this certificate.

'!
!DolphinSureTrustWarning categoriesForClass!System-Binary class loading! !
!DolphinSureTrustWarning methodsFor!

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
!DolphinSureTrustWarning categoriesFor: #alwaysTrust!accessing!public! !
!DolphinSureTrustWarning categoriesFor: #createComponents!initializing!public! !
!DolphinSureTrustWarning categoriesFor: #description:!accessing!private! !
!DolphinSureTrustWarning categoriesFor: #model:!accessing!public! !
!DolphinSureTrustWarning categoriesFor: #ok!commands!public! !
!DolphinSureTrustWarning categoriesFor: #validateUserInterface!operations!public! !

!DolphinSureTrustWarning class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized. This should be an instance of DolphinSureCertificate"

	^ObjectArtsRootCertificate new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26214401 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 0 0 416 0 234 256 98 6 410 8 ##(Smalltalk.CheckBox)  98 16 0 416 98 2 8 1140924451 1 560 721990 2 ##(Smalltalk.ValueHolder)  0 0 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.SearchPolicy)  8 #never 32 482 512 0 7 0 0 0 560 0 8 4294903893 852486 ##(Smalltalk.NullConverter)  0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  45 733 930 621 61 560 866 8 #text: 98 1 8 '&Always trust content with this certificate?' 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 22 0 0 0 110 1 0 0 76 1 0 0 140 1 0 0] 98 0 930 193 193 0 27 8 'alwaysTrust' 410 8 ##(Smalltalk.ImageView)  98 21 0 416 98 2 8 1140850944 1 1136 642 0 32 1376774 ##(Smalltalk.PluggableSearchPolicy)  459270 ##(Smalltalk.Message)  8 #= 98 0 1266 8 #hash 98 0 657478 3 ##(Smalltalk.OLEPicture)  0 16 682 8 ##(Smalltalk.ImageRelativeFileLocator)  8 #current 8 'Resources\DolphinSureCert.jpg' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 524806 ##(Smalltalk.IPicture)  0 0 930 677 491 930 17887 12965 482 512 0 7 0 0 0 1136 0 8 4294903431 770 0 0 0 1392 8 #centered 1 0 0 802 202 208 98 1 866 896 98 2 930 11 11 930 681 501 1136 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 89 1 0 0 255 0 0 0] 98 0 1104 0 27 8 'certificateImage' 410 8 ##(Smalltalk.StaticText)  98 16 0 416 98 2 8 1140850945 1 1824 0 0 0 7 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 930 193 193 0 1824 0 8 4294903875 770 0 0 0 802 202 208 98 2 866 896 98 2 930 51 521 930 611 41 1824 866 992 98 1 8 'Unknown
' 1824 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 25 0 0 0 4 1 0 0 74 1 0 0 24 1 0 0] 98 0 1104 0 27 8 'description' 0 0 0 0 0 5 0 0 0 0 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 802 202 208 98 3 866 896 98 2 930 6399 21 930 711 951 416 866 992 98 1 8 'Security Warning' 416 866 8 #updateMenuBar 98 0 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 12 0 0 10 0 0 0 226 13 0 0 229 1 0 0] 98 6 410 8 ##(Smalltalk.PushButton)  98 17 0 416 98 2 8 1140924416 1 2560 0 482 512 0 7 0 0 0 2560 0 8 4294903893 1180998 4 ##(Smalltalk.CommandDescription)  8 #cancel 8 '&No, don''t install' 1 1 0 0 16 802 202 208 98 2 866 896 98 2 930 381 801 930 291 61 2560 866 992 98 1 8 '&No, don''t install' 2560 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 190 0 0 0 144 1 0 0 79 1 0 0 174 1 0 0] 98 0 1104 0 27 560 410 2576 98 17 0 416 98 2 8 1140924416 1 2944 0 482 512 0 7 0 0 0 2944 0 8 4294903893 2674 8 #ok 8 '&Yes, trust this content' 1 1 0 0 32 802 202 208 98 3 866 896 98 2 930 41 801 930 291 61 2944 866 8 #isEnabled: 98 1 32 2944 866 992 98 1 8 '&Yes, trust this content' 2944 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 144 1 0 0 165 0 0 0 174 1 0 0] 98 0 1104 0 27 1136 1824 410 1840 98 16 0 416 98 2 8 1140850944 1 3344 0 0 0 7 0 0 0 3344 0 8 4294903875 770 0 0 0 802 202 208 98 2 866 896 98 2 930 45 563 930 641 171 3344 866 992 98 1 8 'Do you want to install and run this content? The authenticity certificate for the original publisher is displayed above. 

"DolphinSure" is a security mechanism provided by Object Arts Ltd (www.object-arts.com) exclusively for Dolphin Smalltalk applications.' 3344 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 22 0 0 0 25 1 0 0 86 1 0 0 110 1 0 0] 98 0 1104 0 27 1104 0 27 )!

showModalOn: aDolphinSureCertificate description: aStringDescription
	"Creates and shows an instance of the receiver on aDolphinSureCertificate and with aStringDescription"

	^(self createOn: aDolphinSureCertificate)
		description: aStringDescription;
		showModal
! !
!DolphinSureTrustWarning class categoriesFor: #defaultModel!models!public! !
!DolphinSureTrustWarning class categoriesFor: #resource_Default_view!public!resources-views! !
!DolphinSureTrustWarning class categoriesFor: #showModalOn:description:!instance creation!public! !

