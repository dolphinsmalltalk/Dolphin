"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ClassAttributeChange subclass: #'Refactory.Browser.ClassCategoryChange'
	instanceVariableNames: 'categories'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ClassCategoryChange guid: (Core.GUID fromString: '{cd00dfac-537f-4360-838d-2ed615575cb4}')!
Refactory.Browser.ClassCategoryChange comment: ''!
!Refactory.Browser.ClassCategoryChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.ClassCategoryChange methodsFor!

asUndoOperation
	^self copy
		categories: self changeClass categories;
		yourself!

categories
	^categories!

categories: anArray
	categories := anArray!

changeString
	^'Categorize <1d>' << classReference!

emitAttributeOf: class with: filer
	filer emitCategoriesOfClass: class!

mutateAttributes: aClassAttributes
	"Alter the <ClassAttributes> argument to reflect the change described by the receiver."

	aClassAttributes categories: categories!

primitiveExecute
	self changeClass categories: self categories! !
!Refactory.Browser.ClassCategoryChange categoriesForMethods!
asUndoOperation!converting!public! !
categories!accessing!public! !
categories:!accessing!public! !
changeString!printing!public! !
emitAttributeOf:with:!printing!public! !
mutateAttributes:!helpers!private! !
primitiveExecute!applying!private! !
!

!Refactory.Browser.ClassCategoryChange class methodsFor!

categorize: aClass as: aCollectionOfClassCategories 
	^self new
		changeClass: aClass;
		categories: aCollectionOfClassCategories ;
		yourself! !
!Refactory.Browser.ClassCategoryChange class categoriesForMethods!
categorize:as:!instance creation!public! !
!

