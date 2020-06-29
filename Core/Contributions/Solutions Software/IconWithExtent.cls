"Filed out from Dolphin Smalltalk 7"!

Icon subclass: #IconWithExtent
	instanceVariableNames: 'extent'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IconWithExtent guid: (GUID fromString: '{429114bb-12f2-41ab-8fe0-7585364ac305}')!
IconWithExtent comment: ''!
!IconWithExtent categoriesForClass!Graphics-Tools! !
!IconWithExtent methodsFor!

extent
	^extent!

extent: anObject
	extent := anObject!

loadFromInstance: hModule
	"Private - Attempts to load the receiver as a resource from an instance. 
	I would have expected the User32 loadImage function to be capable of this but
	it does not appear to work for instance 0; the system. Hence this method 
	which tries the old way. Answers the loaded handle or nil if the load failed"

	^UserLibrary default 
			loadImage: hModule asParameter 
			lpszName: identifier asResourceId
			uType: IMAGE_ICON
			cxDesired: self extent x
			cyDesired: self extent y
			fuLoad: LR_DEFAULTCOLOR! !
!IconWithExtent categoriesFor: #extent!accessing!private! !
!IconWithExtent categoriesFor: #extent:!accessing!private! !
!IconWithExtent categoriesFor: #loadFromInstance:!private!realizing/unrealizing! !

