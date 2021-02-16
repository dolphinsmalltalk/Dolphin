"Filed out from Dolphin Smalltalk 7"!

Model subclass: #LightsOutBoard
	instanceVariableNames: 'cells'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LightsOutBoard guid: (GUID fromString: '{C0D9D90B-0267-4C2F-8AB8-4D1D2EF59D56}')!
LightsOutBoard comment: ''!
!LightsOutBoard categoriesForClass!Unclassified! !
!LightsOutBoard methodsFor!

cells
	^cells!

setSize: anInteger 
	cells := (1 to: anInteger squared) collect: [:each | true asValue]!

size
	^cells size sqrt truncated! !
!LightsOutBoard categoriesFor: #cells!public! !
!LightsOutBoard categoriesFor: #setSize:!private! !
!LightsOutBoard categoriesFor: #size!public! !

!LightsOutBoard class methodsFor!

defaultSize
	^10!

new
	^self withSize: self defaultSize!

withSize: anInteger
	^super new setSize: anInteger! !
!LightsOutBoard class categoriesFor: #defaultSize!private! !
!LightsOutBoard class categoriesFor: #new!public! !
!LightsOutBoard class categoriesFor: #withSize:!public! !

