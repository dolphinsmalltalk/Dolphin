"Filed out from Dolphin Smallalk"!

ICoreWebView2Collection subclass: #ICoreWebView2IterableCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2IterableCollection guid: (IID fromString: '{0d1a3c69-2d9b-461b-98a3-5d7f04e3383d}')!
ICoreWebView2IterableCollection isAbstract: true!
ICoreWebView2IterableCollection comment: '`ICoreWebView2IterableCollection` is not defined in the WebView2 IDL, but is defined here for economy of mechanism, providing some functionality common to all the the WebView2 collections that have iterators (as opposed to being randomly indexable).

Subclasses must provide at least `GetIterator:` and `iteratorClass` to complete the implementation.'!
!ICoreWebView2IterableCollection categoriesForClass!COM-Interfaces! !
!ICoreWebView2IterableCollection methodsFor!

do: aMonadicValuable
	| iterator |
	iterator := self getIterator.
	iterator do: [:eachValue | aMonadicValuable value: eachValue].
	iterator free!

getIterator
	| iterator |
	iterator := self iteratorClass newPointer.
	self GetIterator: iterator.
	^iterator!

GetIterator: iteratorInterface
	self subclassResponsibility!

isEmpty
	"Answer whether the receiver contains any elements."

	| iterator hasCurrent |
	iterator := self getIterator.
	hasCurrent := iterator hasCurrent.
	iterator free.
	^hasCurrent not!

iteratorClass
	^self subclassResponsibility! !
!ICoreWebView2IterableCollection categoriesForMethods!
do:!enumerating!public! !
getIterator!methods!public! !
GetIterator:!COM Interfaces-ICoreWebView2FrameInfoCollection!COM Interfaces-ICoreWebView2HttpRequestHeaders!COM Interfaces-ICoreWebView2HttpResponseHeaders!methods!private! !
isEmpty!public!testing! !
iteratorClass!constants!private! !
!

