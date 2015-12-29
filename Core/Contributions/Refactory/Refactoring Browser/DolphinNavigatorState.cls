"Filed out from Dolphin Smalltalk 2000 release 4.01"!

NavigatorState subclass: #DolphinNavigatorState
	instanceVariableNames: 'selectedClass category method packages filterPresenter mode variables currentView'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinNavigatorState comment: ''!

DolphinNavigatorState guid: (GUID fromString: '{BEA24722-1A41-11D5-BA96-444553540000}')!

!DolphinNavigatorState categoriesForClass!Unclassified! !
!DolphinNavigatorState methodsFor!

category
	"Private - Answer the value of the receiver's ''category'' instance variable."

	^category!

category: anObject
	"Private - Set the value of the receiver's ''category'' instance variable to the argument, anObject."

	category := anObject!

currentView
	"Private - Answer the value of the receiver's ''currentView'' instance variable."

	^currentView!

currentView: anObject
	"Private - Set the value of the receiver's ''currentView'' instance variable to the argument, anObject."

	currentView := anObject!

filterPresenter
	"Private - Answer the value of the receiver's ''filterPresenter'' instance variable."

	^filterPresenter!

filterPresenter: anObject
	"Private - Set the value of the receiver's ''filterPresenter'' instance variable to the argument, anObject."

	filterPresenter := anObject!

method
	"Private - Answer the value of the receiver's ''method'' instance variable."

	^method!

method: anObject
	"Private - Set the value of the receiver's ''method'' instance variable to the argument, anObject."

	method := anObject!

mode
	"Private - Answer the value of the receiver's ''mode'' instance variable."

	^mode!

mode: anObject
	"Private - Set the value of the receiver's ''mode'' instance variable to the argument, anObject."

	mode := anObject!

packages
	"Private - Answer the value of the receiver's ''packages'' instance variable."

	^packages!

packages: anObject
	"Private - Set the value of the receiver's ''packages'' instance variable to the argument, anObject."

	packages := anObject!

printOn: aStream 
	| class |
	class := self className. 
	selectedClass notNil 
		ifTrue: 
			[aStream nextPutAll: selectedClass name.
			self method notNil
				ifTrue: 
					[aStream nextPutAll: '>>';
						nextPutAll: self method selector]]
		ifFalse: 
			[aStream nextPutAll: '(nothing selected)']!

selectedClass
	"Private - Answer the value of the receiver's ''selectedClass'' instance variable."

	^selectedClass!

selectedClass: anObject
	"Private - Set the value of the receiver's ''selectedClass'' instance variable to the argument, anObject."

	selectedClass := anObject!

variables
	"Private - Answer the value of the receiver's ''variables'' instance variable."

	^variables!

variables: anObject
	"Private - Set the value of the receiver's ''variables'' instance variable to the argument, anObject."

	variables := anObject! !
!DolphinNavigatorState categoriesFor: #category!accessing!private! !
!DolphinNavigatorState categoriesFor: #category:!accessing!private! !
!DolphinNavigatorState categoriesFor: #currentView!accessing!private! !
!DolphinNavigatorState categoriesFor: #currentView:!accessing!private! !
!DolphinNavigatorState categoriesFor: #filterPresenter!accessing!private! !
!DolphinNavigatorState categoriesFor: #filterPresenter:!accessing!private! !
!DolphinNavigatorState categoriesFor: #method!accessing!private! !
!DolphinNavigatorState categoriesFor: #method:!accessing!private! !
!DolphinNavigatorState categoriesFor: #mode!accessing!private! !
!DolphinNavigatorState categoriesFor: #mode:!accessing!private! !
!DolphinNavigatorState categoriesFor: #packages!accessing!private! !
!DolphinNavigatorState categoriesFor: #packages:!accessing!private! !
!DolphinNavigatorState categoriesFor: #printOn:!accessing!private! !
!DolphinNavigatorState categoriesFor: #selectedClass!accessing!private! !
!DolphinNavigatorState categoriesFor: #selectedClass:!accessing!private! !
!DolphinNavigatorState categoriesFor: #variables!accessing!private! !
!DolphinNavigatorState categoriesFor: #variables:!accessing!private! !

