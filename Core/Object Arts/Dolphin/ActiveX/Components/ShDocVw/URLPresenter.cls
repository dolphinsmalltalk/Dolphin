"Filed out from Dolphin Smalltalk 7"!

ValuePresenter subclass: #URLPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
URLPresenter guid: (GUID fromString: '{a98215d9-bda9-4b36-8443-c6a72c049d71}')!
URLPresenter comment: ''!
!URLPresenter categoriesForClass!MVP-Presenters! !
!URLPresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^'about:blank' copy asValue!

defaultView
	"Answer the resource name of the default view for the receiver."

	^'Internet Explorer'!

resource_Internet_Explorer
	"Answer the literal data from which the 'Internet Explorer' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Internet_Explorer)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(AXValueConvertingControlSite)  98 26 0 0 98 2 8 1140916224 1 416 721990 2 ##(ValueHolder)  0 32 1376774 ##(PluggableSearchPolicy)  459270 ##(Message)  8 #= 98 0 562 8 #hash 98 0 0 524550 ##(ColorRef)  8 4278190080 0 7 0 0 0 416 0 81920801 8 'Shell.Explorer' 787462 ##(IWebBrowser2)  0 0 1444166 1 ##(TKindInterfaceAnalyzer)  590598 ##(ITypeInfo)  0 0 525062 ##(TYPEATTR)  0 816 784 0 1378630 2 ##(AXTypeLibraryAnalyzer)  590342 ##(ITypeLib2)  0 0 257 524550 ##(TLIBATTR)  8 #[192 42 178 234 193 48 207 17 167 235 0 0 192 91 174 11 0 0 0 0 1 0 0 0 1 0 1 0 8 0 0 0] 8 '' 8 'Internet Explorer' 8 #SHDocVwLib 8 #SHDocVwConstants 234 240 98 2 8 #GUID 1072 0 0 0 11 0 0 0 0 918022 ##(IDolphinAxHost)  0 0 722438 ##(AXEventSink)  234 240 98 66 205 8 #StatusTextChange: 209 8 #DownloadComplete 211 8 #CommandStateChange:Enable: 213 8 #DownloadBegin 217 8 #ProgressChange:ProgressMax: 501 8 #BeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel: 503 8 #NewWindow2:Cancel: 505 8 #NavigateComplete2:URL: 225 8 #PropertyChange: 227 8 #TitleChange: 507 8 #OnQuit 509 8 #OnVisible: 511 8 #OnToolBar: 513 8 #OnMenuBar: 519 8 #DocumentComplete:URL: 515 8 #OnStatusBar: 517 8 #OnFullScreen: 521 8 #OnTheaterMode: 525 8 #WindowSetResizable: 529 8 #WindowSetLeft: 531 8 #WindowSetTop: 533 8 #WindowSetWidth: 535 8 #WindowSetHeight: 527 8 #WindowClosing:Cancel: 537 8 #ClientToHostWindow:CY: 539 8 #SetSecureLockIcon: 541 8 #FileDownload: 543 8 #NavigateError:URL:Frame:StatusCode:Cancel: 451 8 #PrintTemplateInstantiation: 453 8 #PrintTemplateTeardown: 455 8 #UpdatePageStatus:nPage:fDone: 545 8 #PrivacyImpactedStateChange: 547 8 #NewWindow3:Cancel:dwFlags:bstrUrlContext:bstrUrl: 416 1049094 ##(IConnectionPoint)  0 0 3 1378630 1 ##(TKindDispatchAnalyzer)  802 0 0 834 0 1776 1760 0 866 898 0 0 257 930 8 #[192 42 178 234 193 48 207 17 167 235 0 0 192 91 174 11 0 0 0 0 1 0 0 0 1 0 1 0 8 0 0 0] 8 '' 8 'Internet Explorer' 1008 1024 234 240 98 2 1072 1072 0 0 262198 ##(GUID)  16 160 21 167 52 135 101 208 17 146 74 0 32 175 199 172 77 23 0 0 0 1 3787 234 240 98 0 1508358 ##(IAxWinAmbientDispatchEx)  0 0 0 0 524806 ##(IUnknown)  0 0 0 0 0 852486 ##(NullConverter)  0 0 983302 ##(MessageSequence)  202 208 98 4 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  11 11 2226 1179 289 416 2162 8 #restoreAmbientProperties 1984 416 2162 8 #docHostFlags: 98 1 9 416 2162 8 #controlBinaryStoreBytes: 98 1 8 #[97 249 86 136 10 52 208 17 169 107 0 192 79 215 5 162 76 0 0 0 224 60 0 0 226 14 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 76 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 224 208 87 0 115 53 207 17 174 105 8 0 43 46 18 98 8 0 0 0 0 0 0 0 76 0 0 0 1 20 2 0 0 0 0 0 192 0 0 0 0 0 0 70 128 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 82 2 0 0 149 0 0 0] 98 0 2226 193 193 0 27 )! !
!URLPresenter class categoriesFor: #defaultModel!models!public! !
!URLPresenter class categoriesFor: #defaultView!constants!public! !
!URLPresenter class categoriesFor: #resource_Internet_Explorer!public!resources-views! !

