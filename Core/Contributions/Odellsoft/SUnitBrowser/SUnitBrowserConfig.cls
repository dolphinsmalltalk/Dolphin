"Filed out from Dolphin Smalltalk"!

SUnitBrowserAbsConfig subclass: #SUnitBrowserConfig
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitBrowserConfig guid: (GUID fromString: '{fa1bbe24-e5e3-4931-bb4d-448d0401e1e1}')!
SUnitBrowserConfig comment: ''!
!SUnitBrowserConfig categoriesForClass!Unclassified! !
!SUnitBrowserConfig methodsFor!

shouldInitializeResources

	^self propertyAt: #shouldInitializeResources!

shouldInitializeResources: aBoolean

	self
		propertyAt: #shouldInitializeResources
		put: aBoolean!

showAll

	^self propertyAt: #showAll!

showAll: aBoolean

	self
		propertyAt: #showAll
		put: aBoolean!

showRunningStatusInList

	^self propertyAt: #showRunningStatusInList!

showRunningStatusInList: aBoolean

	self
		propertyAt: #showRunningStatusInList
		put: aBoolean!

showStatusBackgroundColors

	^self propertyAt: #showStatusBackgroundColors!

showStatusBackgroundColors: aBoolean

	self
		propertyAt: #showStatusBackgroundColors
		put: aBoolean!

toggleShouldInitializeResources

	self shouldInitializeResources: self shouldInitializeResources not!

toggleShowAll

	self showAll: self showAll not!

toggleShowRunningStatusInList

	self showRunningStatusInList: self showRunningStatusInList not!

toggleShowStatusBackgroundColors

	self showStatusBackgroundColors: self showStatusBackgroundColors not! !
!SUnitBrowserConfig categoriesForMethods!
shouldInitializeResources!configuring!public! !
shouldInitializeResources:!configuring!public! !
showAll!configuring!public! !
showAll:!configuring!public! !
showRunningStatusInList!configuring!public! !
showRunningStatusInList:!configuring!public! !
showStatusBackgroundColors!configuring!public! !
showStatusBackgroundColors:!configuring!public! !
toggleShouldInitializeResources!configuring!public! !
toggleShowAll!configuring!public! !
toggleShowRunningStatusInList!configuring!public! !
toggleShowStatusBackgroundColors!configuring!public! !
!

