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

mutateAttributes: aClassAttributes
	"Alter the <ClassAttributes> argument to reflect the change described by the receiver."

	aClassAttributes instanceSpec: instanceSpec!

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
mutateAttributes:!helpers!private! !
primitiveExecute!applying!private! !
!

!Refactory.Browser.ClassSpecialBehaviorChange class methodsFor!

setGuid: aGUID of: aClass
	^self new
		changeClass: aClass;
		instanceSpec: aGUID;
		yourself!

setSpecialBehavior: anInteger of: aClass
	^self new
		changeClass: aClass;
		instanceSpec: anInteger;
		yourself! !
!Refactory.Browser.ClassSpecialBehaviorChange class categoriesForMethods!
setGuid:of:!instance creation!public! !
setSpecialBehavior:of:!instance creation!public! !
!

