"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Collection
	subclass: #'WebView2.ICoreWebView2IterableCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2IterableCollection guid: (OS.COM.IID fromString: '{0d1a3c69-2d9b-461b-98a3-5d7f04e3383d}')!
WebView2.ICoreWebView2IterableCollection isNonInstantiable: true!
WebView2.ICoreWebView2IterableCollection comment: '`ICoreWebView2IterableCollection` is not defined in the WebView2 IDL, but is defined here for economy of mechanism, providing some functionality common to all the the WebView2 collections that have iterators (as opposed to being randomly indexable).

Subclasses must provide at least `GetIterator:` and `iteratorClass` to complete the implementation.'!
!WebView2.ICoreWebView2IterableCollection categoriesForClass!COM-Interfaces! !
!WebView2.ICoreWebView2IterableCollection methodsFor!

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
!WebView2.ICoreWebView2IterableCollection categoriesForMethods!
do:!enumerating!public! !
getIterator!methods!public! !
GetIterator:!COM Interfaces-ICoreWebView2FrameInfoCollection!COM Interfaces-ICoreWebView2HttpRequestHeaders!COM Interfaces-ICoreWebView2HttpResponseHeaders!methods!private! !
isEmpty!public!testing! !
iteratorClass!constants!private! !
!

