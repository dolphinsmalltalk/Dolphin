"Filed out from Dolphin Smalltalk 7"!

Tools.SmalltalkSystem subclass: #'Tools.CommunityEditionSmalltalkSystem'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.CommunityEditionSmalltalkSystem guid: (Core.GUID fromString: '{fe94a239-c422-4a02-a575-5e7923ce1d63}')!
Tools.CommunityEditionSmalltalkSystem comment: ''!
!Tools.CommunityEditionSmalltalkSystem categoriesForClass!MVP-Models! !
!Tools.CommunityEditionSmalltalkSystem methodsFor!

initializeSystemFolder
	super initializeSystemFolder.
	self
		addSystemFolderIcon: (SmalltalkSystemFolder
					icon: self samplesFolderIcon
					description: 'Sample Applications'
					helpId: 10560);
		addSystemFolderIcon: (SmalltalkSystemFolder
					icon: self userPreferencesIcon
					description: 'User Preferences'
					openBlock: [:folder :item | self inspectSystemOptions]
					helpId: 10580)! !
!Tools.CommunityEditionSmalltalkSystem categoriesFor: #initializeSystemFolder!initializing!private! !

!Tools.CommunityEditionSmalltalkSystem class methodsFor!

initialize
	"Private - Initialize the receiver on load (take over as the development system model)."

	self installCurrent!

installCurrent
	"Private - Take over as the development system model."

	self current become: (self basicNew initializeFrom: self current)!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	self uninstallCurrent!

uninstallCurrent
	(Current notNil and: [Current class == self]) 
		ifTrue: 
			[(self superclass basicNew)
				initializeFrom: Current;
				become: Current]! !
!Tools.CommunityEditionSmalltalkSystem class categoriesFor: #initialize!initializing!private! !
!Tools.CommunityEditionSmalltalkSystem class categoriesFor: #installCurrent!initializing!private! !
!Tools.CommunityEditionSmalltalkSystem class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!Tools.CommunityEditionSmalltalkSystem class categoriesFor: #uninstallCurrent!class hierarchy-removing!private! !

