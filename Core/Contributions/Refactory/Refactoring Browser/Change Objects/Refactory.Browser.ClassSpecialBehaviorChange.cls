"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ClassAttributeChange subclass: #'Refactory.Browser.ClassSpecialBehaviorChange'
	instanceVariableNames: 'instanceSpec'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ClassSpecialBehaviorChange guid: (Core.GUID fromString: '{f2364206-9c2f-4a40-bef1-5d27cbd5dee5}')!
Refactory.Browser.ClassSpecialBehaviorChange comment: ''!
!Refactory.Browser.ClassSpecialBehaviorChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.ClassSpecialBehaviorChange methodsFor!

asUndoOperation
	^self copy
		instanceSpec: self changeClass instanceSpec;
		yourself!

changeString
	^'Set special behavior of <1d>' << classReference!

emitAttributeOf: aClass with: aChunkSourceFiler
	aChunkSourceFiler emitSpecialBehaviorAttributesOfClass: aClass!

instanceSpec
	^instanceSpec!

instanceSpec: aString
	instanceSpec := aString!

mutateClassDetails: aClassDetails
	"Alter the <ClassDetails> argument to reflect the change described by the receiver."

	aClassDetails instanceSpec: instanceSpec!

primitiveExecute
	| class |
	class := self changeClass.
	class instanceSpec: ((class instanceSpec bitAnd: Behavior._FundamentalShapeMask)
				bitOr: (instanceSpec maskClear: Behavior._FundamentalShapeMask))! !
!Refactory.Browser.ClassSpecialBehaviorChange categoriesForMethods!
asUndoOperation!converting!public! !
changeString!printing!public! !
emitAttributeOf:with:!printing!private! !
instanceSpec!accessing!public! !
instanceSpec:!accessing!public! !
mutateClassDetails:!helpers!private! !
primitiveExecute!applying!private! !
!

!Refactory.Browser.ClassSpecialBehaviorChange class methodsFor!

setSpecialBehavior: anInteger of: aClass
	^self new
		changeClass: aClass;
		instanceSpec: anInteger;
		yourself!

uniquelyIdentify: aClass with: aGUID
	^self new
		changeClass: aClass;
		instanceSpec: aGUID;
		yourself! !
!Refactory.Browser.ClassSpecialBehaviorChange class categoriesForMethods!
setSpecialBehavior:of:!instance creation!public! !
uniquelyIdentify:with:!instance creation!public! !
!

