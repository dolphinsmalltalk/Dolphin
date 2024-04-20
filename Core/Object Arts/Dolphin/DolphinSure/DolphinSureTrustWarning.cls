"Filed out from Dolphin Smalltalk"!

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

!DolphinSureTrustWarning categoriesForMethods!
alwaysTrust!accessing!public! !
createComponents!initializing!public! !
description:!accessing!private! !
model:!accessing!public! !
ok!commands!public! !
validateUserInterface!operations!public! !
!

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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 0 105 0 99 0 114 0 111 0 115 0 111 0 102 0 116 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 nil 170 192 34 6 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850945 1 608 nil nil nil 7 nil 498 nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 608 nil 8 1796240416 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[25 0 0 0 4 1 0 0 74 1 0 0 24 1 0 0] 193 640 nil 608 850 #text: 34 1 8 'Unknown
' 608 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 8 'description' 410 ##(Smalltalk.ImageView) 34 21 nil 416 34 2 8 1140850944 1 1088 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 1218 #hash 8 #() 787206 ##(Smalltalk.GdiplusImage) nil true 2032390 ##(Smalltalk.GdiplusImageFromFileInitializer) nil 8 'Resources/DolphinSureCert.jpg' 1703942 ##(Smalltalk.InstallRelativeFileLocator) 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 1088 nil 8 4294903431 754 nil nil nil 1312 #centered 1 nil nil 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[5 0 0 0 5 0 0 0 89 1 0 0 255 0 0 0] 193 1120 nil 1088 850 #text: 34 1 8 '' 1088 3 8 #() 1042 193 193 nil 27 8 'certificateImage' 410 ##(Smalltalk.CheckBox) 34 16 nil 416 34 2 8 1140924451 1 1696 1154 nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 7 nil nil nil 1696 nil 8 1796035392 754 nil nil nil 786 138 144 34 1 850 #createWindow: 34 1 898 930 8 #[22 0 0 0 110 1 0 0 76 1 0 0 140 1 0 0] 193 1728 8 '&Always trust content with this certificate?' 1696 3 8 #() 1042 193 193 nil 27 8 'alwaysTrust' nil nil nil nil nil 5 nil nil nil nil 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2008255760 786 138 144 34 2 850 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 930 8 #[255 9 0 0 10 0 0 0 108 11 0 0 234 1 0 0] 193 416 850 #setWindowText: 34 1 8 'Security Warning' 416 1 34 6 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 2288 nil 1424 nil 7 nil nil nil 2288 nil 8 1796035392 1180998 4 ##(Smalltalk.CommandDescription) #cancel 8 '&No, don''t install' 1 1 nil nil false nil nil nil 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[190 0 0 0 144 1 0 0 79 1 0 0 174 1 0 0] 193 2320 8 '&No, don''t install' 2288 850 #isEnabled: 8 #(false) 2288 3 8 #() 1042 193 193 nil 29 1696 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 2624 nil 1424 nil 7 nil nil nil 2624 nil 8 1796035392 2370 #ok 8 '&Yes, trust this content' 1 1 nil nil false nil nil nil 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[20 0 0 0 144 1 0 0 165 0 0 0 174 1 0 0] 193 2656 8 '&Yes, trust this content' 2624 850 #isEnabled: 8 #(false) 2624 3 8 #() 1042 193 193 nil 29 1088 608 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 2944 nil nil nil 7 nil nil nil 2944 nil 8 1796240416 754 nil nil nil 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[22 0 0 0 23 1 0 0 81 1 0 0 108 1 0 0] 193 2976 nil 2944 850 #text: 34 1 8 'Do you want to install and run this content? The authenticity certificate for the original publisher is displayed above. 

"DolphinSure" is a security mechanism provided by Object Arts Ltd exclusively for Dolphin Smalltalk applications.' 2944 3 8 #() 1042 193 193 nil 27 1042 193 193 nil 27 )!

showModalOn: aDolphinSureCertificate description: aStringDescription
	"Creates and shows an instance of the receiver on aDolphinSureCertificate and with aStringDescription"

	^(self createOn: aDolphinSureCertificate)
		description: aStringDescription;
		showModal
! !

!DolphinSureTrustWarning class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
showModalOn:description:!instance creation!public! !
!

