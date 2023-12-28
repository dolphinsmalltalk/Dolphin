"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'Tools.Tests.SmalltalkSearchPresenterTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.SmalltalkSearchPresenterTest guid: (Core.GUID fromString: '{a2c7b693-05c5-4fc9-9f02-2bdf94afb765}')!
Tools.Tests.SmalltalkSearchPresenterTest comment: ''!
!Tools.Tests.SmalltalkSearchPresenterTest methodsFor!

classToTest
	^SmalltalkSearchPresenter!

testAmbiguousClass
	<nocreate>
	| subject items item |
	subject := self classToTest new.
	subject searchEnvironment: (Refactory.Browser.BrowserEnvironment new
				forPackages: { Graphics.Bitmap owningPackage. Gdiplus.Bitmap owningPackage }).
	items := (subject searchItemsStartingWith: 'Bitmap' maxItems: 100)
				asSortedArray: subject completionListSortBlock.
	item := items first.
	self assert: item object identicalTo: Graphics.Bitmap.
	self assert: item text equals: 'Bitmap (Graphics)'.
	self assert: item icon equals: Graphics.Bitmap icon.
	item := items second.
	self assert: item object identicalTo: Graphics.Gdiplus.Bitmap.
	self assert: item text equals: 'Bitmap (Graphics.Gdiplus)'.
	self assert: item icon equals: Graphics.Gdiplus.Bitmap icon.
	item := items third.
	self assert: item object identicalTo: Graphics.Gdiplus.BitmapData.
	self assert: item text equals: 'BitmapData'.
	self assert: item icon equals: Graphics.Gdiplus.BitmapData icon!

testClassAndPackageAmbiguity
	<nocreate>
	| subject items |
	subject := self classToTest new.
	subject searchEnvironment: (Refactory.Browser.BrowserEnvironment new
				forPackages: { Refactory.Browser.RBParser owningPackage }).
	items := (subject searchItemsStartingWith: 'RBParser' maxItems: 100)
				asSortedArray: subject completionListSortBlock.
	self assert: items first text equals: 'RBParser'.
	self assert: items second text equals: 'RBParser (Refactory.Browser)'.
	self assert: items third text equals: 'RBParser>>qualifiedReferenceNodeClass'!

testCompletionFromChoice
	<nocreate>
	| subject |
	subject := self classToTest new.
	self assert: (subject completionForChoice: 'Bitmap (Graphics)') equals: 'Graphics.Bitmap'.
	self assert: (subject completionForChoice: 'Bitmap (Graphics.Gdiplus)')
		equals: 'Graphics.Gdiplus.Bitmap'.
	self assert: (subject completionForChoice: 'BitmapData') equals: 'BitmapData'.
	self assert: (subject completionForChoice: 'RBParser') equals: 'RBParser'.
	self assert: (subject completionForChoice: 'RBParser (Refactory.Browser)')
		equals: 'Refactory.Browser.RBParser'.
	self
		assert: (subject completionForChoice: 'RBParser>>qualifiedReferenceNodeClass (Refactory.Browser)')
		equals: 'Refactory.Browser.RBParser>>qualifiedReferenceNodeClass'!

testSearchLimit
	<nocreate>
	| subject |
	subject := self classToTest new.
	"Too many packages"
	self should: [subject searchItemsStartingWith: 'Dolphin' maxItems: 5] raise: OperationAborted.
	"Too many classes"
	self should: [subject searchItemsStartingWith: 'Class' maxItems: 10] raise: OperationAborted.
	"Too many selectors"
	self should: [subject searchItemsStartingWith: 'a' maxItems: 10] raise: OperationAborted.
	"Too many methods"
	self should: [subject searchItemsStartingWith: 'Object>>' maxItems: 10] raise: OperationAborted!

testSearchObjectFromText
	<nocreate>
	| subject |
	subject := self classToTest new.
	subject
		searchEnvironment: (Refactory.Browser.BrowserEnvironment new forPackages: {
						Graphics.Bitmap owningPackage.
						Gdiplus.Bitmap owningPackage.
						Refactory.Browser.RBParser owningPackage
					}).
	"A class with unqualified name"
	self assert: (subject searchObjectFromText: 'BitmapData') identicalTo: Graphics.Gdiplus.BitmapData.
	"A class with qualified name"
	self assert: (subject searchObjectFromText: 'Graphics.Bitmap') identicalTo: Graphics.Bitmap.
	"A method"
	self assert: (subject searchObjectFromText: 'Bitmap>>asBitmap')
		identicalTo: Graphics.Bitmap >> #asBitmap.
	"A method with qualified class name"
	self assert: (subject searchObjectFromText: 'Graphics.Gdiplus.Bitmap>>asBitmap')
		identicalTo: Graphics.Gdiplus.Bitmap >> #asBitmap.
	"A package name that is also the same as an unqalified class name (package takes precedence for the search)"
	self assert: (subject searchObjectFromText: 'RBParser')
		identicalTo: Refactory.Browser.RBParser owningPackage.
	"A selector"
	self assert: (subject searchObjectFromText: 'asBitmap') identicalTo: #asBitmap!

testSelectors
	<nocreate>
	| subject items item |
	subject := self classToTest new.
	items := (subject searchItemsStartingWith: '=' maxItems: 100)
				asSortedArray: subject completionListSortBlock.
	item := items first.
	self assert: item object identicalTo: #=.
	self assert: item text equals: '='.
	self assert: item icon equals: #= icon.
	item := items second.
	self assert: item object identicalTo: #==.
	self assert: item text equals: '=='.
	self assert: item icon equals: #== icon! !
!Tools.Tests.SmalltalkSearchPresenterTest categoriesForMethods!
classToTest!constants!private! !
testAmbiguousClass!public! !
testClassAndPackageAmbiguity!public! !
testCompletionFromChoice!public! !
testSearchLimit!public! !
testSearchObjectFromText!public! !
testSelectors!public! !
!

