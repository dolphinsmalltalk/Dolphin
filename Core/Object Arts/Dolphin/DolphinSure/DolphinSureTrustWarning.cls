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

!DolphinSureTrustWarning categoriesForMethods!
alwaysTrust!accessing!public! !
createComponents!initializing!public! !
description:!accessing!private! !
displayImageAtDpi:!operations!private! !
ok!commands!public! !
onDpiChanged:!event handling!public! !
onViewAvailable!public! !
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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13107200 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 nil 170 192 34 6 410 ##(Smalltalk.CheckBox) 34 16 nil 416 34 2 8 1140924451 1 608 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 608 nil 8 1759007584 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[25 0 0 0 109 1 0 0 79 1 0 0 139 1 0 0] 193 640 8 '&Always trust content with this certificate?' 608 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 8 'alwaysTrust' 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850945 1 1056 nil nil nil 5 nil 498 nil true 530 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 88 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 32 0 83 0 101 0 109 0 105 0 98 0 111 0 108 0 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1056 nil 8 1759212608 754 nil nil nil 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[22 0 0 0 4 1 0 0 81 1 0 0 20 1 0 0] 193 1088 nil 1056 850 #text: 34 1 8 'Unknown' 1056 3 8 #() 1010 193 193 nil 27 8 'description' 410 ##(Smalltalk.ImageView) 34 21 nil 416 34 2 8 1140850944 1 1424 674 nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 1538 #hash 8 #() 787206 ##(Smalltalk.GdiplusImage) nil true 2032390 ##(Smalltalk.GdiplusImageFromFileInitializer) nil 8 'Resources/DolphinSureCert.jpg' 1703942 ##(Smalltalk.InstallRelativeFileLocator) 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 1424 nil 8 4294903431 754 nil nil nil 1632 #scale 1 nil nil 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[5 0 0 0 5 0 0 0 89 1 0 0 255 0 0 0] 193 1456 nil 1424 850 #text: 34 1 8 '' 1424 3 8 #() 1010 193 193 nil 27 8 'certificateImage' nil nil nil nil nil 3 nil nil nil nil 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 786 138 144 34 2 850 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 590342 ##(Smalltalk.Rectangle) 1010 1 1 1010 731 961 193 416 850 #setWindowText: 34 1 8 'Security Warning' 416 1 34 6 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 2304 nil 1744 nil 5 nil nil nil 2304 nil 8 1759007584 1180998 4 ##(Smalltalk.CommandDescription) #cancel 8 '&No, don''t install' 1 1 nil nil false nil nil nil 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[190 0 0 0 144 1 0 0 79 1 0 0 174 1 0 0] 193 2336 8 '&No, don''t install' 2304 850 #isEnabled: 8 #(false) 2304 3 8 #() 1010 193 193 nil 29 608 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 2640 nil 1744 nil 5 nil nil nil 2640 nil 8 1759007584 2386 #ok 8 '&Yes, trust this content' 1 1 nil nil false nil nil nil 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[20 0 0 0 144 1 0 0 165 0 0 0 174 1 0 0] 193 2672 8 '&Yes, trust this content' 2640 850 #isEnabled: 8 #(false) 2640 3 8 #() 1010 193 193 nil 29 1424 1056 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 2960 nil nil nil 5 nil nil nil 2960 nil 8 1759212608 754 nil nil nil 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[22 0 0 0 26 1 0 0 81 1 0 0 106 1 0 0] 193 2992 nil 2960 850 #text: 34 1 8 'Do you want to install and run this content? The authenticity certificate for the original publisher is displayed above. 

"DolphinSure" is a security mechanism provided by Object Arts Ltd exclusively for Dolphin Smalltalk applications.' 2960 3 8 #() 1010 193 193 nil 27 1010 193 193 nil 29 )!

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

